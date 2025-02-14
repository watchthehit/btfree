import SwiftUI
import CoreData

struct AchievementCard: View {
    let achievement: Achievement
    @State private var isHovered = false
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.small) {
            // Icon
            ZStack {
                Circle()
                    .fill(achievement.color.opacity(0.1))
                    .frame(width: BFDesignSystem.Layout.Size.iconXLarge,
                           height: BFDesignSystem.Layout.Size.iconXLarge)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: BFDesignSystem.Layout.Size.iconLarge))
                    .foregroundColor(achievement.color)
                    .opacity(achievement.isUnlocked ? 1.0 : 0.5)
                    .scaleEffect(isHovered ? 1.1 : 1.0)
            }
            
            // Title
            Text(achievement.title)
                .font(BFDesignSystem.Typography.bodyLargeMedium)
                .foregroundColor(achievement.isUnlocked ? 
                    BFDesignSystem.Colors.textPrimary :
                    BFDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
            
            // Description
            Text(achievement.desc)
                .font(BFDesignSystem.Typography.caption)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.small)
                        .fill(BFDesignSystem.Colors.separator)
                        .frame(height: 4)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.small)
                        .fill(achievement.color)
                        .frame(width: geometry.size.width * achievement.progress, height: 4)
                }
            }
            .frame(height: 4)
            .padding(.top, BFDesignSystem.Layout.Spacing.xSmall)
        }
        .padding(BFDesignSystem.Layout.Spacing.medium)
        .frame(width: 150)
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.medium)
        .withShadow(isHovered ? BFDesignSystem.Layout.Shadow.medium : BFDesignSystem.Layout.Shadow.small)
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.spring(response: 0.3), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

#Preview {
    let context = CoreDataManager.shared.context
    let achievements = [
        createPreviewAchievement(title: "First Step", desc: "Complete your first day", icon: "figure.walk", color: BFDesignSystem.Colors.success, context: context),
        createPreviewAchievement(title: "Week Warrior", desc: "Complete a 7-day streak", icon: "star.fill", color: BFDesignSystem.Colors.primary, context: context),
        createPreviewAchievement(title: "Money Master", desc: "Save your first $100", icon: "dollarsign.circle.fill", color: BFDesignSystem.Colors.secondary, context: context)
    ]
    
    return ScrollView(.horizontal) {
        HStack {
            ForEach(achievements) { achievement in
                AchievementCard(achievement: achievement)
            }
        }
        .padding()
    }
    .background(BFDesignSystem.Colors.background)
}

private func createPreviewAchievement(title: String, desc: String, icon: String, color: Color, context: NSManagedObjectContext) -> Achievement {
    let achievement = Achievement(context: context)
    achievement.title = title
    achievement.desc = desc
    achievement.icon = icon
    achievement.colorHex = color.toHex() ?? "#007AFF"
    achievement.isUnlocked = false
    achievement.progress = 0.0
    achievement.unlockDate = nil
    achievement.lastCheckInHour = -1
    return achievement
} 