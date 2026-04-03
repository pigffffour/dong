import SwiftUI

@main
struct HealthBuddyApp: App {
    @StateObject private var dependencies = AppDependencies()
    
    var body: some Scene {
        WindowGroup {
            BuilderRootView()
                .environmentObject(dependencies)
                .environmentObject(dependencies.authService)
                .environmentObject(dependencies.calorieManager)
        }
    }
}
