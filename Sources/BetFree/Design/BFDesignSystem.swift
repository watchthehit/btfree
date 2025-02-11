import SwiftUI

public enum BFDesignSystem {
    public enum Colors {
        // Primary Brand Colors
        public static let primary = Color(hex: "4A90E2")  // Calming blue - represents trust and stability
        public static let secondary = Color(hex: "9B6EF3") // Soft purple - represents transformation
        public static let accent = Color(hex: "FFB547")    // Warm orange - represents energy and motivation
        
        // Semantic Colors
        public static let success = Color(hex: "4CAF50")   // Growth green
        public static let warning = Color(hex: "FF9F43")   // Mindful orange
        public static let error = Color(hex: "FF5252")     // Gentle red
        public static let info = Color(hex: "2196F3")      // Clear blue
        
        // Gradients
        public static let primaryGradient = LinearGradient(
            colors: [primary, primary.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let accentGradient = LinearGradient(
            colors: [accent, secondary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Background Colors
        public static let background = Color(hex: "F8FAFC")  // Soft white
        public static let cardBackground = Color(hex: "FFFFFF") // Pure white
        public static let overlay = Color.black.opacity(0.4)    // Modal overlay
        
        // Text Colors
        public static let textPrimary = Color(hex: "1A1F36")   // Deep blue-gray
        public static let textSecondary = Color(hex: "64748B")  // Medium gray
        public static let textTertiary = Color(hex: "94A3B8")   // Light gray
    }
    
    public enum Typography {
        // Display & Titles
        public static let display = Font.system(size: 40, weight: .bold, design: .rounded)
        public static let titleLarge = Font.system(size: 32, weight: .bold, design: .rounded)
        public static let titleMedium = Font.system(size: 24, weight: .semibold, design: .rounded)
        public static let titleSmall = Font.system(size: 20, weight: .semibold, design: .rounded)
        
        // Body Text
        public static let bodyLarge = Font.system(size: 18, weight: .regular)
        public static let bodyMedium = Font.system(size: 16, weight: .regular)
        public static let bodySmall = Font.system(size: 14, weight: .regular)
        
        // Special Text
        public static let caption = Font.system(size: 12, weight: .medium)
        public static let button = Font.system(size: 16, weight: .semibold)
        public static let quote = Font.system(size: 24, weight: .medium, design: .serif)
    }
    
    public enum Layout {
        public enum Spacing {
            public static let xxxSmall: CGFloat = 2
            public static let xxSmall: CGFloat = 4
            public static let xSmall: CGFloat = 8
            public static let small: CGFloat = 12
            public static let medium: CGFloat = 16
            public static let large: CGFloat = 24
            public static let xLarge: CGFloat = 32
            public static let xxLarge: CGFloat = 40
            public static let xxxLarge: CGFloat = 48
        }
        
        public enum CornerRadius {
            public static let small: CGFloat = 8
            public static let medium: CGFloat = 12
            public static let large: CGFloat = 16
            public static let xLarge: CGFloat = 24
            public static let button: CGFloat = 12
            public static let card: CGFloat = 16
        }
        
        public enum Size {
            public static let iconSmall: CGFloat = 20
            public static let iconMedium: CGFloat = 24
            public static let iconLarge: CGFloat = 32
            public static let iconXLarge: CGFloat = 48
            
            public static let buttonHeight: CGFloat = 48
            public static let inputHeight: CGFloat = 44
            public static let cardMinHeight: CGFloat = 80
            
            public static let progressCircleLarge: CGFloat = 160
            public static let progressCircleMedium: CGFloat = 120
            public static let progressCircleSmall: CGFloat = 80
        }
        
        public enum Shadow {
            public static let small = ShadowStyle(
                color: Colors.textPrimary.opacity(0.05),
                radius: 4,
                x: 0,
                y: 2
            )
            
            public static let medium = ShadowStyle(
                color: Colors.textPrimary.opacity(0.08),
                radius: 8,
                x: 0,
                y: 4
            )
            
            public static let large = ShadowStyle(
                color: Colors.textPrimary.opacity(0.12),
                radius: 16,
                x: 0,
                y: 8
            )
            
            public static let button = ShadowStyle(
                color: Colors.primary.opacity(0.3),
                radius: 8,
                x: 0,
                y: 4
            )
        }
        
        public enum Animation {
            public static let spring = Animation.spring(
                response: 0.5,
                dampingFraction: 0.7,
                blendDuration: 0
            )
            
            public static let easeOut = Animation.easeOut(duration: 0.3)
            public static let easeIn = Animation.easeIn(duration: 0.3)
            
            public static func springWithDelay(_ delay: Double) -> Animation {
                Animation.spring(
                    response: 0.5,
                    dampingFraction: 0.7,
                    blendDuration: 0
                ).delay(delay)
            }
        }
    }
}

// MARK: - Helper Extensions
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
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

public struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

extension View {
    func withShadow(_ style: ShadowStyle) -> some View {
        self.shadow(
            color: style.color,
            radius: style.radius,
            x: style.x,
            y: style.y
        )
    }
} 