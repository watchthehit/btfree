import SwiftUI

public struct MainTabView: View {
    public init() {}
    
    public var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Image(systemName: "sun.max.fill")
                    Text("Today")
                }
            
            BFProgressView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Progress")
                }
        }
    }
}