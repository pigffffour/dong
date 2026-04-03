import Foundation

struct EnergyInput {
    let steps: Int
    let sleepHours: Double
    let activeEnergyBurned: Double
    let caloriesConsumed: Double
    let bodyProfile: BodyProfile
    let streakDays: Int
    let recentDaysSteps: [Int]
    let recentDaysSleep: [Double]
}

struct EnergyOutput {
    let score: Double
    let components: EnergyComponents
    let suggestedMood: BuddyMood
    let confidence: Double
}

struct EnergyComponents {
    let stepsContribution: Double
    let sleepContribution: Double
    let dietContribution: Double
    let streakBonus: Double
    let bodyAdjustment: Double
}

protocol EnergyEngineProtocol {
    func calculate(input: EnergyInput) -> EnergyOutput
}
