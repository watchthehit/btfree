import SwiftUI
import ComposableArchitecture
import BetFree
import BetFreeUI
import BetFreeModels

@main
struct BetFreeApp: App {
    @StateObject private var appState: AppState
    
    init() {
        // Initialize Core Data manager first
        let dataManager = CoreDataManager.shared
        print("📱 Core Data manager initialized")
        
        // Create AppState with the data manager
        _appState = StateObject(wrappedValue: AppState(dataManager: dataManager))
        print("📱 App state created")
    }
    
    var body: some Scene {
        WindowGroup {
            BetFreeRootView(dataManager: appState.dataManager)
                .environmentObject(appState)
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("Welcome to BetFree!")
            .padding()
    }
} 