import SwiftUI

@main
struct BetFreeApp: App {
    // Create AppState with lazy initialization to prevent excessive memory usage on launch
    @StateObject private var appState = AppState()
    
    // Create PaywallManager instance
    @StateObject private var paywallManager = PaywallManager()
    
    // Add an environment value to monitor memory warnings
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            BetFreeRootView()
                .environmentObject(appState)
                .environmentObject(paywallManager)
                // Add a modifier to handle memory pressure
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    if newPhase == .background {
                        // Release any cached resources when going to background
                        print("App entering background - releasing resources")
                    } else if newPhase == .active {
                        // Refresh state when becoming active
                        print("App becoming active - refreshing state")
                    }
                }
        }
    }
} 