import SwiftUI
import ComposableArchitecture

public struct ProgressView: View {
    @ObservedObject var appState: AppState
    @State private var selectedTimeframe: Timeframe = .week
    @State private var isAnimated = false
    
    enum Timeframe: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
                // Progress Summary
                VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.medium) {
                    Text("Your Progress")
                        .font(BFDesignSystem.Typography.titleLarge)
                        .foregroundStyle(BFDesignSystem.Colors.primaryGradient)
                    
                    Text("Keep going! You're doing great.")
                        .font(BFDesignSystem.Typography.bodyLarge)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : 20)
                
                // Timeframe Selector
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(Timeframe.allCases, id: \.self) { timeframe in
                        Text(timeframe.rawValue)
                            .tag(timeframe)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : 20)
                
                // Progress Chart
                ProgressChartView(appState: appState, timeframe: selectedTimeframe)
                    .frame(height: 200)
                    .padding(.horizontal)
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 20)
                
                // Stats Grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: BFDesignSystem.Layout.Spacing.medium) {
                    StatCard(
                        title: "Longest Streak",
                        value: "\(appState.streak) days",
                        icon: "flame.fill",
                        gradient: BFDesignSystem.Colors.warmGradient
                    )
                    
                    StatCard(
                        title: "Total Savings",
                        value: "$\(String(format: "%.2f", appState.savings))",
                        icon: "dollarsign.circle.fill",
                        gradient: BFDesignSystem.Colors.mindfulGradient
                    )
                }
                .padding(.horizontal)
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : 20)
                
                // Achievements
                VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.medium) {
                    Text("Achievements")
                        .font(BFDesignSystem.Typography.titleSmall)
                        .foregroundStyle(BFDesignSystem.Colors.primaryGradient)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                            ForEach(Achievement.samples) { achievement in
                                AchievementCard(achievement: achievement)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : 20)
            }
            .padding(.vertical, BFDesignSystem.Layout.Spacing.large)
        }
        .navigationTitle("Progress")
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isAnimated = true
            }
        }
    }
    
    public init(appState: AppState) {
        self.appState = appState
    }
}

#Preview {
    NavigationView {
        ProgressView(appState: AppState())
    }
} 