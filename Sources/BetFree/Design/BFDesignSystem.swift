import SwiftUI

public enum BFDesignSystem {
    public enum Colors {
        // Primary Brand Colors
        public static let primary = Color(hex: "6C5CE7")  // Modern Purple
        public static let secondary = Color(hex: "00B894")  // Fresh Mint
        public static let accent = Color(hex: "FD79A8")  // Soft Pink
        
        // Semantic Colors
        public static let success = Color(hex: "00B894")  // Fresh Green
        public static let info = Color(hex: "74B9FF")  // Sky Blue
        public static let warning = Color(hex: "FDCB6E")  // Warm Yellow
        public static let error = Color(hex: "FF7675")  // Soft Red
        
        // Text Colors
        public static let textPrimary = Color(hex: "2D3436")  // Deep Gray
        public static let textSecondary = Color(hex: "636E72")  // Medium Gray
        public static let textTertiary = Color(hex: "B2BEC3")  // Light Gray
        
        // Background Colors
        public static let cardBackground = Color(hex: "FFFFFF")  // Pure White
        public static let background = Color(hex: "F7F7F9")  // Soft Background
        public static let separator = Color(hex: "DFE6E9").opacity(0.6)  // Subtle Border
        
        // Gradients
        public static let calmingGradient = LinearGradient(
            colors: [primary, info],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let warmGradient = LinearGradient(
            colors: [accent, warning],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let mindfulGradient = LinearGradient(
            colors: [success, info],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let primaryGradient = LinearGradient(
            colors: [primary, primary.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Progress Gradients
        public static let progressGradient = LinearGradient(
            colors: [
                Color(hex: "00B894"),  // Fresh Green
                Color(hex: "74B9FF")   // Sky Blue
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        // Dark Mode Colors
        public static let darkBackground = Color(hex: "17171F")
        public static let darkCardBackground = Color(hex: "252530")
        public static let darkTextPrimary = Color(hex: "F7F7F9")
        public static let darkTextSecondary = Color(hex: "B2BEC3")
    }
    
    public enum Typography {
        public static let display: Font = .system(size: 34, weight: .bold)
        public static let titleLarge: Font = .system(size: 28, weight: .bold)
        public static let titleMedium: Font = .system(size: 24, weight: .bold)
        public static let titleSmall: Font = .system(size: 20, weight: .semibold)
        public static let bodyLargeMedium: Font = .system(size: 17, weight: .medium)
        public static let bodyMedium: Font = .system(size: 15, weight: .medium)
        public static let bodyLarge: Font = .system(size: 17, weight: .regular)
        public static let body: Font = .system(size: 15, weight: .regular)
        public static let caption: Font = .system(size: 13, weight: .regular)
        public static let button: Font = .system(size: 17, weight: .semibold)
    }
    
    public enum Layout {
        public enum Spacing {
            public static let xxSmall: CGFloat = 4
            public static let xSmall: CGFloat = 8
            public static let small: CGFloat = 12
            public static let medium: CGFloat = 16
            public static let large: CGFloat = 24
            public static let xLarge: CGFloat = 32
            public static let xxLarge: CGFloat = 48
        }
        
        public enum CornerRadius {
            public static let small: CGFloat = 12
            public static let medium: CGFloat = 16
            public static let large: CGFloat = 20
            public static let xLarge: CGFloat = 28
            public static let card: CGFloat = 24
            public static let button: CGFloat = 16
        }
        
        public enum Shadow {
            public static let small = ViewShadow(radius: 10, y: 4, opacity: 0.1)
            public static let medium = ViewShadow(radius: 15, y: 8, opacity: 0.12)
            public static let large = ViewShadow(radius: 20, y: 12, opacity: 0.14)
            public static let card = ViewShadow(radius: 15, y: 8, opacity: 0.1)
            public static let button = ViewShadow(radius: 12, y: 6, opacity: 0.15)
        }
        
        public enum Size {
            public static let iconSmall: CGFloat = 18
            public static let iconMedium: CGFloat = 24
            public static let iconLarge: CGFloat = 32
            public static let iconXLarge: CGFloat = 40
            
            public static let buttonHeight: CGFloat = 56
            public static let progressCircleLarge: CGFloat = 100
        }
    }
}

public struct ViewShadow: Sendable {
    let radius: CGFloat
    let y: CGFloat
    let opacity: CGFloat
    
    init(radius: CGFloat, y: CGFloat, opacity: CGFloat) {
        self.radius = radius
        self.y = y
        self.opacity = opacity
    }
}

public extension View {
    func withShadow(_ shadow: ViewShadow) -> some View {
        self.shadow(color: Color.black.opacity(shadow.opacity), radius: shadow.radius, y: shadow.y)
    }
}

// Color Hex Extension
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