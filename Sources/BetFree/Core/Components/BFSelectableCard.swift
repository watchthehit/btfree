import SwiftUI
import BetFreeUI

public struct BFSelectableCard: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    public init(title: String, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(isSelected ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.textPrimary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(BFDesignSystem.Colors.primary)
                }
            }
            .padding(BFDesignSystem.Layout.Spacing.medium)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.medium)
                    .fill(BFDesignSystem.Colors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.medium)
                            .stroke(isSelected ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.border, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
} 