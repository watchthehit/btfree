import SwiftUI

/**
 * BFColors - Color management for the BetFree app
 *
 * This file implements the "Serene Strength" color scheme, which uses a palette of
 * deep blues, vibrant teals, and coral accents to create a powerful,
 * motivating environment for users on their recovery journey.
 */
public struct BFColors {
    // MARK: - Primary Colors
    
    /// Deep Space Blue - Primary brand color representing strength and depth
    public static var primary: Color {
        dynamicColor(light: Color(hex: "#0D1B2A"), dark: Color(hex: "#1B263B"))
    }
    
    /// Vibrant Teal - Secondary color representing energy and clarity
    public static var secondary: Color {
        dynamicColor(light: Color(hex: "#00B2A9"), dark: Color(hex: "#00A896"))
    }
    
    /// Coral Accent - Accent color providing warmth and encouragement
    public static var accent: Color {
        dynamicColor(light: Color(hex: "#E94E34"), dark: Color(hex: "#E74C3C"))
    }
    
    /// Accent Red - Accent color providing warmth and encouragement
    public static var accentRed: Color {
        dynamicColor(light: Color(hex: "#E53935"), dark: Color(hex: "#F44336"))
    }
    
    // MARK: - Theme Colors
    
    /// Ocean Blue - Used in relaxation-focused features
    public static var calm: Color {
        dynamicColor(light: Color(hex: "#0097A7"), dark: Color(hex: "#00ACC1"))
    }
    
    /// Aquamarine - Used in focus and mindfulness features
    public static var focus: Color {
        dynamicColor(light: Color(hex: "#00897B"), dark: Color(hex: "#00ACC1"))
    }
    
    /// Warm Sand - Used in supportive content areas
    public static var hope: Color {
        dynamicColor(light: Color(hex: "#E0E1DD"), dark: Color(hex: "#CCD1D9"))
    }
    
    // MARK: - Additional Theme Colors
    
    /// Healing Green - A gentle teal for healing and growth content
    public static var healing: Color {
        dynamicColor(light: Color(hex: "#26A69A"), dark: Color(hex: "#00BFA5"))
    }
    
    /// Info Blue - A soft blue for informational content
    public static var info: Color {
        dynamicColor(light: Color(hex: "#0077B6"), dark: Color(hex: "#0096C7"))
    }
    
    // MARK: - Functional Colors
    
    /// Success Green - Indicates successful actions and achievements
    public static var success: Color {
        dynamicColor(light: Color(hex: "#4CAF50"), dark: Color(hex: "#5DBF61"))
    }
    
    /// Warning Amber - Used for cautionary messages requiring attention
    public static var warning: Color {
        dynamicColor(light: Color(hex: "#FFB74D"), dark: Color(hex: "#FFC107"))
    }
    
    /// Error Red - Signals error states and critical alerts
    public static var error: Color {
        dynamicColor(light: Color(hex: "#F95738"), dark: Color(hex: "#FF5252"))
    }
    
    // MARK: - Neutral Colors
    
    /// Background color - Light Sand in light mode, Dark Charcoal in dark mode
    public static var background: Color {
        dynamicColor(light: Color(hex: "#F7F3EB"), dark: Color(hex: "#1C1F2E"))
    }
    
    /// Secondary background color - Slightly darker than primary background
    public static var secondaryBackground: Color {
        dynamicColor(light: Color(hex: "#EAE6DE"), dark: Color(hex: "#252837"))
    }
    
    /// Card background - White in light mode, Charcoal in dark mode
    public static var cardBackground: Color {
        dynamicColor(light: Color(hex: "#FFFFFF"), dark: Color(hex: "#2D3142"))
    }
    
    /// Primary text - Deep Space in light mode, White in dark mode
    public static var textPrimary: Color {
        dynamicColor(light: Color(hex: "#0D1B2A"), dark: Color(hex: "#FFFFFF"))
    }
    
    /// Secondary text - Oxford Blue in light mode, Light Silver in dark mode
    public static var textSecondary: Color {
        dynamicColor(light: Color(hex: "#1B263B"), dark: Color(hex: "#E0E0E0"))
    }
    
    /// Tertiary text - Light Gray in both modes
    public static var textTertiary: Color {
        dynamicColor(light: Color(hex: "#505F79"), dark: Color(hex: "#BDBDBD"))
    }
    
    /// Divider - Light Gray in light mode, Dark Blue in dark mode
    public static var divider: Color {
        dynamicColor(light: Color(hex: "#E6EBF0"), dark: Color(hex: "#2C3E50"))
    }
    
    // MARK: - Dynamic Colors
    
    /// Creates a dynamic color that adapts to light and dark mode
    /// - Parameters:
    ///   - light: Color to use in light mode
    ///   - dark: Color to use in dark mode
    /// - Returns: Color that adapts to the current color scheme
    private static func dynamicColor(light: Color, dark: Color) -> Color {
        #if os(iOS)
        return Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light) })
        #else
        return light // Default to light color on non-iOS platforms for now
        #endif
    }
    
    // MARK: - Gradients
    
    /// Primary gradient - From Deep Space Blue to Oxford Blue
    public static func primaryGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "#0D1B2A"), Color(hex: "#1B263B")]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    /// Brand gradient - From Vibrant Teal to Ocean Blue
    public static func brandGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "#64FFDA"), Color(hex: "#00B4D8")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Energy gradient - From Ocean Blue to Coral
    public static func energyGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "#00B4D8"), Color(hex: "#F95738")]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    /// Progress gradient - Used for progress indicators
    public static func progressGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [secondary, calm]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// MARK: - Color extension has been moved to avoid duplication
// The Color extension with hex support should be imported from ColorExtensions.swift instead of being defined here
