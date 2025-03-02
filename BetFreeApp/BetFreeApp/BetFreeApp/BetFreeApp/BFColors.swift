import SwiftUI

/**
 * BFColors - Color management for the BetFree app
 *
 * This file implements the "Serene Strength" color scheme, which uses a palette of
 * deep blues, vibrant teals, and warm coral accents to create a powerful,
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
        dynamicColor(light: Color(hex: "#64FFDA"), dark: Color(hex: "#00E676"))
    }
    
    /// Coral Accent - Accent color providing warmth and encouragement
    public static var accent: Color {
        dynamicColor(light: Color(hex: "#FF7043"), dark: Color(hex: "#FF8A65"))
    }
    
    // MARK: - Theme Colors
    
    /// Ocean Blue - Used in relaxation-focused features
    public static var calm: Color {
        dynamicColor(light: Color(hex: "#415A77"), dark: Color(hex: "#546A8C"))
    }
    
    /// Aquamarine - Used in focus and mindfulness features
    public static var focus: Color {
        dynamicColor(light: Color(hex: "#00B4D8"), dark: Color(hex: "#00E5FF"))
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
        dynamicColor(light: Color(hex: "#FF9800"), dark: Color(hex: "#FFB74D"))
    }
    
    /// Error Red - Signals error states and critical alerts
    public static var error: Color {
        dynamicColor(light: Color(hex: "#F44336"), dark: Color(hex: "#FF5252"))
    }
    
    // MARK: - Neutral Colors
    
    /// Background color - Light Silver in light mode, Deep Space in dark mode
    public static var background: Color {
        dynamicColor(light: Color(hex: "#E0E1DD"), dark: Color(hex: "#0D1B2A"))
    }
    
    /// Secondary background color - Slightly darker than primary background
    public static var secondaryBackground: Color {
        dynamicColor(light: Color(hex: "#D2D3D9"), dark: Color(hex: "#1B263B"))
    }
    
    /// Card background - White in light mode, Navy in dark mode
    public static var cardBackground: Color {
        dynamicColor(light: Color(hex: "#FFFFFF"), dark: Color(hex: "#263F60"))
    }
    
    /// Primary text - Deep Space in light mode, Silver in dark mode
    public static var textPrimary: Color {
        dynamicColor(light: Color(hex: "#0D1B2A"), dark: Color(hex: "#E0E1DD"))
    }
    
    /// Secondary text - Navy in light mode, Light Silver in dark mode
    public static var textSecondary: Color {
        dynamicColor(light: Color(hex: "#1B263B"), dark: Color(hex: "#CCD1D9"))
    }
    
    /// Tertiary text - Blue Gray in both modes
    public static var textTertiary: Color {
        dynamicColor(light: Color(hex: "#415A77"), dark: Color(hex: "#778DA9"))
    }
    
    /// Divider - Light Gray in light mode, Dark Navy in dark mode
    public static var divider: Color {
        dynamicColor(light: Color(hex: "#CCD1D9"), dark: Color(hex: "#263F60"))
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
    
    /// Primary gradient - From Deep Space Blue to a slightly lighter shade
    public static func primaryGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [primary, Color(hex: "#1B263B")]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    /// Calm gradient - A soothing gradient for meditation features
    public static func calmGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [calm, Color(hex: "#778DA9")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Energy gradient - A vibrant, energizing gradient for achievements
    public static func energyGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [secondary, Color(hex: "#00BFA5")]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    /// Progress gradient - Used for progress indicators
    public static func progressGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [secondary, focus]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

/// Extension to create colors from hex values
extension Color {
    /// Initialize a Color from a hex string
    /// - Parameter hex: A hex string in the format "#RRGGBB" or "RRGGBB"
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 