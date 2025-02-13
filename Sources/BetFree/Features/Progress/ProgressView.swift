import SwiftUI
import ComposableArchitecture
import CoreData

public struct ProgressView: View {
    @ObservedObject var appState: AppState
    @State private var selectedTimeframe: Timeframe = .week
    @State private var isAnimated = false
    @State private var achievements: [Achievement] = []
    @State private var error: Error?
    
    private let achievementService: AchievementService
    
    private struct ProgressStatCard: View {
        let title: String
        let value: String
        let icon: String
        let gradient: LinearGradient
        
        var body: some View {
            VStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                Text(title)
                    .font(BFDesignSystem.Typography.caption)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                
                Text(value)
                    .font(BFDesignSystem.Typography.titleMedium)
                    .foregroundColor(BFDesignSystem.Colors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(BFDesignSystem.Colors.cardBackground)
            .cornerRadius(BFDesignSystem.Layout.CornerRadius.medium)
        }
    }
    
    public init(appState: AppState) {
        self.appState = appState
        self.achievementService = AchievementService(context: CoreDataManager.shared.context)
    }
    
    public enum Timeframe: String, CaseIterable {
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
                    
                    Text("Keep going! Every day is a step forward.")
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
                    ProgressStatCard(
                        title: "Longest Streak",
                        value: "\(appState.streak) days",
                        icon: "flame.fill",
                        gradient: BFDesignSystem.Colors.warmGradient
                    )
                    
                    ProgressStatCard(
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
                            ForEach(achievements, id: \.id) { achievement in
                                AchievementCard(achievement: achievement)
                                    .frame(width: 160)
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
            loadAchievements()
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isAnimated = true
            }
        }
        .alert("Error", isPresented: .constant(error != nil)) {
            Button("OK") { error = nil }
        } message: {
            Text(error?.localizedDescription ?? "An unknown error occurred")
        }
    }
    
    private func loadAchievements() {
        do {
            try achievementService.initializeDefaultAchievementsIfNeeded()
            achievements = try achievementService.fetchAchievements()
            
            try achievementService.checkAndUpdateAchievements(
                streak: Int32(appState.streak),
                savings: appState.savings
            )
        } catch {
            self.error = error
        }
    }
}

#Preview {
    NavigationView {
        ProgressView(appState: AppState())
    }
} 
