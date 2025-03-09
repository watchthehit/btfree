import SwiftUI

/// BetFree Design System Colors
/// A comprehensive color system that supports both light and dark modes
/// with clear semantic meaning and consistent application

struct BFColors {
    // MARK: - Brand Colors
    
    /// Primary brand color - Used for main actions and key UI elements
    static let primary = Color("BFPrimary", bundle: nil)
    
    /// Secondary brand color - Used for complementary UI elements
    static let secondary = Color("BFSecondary", bundle: nil)
    
    /// Accent color - Used for highlighting and important elements
    static let accent = Color("BFAccent", bundle: nil)
    
    // MARK: - Background Colors
    
    /// Main app background
    static let background = Color("BFBackground", bundle: nil)
    
    /// Secondary background for visual hierarchy (cards, sections)
    static let cardBackground = Color("BFCardBackground", bundle: nil)
    
    /// Input field background
    static let inputBackground = Color("BFInputBackground", bundle: nil)
    
    // MARK: - Text Colors
    
    /// Primary text - Highest contrast
    static let textPrimary = Color("BFTextPrimary", bundle: nil)
    
    /// Secondary text - Medium contrast for subtitles, descriptions
    static let textSecondary = Color("BFTextSecondary", bundle: nil)
    
    /// Tertiary text - Lowest contrast for hints, footnotes
    static let textTertiary = Color("BFTextTertiary", bundle: nil)
    
    // MARK: - Semantic Colors
    
    /// Success color - Used for positive outcomes
    static let success = Color("BFSuccess", bundle: nil)
    
    /// Warning color - Used for cautionary elements
    static let warning = Color("BFWarning", bundle: nil)
    
    /// Error color - Used for negative outcomes
    static let error = Color("BFError", bundle: nil)
    
    // MARK: - Feature-specific Colors
    
    /// Streak-related elements
    static let streak = Color("BFStreak", bundle: nil)
    
    /// Money/savings-related elements
    static let savings = Color("BFSavings", bundle: nil)
    
    /// Mindfulness-related elements
    static let mindfulness = Color("BFMindfulness", bundle: nil)
    
    // MARK: - Gradients
    
    /// Main app gradient
    static let primaryGradient = LinearGradient(
        colors: [primary, primary.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Accent gradient for buttons and important UI elements
    static let accentGradient = LinearGradient(
        colors: [accent, accent.opacity(0.8)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    /// Streak gradient for motivation elements
    static let streakGradient = LinearGradient(
        colors: [streak, streak.opacity(0.7)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // MARK: - Utility Methods
    
    /// Returns an appropriate color for urge trigger categories
    static func colorForTrigger(_ category: EnhancedTriggerCategory) -> Color {
        switch category {
        case .stress:
            return Color("BFTriggerStress", bundle: nil)
        case .boredom:
            return Color("BFTriggerBoredom", bundle: nil)
        case .social:
            return Color("BFTriggerSocial", bundle: nil)
        case .celebration:
            return Color("BFTriggerCelebration", bundle: nil)
        case .sadness:
            return Color("BFTriggerSadness", bundle: nil)
        case .habit:
            return Color("BFTriggerHabit", bundle: nil)
        case .other:
            return Color("BFTriggerOther", bundle: nil)
        }
    }
}

// MARK: - Helper Extensions

extension Color {
    /// Creates a color with the specified hex string
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
            (a, r, g, b) = (255, 0, 0, 0)
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