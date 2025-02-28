import SwiftUI

@main
struct BetFreeApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            BetFreeRootView()
                .environmentObject(appState)
        }
    }
} 