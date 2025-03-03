import SwiftUI

/**
 * BFUIStandardization - Utilities to ensure consistent UI styling across the app
 *
 * This file provides extensions and utilities to standardize the appearance
 * of all UI elements in the app and enforce proper use of the design system.
 */

// MARK: - Color Standardization Extensions

extension Color {
    // MARK: - Standard UI Color Replacements
    
    /// Standard replacement for Color.white
    static var bfWhite: Color {
        return Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(BFColors.background) : UIColor.white })
    }
    
    /// Standard replacement for Color.black
    static var bfBlack: Color {
        return Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor.black : UIColor(BFColors.textPrimary) })
    }
    
    /// Standard replacement for Color.gray and its variants
    static func bfGray(opacity: Double = 1.0) -> Color {
        return BFColors.textTertiary.opacity(opacity)
    }
    
    /// Standard replacement for Color.red
    static var bfRed: Color {
        return BFColors.error
    }
    
    /// Standard replacement for Color.green
    static var bfGreen: Color {
        return BFColors.success
    }
    
    /// Standard replacement for alert colors
    static var bfWarning: Color {
        return BFColors.warning
    }
    
    // MARK: - Semantic Background Colors
    
    /// Standard overlay color with proper opacity for dark/light modes
    static func bfOverlay(opacity: Double = 0.1) -> Color {
        return Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? 
                UIColor(white: 1.0, alpha: opacity) : 
                UIColor(white: 0.0, alpha: opacity)
        })
    }
    
    /// Standard shadow color with proper opacity for dark/light modes
    static func bfShadow(opacity: Double = 0.1) -> Color {
        return Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? 
                UIColor(BFColors.textPrimary).withAlphaComponent(opacity) : 
                UIColor.black.withAlphaComponent(opacity)
        })
    }
}

// MARK: - Standard Background Styles

extension View {
    /// Apply a standard card background with appropriate styling for the app
    func standardCardBackground(cornerRadius: CGFloat = BFCornerRadius.medium) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(BFColors.cardBackground)
                .shadow(color: Color.bfShadow(opacity: 0.07), radius: 8, x: 0, y: 3)
        )
    }
    
    /// Apply a standard overlay background with opacity adjustment
    func standardOverlay(opacity: Double = 0.1, cornerRadius: CGFloat = BFCornerRadius.medium) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.bfOverlay(opacity: opacity))
        )
    }
    
    /// Apply a standard selection state background 
    func standardSelectionBackground(isSelected: Bool, cornerRadius: CGFloat = BFCornerRadius.medium) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(isSelected ? BFColors.accent.opacity(0.2) : Color.bfOverlay(opacity: 0.08))
        )
    }
}

// MARK: - Standard Spacing Extensions

extension View {
    /// Apply standard content spacing to a stack
    func standardContentSpacing() -> some View {
        self.padding(.horizontal, BFSpacing.screenHorizontal)
            .padding(.vertical, BFSpacing.medium)
    }
    
    /// Apply standard section spacing between elements
    func standardSectionSpacing() -> some View {
        self.padding(.vertical, BFSpacing.large)
    }
}

// MARK: - Animation Standardization Extensions

extension Animation {
    /// Standard appear animation
    static var bfAppear: Animation {
        .easeOut(duration: BFAnimations.standardDuration)
    }
    
    /// Standard disappear animation
    static var bfDisappear: Animation {
        .easeIn(duration: BFAnimations.quickDuration)
    }
    
    /// Standard button press animation
    static var bfButtonPress: Animation {
        .spring(response: 0.3, dampingFraction: 0.6)
    }
    
    /// Standard emphasis animation for drawing attention
    static var bfEmphasis: Animation {
        .spring(response: 0.5, dampingFraction: 0.7)
    }
    
    /// Create a standard delayed animation
    static func bfDelayed(delay: Double = 0.2, animation: Animation = .bfAppear) -> Animation {
        animation.delay(delay)
    }
    
    /// Standard staggered animation for lists
    static func bfStaggered(index: Int, baseDelay: Double = 0.1) -> Animation {
        .easeOut(duration: BFAnimations.standardDuration)
            .delay(baseDelay + (Double(index) * 0.05))
    }
}

// MARK: - Animation View Extensions

extension View {
    /// Apply standard fade-in animation
    func fadeInAnimation(isActive: Bool, delay: Double = 0) -> some View {
        self.opacity(isActive ? 1 : 0)
            .animation(
                .easeInOut(duration: BFAnimations.standardDuration)
                    .delay(delay),
                value: isActive
            )
    }
    
    /// Apply standard slide-in animation from a direction
    func slideInAnimation(isActive: Bool, from edge: Edge, delay: Double = 0) -> some View {
        self.opacity(isActive ? 1 : 0)
            .offset(x: edge == .leading ? (isActive ? 0 : -20) : 
                     (edge == .trailing ? (isActive ? 0 : 20) : 0),
                   y: edge == .top ? (isActive ? 0 : -20) : 
                     (edge == .bottom ? (isActive ? 0 : 20) : 0))
            .animation(
                .easeOut(duration: BFAnimations.standardDuration)
                    .delay(delay),
                value: isActive
            )
    }
    
    /// Apply standard scale animation
    func scaleAnimation(isActive: Bool, delay: Double = 0) -> some View {
        self.scaleEffect(isActive ? 1.0 : 0.95)
            .opacity(isActive ? 1 : 0)
            .animation(
                .spring(response: 0.4, dampingFraction: 0.8)
                    .delay(delay),
                value: isActive
            )
    }
    
    /// Apply standard button tap animation
    func buttonTapAnimation() -> some View {
        self.scaleEffect(0.98)
            .animation(.bfButtonPress, value: true)
    }
    
    /// Apply animated entrance for content with staggered children
    func animatedEntrance<Content: View>(
        isActive: Bool,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            if isActive {
                content()
            }
        }
        .animation(.bfAppear, value: isActive)
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
    
    /// Apply accessibility-aware animation (respects reduced motion setting)
    func accessibleAnimation<Value: Equatable>(_ animation: Animation?, value: Value, reduceMotion: Bool = false) -> some View {
        if reduceMotion {
            return self.animation(nil, value: value)
        } else {
            return self.animation(animation, value: value)
        }
    }
}

// MARK: - Usage Guide
/**
 * How to use this standardization file:
 *
 * 1. Replace direct color usage with semantic colors:
 *    - Instead of Color.white, use Color.bfWhite
 *    - Instead of Color.black.opacity(0.1), use Color.bfShadow(opacity: 0.1)
 *    - Instead of Color.gray, use Color.bfGray()
 *
 * 2. Use standard background styles:
 *    - Instead of custom card backgrounds, use .standardCardBackground()
 *    - Instead of custom overlays, use .standardOverlay()
 *    - For selection states, use .standardSelectionBackground(isSelected: bool)
 *
 * 3. Use standard spacing:
 *    - For content containers, use .standardContentSpacing()
 *    - For section spacing, use .standardSectionSpacing()
 */ 