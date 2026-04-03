import Foundation
import SwiftData

// MARK: - SwiftData Models

@Model
final class PersistedUser {
    @Attribute(.unique) var id: String
    var phoneNumber: String
    var displayName: String
    var avatarEmoji: String
    var heightCm: Double?
    var weightKg: Double?
    var age: Int?
    var genderRaw: String?
    var activityLevelRaw: String
    var createdAt: Date
    var updatedAt: Date
    
    init(from user: User) {
        self.id = user.id.uuidString
        self.phoneNumber = user.phoneNumber
        self.displayName = user.displayName
        self.avatarEmoji = user.avatarEmoji
        self.heightCm = user.bodyProfile.heightCm
        self.weightKg = user.bodyProfile.weightKg
        self.age = user.bodyProfile.age
        self.genderRaw = user.bodyProfile.gender?.rawValue
        self.activityLevelRaw = user.bodyProfile.activityLevel.rawValue
        self.createdAt = user.createdAt
        self.updatedAt = user.updatedAt
    }
    
    func toUser() -> User {
        var profile = BodyProfile()
        profile.heightCm = heightCm
        profile.weightKg = weightKg
        profile.age = age
        if let raw = genderRaw {
            profile.gender = BodyProfile.Gender(rawValue: raw)
        }
        if let level = BodyProfile.ActivityLevel(rawValue: activityLevelRaw) {
            profile.activityLevel = level
        }
        var user = User(phoneNumber: phoneNumber)
        // Restore the original ID
        if let uuid = UUID(uuidString: id) {
            user = User(id: uuid, phoneNumber: phoneNumber, displayName: displayName,
                        avatarEmoji: avatarEmoji, bodyProfile: profile,
                        createdAt: createdAt, updatedAt: updatedAt)
        }
        return user
    }
}

@Model
final class PersistedHealthRecord {
    @Attribute(.unique) var id: String
    var typeRaw: String
    var value: Double
    var unit: String
    var startDate: Date
    var endDate: Date
    var metadataJSON: String?
    var sourceRaw: String
    var syncStatusRaw: String
    var createdAt: Date
    
    init(from record: HealthRecord) {
        self.id = record.id.uuidString
        self.typeRaw = record.type.rawValue
        self.value = record.value
        self.unit = record.unit
        self.startDate = record.startDate
        self.endDate = record.endDate
        if let meta = record.metadata {
            self.metadataJSON = try? String(data: JSONEncoder().encode(meta), encoding: .utf8)
        }
        self.sourceRaw = record.source.rawValue
        self.syncStatusRaw = record.syncStatus.rawValue
        self.createdAt = record.createdAt
    }
    
    func toHealthRecord() -> HealthRecord? {
        guard let type = HealthRecordType(rawValue: typeRaw),
              let source = HealthRecord.RecordSource(rawValue: sourceRaw) else { return nil }
        var metadata: [String: String]?
        if let json = metadataJSON, let data = json.data(using: .utf8) {
            metadata = try? JSONDecoder().decode([String: String].self, from: data)
        }
        return HealthRecord(type: type, value: value, unit: unit,
                            startDate: startDate, endDate: endDate,
                            source: source, metadata: metadata)
    }
}

@Model
final class PersistedFoodRecord {
    @Attribute(.unique) var id: String
    var foodName: String
    var emoji: String
    var calories: Double
    var confidence: Float
    var carbsGrams: Double?
    var proteinGrams: Double?
    var fatGrams: Double?
    var mealTypeRaw: String
    var recognitionSource: String
    var timestamp: Date
    var syncStatusRaw: String
    
    init(from record: FoodRecord) {
        self.id = record.id.uuidString
        self.foodName = record.foodName
        self.emoji = record.emoji
        self.calories = record.calories
        self.confidence = record.confidence
        self.carbsGrams = record.macros?.carbsGrams
        self.proteinGrams = record.macros?.proteinGrams
        self.fatGrams = record.macros?.fatGrams
        self.mealTypeRaw = record.mealType.rawValue
        self.recognitionSource = record.recognitionSource
        self.timestamp = record.timestamp
        self.syncStatusRaw = record.syncStatus.rawValue
    }
    
