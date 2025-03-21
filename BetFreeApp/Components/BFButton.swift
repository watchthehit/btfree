import SwiftUI

/**
 * BFButton
 * A reusable button component that implements the BetFree design system
 * Supports primary, secondary, and text button styles with proper theming
 */
struct BFButton: View {
    enum ButtonStyle {
        case primary
        case secondary
        case text
    }
    
    var title: String
    var style: ButtonStyle = .primary
    var icon: String? = nil
    var action: () -> Void
    var isFullWidth: Bool = false
    var isDisabled: Bool = false
    
    var body: some View {
        Button(action: {
            if !isDisabled {
                action()
            }
        }) {
            HStack(spacing: 8) {
                // Optional icon
                if let iconName = icon {
                    Image(systemName: iconName)
                        .font(.system(size: 16, weight: .medium))
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(1)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .background(
                Group {
                    switch style {
                    case .primary:
                        BFColors.brandGradient()
                    case .secondary:
                        Color.clear
                    case .text:
                        Color.clear
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(
                        style == .secondary ? BFColors.secondary : Color.clear,
                        lineWidth: 1.5
                    )
            )
            .foregroundColor(buttonTextColor)
            .cornerRadius(8)
            .opacity(isDisabled ? 0.6 : 1.0)
            .shadow(
                color: style == .primary ? BFColors.healing.opacity(0.3) : Color.clear,
                radius: 4,
                x: 0,
                y: 2
            )
        }
        .disabled(isDisabled)
    }
    
    // Determine text color based on style and theme
    private var buttonTextColor: Color {
        switch style {
        case .primary:
            // For primary style, use white text for high contrast against gradient
            return Color.white
        case .secondary:
            // For secondary style, use secondary color for the border and text
            return BFColors.secondary
        case .text:
            // For text style, use calm for a more subtle appearance
            return BFColors.calm
        }
    }
}

// MARK: - Preview
struct BFButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Light mode preview
            VStack(spacing: 20) {
                BFButton(
                    title: "Continue",
                    style: .primary,
                    action: {}
                )
                
                BFButton(
                    title: "Learn More",
                    style: .secondary,
                    action: {}
                )
                
                BFButton(
                    title: "Skip",
                    style: .text,
                    action: {}
                )
                
                BFButton(
                    title: "Save Progress",
                    style: .primary,
                    icon: "arrow.down.doc.fill",
                    action: {},
                    isFullWidth: true
                )
                
                BFButton(
                    title: "Not Available",
                    style: .primary,
                    action: {},
                    isDisabled: true
                )
            }
            .padding()
            .background(BFColors.background)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Light Mode")
            
            // Dark mode preview
            VStack(spacing: 20) {
                BFButton(
                    title: "Continue",
                    style: .primary,
                    action: {}
                )
                
                BFButton(
                    title: "Learn More",
                    style: .secondary,
                    action: {}
                )
                
                BFButton(
                    title: "Skip",
                    style: .text,
                    action: {}
                )
                
                BFButton(
                    title: "Save Progress",
                    style: .primary,
                    icon: "arrow.down.doc.fill",
                    action: {},
                    isFullWidth: true
                )
                
                BFButton(
                    title: "Not Available",
                    style: .primary,
                    action: {},
                    isDisabled: true
                )
            }
            .padding()
            .background(BFColors.background)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Dark Mode")
            .preferredColorScheme(.dark)
        }
    }
} 