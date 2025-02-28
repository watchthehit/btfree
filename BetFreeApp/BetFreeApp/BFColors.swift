import SwiftUI

struct BFColors {
    // Primary colors
    static let primary = Color("Primary", bundle: nil, defaultColor: Color(hex: "#3B82F6")) // Blue
    static let secondary = Color("Secondary", bundle: nil, defaultColor: Color(hex: "#10B981")) // Green
    static let accent = Color("Accent", bundle: nil, defaultColor: Color(hex: "#8B5CF6")) // Purple
    
    // Background colors
    static let background = Color("Background", bundle: nil, defaultColor: Color(hex: "#FFFFFF")) // White
    static let secondaryBackground = Color("SecondaryBackground", bundle: nil, defaultColor: Color(hex: "#F3F4F6")) // Light Gray
    
    // Text colors
    static let textPrimary = Color("TextPrimary", bundle: nil, defaultColor: Color(hex: "#1F2937")) // Dark Gray
    static let textSecondary = Color("TextSecondary", bundle: nil, defaultColor: Color(hex: "#6B7280")) // Medium Gray
    static let textTertiary = Color("TextTertiary", bundle: nil, defaultColor: Color(hex: "#9CA3AF")) // Light Gray
    
    // Semantic colors
    static let success = Color("Success", bundle: nil, defaultColor: Color(hex: "#10B981")) // Green
    static let warning = Color("Warning", bundle: nil, defaultColor: Color(hex: "#F59E0B")) // Amber
    static let error = Color("Error", bundle: nil, defaultColor: Color(hex: "#EF4444")) // Red
    static let info = Color("Info", bundle: nil, defaultColor: Color(hex: "#3B82F6")) // Blue
    
    // Custom colors for specific features
    static let calm = Color("Calm", bundle: nil, defaultColor: Color(hex: "#67E8F9")) // Light Blue
    static let focus = Color("Focus", bundle: nil, defaultColor: Color(hex: "#A78BFA")) // Lavender
    static let energy = Color("Energy", bundle: nil, defaultColor: Color(hex: "#FBBF24")) // Yellow
}

// Extension to create colors from hex values
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