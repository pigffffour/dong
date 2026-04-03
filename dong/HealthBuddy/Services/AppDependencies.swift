import Foundation
import SwiftUI
import Combine

/// 全局依赖注入容器，在 App 启动时创建并注入环境
final class AppDependencies: ObservableObject {
    let persistenceService: LocalPersistenceService
    let keychainService: KeychainService
    let authService: AuthService
    let energyEngine: EnergyEngineProtocol
    let levelManager: LevelManager
    let streakManager: StreakManager
    let healthManager: HealthManager
    let calorieManager: CalorieManager
    
    @MainActor
    init() {
        let persistence = LocalPersistenceService()
        let keychain = KeychainService()
        
        // 开发期使用 MockSMSProvider，生产环境切换 AliyunSMSProvider
        let smsProvider: SMSProviderProtocol = MockSMSProvider()
        
        self.persistenceService = persistence
        self.keychainService = keychain
        self.authService = AuthService(smsProvider: smsProvider, keychain: keychain, persistence: persistence)
        self.energyEngine = EnergyEngineFactory.create()
        self.levelManager = LevelManager(persistence: persistence)
        self.streakManager = StreakManager(persistence: persistence)
        self.healthManager = HealthManager()
        self.calorieManager = CalorieManager(persistence: persistence)
    }
}
