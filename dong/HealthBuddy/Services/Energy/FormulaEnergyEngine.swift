import Foundation

/// 基于公式的能量引擎：步数 40% + 睡眠 35% + 饮食 25%
final class FormulaEnergyEngine: EnergyEngineProtocol {
    
    private let stepsWeight: Double = 0.40
    private let sleepWeight: Double = 0.35
    private let dietWeight: Double = 0.25
    
    func calculate(input: EnergyInput) -> EnergyOutput {
        // 步数评分
        let stepGoal = adjustedStepGoal(for: input.bodyProfile)
        let stepsRaw = min(1.0, Double(input.steps) / stepGoal)
        let stepTrend = trendAverage(input.recentDaysSteps.map { Double($0) / stepGoal })
        let stepsScore = min(1.0, stepsRaw * 0.85 + stepTrend * 0.15)
        
        // 睡眠评分（钟型曲线）
        let sleepGoal = adjustedSleepGoal(for: input.bodyProfile)
        let sleepRaw = sleepQualityScore(hours: input.sleepHours, goal: sleepGoal)
        let sleepTrend = trendAverage(input.recentDaysSleep.map { sleepQualityScore(hours: $0, goal: sleepGoal) })
        let sleepScore = min(1.0, sleepRaw * 0.85 + sleepTrend * 0.15)
        
        // 饮食评分
        let tdee = input.bodyProfile.tdee ?? 2000.0
        let dietScore = dietQualityScore(consumed: input.caloriesConsumed, target: tdee)
        
        // 身体调节
        let bodyAdj = bodyAdjustment(profile: input.bodyProfile)
        
        // 连续打卡乘数（对能量影响有上限 1.2）
        let streakMult = min(LevelConfig.streakMultiplier(days: input.streakDays), 1.2)
        
        // 加权求和
        let baseScore = stepsScore * stepsWeight + sleepScore * sleepWeight + dietScore * dietWeight
        let adjusted = baseScore * (1.0 + bodyAdj) * streakMult
        let finalScore = min(1.0, max(0.0, adjusted))
        
        let mood = determineMood(energy: finalScore, sleepScore: sleepScore, dietScore: dietScore)
        
        let components = EnergyComponents(
            stepsContribution: stepsScore,
            sleepContribution: sleepScore,
            dietContribution: dietScore,
            streakBonus: streakMult,
            bodyAdjustment: bodyAdj
        )
        
        return EnergyOutput(
            score: finalScore,
            components: components,
            suggestedMood: mood,
            confidence: 1.0
        )
    }
    
    // MARK: - Helpers
    
    private func adjustedStepGoal(for profile: BodyProfile) -> Double {
        let base: Double
        if let age = profile.age, age > 60 {
            base = 7000
        } else if let age = profile.age, age > 50 {
            base = 8000
        } else {
            switch profile.activityLevel {
            case .sedentary:        base = 8000
            case .lightlyActive:    base = 10000
            case .moderatelyActive: base = 12000
            case .veryActive:       base = 14000
            }
        }
        return base
    }
    
    private func adjustedSleepGoal(for profile: BodyProfile) -> Double {
        guard let age = profile.age else { return 8.0 }
        if age < 18 { return 9.0 }
        if age > 65 { return 7.0 }
        return 8.0
    }
    
    private func sleepQualityScore(hours: Double, goal: Double) -> Double {
        guard hours > 0 else { return 0 }
        let ratio = hours / goal
        if ratio >= 0.85 && ratio <= 1.15 { return 1.0 }
        if ratio >= 0.7 && ratio <= 1.3 { return 0.75 }
        if ratio >= 0.5 { return 0.4 }
        return 0.15
    }
    
    private func dietQualityScore(consumed: Double, target: Double) -> Double {
        guard consumed > 0 else { return 0.1 }
        let ratio = consumed / target
        if ratio >= 0.8 && ratio <= 1.1 { return 1.0 }
        if ratio >= 0.6 && ratio <= 1.3 { return 0.7 }
        if ratio >= 0.4 { return 0.4 }
        return 0.2
    }
    
    private func trendAverage(_ values: [Double]) -> Double {
        guard values.count >= 3 else { return 0 }
        let recent = Array(values.suffix(7))
        return recent.reduce(0, +) / Double(recent.count)
    }
    
    private func bodyAdjustment(profile: BodyProfile) -> Double {
        guard let bmi = profile.bmi else { return 0 }
        if bmi >= 18.5 && bmi <= 24.9 { return 0.05 }
        if bmi >= 25 && bmi <= 29.9 { return 0.0 }
        return -0.05
    }
    
    private func determineMood(energy: Double, sleepScore: Double, dietScore: Double) -> BuddyMood {
        if energy >= 0.75 && sleepScore >= 0.7 { return .happy }
        if energy <= 0.25 { return .tired }
        if dietScore <= 0.15 { return .hungry }
        return .normal
    }
}
