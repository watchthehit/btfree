import SwiftUI
import BetFreeUI

public struct MainTabView: View {
    @EnvironmentObject private var appState: AppState
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $appState.selectedTab) {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "sun.max.fill")
                }
                .tag(0)
            
            SavingsView()
                .tabItem {
                    Label("Savings", systemImage: "dollarsign.circle.fill")
                }
                .tag(1)
            
            CravingView()
                .tabItem {
                    Label("Cravings", systemImage: "exclamationmark.triangle.fill")
                }
                .tag(2)
            
            ProgressTrackingView()
                .tabItem {
                    Label("Progress", systemImage: "chart.line.uptrend.xyaxis.circle.fill")
                }
                .tag(3)
            
            ResourcesView()
                .tabItem {
                    Label("Resources", systemImage: "heart.circle.fill")
                }
                .tag(4)
        }
        .tint(BFDesignSystem.Colors.primary)
        .background(
            LinearGradient(
                colors: [
                    BFDesignSystem.Colors.background,
                    BFDesignSystem.Colors.background.opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .preferredColorScheme(appState.colorScheme)
        .overlay(alignment: .topTrailing) {
            ColorSchemeButton(colorScheme: appState.colorScheme) {
                appState.toggleColorScheme()
            }
            .padding()
        }
    }
}

private struct ColorSchemeButton: View {
    let colorScheme: ColorScheme?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.system(size: 20))
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
                .padding(12)
                .background(BFDesignSystem.Colors.secondaryBackground)
                .clipShape(Circle())
        }
    }
    
    private var iconName: String {
        switch colorScheme {
        case .none:
            return "circle.lefthalf.filled"
        case .dark:
            return "moon.fill"
        case .light:
            return "sun.max.fill"
        @unknown default:
            return "circle.lefthalf.filled"
        }
    }
}