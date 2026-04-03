import Foundation
import Combine

/// 管理 XP 获取、等级提升和解锁逻辑
@MainActor
final class LevelManager: ObservableObject {
    private let persistence: PersistenceServiceProtocol
    
    init(persistence: PersistenceServiceProtocol) {
        self.persistence = persistence
    }
    
    /// 根据今日步数计算并奖励 XP
    func rewardStepsXP(steps: Int, to buddy: Buddy) {
        let thousands = Double(steps) / 1000.0
        let xp = thousands * LevelConfig.XPReward.stepsPerThousand
        buddy.addExperience(xp)
        buddy.totalStepsAllTime += steps
        saveBuddy(buddy)
    }
    
    /// 根据睡眠时长奖励 XP
    func rewardSleepXP(hours: Double, to buddy: Buddy) {
        let xp = hours * LevelConfig.XPReward.sleepPerHour
        buddy.addExperience(xp)
        saveBuddy(buddy)
    }
    
    /// 记录食物后奖励 XP
    func rewardFoodLogXP(to buddy: Buddy, isFirstOfDay: Bool) {
        var xp = LevelConfig.XPReward.foodLogPerEntry
        if isFirstOfDay {
            xp += LevelConfig.XPReward.firstFoodLogOfDay
        }
        buddy.addExperience(xp)
        saveBuddy(buddy)
    }
    
    /// 完成每日目标奖励
    func rewardDailyGoalXP(to buddy: Buddy, streakDays: Int) {
        let base = LevelConfig.XPReward.dailyGoalCompletion
        let multiplier = LevelConfig.streakMultiplier(days: streakDays)
        buddy.addExperience(base * multiplier)
        saveBuddy(buddy)
    }
    
    private func saveBuddy(_ buddy: Buddy) {
        try? persistence.saveBuddy(buddy.toBuddyData())
    }
}
