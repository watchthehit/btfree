import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public struct ViewShadow {
    let radius: CGFloat
    let y: CGFloat
    let opacity: Double
    
    public init(radius: CGFloat, y: CGFloat, opacity: Double) {
        self.radius = radius
        self.y = y
        self.opacity = opacity
    }
}

public enum BFDesignSystem {
    public enum Colors {
        // Base colors that adapt to color scheme
        public static var primary: Color {
            adaptiveColor(light: colorFromHex("007AFF"), dark: colorFromHex("0A84FF"))
        }
        
        public static var success: Color {
            adaptiveColor(light: colorFromHex("34C759"), dark: colorFromHex("30D158"))
        }
        
        public static var warning: Color {
            adaptiveColor(light: colorFromHex("FF9500"), dark: colorFromHex("FFB340"))
        }
        
        public static var error: Color {
            adaptiveColor(light: colorFromHex("FF3B30"), dark: colorFromHex("FF453A"))
        }
        
        public static var background: Color {
            adaptiveColor(light: .white, dark: colorFromHex("1C1C1E"))
        }
        
        public static var secondaryBackground: Color {
            adaptiveColor(light: colorFromHex("F2F2F7"), dark: colorFromHex("2C2C2E"))
        }
        
        public static var cardBackground: Color {
            adaptiveColor(light: .white, dark: colorFromHex("2C2C2E"))
        }
        
        public static var textPrimary: Color {
            adaptiveColor(light: colorFromHex("000000"), dark: .white)
        }
        
        public static var textSecondary: Color {
            adaptiveColor(light: colorFromHex("6C6C6C"), dark: colorFromHex("EBEBF5").opacity(0.6))
        }
        
        public static var border: Color {
            adaptiveColor(light: colorFromHex("E5E5EA"), dark: colorFromHex("38383A"))
        }
        
        // Gradients
        public static var primaryGradient: LinearGradient {
            LinearGradient(
                colors: [primary, primary.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        public static var successGradient: LinearGradient {
            LinearGradient(
                colors: [success, success.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        public static var warningGradient: LinearGradient {
            LinearGradient(
                colors: [warning, warning.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        public static var errorGradient: LinearGradient {
            LinearGradient(
                colors: [error, error.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        public static var calmingGradient: LinearGradient {
            LinearGradient(
                colors: [primary, success],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        public static var warmGradient: LinearGradient {
            LinearGradient(
                colors: [warning, error],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        public static var mindfulGradient: LinearGradient {
            LinearGradient(
                colors: [success, primary],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
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
    
    public enum Typography {
        public static let displayLarge = Font.system(size: 34, weight: .bold)
        public static let displayMedium = Font.system(size: 28, weight: .bold)
        public static let displaySmall = Font.system(size: 24, weight: .bold)
        
        public static let titleLarge = Font.title
        public static let titleMedium = Font.title2
        public static let titleSmall = Font.title3
        
        public static let bodyLarge = Font.body.weight(.medium)
        public static let bodyMedium = Font.body
        public static let bodySmall = Font.footnote
        
        public static let labelLarge = Font.callout.weight(.medium)
        public static let labelMedium = Font.callout
        public static let labelSmall = Font.caption
        
        public static let caption = Font.caption
        public static let captionSmall = Font.caption2
    }
    
    // Helper to create color variants
    private static func adaptiveColor(light: Color, dark: Color) -> Color {
        return Color(uiColor: UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
    
    // Helper to create color from hex
    private static func colorFromHex(_ hex: String) -> Color {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        
        return Color(red: r, green: g, blue: b)
    }
    
    // ... rest of the file ...
}

public extension View {
    func withViewShadow(_ shadow: ViewShadow) -> some View {
        self.shadow(
            color: BFDesignSystem.Colors.textPrimary.opacity(shadow.opacity),
            radius: shadow.radius,
            x: 0,
            y: shadow.y
        )
    }
} 