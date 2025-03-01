import SwiftUI

struct BFColors {
    // Primary Colors - Base Palette
    static let primary = Color(hex: "#3B82F6") // Blue
    static let secondary = Color(hex: "#10B981") // Green
    static let accent = Color(hex: "#8B5CF6") // Purple
    
    // Functional Colors
    static let success = Color(hex: "#10B981") // Green
    static let warning = Color(hex: "#F59E0B") // Amber
    static let error = Color(hex: "#EF4444") // Red
    
    // Theme Colors - For different emotional states
    static let calm = Color(hex: "#67E8F9") // Cyan
    static let focus = Color(hex: "#A78BFA") // Lavender
    static let hope = Color(hex: "#34D399") // Teal
    
    // Neutral Colors - For backgrounds, cards, and text - with dark mode support
    static let background = adaptiveColor(light: Color(hex: "#FFFFFF"), dark: Color(hex: "#1F2937"))
    static let cardBackground = adaptiveColor(light: Color(hex: "#F9FAFB"), dark: Color(hex: "#374151"))
    static let textPrimary = adaptiveColor(light: Color(hex: "#1F2937"), dark: Color(hex: "#F9FAFB"))
    static let textSecondary = adaptiveColor(light: Color(hex: "#6B7280"), dark: Color(hex: "#D1D5DB"))
    static let textTertiary = adaptiveColor(light: Color(hex: "#9CA3AF"), dark: Color(hex: "#9CA3AF"))
    static let divider = adaptiveColor(light: Color(hex: "#E5E7EB"), dark: Color(hex: "#4B5563"))
    
    // Helper Functions for Dynamic Coloring
    static func progressGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [primary, accent]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    static func calmingGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [calm.opacity(0.6), calm]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    static func themeGradient(for theme: AppState.AppTheme) -> LinearGradient {
        switch theme {
        case .standard:
            return progressGradient()
        case .calm:
            return calmingGradient()
        case .focus:
            return LinearGradient(
                gradient: Gradient(colors: [focus.opacity(0.7), focus]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .hope:
            return LinearGradient(
                gradient: Gradient(colors: [hope.opacity(0.6), hope]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    // Helper to get color based on craving intensity
    static func intensityColor(for level: Int) -> Color {
        switch level {
        case 0...3:
            return calm
        case 4...6:
            return warning
        case 7...10:
            return error
        default:
            return primary
        }
    }
    
    // Dark mode adjustments
    static func adaptiveColor(light: Color, dark: Color) -> Color {
        #if os(iOS)
        return Color(.init { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
        #else
        return light
        #endif
    }
}

// We'll keep the extension here for reference, but it's also in ColorExtensions.swift
extension Color {
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
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 