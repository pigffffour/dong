import Foundation

struct FoodRecord: Codable, Identifiable {
    let id: UUID
    var foodName: String
    var emoji: String
    var calories: Double
    var confidence: Float
    var macros: Macros?
    var mealType: MealType
    let recognitionSource: String
    let timestamp: Date
    var syncStatus: HealthRecord.SyncStatus
    
    struct Macros: Codable {
        var carbsGrams: Double?
        var proteinGrams: Double?
        var fatGrams: Double?
        var fiberGrams: Double?
    }
    
    enum MealType: String, Codable, CaseIterable {
        case breakfast = "早餐"
        case lunch = "午餐"
        case dinner = "晚餐"
        case snack = "加餐"
    }
    
    init(foodName: String, emoji: String = "🍽️", calories: Double, confidence: Float,
         mealType: MealType = .lunch, recognitionSource: String = "mock") {
        self.id = UUID()
        self.foodName = foodName
        self.emoji = emoji
        self.calories = calories
        self.confidence = confidence
        self.mealType = mealType
        self.recognitionSource = recognitionSource
        self.timestamp = Date()
        self.syncStatus = .pending
    }
}
