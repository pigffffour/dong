import SwiftUI
import Combine

final class BuilderAppState: ObservableObject {
    enum OnboardingStep: Int, CaseIterable {
        case welcome
        case perm1
        case perm2
        case perm3
        case create
    }
    
    enum Tab: Hashable {
        case buddy
        case record
        case explore
        case profile
    }
    
    @Published var onboardingStep: OnboardingStep = .welcome
    @Published var onboardingCompleted: Bool {
        didSet { UserDefaults.standard.set(onboardingCompleted, forKey: "onboardingCompleted") }
    }
    
    @Published var selectedTab: Tab = .buddy
    @Published var buddy: Buddy = Buddy()
    @Published var selectedFoodEnergyBonus: Int = 12
    @Published var showFoodLoading: Bool = false
    @Published var showFoodResults: Bool = false
    @Published var showFeedResult: Bool = false
    
    init() {
        self.onboardingCompleted = UserDefaults.standard.bool(forKey: "onboardingCompleted")
    }
    
    /// 从持久化数据恢复伙伴状态
    func restoreBuddy(from persistence: PersistenceServiceProtocol) {
        if let data = try? persistence.loadBuddy() {
            self.buddy = Buddy(from: data)
        }
    }
    
    /// 保存伙伴状态
    func saveBuddy(to persistence: PersistenceServiceProtocol) {
        try? persistence.saveBuddy(buddy.toBuddyData())
    }
    
    func resetToWelcome() {
        onboardingStep = .welcome
        onboardingCompleted = false
        selectedTab = .buddy
        buddy = Buddy()
    }
}

struct BuilderRootView: View {
    @EnvironmentObject private var deps: AppDependencies
    @EnvironmentObject private var authService: AuthService
    @StateObject private var appState = BuilderAppState()
    @State private var bodyDataComplete = false
    
    var body: some View {
        NavigationStack {
            Group {
                if !authService.isLoggedIn {
                    // 未登录 → 手机号登录
                    PhoneLoginView()
                } else if !bodyDataComplete && !(authService.currentUser?.bodyProfile.isComplete ?? false) {
                    // 已登录但未填写身体数据
                    BodyDataCollectionView(isComplete: $bodyDataComplete)
                } else if appState.onboardingCompleted {
                    // 一切就绪 → 主界面
                    BuilderMainShell()
                } else {
                    // 需完成引导流程
                    BuilderOnboardingFlow()
                }
            }
            .navigationBarHidden(true)
        }
        .environmentObject(appState)
        .environmentObject(deps.authService)
        .environmentObject(deps.calorieManager)
        .onAppear {
            appState.restoreBuddy(from: deps.persistenceService)
            deps.streakManager.checkStreakContinuity()
        }
    }
}
