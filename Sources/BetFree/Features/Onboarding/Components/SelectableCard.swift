import SwiftUI

struct SelectableCard: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(isSelected ? .white : BFDesignSystem.Colors.textPrimary)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .white : BFDesignSystem.Colors.textSecondary)
            }
            .padding()
            .background(isSelected ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.cardBackground)
            .cornerRadius(BFDesignSystem.Layout.CornerRadius.medium)
            .animation(.spring(), value: isSelected)
        }
    }
} 