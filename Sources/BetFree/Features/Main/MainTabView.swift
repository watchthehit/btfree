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
                
                ProgressView(appState: appState)
                    .tabItem {
                        Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                    }
                    .tag(1)
                
                ProfileView(appState: appState)
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag(2)
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