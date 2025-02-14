import SwiftUI

public struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    
    public var body: some View {
        TabView(selection: $appState.selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            ProgressView()
                .tabItem {
                    Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(1)
            
            ResourcesView()
                .tabItem {
                    Label("Resources", systemImage: "book.fill")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(3)
        }
    }
    
    public init() {}
}

#Preview {
    MainTabView()
        .environmentObject(AppState.preview())
} 