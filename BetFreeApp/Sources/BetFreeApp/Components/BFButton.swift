import SwiftUI

/**
 * BFButton - Custom button component for the BetFree app
 *
 * This component implements buttons using the "Serene Recovery" color scheme.
 * It provides primary, secondary, and tertiary button styles with appropriate
 * visual feedback for different states.
 */
public struct BFButton: View {
    // MARK: - Button Style
    
    /// The style of the button
    public enum ButtonStyle {
        /// Primary button with deep teal background and white text
        case primary
        /// Secondary button with soft sage background and dark text
        case secondary
        /// Tertiary button with transparent background and colored text
        case tertiary
        /// Destructive button with error red background
        case destructive
    }
    
    // MARK: - Properties
    
    private let title: String
    private let style: ButtonStyle
    private let action: () -> Void
    private let isEnabled: Bool
    private let icon: Image?
    private let iconPosition: IconPosition
    
    /// Position of the icon relative to the text
    public enum IconPosition {
        case leading
        case trailing
    }
    
    // MARK: - Initializers
    
    /// Creates a new button with the specified parameters
    /// - Parameters:
    ///   - title: The text to display on the button
    ///   - style: The visual style of the button
    ///   - isEnabled: Whether the button is enabled
    ///   - icon: Optional icon to display alongside the text
    ///   - iconPosition: Position of the icon relative to the text
    ///   - action: The action to perform when the button is tapped
    public init(
        _ title: String,
        style: ButtonStyle = .primary,
        isEnabled: Bool = true,
        icon: Image? = nil,
        iconPosition: IconPosition = .leading,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.isEnabled = isEnabled
        self.icon = icon
        self.iconPosition = iconPosition
        self.action = action
    }
    
    // MARK: - Body
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon, iconPosition == .leading {
                    icon
                        .font(.system(size: 16, weight: .medium))
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                
                if let icon = icon, iconPosition == .trailing {
                    icon
                        .font(.system(size: 16, weight: .medium))
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: style == .tertiary ? 1 : 0)
            )
            .opacity(isEnabled ? 1.0 : 0.6)
        }
        .disabled(!isEnabled)
    }
    
    // MARK: - Helper Properties
    
    /// The background color of the button based on its style
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return BFColors.primary
        case .secondary:
            return BFColors.secondary
        case .tertiary:
            return Color.clear
        case .destructive:
            return BFColors.error
        }
    }
    
    /// The text color of the button based on its style
    private var foregroundColor: Color {
        switch style {
        case .primary, .destructive:
            return Color.white
        case .secondary:
            return BFColors.textPrimary
        case .tertiary:
            return BFColors.primary
        }
    }
    
    /// The border color of the button based on its style
    private var borderColor: Color {
        switch style {
        case .tertiary:
            return BFColors.primary.opacity(0.3)
        default:
            return Color.clear
        }
    }
}

// MARK: - Preview

struct BFButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            BFButton("Primary Button", style: .primary) {}
            BFButton("Secondary Button", style: .secondary) {}
            BFButton("Tertiary Button", style: .tertiary) {}
            BFButton("Destructive Button", style: .destructive) {}
            BFButton("Disabled Button", isEnabled: false) {}
            BFButton("With Leading Icon", icon: Image(systemName: "star.fill")) {}
            BFButton("With Trailing Icon", icon: Image(systemName: "arrow.right"), iconPosition: .trailing) {}
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
} 