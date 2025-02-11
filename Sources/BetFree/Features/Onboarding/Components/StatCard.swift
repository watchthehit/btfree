import SwiftUI

struct StatCard: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.xxSmall) {
            Text(value)
                .font(BFDesignSystem.Typography.titleLarge)
                .foregroundColor(BFDesignSystem.Colors.primary)
            
            Text(label)
                .font(BFDesignSystem.Typography.bodySmall)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
        }
        .padding()
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.medium)
    }
} 