import SwiftUI

// MARK: - Component Library

/// Reusable UI components for the BetFree app
enum BFComponents {
    
    // MARK: - Cards
    
    /// Standard card component with consistent styling
    struct Card<Content: View>: View {
        var title: String?
        var icon: String?
        var iconColor: Color?
        let content: Content
        
        init(
            title: String? = nil,
            icon: String? = nil,
            iconColor: Color? = nil,
            @ViewBuilder content: () -> Content
        ) {
            self.title = title
            self.icon = icon
            self.iconColor = iconColor
            self.content = content()
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                if let title = title {
                    HStack {
                        if let icon = icon, let iconColor = iconColor {
                            Image(systemName: icon)
                                .font(BFTypography.subheadlineBold())
                                .foregroundColor(iconColor)
                                .frame(width: 30, height: 30)
                                .background(
                                    Circle()
                                        .fill(iconColor.opacity(0.1))
                                )
                        }
                        
                        Text(title)
                            .font(BFTypography.title3())
                            .foregroundColor(BFColors.textPrimary)
                        
                        Spacer()
                    }
                    
                    Divider()
                        .background(BFColors.textTertiary)
                }
                
                content
                    .foregroundColor(BFColors.textPrimary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(BFColors.cardBackground)
            )
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(BFColors.textPrimary.opacity(0.1), lineWidth: 1)
            )
        }
    }
    
    /// Feature card with gradient background and stronger visual presence
    struct FeatureCard<Content: View>: View {
        var title: String
        var gradient: LinearGradient
        let content: Content
        
        init(
            title: String,
            gradient: LinearGradient = BFColors.accentGradient,
            @ViewBuilder content: () -> Content
        ) {
            self.title = title
            self.gradient = gradient
            self.content = content()
        }
        
        var body: some View {
            ZStack(alignment: .leading) {
                // Background with gradient
                Rectangle()
                    .fill(gradient)
                    .cornerRadius(12)
                
                // Content
                VStack(alignment: .leading, spacing: 16) {
                    Text(title)
                        .font(BFTypography.title3())
                        .foregroundColor(.white)
                    
                    content
                }
                .padding(20)
            }
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
    }
    
    // MARK: - Buttons
    
    /// Primary button with standardized styling
    struct PrimaryButton: View {
        let title: String
        let icon: String?
        let action: () -> Void
        
        init(title: String, icon: String? = nil, action: @escaping () -> Void) {
            self.title = title
            self.icon = icon
            self.action = action
        }
        
        var body: some View {
            Button(action: {
                HapticManager.shared.playLightFeedback()
                action()
            }) {
                HStack(spacing: 8) {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(BFTypography.subheadlineBold())
                    }
                    
                    Text(title)
                        .font(BFTypography.buttonPrimary())
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background(
                    ZStack {
                        // Gradient background
                        RoundedRectangle(cornerRadius: 10)
                            .fill(BFColors.accentGradient)
                        
                        // Shine effect
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.0)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .center
                                )
                            )
                    }
                )
                .foregroundColor(.white)
                .shadow(color: BFColors.accent.opacity(0.4), radius: 10, x: 0, y: 5)
            }
            .buttonStyle(PressableButtonStyle())
        }
    }
    
    /// Secondary button with lighter visual weight
    struct SecondaryButton: View {
        let title: String
        let icon: String?
        let action: () -> Void
        
        init(title: String, icon: String? = nil, action: @escaping () -> Void) {
            self.title = title
            self.icon = icon
            self.action = action
        }
        
        var body: some View {
            Button(action: {
                HapticManager.shared.playLightFeedback()
                action()
            }) {
                HStack(spacing: 8) {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(BFTypography.subheadlineBold())
                    }
                    
                    Text(title)
                        .font(BFTypography.buttonSecondary())
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(BFColors.accent.opacity(0.1))
                )
                .foregroundColor(BFColors.accent)
            }
            .buttonStyle(PressableButtonStyle())
        }
    }
    
    /// Text-only button
    struct TextButton: View {
        let title: String
        let action: () -> Void
        
        init(title: String, action: @escaping () -> Void) {
            self.title = title
            self.action = action
        }
        
        var body: some View {
            Button(action: {
                HapticManager.shared.playLightFeedback()
                action()
            }) {
                Text(title)
                    .font(BFTypography.buttonSecondary())
                    .foregroundColor(BFColors.accent)
                    .padding(.vertical, 8)
            }
        }
    }
    
    /// Icon button with circle background
    struct IconButton: View {
        let icon: String
        let color: Color
        let action: () -> Void
        
        init(icon: String, color: Color = BFColors.accent, action: @escaping () -> Void) {
            self.icon = icon
            self.color = color
            self.action = action
        }
        
        var body: some View {
            Button(action: {
                HapticManager.shared.playLightFeedback()
                action()
            }) {
                Image(systemName: icon)
                    .font(BFTypography.title3())
                    .foregroundColor(color)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(color.opacity(0.1))
                    )
            }
            .buttonStyle(PressableButtonStyle())
        }
    }
    
    // MARK: - Pressable Button Style
    
    struct PressableButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
        }
    }
    
    // MARK: - Stats & Metrics
    
    /// Standard metric card for displaying statistics
    struct MetricCard: View {
        let title: String
        let value: String
        let icon: String
        let iconColor: Color
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: icon)
                        .font(BFTypography.title3())
                        .foregroundColor(iconColor)
                    
                    Spacer()
                }
                
                Spacer()
                
                Text(value)
                    .font(BFTypography.statMedium())
                    .foregroundColor(BFColors.textPrimary)
                
                Text(title)
                    .font(BFTypography.caption())
                    .foregroundColor(BFColors.textSecondary)
            }
            .padding(16)
            .frame(height: 125)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                BFColors.cardBackground.opacity(0.8),
                                BFColors.cardBackground
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(BFColors.textPrimary.opacity(0.1), lineWidth: 1)
            )
        }
    }
    
    // MARK: - Screen Backgrounds
    
    /// Standard background for all screens
    struct ScreenBackground<Content: View>: View {
        let content: Content
        
        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        var body: some View {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        BFColors.background,
                        BFColors.background.opacity(0.95)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                // Content
                content
            }
        }
    }
    
    // MARK: - Button Size Enum
    
    /// Button size definitions
    enum BFButtonSize {
        case small
        case medium
        case large
        
        var padding: EdgeInsets {
            switch self {
            case .small:
                return EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
            case .medium:
                return EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
            case .large:
                return EdgeInsets(top: 14, leading: 24, bottom: 14, trailing: 24)
            }
        }
        
        var font: Font {
            switch self {
            case .small:
                return BFTypography.buttonSmall()
            case .medium:
                return BFTypography.buttonSecondary()
            case .large:
                return BFTypography.buttonPrimary()
            }
        }
    }
    
    // MARK: - Accessibility Components
    
    /// Accessibility label with icon
    struct AccessibilityLabel: View {
        let icon: String
        let text: String
        
        var body: some View {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(BFTypography.caption())
                
                Text(text)
                    .font(BFTypography.caption())
            }
            .foregroundColor(BFColors.textSecondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(BFColors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(BFColors.textSecondary.opacity(0.2), lineWidth: 1)
            )
        }
    }
    
    // MARK: - Input Components
    
    /// Styled text field with title
    struct StyledTextField: View {
        let title: String
        @Binding var text: String
        let placeholder: String
        let keyboardType: UIKeyboardType
        let isSecure: Bool
        
        init(
            title: String,
            text: Binding<String>,
            placeholder: String = "",
            keyboardType: UIKeyboardType = .default,
            isSecure: Bool = false
        ) {
            self.title = title
            self._text = text
            self.placeholder = placeholder
            self.keyboardType = keyboardType
            self.isSecure = isSecure
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(BFTypography.caption())
                    .foregroundColor(BFColors.textSecondary)
                
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .font(BFTypography.body())
                        .keyboardType(keyboardType)
                        .padding()
                        .background(BFColors.inputBackground)
                        .cornerRadius(10)
                } else {
                    TextField(placeholder, text: $text)
                        .font(BFTypography.body())
                        .keyboardType(keyboardType)
                        .padding()
                        .background(BFColors.inputBackground)
                        .cornerRadius(10)
                }
            }
        }
    }
}

// MARK: - Button Style Extensions

extension View {
    /// Applies the primary button style
    func bfPrimaryButton(isWide: Bool = true, size: BFComponents.BFButtonSize = .medium) -> some View {
        self.font(size.font)
            .padding(size.padding)
            .frame(maxWidth: isWide ? .infinity : nil)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(BFColors.accentGradient)
            )
            .foregroundColor(.white)
            .shadow(color: BFColors.accent.opacity(0.3), radius: 5, x: 0, y: 3)
    }
    
    /// Applies the secondary button style
    func bfSecondaryButton(isWide: Bool = false, size: BFComponents.BFButtonSize = .medium) -> some View {
        self.font(size.font)
            .padding(size.padding)
            .frame(maxWidth: isWide ? .infinity : nil)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(BFColors.accent.opacity(0.1))
            )
            .foregroundColor(BFColors.accent)
    }
    
    /// Applies the text button style
    func bfTextButton() -> some View {
        self.font(BFTypography.buttonSecondary())
            .foregroundColor(BFColors.accent)
    }
} 