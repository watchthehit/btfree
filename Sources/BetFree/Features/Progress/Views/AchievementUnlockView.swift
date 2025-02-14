import SwiftUI
import CoreData

public struct AchievementUnlockView: View {
    let achievement: Achievement
    @State private var isAnimating = false
    @State private var iconScale: CGFloat = 1.0
    
    public var body: some View {
        HStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            // Achievement Icon
            Image(systemName: achievement.icon)
                .font(.system(size: BFDesignSystem.Layout.Size.iconXLarge))
                .foregroundStyle(achievement.color)
                .scaleEffect(iconScale)
                .onAppear {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.5).repeatCount(1)) {
                        iconScale = 1.2
                    }
                }
            
            VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.small) {
                // Title
                Text("Achievement Unlocked!")
                    .font(BFDesignSystem.Typography.titleMedium)
                    .foregroundStyle(BFDesignSystem.Colors.primaryGradient)
                
                // Achievement Name
                Text(achievement.title)
                    .font(BFDesignSystem.Typography.bodyLargeMedium)
                    .foregroundColor(BFDesignSystem.Colors.textPrimary)
                
                // Description
                Text(achievement.desc)
                    .font(BFDesignSystem.Typography.caption)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
        }
        .padding(BFDesignSystem.Layout.Spacing.large)
        .background(
            RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.large)
                .fill(BFDesignSystem.Colors.cardBackground)
                .withShadow(BFDesignSystem.Layout.Shadow.large)
        )
        .opacity(isAnimating ? 1 : 0)
        .offset(y: isAnimating ? 0 : 50)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isAnimating = true
            }
            HapticFeedback.fireAndForget(style: .medium)
        }
    }
    
    public init(achievement: Achievement) {
        self.achievement = achievement
    }
}

public struct AchievementUnlockOverlay: View {
    @ObservedObject private var achievementManager = AchievementManager.shared
    
    public var body: some View {
        VStack {
            if achievementManager.isShowingUnlockAnimation {
                ForEach(achievementManager.recentlyUnlocked) { achievement in
                    AchievementUnlockView(achievement: achievement)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: achievementManager.isShowingUnlockAnimation)
        .padding(.top, BFDesignSystem.Layout.Spacing.xxLarge)
    }
    
    public init() {}
}

#Preview {
    let context = CoreDataManager.shared.context
    let achievement = Achievement(context: context)
    achievement.title = "First Step"
    achievement.desc = "Complete your first day"
    achievement.icon = "figure.walk"
    achievement.colorHex = BFDesignSystem.Colors.success.toHex() ?? "#007AFF"
    
    return AchievementUnlockView(achievement: achievement)
        .background(BFDesignSystem.Colors.background)
} 