import SwiftUI
import BetFreeUI

struct EmptyStateView: View {
    let title: String
    let message: String
    let systemImage: String
    
    init(
        title: String = "No Data",
        message: String = "There's nothing to show here yet.",
        systemImage: String = "tray.fill"
    ) {
        self.title = title
        self.message = message
        self.systemImage = systemImage
    }
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            Image(systemName: systemImage)
                .font(.system(size: 48))
                .foregroundStyle(BFDesignSystem.Colors.calmingGradient)
            
            Text(title)
                .font(BFDesignSystem.Typography.titleMedium)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            Text(message)
                .font(BFDesignSystem.Typography.bodyMedium)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(BFDesignSystem.Layout.Spacing.xxLarge)
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.card)
        .withViewShadow(BFDesignSystem.Layout.Shadow.card)
    }
} 