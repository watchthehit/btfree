import SwiftUI

public struct MainTabView: View {
    @EnvironmentObject private var appState: AppState
    
    public var body: some View {
        TabView(selection: $appState.selectedTab) {
            Text("Home")
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            Text("Progress")
                .tabItem {
                    Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(1)
            
            Text("Community")
                .tabItem {
                    Label("Community", systemImage: "person.3.fill")
                }
                .tag(2)
            
            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
        }
    }
    
    public init() {}
} 