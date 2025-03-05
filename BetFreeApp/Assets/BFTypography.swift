import SwiftUI

/**
 * BFTypography - Typography system for the BetFree app.
 *
 * This file provides consistent font styles throughout the app.
 * All text elements should use these predefined styles to maintain
 * visual consistency.
 */
public struct BFTypography {
    // Title text style - Largest heading
    public static func title(_ size: CGFloat = 24) -> Font {
        return .system(size: size, weight: .bold, design: .rounded)
    }
    
    // Headline text style - Medium heading
    public static func headline(_ size: CGFloat = 18) -> Font {
        return .system(size: size, weight: .semibold, design: .rounded)
    }
    
    // Body text style - Regular text
    public static func body(_ size: CGFloat = 16) -> Font {
        return .system(size: size, weight: .regular, design: .rounded)
    }
    
    // Caption text style - Small text
    public static func caption(_ size: CGFloat = 13) -> Font {
        return .system(size: size, weight: .regular, design: .rounded)
    }
    
    // Button text style - Text for buttons
    public static func button(_ size: CGFloat = 16) -> Font {
        return .system(size: size, weight: .semibold, design: .rounded)
    }
}

// MARK: - SwiftUI Text Extensions

extension Text {
    // Title style
    public func titleStyle(_ size: CGFloat = 24) -> some View {
        self.font(BFTypography.title(size))
            .foregroundColor(BFColors.textPrimary)
    }
    
    // Headline style
    public func headlineStyle(_ size: CGFloat = 18) -> some View {
        self.font(BFTypography.headline(size))
            .foregroundColor(BFColors.textPrimary)
    }
    
    // Body style
    public func bodyStyle(_ size: CGFloat = 16) -> some View {
        self.font(BFTypography.body(size))
            .foregroundColor(BFColors.textPrimary)
    }
    
    // Caption style
    public func captionStyle(_ size: CGFloat = 13) -> some View {
        self.font(BFTypography.caption(size))
            .foregroundColor(BFColors.textSecondary)
    }
    
    // Button style
    public func buttonStyle(_ size: CGFloat = 16) -> some View {
        self.font(BFTypography.button(size))
            .foregroundColor(BFColors.primary)
    }
} 