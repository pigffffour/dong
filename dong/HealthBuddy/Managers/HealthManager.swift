import Foundation
import HealthKit
import Combine

/// 为将来扩展跑步、徒步等功能预留的协议
protocol Activity: Identifiable {
    var id: UUID { get }
    var name: String { get }
    var iconName: String { get }
    var duration: TimeInterval { get }
    var caloriesBurned: Double { get }
    var routeCoordinates: [Double]? { get } // 经纬度数据
}

/// 健康数据结构
struct HealthStats: Identifiable {
    let id: UUID = UUID()
    let steps: Int
    let sleepHours: Double
    let activeEnergyBurned: Double
}

/// 健康数据管理类
class HealthManager: ObservableObject {
    private let healthStore = HKHealthStore()
    
    @Published var currentStats: HealthStats = HealthStats(steps: 0, sleepHours: 0, activeEnergyBurned: 0)
    @Published var isAuthorized: Bool = false
    
    init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        let typesToRead: Set = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
            DispatchQueue.main.async {
                self.isAuthorized = success
                if success {
                    self.fetchTodayStats()
                }
            }
        }
    }
    
    /// 获取当日数据
    func fetchTodayStats() {
        // 实现读取步数、睡眠和活跃能量的逻辑
        // 这里提供简化的 fetch 方法占位
        fetchSteps { steps in
            self.fetchSleep { sleep in
                self.fetchEnergy { energy in
                    DispatchQueue.main.async {
                        self.currentStats = HealthStats(steps: Int(steps), sleepHours: sleep, activeEnergyBurned: energy)
                    }
                }
            }
        }
    }
    
    private func fetchSteps(completion: @escaping (Double) -> Void) {
        let steps = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let sum = result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
            completion(sum)
        }
        healthStore.execute(query)
    }
    
    private func fetchSleep(completion: @escaping (Double) -> Void) {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        // 统计过去 24 小时内的睡眠数据
        let now = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        let predicate = HKQuery.predicateForSamples(withStart: yesterday, end: now, options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { _, results, error in
            guard let samples = results as? [HKCategorySample] else {
                completion(0)
                return
            }
            
            // 计算处于睡眠状态（asleep, asleepCore, asleepDeep, asleepREM）的总时长
            let totalSleepTime = samples.filter { sample in
                // 在较新 iOS 版本中包含多种睡眠阶段
                return sample.value == HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue ||
                       sample.value == 3 || // .asleepCore
                       sample.value == 4 || // .asleepDeep
                       sample.value == 5    // .asleepREM
            }.reduce(0) { $0 + $1.endDate.timeIntervalSince($1.startDate) }
            
            completion(totalSleepTime / 3600.0) // 转换为小时
        }
        healthStore.execute(query)
    }
    
    private func fetchEnergy(completion: @escaping (Double) -> Void) {
        let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let sum = result?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0
            completion(sum)
        }
        healthStore.execute(query)
    }
}
