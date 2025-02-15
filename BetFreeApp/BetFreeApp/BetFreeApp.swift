import SwiftUI
import BetFree

@main
struct BetFreeApp: App {
    @StateObject private var appState = AppState(syncDataManager: DataManagerFactory.createDataManager())
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                BetFreeRootView()
                    .environmentObject(appState)
            }
        }
    }
}