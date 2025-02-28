import SwiftUI

struct BFTypography {
    // Headings
    static let heading1 = Font.system(size: 32, weight: .bold)
    static let heading2 = Font.system(size: 24, weight: .semibold)
    static let heading3 = Font.system(size: 20, weight: .medium)
    
    // Body text
    static let bodyLarge = Font.system(size: 18, weight: .regular)
    static let bodyMedium = Font.system(size: 16, weight: .regular)
    static let bodySmall = Font.system(size: 14, weight: .regular)
    
    // UI elements
    static let button = Font.system(size: 16, weight: .medium)
    static let caption = Font.system(size: 12, weight: .regular)
    static let overline = Font.system(size: 10, weight: .medium).uppercaseSmallCaps()
    
    // Text modifiers for views
    struct Modifiers {
        // Heading modifiers
        static func heading1() -> some ViewModifier {
            HeadingModifier(font: BFTypography.heading1, color: BFColors.textPrimary)
        }
        
        static func heading2() -> some ViewModifier {
            HeadingModifier(font: BFTypography.heading2, color: BFColors.textPrimary)
        }
        
        static func heading3() -> some ViewModifier {
            HeadingModifier(font: BFTypography.heading3, color: BFColors.textPrimary)
        }
        
        // Body modifiers
        static func bodyLarge() -> some ViewModifier {
            BodyModifier(font: BFTypography.bodyLarge, color: BFColors.textPrimary)
        }
        
        static func bodyMedium() -> some ViewModifier {
            BodyModifier(font: BFTypography.bodyMedium, color: BFColors.textPrimary)
        }
        
        static func bodySmall() -> some ViewModifier {
            BodyModifier(font: BFTypography.bodySmall, color: BFColors.textSecondary)
        }
        
        static func caption() -> some ViewModifier {
            BodyModifier(font: BFTypography.caption, color: BFColors.textTertiary)
        }
    }
}

// Private modifiers
private struct HeadingModifier: ViewModifier {
    let font: Font
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
            .lineSpacing(4)
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityAddTraits(.isHeader)
    }
}

private struct BodyModifier: ViewModifier {
    let font: Font
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
            .lineSpacing(2)
            .fixedSize(horizontal: false, vertical: true)
    }
}

// Text style view extensions
extension View {
    func textStyle<S: ViewModifier>(_ style: S) -> some View {
        modifier(style)
    }
}

extension Text {
    func heading1() -> some View {
        modifier(BFTypography.Modifiers.heading1())
    }
    
    func heading2() -> some View {
        modifier(BFTypography.Modifiers.heading2())
    }
    
    func heading3() -> some View {
        modifier(BFTypography.Modifiers.heading3())
    }
    
    func bodyLarge() -> some View {
        modifier(BFTypography.Modifiers.bodyLarge())
    }
    
    func bodyMedium() -> some View {
        modifier(BFTypography.Modifiers.bodyMedium())
    }
    
    func bodySmall() -> some View {
        modifier(BFTypography.Modifiers.bodySmall())
    }
    
    func caption() -> some View {
        modifier(BFTypography.Modifiers.caption())
    }
} 