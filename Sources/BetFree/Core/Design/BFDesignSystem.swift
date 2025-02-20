import SwiftUI
#if os(iOS)
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
        #if os(iOS)
        public static let textPrimary = Color(UIColor.label)
        public static let textSecondary = Color(UIColor.secondaryLabel)
        public static let border = Color(UIColor.separator)
        public static let background = Color(UIColor.systemBackground)
        public static let secondaryBackground = Color(UIColor.secondarySystemBackground)
        #else
        public static let textPrimary = Color.primary
        public static let textSecondary = Color.secondary
        public static let border = Color.gray.opacity(0.2)
        public static let background = Color(NSColor.windowBackgroundColor)
        public static let secondaryBackground = Color(NSColor.controlBackgroundColor)
        #endif
        
        // Gradients
        public static let primaryGradient = LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.4, green: 0.2, blue: 1.0),
                Color(red: 0.2, green: 0.4, blue: 1.0)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let primary = Color(red: 0.4, green: 0.2, blue: 1.0)
        public static let success = Color.green
        public static let error = Color.red
        public static let warning = Color.yellow
        
        // Helper to create color variants
        private static func adaptiveColor(light: Color, dark: Color) -> Color {
            #if os(iOS)
            return Color(UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor(dark)
                default:
                    return UIColor(light)
                }
            })
            #else
            return light
            #endif
        }
        
        private static func colorFromHex(_ hex: String) -> Color {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
            
            var rgb: UInt64 = 0
            Scanner(string: hexSanitized).scanHexInt64(&rgb)
            
            let red = Double((rgb & 0xFF0000) >> 16) / 255.0
            let green = Double((rgb & 0x00FF00) >> 8) / 255.0
            let blue = Double(rgb & 0x0000FF) / 255.0
            
            return Color(red: red, green: green, blue: blue)
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