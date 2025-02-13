import SwiftUI

public struct AchievementListView: View {
    @ObservedObject private var achievementManager = AchievementManager.shared
    @State private var achievements: [Achievement] = []
    @State private var isLoading = true
    @State private var error: Error?
    @State private var showingError = false
    
    public var body: some View {
        Group {
            if isLoading {
                SwiftUI.ProgressView()
                    .scaleEffect(1.5)
            } else if !achievements.isEmpty {
                ScrollView {
                    LazyVStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                        ForEach(achievements) { achievement in
                            AchievementListCard(achievement: achievement)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding()
                }
            } else {
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
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            if let error = error {
                Text(error.localizedDescription)
            }
        }
        .onAppear(perform: loadAchievements)
    }
    
    private func loadAchievements() {
        isLoading = true
        do {
            achievements = try achievementManager.getAllAchievements()
            withAnimation {
                isLoading = false
            }
        } catch {
            self.error = error
            self.showingError = true
            isLoading = false
        }
    }
    
    public init() {}
}

private struct AchievementListCard: View {
    let achievement: Achievement
    @State private var isHovered = false
    @State private var iconScale: CGFloat = 1.0
    
    var body: some View {
        HStack(spacing: BFDesignSystem.Layout.Spacing.large) {
            // Icon
            Image(systemName: achievement.icon)
                .font(.system(size: BFDesignSystem.Layout.Size.iconLarge))
                .foregroundStyle(
                    achievement.isUnlocked ? 
                    achievement.color : 
                    BFDesignSystem.Colors.textSecondary
                )
                .opacity(achievement.isUnlocked ? 1 : 0.5)
                .scaleEffect(isHovered && achievement.isUnlocked ? 1.1 : 1.0)
                .animation(.spring(response: 0.3), value: isHovered)
            
            VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.small) {
                // Title
                Text(achievement.title)
                    .font(BFDesignSystem.Typography.bodyLargeMedium)
                    .foregroundColor(
                        achievement.isUnlocked ? 
                        BFDesignSystem.Colors.textPrimary : 
                        BFDesignSystem.Colors.textSecondary
                    )
                
                // Description
                Text(achievement.desc)
                    .font(BFDesignSystem.Typography.caption)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    .opacity(achievement.isUnlocked ? 1 : 0.7)
                
                // Progress Bar
                SwiftUI.ProgressView(value: achievement.progress)
                    .tint(achievement.color)
                    .opacity(achievement.isUnlocked ? 1 : 0.5)
            }
            
            Spacer()
            
            // Unlock Date
            if let unlockDate = achievement.unlockDate {
                Text(unlockDate.formatted(.dateTime.month().day()))
                    .font(BFDesignSystem.Typography.caption)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.large)
                .fill(BFDesignSystem.Colors.cardBackground)
                .withShadow(isHovered ? BFDesignSystem.Layout.Shadow.medium : BFDesignSystem.Layout.Shadow.small)
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.spring(response: 0.3), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

#Preview {
    AchievementListView()
} 