    func toFoodRecord() -> FoodRecord {
        var macros: FoodRecord.Macros?
        if carbsGrams != nil || proteinGrams != nil || fatGrams != nil {
            macros = FoodRecord.Macros(carbsGrams: carbsGrams, proteinGrams: proteinGrams,
                                       fatGrams: fatGrams, fiberGrams: nil)
        }
        var record = FoodRecord(foodName: foodName, emoji: emoji, calories: calories,
                                confidence: confidence,
                                mealType: FoodRecord.MealType(rawValue: mealTypeRaw) ?? .lunch,
                                recognitionSource: recognitionSource)
        record.macros = macros
        return record
    }
}

@Model
final class PersistedBuddyData {
    @Attribute(.unique) var id: String
    var name: String
    var skinEmoji: String
    var energy: Double
    var level: Int
    var experience: Double
    var moodRaw: String
    var unlockedDecorationIDsJSON: String
    var currentDecorationID: String?
    var unlockedMapIDsJSON: String
    var currentMapID: String?
    var totalStepsAllTime: Int
    var totalFoodLogsAllTime: Int
    var longestStreak: Int
    var createdAt: Date
    var updatedAt: Date
    
    init(from data: BuddyData) {
        self.id = "current_buddy"
        self.name = data.name
        self.skinEmoji = data.skinEmoji
        self.energy = data.energy
        self.level = data.level
        self.experience = data.experience
        self.moodRaw = data.mood.rawValue
        self.unlockedDecorationIDsJSON = (try? String(data: JSONEncoder().encode(Array(data.unlockedDecorationIDs)), encoding: .utf8)) ?? "[]"
        self.currentDecorationID = data.currentDecorationID
        self.unlockedMapIDsJSON = (try? String(data: JSONEncoder().encode(Array(data.unlockedMapIDs)), encoding: .utf8)) ?? "[]"
        self.currentMapID = data.currentMapID
        self.totalStepsAllTime = data.totalStepsAllTime
        self.totalFoodLogsAllTime = data.totalFoodLogsAllTime
        self.longestStreak = data.longestStreak
        self.createdAt = data.createdAt
        self.updatedAt = data.updatedAt
    }
    
    func toBuddyData() -> BuddyData {
        var data = BuddyData()
        data.name = name
        data.skinEmoji = skinEmoji
        data.energy = energy
        data.level = level
        data.experience = experience
        data.mood = BuddyMood(rawValue: moodRaw) ?? .normal
        if let jsonData = unlockedDecorationIDsJSON.data(using: .utf8),
           let ids = try? JSONDecoder().decode([String].self, from: jsonData) {
            data.unlockedDecorationIDs = Set(ids)
        }
        data.currentDecorationID = currentDecorationID
        if let jsonData = unlockedMapIDsJSON.data(using: .utf8),
           let ids = try? JSONDecoder().decode([String].self, from: jsonData) {
            data.unlockedMapIDs = Set(ids)
        }
        data.currentMapID = currentMapID
        data.totalStepsAllTime = totalStepsAllTime
        data.totalFoodLogsAllTime = totalFoodLogsAllTime
        data.longestStreak = longestStreak
        data.createdAt = createdAt
        data.updatedAt = updatedAt
        return data
    }
}

@Model
final class PersistedStreakData {
    @Attribute(.unique) var id: String
    var currentStreak: Int
    var longestStreak: Int
    var lastActiveDate: Date?
    
    init(from data: StreakData) {
        self.id = "current_streak"
        self.currentStreak = data.currentStreak
        self.longestStreak = data.longestStreak
        self.lastActiveDate = data.lastActiveDate
    }
    
    func toStreakData() -> StreakData {
        var data = StreakData()
        data.currentStreak = currentStreak
        data.longestStreak = longestStreak
        data.lastActiveDate = lastActiveDate
        return data
    }
}

// MARK: - LocalPersistenceService

final class LocalPersistenceService: PersistenceServiceProtocol {
    private let container: ModelContainer
    
    static let schema = Schema([
        PersistedUser.self,
        PersistedHealthRecord.self,
        PersistedFoodRecord.self,
        PersistedBuddyData.self,
        PersistedStreakData.self,
    ])
    
    init() {
        let config = ModelConfiguration(isStoredInMemoryOnly: false)
        self.container = try! ModelContainer(for: Self.schema, configurations: [config])
    }
    
    @MainActor
    private var context: ModelContext {
        container.mainContext
    }
    
    // MARK: - User
    
