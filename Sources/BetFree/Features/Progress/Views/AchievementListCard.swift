import SwiftUI

struct AchievementListCard: View {
    let achievement: Achievement
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            // Icon Container
            Circle()
                .fill(achievement.color.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: achievement.icon)
                        .font(.system(size: 24))
                        .foregroundStyle(
                            achievement.isUnlocked ? 
                            achievement.color : 
                            BFDesignSystem.Colors.textSecondary
                        )
                        .opacity(achievement.isUnlocked ? 1 : 0.5)
                )
            
            VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.xSmall) {
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
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    .opacity(achievement.isUnlocked ? 1 : 0.7)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
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
                            .opacity(achievement.isUnlocked ? 1 : 0.5)
                    }
                }
                .frame(height: 4)
            }
            
            Spacer()
            
            // Progress Percentage and Date
            VStack(alignment: .trailing, spacing: BFDesignSystem.Layout.Spacing.xSmall) {
                Text("\(Int(achievement.progress * 100))%")
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(
                        achievement.isUnlocked ? 
                        achievement.color : 
                        BFDesignSystem.Colors.textSecondary
                    )
                
                if let unlockDate = achievement.unlockDate {
                    Text(unlockDate.formatted(.dateTime.month().day()))
                        .font(BFDesignSystem.Typography.caption)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
            }
        }
        .padding(BFDesignSystem.Layout.Spacing.medium)
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
    ScrollView {
        VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            ForEach(Achievement.samples) { achievement in
                AchievementListCard(achievement: achievement)
            }
        }
        .padding()
    }
    .background(BFDesignSystem.Colors.background)
} 