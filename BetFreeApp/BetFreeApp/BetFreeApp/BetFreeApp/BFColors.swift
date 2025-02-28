import SwiftUI

struct BFColors {
    // Primary palette
    static let primary = Color(hex: "#3F72AF")     // Calm blue - instills trust and reliability
    static let secondary = Color(hex: "#16A085")   // Healing green - represents growth and healing
    static let accent = Color(hex: "#FFB830")      // Warm amber - encourages positive action
    
    // Background colors
    static let background = Color(hex: "#FFFFFF")  // Pure white background
    static let secondaryBackground = Color(hex: "#F7F9FC") // Soft blue-tinted background
    static let cardBackground = Color(hex: "#FFFFFF").opacity(0.95) // Slightly transparent card backgrounds
    
    // Text colors
    static let textPrimary = Color(hex: "#2C3E50")   // Deep blue-gray - less harsh than black
    static let textSecondary = Color(hex: "#7F8C8D") // Medium gray with slight warmth
    static let textTertiary = Color(hex: "#BDC3C7")  // Light gray for less important text
    
    // Semantic colors
    static let success = Color(hex: "#27AE60")     // Vibrant green - achievement 
    static let warning = Color(hex: "#F39C12")     // Amber - caution
    static let error = Color(hex: "#E74C3C")       // Soft red - less aggressive than standard red
    static let info = Color(hex: "#3498DB")        // Sky blue - calming information
    
    // Emotional state colors
    static let calm = Color(hex: "#AED6F1")        // Soft blue - mindfulness
    static let focus = Color(hex: "#9B59B6")       // Purple - concentration
    static let healing = Color(hex: "#A2D9A1")     // Soft green - recovery
    
    // Gradient presets
    static func calmGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "#3F72AF"), Color(hex: "#5E97D1")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static func healingGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "#16A085"), Color(hex: "#A2D9A1")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static func energyGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "#FFB830"), Color(hex: "#FFDB8F")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
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