import SwiftUI

/**
 * BFDesignSystem - Core design system values for the BetFree app
 * 
 * This file centralizes spacing, animation, and component standards
 * to ensure consistent UI/UX across all screens of the application.
 */

// MARK: - Spacing System
struct BFSpacing {
    /// Tiny spacing (4pt) - For tight spacing between related elements
    static let tiny: CGFloat = 4
    
    /// Small spacing (8pt) - For closely related elements
    static let small: CGFloat = 8
    
    /// Medium spacing (16pt) - Default spacing between elements
    static let medium: CGFloat = 16
    
    /// Large spacing (24pt) - For section separation
    static let large: CGFloat = 24
    
    /// Extra large spacing (32pt) - For major section breaks
    static let xlarge: CGFloat = 32
    
    /// Double extra large spacing (48pt) - For very significant separations
    static let xxlarge: CGFloat = 48
    
    /// Screen horizontal padding (20pt) - Standard horizontal padding for screens
    static let screenHorizontal: CGFloat = 20
    
    /// Screen vertical padding (24pt) - Standard vertical padding for screen content
    static let screenVertical: CGFloat = 24
    
    /// Card padding (16pt) - Standard internal padding for cards
    static let cardPadding: CGFloat = 16
}

// MARK: - Animation System
struct BFAnimations {
    // MARK: - Durations
    
    /// Quick animations (0.2s) - For immediate feedback
    static let quickDuration: Double = 0.2
    
    /// Standard animations (0.4s) - For most UI transitions
    static let standardDuration: Double = 0.4
    
    /// Slow animations (0.6s) - For emphasis or dramatic effect
    static let slowDuration: Double = 0.6
    
    // MARK: - Standard Animations
    
    /// Standard in animation - For elements appearing
    static let standardAppear = Animation.easeOut(duration: standardDuration)
    
    /// Standard out animation - For elements disappearing
    static let standardDisappear = Animation.easeIn(duration: quickDuration)
    
    /// Emphasis animation - For drawing attention to elements
    static let emphasis = Animation.spring(response: 0.4, dampingFraction: 0.7)
    
    /// Subtle animation - For background or secondary animations
    static let subtle = Animation.easeInOut(duration: standardDuration)
    
    // MARK: - Staggered Animation Helper
    
    /// Creates a staggered animation with a base delay plus per-item delay
    /// - Parameters:
    ///   - baseDelay: Initial delay before the sequence starts
    ///   - itemIndex: Index of the current item in the sequence
    ///   - perItemDelay: Delay between each item in the sequence
    /// - Returns: Total delay to use for this item
    static func staggeredDelay(baseDelay: Double, itemIndex: Int, perItemDelay: Double = 0.1) -> Double {
        return baseDelay + (Double(itemIndex) * perItemDelay)
    }
}

// MARK: - Corner Radius Standards
struct BFCornerRadius {
    /// Small radius (6pt) - For subtle rounding
    static let small: CGFloat = 6
    
    /// Medium radius (12pt) - For standard elements like buttons and cards
    static let medium: CGFloat = 12
    
    /// Large radius (16pt) - For prominent elements
    static let large: CGFloat = 16
    
    /// Extra large radius (24pt) - For feature elements
    static let xlarge: CGFloat = 24
    
    /// Circle - For circular elements (use half of width/height)
    static func circle(size: CGFloat) -> CGFloat {
        return size / 2
    }
}

// MARK: - Shadow Standards
struct BFShadows {
    /// Subtle shadow - For slight elevation
    static func subtle() -> some ViewModifier {
        return ShadowModifier(color: BFColors.textPrimary.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    /// Medium shadow - For cards and interactive elements
    static func medium() -> some ViewModifier {
        return ShadowModifier(color: BFColors.textPrimary.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    /// Emphasized shadow - For elevated or focused elements
    static func emphasized() -> some ViewModifier {
        return ShadowModifier(color: BFColors.textPrimary.opacity(0.15), radius: 16, x: 0, y: 8)
    }
    
    /// Accent shadow - For primary action buttons
    static func accent() -> some ViewModifier {
        return ShadowModifier(color: BFColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

/// Private shadow modifier
private struct ShadowModifier: ViewModifier {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: radius, x: x, y: y)
    }
}

// MARK: - Shadow Extensions

extension View {
    /// Apply subtle shadow
    func subtleShadow() -> some View {
        self.modifier(BFShadows.subtle())
    }
    
    /// Apply medium shadow
    func mediumShadow() -> some View {
        self.modifier(BFShadows.medium())
    }
    
    /// Apply emphasized shadow
    func emphasizedShadow() -> some View {
        self.modifier(BFShadows.emphasized())
    }
    
    /// Apply accent shadow
    func accentShadow() -> some View {
        self.modifier(BFShadows.accent())
    }
    
    /// Apply standard screen padding
    func screenPadding() -> some View {
        self.padding(.horizontal, BFSpacing.screenHorizontal)
            .padding(.vertical, BFSpacing.screenVertical)
    }
} 