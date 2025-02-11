import SwiftUI

public struct BFStatCard: View {
    let value: String
    let label: String
    
    public init(value: String, label: String) {
        self.value = value
        self.label = label
    }
    
    public var body: some View {
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