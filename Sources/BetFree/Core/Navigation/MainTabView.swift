import SwiftUI
import ComposableArchitecture

public struct MainTabView: View {
    @EnvironmentObject private var appState: AppState
    
    public var body: some View {
        NavigationView {
            TabView(selection: $appState.selectedTab) {
                DashboardView()
                    .environmentObject(appState)
                    .tabItem {
                        Label("Dashboard", systemImage: "house.fill")
                    }
                    .tag(0)
                
                ResourcesView()
                    .environmentObject(appState)
                    .tabItem {
                        Label("Resources", systemImage: "book.fill")
                    }
                    .tag(1)
                
                ProfileView()
                    .environmentObject(appState)
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag(2)
            }
            .accentColor(BFDesignSystem.Colors.primary)
        }
    }
    
    public init() {}
} 