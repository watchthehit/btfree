import SwiftUI

public enum BFDesignSystem {
    public enum Colors {
        // Primary Brand Colors
        public static let primary = Color(hex: "4A90E2")  // Trustworthy Blue
        public static let secondary = Color(hex: "9B6B9D")  // Calming Purple
        public static let accent = Color(hex: "F5A623")  // Motivational Orange
        
        // Semantic Colors
        public static let success = Color(hex: "7ED321")  // Positive Green
        public static let info = Color(hex: "50E3C2")  // Informative Teal
        public static let warning = Color(hex: "F5A623")  // Cautionary Orange
        public static let error = Color(hex: "D0021B")  // Alert Red
        
        // Text Colors
        public static let textPrimary = Color(hex: "2C3E50")  // Deep Blue-Gray
        public static let textSecondary = Color(hex: "8492A6")  // Muted Gray
        public static let textTertiary = Color(hex: "C0CCDA")  // Light Gray
        
        // Background Colors
        public static let cardBackground = Color(hex: "FFFFFF")  // Pure White
        public static let background = Color(hex: "F8FAFC")  // Off-White
        public static let separator = Color(hex: "E5E9F2").opacity(0.6)  // Light Border
        
        // Gradients
        public static let calmingGradient = LinearGradient(
            colors: [
                Color(hex: "4A90E2"),  // Trustworthy Blue
                Color(hex: "50E3C2")   // Calming Teal
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let warmGradient = LinearGradient(
            colors: [
                Color(hex: "F5A623"),  // Warm Orange
                Color(hex: "F8E71C")   // Energetic Yellow
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let mindfulGradient = LinearGradient(
            colors: [
                Color(hex: "7ED321"),  // Fresh Green
                Color(hex: "50E3C2")   // Calming Teal
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let primaryGradient = LinearGradient(
            colors: [
                Color(hex: "4A90E2"),  // Trustworthy Blue
                Color(hex: "357ABD")   // Deeper Blue
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Progress Gradients
        public static let progressGradient = LinearGradient(
            colors: [
                Color(hex: "7ED321"),  // Success Green
                Color(hex: "50E3C2")   // Calming Teal
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        // Dark Mode Colors
        public static let darkBackground = Color(hex: "1A1F36")
        public static let darkCardBackground = Color(hex: "252D4A")
        public static let darkTextPrimary = Color(hex: "F8FAFC")
        public static let darkTextSecondary = Color(hex: "C0CCDA")
    }
    
    public enum Typography {
        public static let display = Font.system(size: 32, weight: .bold)
        public static let titleLarge = Font.system(size: 28, weight: .bold)
        public static let titleMedium = Font.system(size: 24, weight: .bold)
        public static let titleSmall = Font.system(size: 20, weight: .semibold)
        public static let headlineMedium = Font.system(size: 22, weight: .semibold)
        
        public static let bodyLarge = Font.system(size: 18)
        public static let bodyLargeMedium = Font.system(size: 18, weight: .medium)
        public static let bodyMedium = Font.system(size: 16)
        public static let bodySmall = Font.system(size: 14)
        
        public static let button = Font.system(size: 16, weight: .medium)
        public static let caption = Font.system(size: 12)
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
            public static let small: CGFloat = 8
            public static let medium: CGFloat = 12
            public static let large: CGFloat = 16
            public static let xLarge: CGFloat = 24
            public static let card: CGFloat = 20
            public static let button: CGFloat = 12
        }
        
        public enum Shadow {
            public static let small = ViewShadow(radius: 4, y: 2)
            public static let medium = ViewShadow(radius: 8, y: 4)
            public static let large = ViewShadow(radius: 16, y: 8)
            public static let card = ViewShadow(radius: 8, y: 4)
            public static let button = ViewShadow(radius: 6, y: 3)
        }
        
        public enum Size {
            public static let iconSmall: CGFloat = 16
            public static let iconMedium: CGFloat = 20
            public static let iconLarge: CGFloat = 24
            public static let iconXLarge: CGFloat = 32
            
            public static let buttonHeight: CGFloat = 48
            public static let progressCircleLarge: CGFloat = 80
        }
    }
}

public struct ViewShadow {
    let radius: CGFloat
    let y: CGFloat
    
    public init(radius: CGFloat, y: CGFloat) {
        self.radius = radius
        self.y = y
    }
}

public extension View {
    func withShadow(_ shadow: ViewShadow) -> some View {
        self.shadow(radius: shadow.radius, y: shadow.y)
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