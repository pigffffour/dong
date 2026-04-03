import Foundation

protocol PersistenceServiceProtocol {
    // User
    func saveUser(_ user: User) throws
    func loadUser() throws -> User?
    func deleteUser() throws
    
    // Buddy
    func saveBuddy(_ buddy: BuddyData) throws
    func loadBuddy() throws -> BuddyData?
    
    // Health Records
    func saveHealthRecord(_ record: HealthRecord) throws
    func fetchHealthRecords(type: HealthRecordType, from: Date, to: Date) throws -> [HealthRecord]
    func fetchLatestHealthRecords(type: HealthRecordType, limit: Int) throws -> [HealthRecord]
    
    // Food Records
    func saveFoodRecord(_ record: FoodRecord) throws
    func fetchFoodRecords(from: Date, to: Date) throws -> [FoodRecord]
    func fetchTodayFoodRecords() throws -> [FoodRecord]
    
    // Streak
    func saveStreakData(_ data: StreakData) throws
    func loadStreakData() throws -> StreakData?
    
    // Generic
    func clearAll() throws
}

/// Persistent buddy state (value type for storage)
struct BuddyData: Codable {
    var name: String
    var skinEmoji: String
    var energy: Double
    var level: Int
    var experience: Double
    var mood: BuddyMood
    var unlockedDecorationIDs: Set<String>
    var currentDecorationID: String?
    var unlockedMapIDs: Set<String>
    var currentMapID: String?
    var totalStepsAllTime: Int
    var totalFoodLogsAllTime: Int
    var longestStreak: Int
    var createdAt: Date
    var updatedAt: Date
    
    init() {
        self.name = "小熊"
        self.skinEmoji = "🐻"
        self.energy = 0.5
        self.level = 1
        self.experience = 0
        self.mood = .normal
        self.unlockedDecorationIDs = []
        self.currentDecorationID = nil
        self.unlockedMapIDs = []
        self.currentMapID = nil
        self.totalStepsAllTime = 0
        self.totalFoodLogsAllTime = 0
        self.longestStreak = 0
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

/// Streak tracking data
struct StreakData: Codable {
    var currentStreak: Int
    var longestStreak: Int
    var lastActiveDate: Date?
    
    init() {
        self.currentStreak = 0
        self.longestStreak = 0
        self.lastActiveDate = nil
    }
}
