import SwiftUI
import CoreData

public struct AchievementListView: View {
    @StateObject private var achievementManager = AchievementManager.shared
    @EnvironmentObject var appState: AppState
    @State private var isLoading = true
    @State private var error: Error?
    @State private var showingError = false
    
    private let categories = [
        "Streak Achievements",
        "Savings Achievements",
        "Check-in Achievements",
        "Transaction Achievements"
    ]
    
    private func achievementsForCategory(_ category: String) -> [Achievement] {
        let achievements = achievementManager.achievements
        switch category {
        case "Streak Achievements":
            return achievements.filter { ["First Step", "Week Warrior", "Monthly Marvel", "Quarterly Victor", "Annual Legend"].contains($0.title) }
        case "Savings Achievements":
            return achievements.filter { ["Money Master", "Savings Champion", "Wealth Builder", "Fortune Maker"].contains($0.title) }
        case "Check-in Achievements":
            return achievements.filter { ["Early Bird", "Night Owl", "Consistency King"].contains($0.title) }
        case "Transaction Achievements":
            return achievements.filter { ["Smart Saver", "Budget Master", "Goal Getter"].contains($0.title) }
        default:
            return []
        }
    }
    
    public var body: some View {
        Group {
            if isLoading {
                SwiftUI.ProgressView()
                    .scaleEffect(1.5)
            } else if !achievementManager.achievements.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.large) {
                        ForEach(categories, id: \.self) { category in
                            let categoryAchievements = achievementsForCategory(category)
                            if !categoryAchievements.isEmpty {
                                CategorySection(
                                    title: category,
                                    achievements: categoryAchievements
                                )
                            }
                        }
                    }
                    .padding(.vertical, BFDesignSystem.Layout.Spacing.medium)
                }
            } else {
                EmptyAchievementsView()
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
            Button("Retry") {
                Task {
                    await loadAchievements()
                }
            }
        } message: {
            if let error = error {
                Text(error.localizedDescription)
            }
        }
        .task {
            await loadAchievements()
        }
    }
    
    private func loadAchievements() async {
        isLoading = true
        do {
            try await achievementManager.initializeAchievements()
            await MainActor.run {
                withAnimation {
                    isLoading = false
                }
            }
        } catch {
            await MainActor.run {
                self.error = error
                self.showingError = true
                isLoading = false
            }
        }
    }
    
    public init() {}
}

private struct CategorySection: View {
    let title: String
    let achievements: [Achievement]
    
    var body: some View {
        VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.medium) {
            Text(title)
                .font(BFDesignSystem.Typography.titleSmall)
                .foregroundStyle(BFDesignSystem.Colors.primaryGradient)
                .padding(.horizontal, BFDesignSystem.Layout.Spacing.large)
            
            LazyVStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                ForEach(achievements) { achievement in
                    AchievementListCard(achievement: achievement)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
}

private struct EmptyAchievementsView: View {
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
            Image(systemName: "trophy.fill")
                .font(.system(size: BFDesignSystem.Layout.Size.iconXLarge))
                .foregroundStyle(BFDesignSystem.Colors.primaryGradient)
            
            Text("No Achievements")
                .font(BFDesignSystem.Typography.titleMedium)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            Text("Start your journey to unlock achievements!")
                .font(BFDesignSystem.Typography.bodyMedium)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    AchievementListView()
        .environmentObject(AppState.preview())
        .background(BFDesignSystem.Colors.background)
} 