import SwiftUI
import BetFree

@main
struct BetFreeApp: App {
    @StateObject private var appState = AppState(syncDataManager: MockCDManager.shared)
    
    var body: some Scene {
        WindowGroup {
            BetFreeRootView()
                .environmentObject(appState)
        }
    }
} 