import SwiftUI

public struct MainTabView: View {
    @ObservedObject var appState: AppState
    
    public var body: some View {
        ZStack {
            BFDesignSystem.Colors.background
                .ignoresSafeArea()
            
            TabView(selection: $appState.selectedTab) {
                DashboardView(appState: appState)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(0)
                
                ProfileView(appState: appState)
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag(1)
            }
        }
        .onAppear {
            // Configure tab bar appearance
            #if canImport(UIKit)
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            UITabBar.appearance().standardAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
            #endif
        }
    }
    
    public init(appState: AppState) {
        self.appState = appState
    }
} 