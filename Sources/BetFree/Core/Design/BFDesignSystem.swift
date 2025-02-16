import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public enum BFDesignSystem {
    public enum Colors {
        // Base colors that adapt to color scheme
        public static var primary: Color {
            Color(light: Color(hex: "007AFF"), dark: Color(hex: "0A84FF"))
        }
        
        public static var success: Color {
            Color(light: Color(hex: "34C759"), dark: Color(hex: "30D158"))
        }
        
        public static var warning: Color {
            Color(light: Color(hex: "FF9500"), dark: Color(hex: "FFB340"))
        }
        
        public static var error: Color {
            Color(light: Color(hex: "FF3B30"), dark: Color(hex: "FF453A"))
        }
        
        public static var background: Color {
            Color(light: .white, dark: Color(hex: "1C1C1E"))
        }
        
        public static var secondaryBackground: Color {
            Color(light: Color(hex: "F2F2F7"), dark: Color(hex: "2C2C2E"))
        }
        
        public static var cardBackground: Color {
            Color(light: .white, dark: Color(hex: "2C2C2E"))
        }
        
        public static var textPrimary: Color {
            Color(light: Color(hex: "000000"), dark: .white)
        }
        
        public static var textSecondary: Color {
            Color(light: Color(hex: "6C6C6C"), dark: Color(hex: "EBEBF5").opacity(0.6))
        }
        
        public static var border: Color {
            Color(light: Color(hex: "E5E5EA"), dark: Color(hex: "38383A"))
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
    
    // Helper to create color variants
    private static func Color(light: Color, dark: Color) -> Color {
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
    private static func Color(hex: String) -> Color {
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