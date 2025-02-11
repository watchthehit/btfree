import SwiftUI
import ComposableArchitecture

public struct MainTabView: View {
    @EnvironmentObject private var appState: AppState
    
    public var body: some View {
        TabView(selection: $appState.selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
                .tag(0)
            
            ResourcesView()
                .tabItem {
                    Label("Resources", systemImage: "book.fill")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
        }
    }
    
    public init() {}
} 