    @MainActor
    func saveUser(_ user: User) throws {
        let descriptor = FetchDescriptor<PersistedUser>(predicate: #Predicate { $0.id == user.id.uuidString })
        if let existing = try context.fetch(descriptor).first {
            existing.phoneNumber = user.phoneNumber
            existing.displayName = user.displayName
            existing.avatarEmoji = user.avatarEmoji
            existing.heightCm = user.bodyProfile.heightCm
            existing.weightKg = user.bodyProfile.weightKg
            existing.age = user.bodyProfile.age
            existing.genderRaw = user.bodyProfile.gender?.rawValue
            existing.activityLevelRaw = user.bodyProfile.activityLevel.rawValue
            existing.updatedAt = Date()
        } else {
            context.insert(PersistedUser(from: user))
        }
        try context.save()
    }
    
    @MainActor
    func loadUser() throws -> User? {
        let descriptor = FetchDescriptor<PersistedUser>()
        return try context.fetch(descriptor).first?.toUser()
    }
    
    @MainActor
    func deleteUser() throws {
        let descriptor = FetchDescriptor<PersistedUser>()
        for item in try context.fetch(descriptor) {
            context.delete(item)
        }
        try context.save()
    }
    
    // MARK: - Buddy
    
    @MainActor
    func saveBuddy(_ buddy: BuddyData) throws {
        let targetID = "current_buddy"
        let descriptor = FetchDescriptor<PersistedBuddyData>(predicate: #Predicate { $0.id == targetID })
        if let existing = try context.fetch(descriptor).first {
            context.delete(existing)
        }
        context.insert(PersistedBuddyData(from: buddy))
        try context.save()
    }
    
    @MainActor
    func loadBuddy() throws -> BuddyData? {
        let descriptor = FetchDescriptor<PersistedBuddyData>()
        return try context.fetch(descriptor).first?.toBuddyData()
    }
    
    // MARK: - Health Records
    
    @MainActor
    func saveHealthRecord(_ record: HealthRecord) throws {
        context.insert(PersistedHealthRecord(from: record))
        try context.save()
    }
    
    @MainActor
    func fetchHealthRecords(type: HealthRecordType, from startDate: Date, to endDate: Date) throws -> [HealthRecord] {
        let typeRaw = type.rawValue
        let descriptor = FetchDescriptor<PersistedHealthRecord>(
            predicate: #Predicate { $0.typeRaw == typeRaw && $0.startDate >= startDate && $0.endDate <= endDate },
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        return try context.fetch(descriptor).compactMap { $0.toHealthRecord() }
    }
    
    @MainActor
    func fetchLatestHealthRecords(type: HealthRecordType, limit: Int) throws -> [HealthRecord] {
        let typeRaw = type.rawValue
        var descriptor = FetchDescriptor<PersistedHealthRecord>(
            predicate: #Predicate { $0.typeRaw == typeRaw },
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return try context.fetch(descriptor).compactMap { $0.toHealthRecord() }
    }
    
    // MARK: - Food Records
    
    @MainActor
    func saveFoodRecord(_ record: FoodRecord) throws {
        context.insert(PersistedFoodRecord(from: record))
        try context.save()
    }
    
    @MainActor
    func fetchFoodRecords(from startDate: Date, to endDate: Date) throws -> [FoodRecord] {
        let descriptor = FetchDescriptor<PersistedFoodRecord>(
            predicate: #Predicate { $0.timestamp >= startDate && $0.timestamp <= endDate },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return try context.fetch(descriptor).map { $0.toFoodRecord() }
    }
    
    @MainActor
    func fetchTodayFoodRecords() throws -> [FoodRecord] {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) ?? Date()
        return try fetchFoodRecords(from: startOfDay, to: endOfDay)
    }
    
    // MARK: - Streak
    
    @MainActor
    func saveStreakData(_ data: StreakData) throws {
        let targetID = "current_streak"
        let descriptor = FetchDescriptor<PersistedStreakData>(predicate: #Predicate { $0.id == targetID })
        if let existing = try context.fetch(descriptor).first {
            context.delete(existing)
        }
        context.insert(PersistedStreakData(from: data))
        try context.save()
    }
    
    @MainActor
    func loadStreakData() throws -> StreakData? {
        let descriptor = FetchDescriptor<PersistedStreakData>()
        return try context.fetch(descriptor).first?.toStreakData()
    }
    
    // MARK: - Clear All
    
    @MainActor
    func clearAll() throws {
        try context.delete(model: PersistedUser.self)
        try context.delete(model: PersistedHealthRecord.self)
        try context.delete(model: PersistedFoodRecord.self)
        try context.delete(model: PersistedBuddyData.self)
        try context.delete(model: PersistedStreakData.self)
        try context.save()
    }
}
