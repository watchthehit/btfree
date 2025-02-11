import SwiftUI
import ComposableArchitecture

public struct DashboardView: View {
    @EnvironmentObject private var appState: AppState
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Stats Section
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Current Streak",
                            value: "\(appState.currentStreak) days",
                            icon: "flame.fill",
                            color: BFDesignSystem.Colors.primary
                        )
                        
                        StatCard(
                            title: "Total Savings",
                            value: "$\(String(format: "%.2f", appState.totalSavings))",
                            icon: "dollarsign.circle.fill",
                            color: BFDesignSystem.Colors.success
                        )
                    }
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Quick Actions")
                            .font(.headline)
                            .foregroundColor(BFDesignSystem.Colors.textPrimary)
                        
                        HStack(spacing: 16) {
                            QuickActionButton(
                                title: "Daily Check-in",
                                systemImage: "checkmark.circle.fill",
                                color: BFDesignSystem.Colors.primary
                            )
                            
                            QuickActionButton(
                                title: "View Progress",
                                systemImage: "chart.bar.fill",
                                color: BFDesignSystem.Colors.secondary
                            )
                        }
                    }
                }
                .padding()
            }
            .background(BFDesignSystem.Colors.background)
            .navigationTitle("Dashboard")
        }
    }
    
    public init() {}
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
            
            Text(value)
                .font(.title2)
                .bold()
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(12)
    }
}

struct QuickActionButton: View {
    let title: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: systemImage)
                .font(.system(size: 30))
                .foregroundColor(color)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    DashboardView()
        .environmentObject(AppState.shared)
} 