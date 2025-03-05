import SwiftUI

/**
 * BFTheme - Transition color system that bridges the gap between the legacy color system
 * and the new BFColors implementation.
 *
 * This file provides a compatibility layer that maintains the BFTheme static property
 * names while using the properly defined light/dark adaptive colors from BFColors.
 *
 * MIGRATION NOTE: New components should use BFColors directly instead of BFTheme.
 * This implementation exists to make the transition smoother.
 */
public struct BFTheme {
    // MARK: - Primary Colors
    
    /// Clean blue primary color - Maps to BFColors.primary
    public static var primaryColor: Color {
        #if canImport(BFColors)
        return BFColors.primary
        #else
        return Color(UIColor { $0.userInterfaceStyle == .dark ? 
            UIColor(hex: "#3A7D8E") : UIColor(hex: "#2A6B7C") })
        #endif
    }
    
    /// Light blue secondary color - Maps to BFColors.secondary
    public static var secondaryColor: Color {
        #if canImport(BFColors)
        return BFColors.secondary
        #else
        return Color(UIColor { $0.userInterfaceStyle == .dark ? 
            UIColor(hex: "#7AA38A") : UIColor(hex: "#89B399") })
        #endif
    }
    
    /// Mint green accent color - Maps to BFColors.accent
    public static var accentColor: Color {
        #if canImport(BFColors)
        return BFColors.accent
        #else
        return Color(UIColor { $0.userInterfaceStyle == .dark ? 
            UIColor(hex: "#F28A5F") : UIColor(hex: "#E67E53") })
        #endif
    }
    
    // MARK: - Background Colors
    
    /// Main background color - Maps to BFColors.background
    public static var background: Color {
        #if canImport(BFColors)
        return BFColors.background
        #else
        return Color(UIColor { $0.userInterfaceStyle == .dark ? 
            UIColor(hex: "#1C1F2E") : UIColor(hex: "#F7F3EB") })
        #endif
    }
    
    /// Card background color - Maps to BFColors.cardBackground
    public static var cardBackground: Color {
        #if canImport(BFColors)
        return BFColors.cardBackground
        #else
        return Color(UIColor { $0.userInterfaceStyle == .dark ? 
            UIColor(hex: "#2D3142") : UIColor(hex: "#FFFFFF") })
        #endif
    }
    
    // MARK: - Text Colors
    
    /// Light text - Maps to BFColors.textPrimary in dark mode and white in light mode
    public static var neutralLight: Color {
        #if canImport(BFColors)
        return Color(UIColor { $0.userInterfaceStyle == .dark ? 
            UIColor(BFColors.textPrimary) : UIColor.white })
        #else
        return Color(UIColor { $0.userInterfaceStyle == .dark ? 
            UIColor(hex: "#F7F3EB") : UIColor.white })
        #endif
    }
    
    /// Dark text - Maps to BFColors.textPrimary in light mode and dark in dark mode
    public static var neutralDark: Color {
        #if canImport(BFColors)
        return Color(UIColor { $0.userInterfaceStyle == .dark ? 
            UIColor.black : UIColor(BFColors.textPrimary) })
        #else
        return Color(UIColor { $0.userInterfaceStyle == .dark ? 
            UIColor.black : UIColor(hex: "#2D3142") })
        #endif
    }
    
    // MARK: - Gradients
    
    /// Primary gradient - Maps to BFColors.primaryGradient()
    public static var gradientPrimary: LinearGradient {
        #if canImport(BFColors)
        return BFColors.primaryGradient()
        #else
        return LinearGradient(
            colors: [primaryColor, primaryColor.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        #endif
    }
    
    /// Accent gradient - Maps to BFColors.energyGradient()
    public static var gradientAccent: LinearGradient {
        #if canImport(BFColors)
        return BFColors.energyGradient()
        #else
        return LinearGradient(
            colors: [accentColor, accentColor.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        #endif
    }
    
    /// Background gradient
    public static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [background, cardBackground],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // MARK: - Typography System
    
    public struct Typography {
        // Title text style - Largest heading
        public static func title(_ size: CGFloat = 24) -> Font {
            return .system(size: size, weight: .bold, design: .rounded)
        }
        
        // Headline text style - Medium heading
        public static func headline(_ size: CGFloat = 18) -> Font {
            return .system(size: size, weight: .semibold, design: .rounded)
        }
        
        // Body text style - Regular text
        public static func body(_ size: CGFloat = 16) -> Font {
            return .system(size: size, weight: .regular, design: .rounded)
        }
        
        // Caption text style - Small text
        public static func caption(_ size: CGFloat = 13) -> Font {
            return .system(size: size, weight: .regular, design: .rounded)
        }
        
        // Button text style - Text for buttons
        public static func button(_ size: CGFloat = 16) -> Font {
            return .system(size: size, weight: .semibold, design: .rounded)
        }
    }
}

// MARK: - Color Extension for Hex Support
private extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
} 