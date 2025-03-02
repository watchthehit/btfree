import SwiftUI

/**
 * BFColors
 * The central color system for the BetFree app, implementing the Serene Strength palette.
 * This file provides consistent color references for use throughout the app.
 */
struct BFColors {
    // MARK: - Primary Colors
    
    /// Deep Space Blue - Main background color
    static let deepSpaceBlue = Color(hex: "#0D1B2A")
    
    /// Oxford Blue - Secondary background color for cards and sections
    static let oxfordBlue = Color(hex: "#1B263B")
    
    /// Vibrant Teal - Primary accent color used in the logo and key UI elements
    static let vibrantTeal = Color(hex: "#64FFDA")
    
    /// Ocean Blue - Secondary accent color for buttons and highlights
    static let oceanBlue = Color(hex: "#00B4D8")
    
    /// Coral - Accent color for alerts and important actions
    static let coral = Color(hex: "#F95738")
    
    // MARK: - Logo Colors (matches our implementation)
    
    /// Logo Primary - The main gradient start color for the logo
    static let logoPrimary = vibrantTeal
    
    /// Logo Secondary - The main gradient end color for the logo
    static let logoSecondary = oceanBlue
    
    /// Logo Background - The background color for the logo (dark mode)
    static let logoBackground = deepSpaceBlue
    
    /// Logo Outline - The outline color for the logo (light mode)
    static let logoOutline = oxfordBlue
    
    // MARK: - Text Colors
    
    /// Primary text color - high contrast
    static let textPrimary = Color.white
    
    /// Secondary text color - medium contrast
    static let textSecondary = Color(hex: "#BFCDE0")
    
    /// Tertiary text color - lowest contrast, for hints and disabled states
    static let textTertiary = Color(hex: "#718096")
    
    // MARK: - Functional Colors
    
    /// Success green for positive feedback
    static let success = Color(hex: "#4CAF50")
    
    /// Warning amber for caution states
    static let warning = Color(hex: "#FFB74D")
    
    /// Error red for critical alerts
    static let error = coral
    
    /// Neutral gray for inactive or disabled states
    static let neutral = Color(hex: "#90A4AE")
    
    // MARK: - Gradients
    
    /// Returns the main brand gradient from vibrant teal to ocean blue
    static func brandGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [vibrantTeal, oceanBlue]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Returns a serene dark gradient for backgrounds
    static func darkGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [deepSpaceBlue, oxfordBlue]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// Returns an energetic gradient for highlights and CTAs
    static func energyGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [oceanBlue, coral]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    // MARK: - Color Mode Adaptive Colors
    
    /// Returns background color appropriate for the current color scheme
    static func adaptiveBackground(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? deepSpaceBlue : Color(hex: "#F5F8FA")
    }
    
    /// Returns text color appropriate for the current color scheme
    static func adaptiveText(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? .white : oxfordBlue
    }
    
    /// Returns card background color appropriate for the current color scheme
    static func adaptiveCardBackground(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? oxfordBlue : .white
    }
}

// MARK: - View Extension
extension View {
    /// Applies the BetFree brand style to a view
    func betFreeBrandStyle() -> some View {
        self
            .accentColor(BFColors.vibrantTeal)
            .tint(BFColors.vibrantTeal)
    }
} 