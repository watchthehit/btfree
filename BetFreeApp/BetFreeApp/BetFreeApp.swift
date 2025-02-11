import SwiftUI
import BetFree
import ComposableArchitecture

@main
struct BetFreeApp: App {
    init() {
        // Force onboarding for testing
        UserDefaults.standard.set(false, forKey: "isOnboarded")
    }
    
    var body: some Scene {
        WindowGroup {
            BetFreeRootView(
                appState: AppState.shared,
                store: Store(initialState: AppFeature.State()) {
                    AppFeature()
                }
            )
        }
    }
}

struct MainView: View {
    var body: some View {
        BetFreeRootView()
    }
} 