import Foundation
import UIKit
import Combine

/// 食物识别结果模型
struct FoodRecognitionResult: Identifiable {
    let id = UUID()
    let name: String
    let calories: Double
    let confidence: Float
}

/// 识别服务协议，支持未来切换本地模型或 API
protocol CalorieRecognitionService {
    func recognizeFood(from image: UIImage, completion: @escaping (Result<[FoodRecognitionResult], Error>) -> Void)
}

/// Mock API 实现（用于初版演示）
class MockAPICalorieService: CalorieRecognitionService {
    func recognizeFood(from image: UIImage, completion: @escaping (Result<[FoodRecognitionResult], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            let mockResults = [
                FoodRecognitionResult(name: "苹果", calories: 52.0, confidence: 0.95),
                FoodRecognitionResult(name: "牛排", calories: 250.0, confidence: 0.88),
                FoodRecognitionResult(name: "披萨", calories: 266.0, confidence: 0.75)
            ]
            completion(.success(mockResults))
        }
    }
}

/// 核心饮食管理类：管理今日饮食记录 + 食物识别
class CalorieManager: ObservableObject {
    @Published var todayMeals: [FoodRecord] = []
    @Published var recognitionResults: [FoodRecognitionResult] = []
    @Published var isProcessing: Bool = false
    
    private let service: CalorieRecognitionService
    private let persistence: LocalPersistenceService
    
    var totalCaloriesToday: Int {
        Int(todayMeals.reduce(0) { $0 + $1.calories })
    }
    
    init(service: CalorieRecognitionService = MockAPICalorieService(), persistence: LocalPersistenceService) {
        self.service = service
        self.persistence = persistence
        loadTodayMeals()
    }
    
    /// 从持久化加载今日饮食
    func loadTodayMeals() {
        let saved = (try? persistence.fetchTodayFoodRecords()) ?? []
        if saved.isEmpty {
            // 开发阶段：无记录时加载示例数据
            todayMeals = Self.demoMeals
        } else {
            todayMeals = saved
        }
    }

    /// 示例数据（开发用，后续移除）
    static let demoMeals: [FoodRecord] = [
        FoodRecord(foodName: "面包", emoji: "🥐", calories: 320, confidence: 0.92, mealType: .breakfast),
        FoodRecord(foodName: "意面", emoji: "🍝", calories: 680, confidence: 0.88, mealType: .lunch),
        FoodRecord(foodName: "水果", emoji: "🍎", calories: 95, confidence: 0.95, mealType: .snack),
        FoodRecord(foodName: "奶茶", emoji: "🍵", calories: 260, confidence: 0.80, mealType: .snack),
        FoodRecord(foodName: "沙拉", emoji: "🥗", calories: 185, confidence: 0.90, mealType: .dinner),
    ]
    
    /// 添加一餐记录
    func addMeal(_ record: FoodRecord) {
        try? persistence.saveFoodRecord(record)
        todayMeals.append(record)
    }
    
    /// 删除一餐记录
    func removeMeal(at index: Int) {
        guard todayMeals.indices.contains(index) else { return }
        todayMeals.remove(at: index)
        // 持久化层暂不支持单条删除，后续补充
    }
    
    /// 拍照识别食物
    func processImage(_ image: UIImage) {
        isProcessing = true
        service.recognizeFood(from: image) { [weak self] result in
            DispatchQueue.main.async {
                self?.isProcessing = false
                switch result {
                case .success(let results):
                    self?.recognitionResults = results
                case .failure(let error):
                    print("识别失败: \(error.localizedDescription)")
                }
            }
        }
    }
}
