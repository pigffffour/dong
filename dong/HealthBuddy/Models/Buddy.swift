import Foundation
import SwiftUI
import Combine

/// 伙伴状态枚举，用于 UI 表现
enum BuddyMood: String, Codable {
    case happy = "开心"
    case normal = "平常"
    case tired = "疲惫"
    case hungry = "饥饿"
}

/// 核心伙伴模型 - 使用稳定字符串 ID 引用 Catalog 中的装饰品和地图
class Buddy: ObservableObject, Identifiable {
    @Published var name: String = "小熊"
    @Published var skinEmoji: String = "🐻"
    @Published var energy: Double = 0.5
    @Published var level: Int = 1
    @Published var experience: Double = 0.0
    @Published var mood: BuddyMood = .normal
    
    @Published var unlockedDecorationIDs: Set<String> = []
    @Published var currentDecorationID: String?
    
    @Published var unlockedMapIDs: Set<String> = []
    @Published var currentMapID: String?
    
    @Published var totalStepsAllTime: Int = 0
    @Published var totalFoodLogsAllTime: Int = 0
    @Published var longestStreak: Int = 0
    
    // MARK: - Catalog Convenience (向后兼容视图层)
    
    static var allDecorations: [DecorationItem] { DecorationCatalog.all }
    static var allMaps: [MapItem] { MapCatalog.all }
    
    var currentDecoration: DecorationItem? {
        get { currentDecorationID.flatMap { DecorationCatalog.find(by: $0) } }
        set { currentDecorationID = newValue?.id }
    }
    
    var currentMap: MapItem? {
        get { currentMapID.flatMap { MapCatalog.find(by: $0) } }
        set { currentMapID = newValue?.id }
    }
    
    var unlockedDecorations: [DecorationItem] {
        DecorationCatalog.all.filter { unlockedDecorationIDs.contains($0.id) }
    }
    
    var unlockedMaps: [MapItem] {
        MapCatalog.all.filter { unlockedMapIDs.contains($0.id) }
    }
    
    // MARK: - Init
    
    init() {
        checkUnlocks()
        currentMapID = unlockedMaps.first?.id
    }
    
    init(from data: BuddyData) {
        self.name = data.name
        self.skinEmoji = data.skinEmoji
        self.energy = data.energy
        self.level = data.level
        self.experience = data.experience
        self.mood = data.mood
        self.unlockedDecorationIDs = data.unlockedDecorationIDs
        self.currentDecorationID = data.currentDecorationID
        self.unlockedMapIDs = data.unlockedMapIDs
        self.currentMapID = data.currentMapID
        self.totalStepsAllTime = data.totalStepsAllTime
        self.totalFoodLogsAllTime = data.totalFoodLogsAllTime
        self.longestStreak = data.longestStreak
    }
    
    func toBuddyData() -> BuddyData {
        var data = BuddyData()
        data.name = name
        data.skinEmoji = skinEmoji
        data.energy = energy
        data.level = level
        data.experience = experience
        data.mood = mood
        data.unlockedDecorationIDs = unlockedDecorationIDs
        data.currentDecorationID = currentDecorationID
        data.unlockedMapIDs = unlockedMapIDs
        data.currentMapID = currentMapID
        data.totalStepsAllTime = totalStepsAllTime
        data.totalFoodLogsAllTime = totalFoodLogsAllTime
        data.longestStreak = longestStreak
        data.updatedAt = Date()
        return data
    }
    
    // MARK: - Game Logic
    
    /// 根据等级检查是否有新的解锁
    func checkUnlocks() {
        for deco in DecorationCatalog.forLevel(level) {
            unlockedDecorationIDs.insert(deco.id)
        }
        for map in MapCatalog.forLevel(level) {
            unlockedMapIDs.insert(map.id)
        }
    }
    
    /// 增加经验值（通过 LevelManager 调用）
    func addExperience(_ xp: Double) {
        experience += xp
        let required = LevelConfig.xpRequired(forLevel: level)
        while experience >= required {
            experience -= required
            level += 1
            checkUnlocks()
        }
    }
    
    /// 增加食物摄入，更新能量
    func consumeFood(calories: Double) {
        let energyGain = calories / 500.0
        self.energy = min(1.0, self.energy + energyGain)
        totalFoodLogsAllTime += 1
    }
}
