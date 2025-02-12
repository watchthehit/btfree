import SwiftUI

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
            Text(achievement.description)
                .font(BFDesignSystem.Typography.caption)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
            
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
    ScrollView(.horizontal) {
        HStack {
            ForEach(Achievement.samples) { achievement in
                AchievementCard(achievement: achievement)
            }
        }
        .padding()
    }
    .background(BFDesignSystem.Colors.background)
} 