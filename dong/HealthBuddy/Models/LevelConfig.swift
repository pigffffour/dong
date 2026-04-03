import Foundation

enum LevelConfig {
    /// XP required to advance from the given level to the next
    static func xpRequired(forLevel level: Int) -> Double {
        if level <= 5 { return 100 }
        if level <= 10 { return 200 }
        if level <= 20 { return 350 }
        return 500
    }
    
    /// XP rewards for various activities
    enum XPReward {
        static let stepsPerThousand: Double = 5.0
        static let sleepPerHour: Double = 8.0
        static let foodLogPerEntry: Double = 15.0
        static let firstFoodLogOfDay: Double = 10.0
        static let dailyGoalCompletion: Double = 25.0
        static let streakBonusPerDay: Double = 10.0
    }
    
    /// Streak multiplier for XP gains
    static func streakMultiplier(days: Int) -> Double {
        if days >= 30 { return 2.0 }
        if days >= 14 { return 1.5 }
        if days >= 7 { return 1.25 }
        if days >= 3 { return 1.1 }
        return 1.0
    }
}
