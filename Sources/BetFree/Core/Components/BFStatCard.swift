import SwiftUI

public struct BFStatCard: View {
    let value: String
    let label: String
    
    public init(value: String, label: String) {
        self.value = value
        self.label = label
    }
    
    public var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.small) {
            Text(value)
                .font(BFDesignSystem.Typography.titleLarge)
                .foregroundColor(BFDesignSystem.Colors.primary)
            
            Text(label)
                .font(BFDesignSystem.Typography.caption)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.medium)
        .withShadow(BFDesignSystem.Layout.Shadow.small)
    }
} 