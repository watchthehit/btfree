import SwiftUI
import BetFreeUI

public struct MainTabView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedTab: Tab = .home
    
    private enum Tab {
        case home, progress, savings, profile, settings
        
        var title: String {
            switch self {
            case .home: return "Home"
            case .progress: return "Progress"
            case .savings: return "Savings"
            case .profile: return "Profile"
            case .settings: return "Settings"
            }
        }
        
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .progress: return "chart.line.uptrend.xyaxis"
            case .savings: return "dollarsign.circle.fill"
            case .profile: return "person.fill"
            case .settings: return "gear"
            }
        }
    }
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(Tab.home.title, systemImage: Tab.home.icon)
                }
                .tag(Tab.home)
            
            ProgressView()
                .tabItem {
                    Label(Tab.progress.title, systemImage: Tab.progress.icon)
                }
                .tag(Tab.progress)
            
            SavingsView()
                .tabItem {
                    Label(Tab.savings.title, systemImage: Tab.savings.icon)
                }
                .tag(Tab.savings)
            
            ProfileView()
                .tabItem {
                    Label(Tab.profile.title, systemImage: Tab.profile.icon)
                }
                .tag(Tab.profile)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(Tab.settings)
        }
        .tint(BFDesignSystem.Colors.primary)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState.preview)
}