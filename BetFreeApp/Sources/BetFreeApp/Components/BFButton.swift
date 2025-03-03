import SwiftUI

/**
 * BFButton - Custom button component for the BetFree app
 *
 * This component implements buttons using the "Serene Recovery" color scheme.
 * It provides primary, secondary, and tertiary button styles with appropriate
 * visual feedback for different states.
 */

/// The style of the button
public enum BFButtonStyle {
    case primary
    case secondary
    case tertiary
    case destructive
}

/// The position of the icon in the button
public enum BFIconPosition {
    case leading
    case trailing
}

/// A customizable button component that provides consistent styling
/// and visual feedback for different states.
@available(iOS 15.0, macOS 12.0, *)
public struct BFButton: View {
    // MARK: - Button Style
    
    private let title: String
    private let style: BFButtonStyle
    private let icon: Image?
    private let iconPosition: BFIconPosition
    private let isEnabled: Bool
    private let action: () -> Void
    
    // MARK: - Initialization
    
    public init(
        _ title: String,
        style: BFButtonStyle = .primary,
        icon: Image? = nil,
        iconPosition: BFIconPosition = .leading,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.icon = icon
        self.iconPosition = iconPosition
        self.isEnabled = isEnabled
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

@available(iOS 15.0, macOS 12.0, *)
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