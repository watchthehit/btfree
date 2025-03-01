import SwiftUI

@main
struct BetFreeApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            BetFreeRootView()
                .environmentObject(appState)
                .preferredColorScheme(appState.preferredTheme == .focus ? .dark : nil)
                .accentColor(appState.preferredTheme.accentColor)
        }
    }
    
    init() {
        // Setup theme and appearance
        setupAppearance()
    }
    
    private func setupAppearance() {
        // Set up navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(BFColors.background)
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(BFColors.textPrimary)]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(BFColors.textPrimary)]
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        // Set up tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(BFColors.background)
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
} 