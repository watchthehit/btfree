import SwiftUI

struct BFTypography {
    // Font sizes
    struct FontSize {
        static let small: CGFloat = 14
        static let body: CGFloat = 16
        static let subheadline: CGFloat = 18
        static let headline: CGFloat = 22
        static let title: CGFloat = 28
        static let largeTitle: CGFloat = 34
    }
    
    // Font weights
    struct FontWeight {
        static let regular = Font.Weight.regular
        static let medium = Font.Weight.medium
        static let semibold = Font.Weight.semibold
        static let bold = Font.Weight.bold
    }
    
    // Line heights
    struct LineHeight {
        static let tight: CGFloat = 1.1
        static let normal: CGFloat = 1.3
        static let relaxed: CGFloat = 1.5
        static let loose: CGFloat = 1.7
    }
    
    // Text styles with modifiers
    static func largeTitle() -> some ViewModifier {
        TextStyleModifier(size: FontSize.largeTitle, weight: FontWeight.bold, lineHeight: LineHeight.tight)
    }
    
    static func title() -> some ViewModifier {
        TextStyleModifier(size: FontSize.title, weight: FontWeight.bold, lineHeight: LineHeight.tight)
    }
    
    static func headline() -> some ViewModifier {
        TextStyleModifier(size: FontSize.headline, weight: FontWeight.semibold, lineHeight: LineHeight.normal)
    }
    
    static func subheadline() -> some ViewModifier {
        TextStyleModifier(size: FontSize.subheadline, weight: FontWeight.medium, lineHeight: LineHeight.normal)
    }
    
    static func body() -> some ViewModifier {
        TextStyleModifier(size: FontSize.body, weight: FontWeight.regular, lineHeight: LineHeight.relaxed)
    }
    
    static func bodyBold() -> some ViewModifier {
        TextStyleModifier(size: FontSize.body, weight: FontWeight.semibold, lineHeight: LineHeight.relaxed)
    }
    
    static func small() -> some ViewModifier {
        TextStyleModifier(size: FontSize.small, weight: FontWeight.regular, lineHeight: LineHeight.normal)
    }
    
    static func smallBold() -> some ViewModifier {
        TextStyleModifier(size: FontSize.small, weight: FontWeight.medium, lineHeight: LineHeight.normal)
    }
}

// ViewModifier for applying text styles
struct TextStyleModifier: ViewModifier {
    let size: CGFloat
    let weight: Font.Weight
    let lineHeight: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight))
            .lineSpacing(size * (lineHeight - 1))
    }
}

// Text style extensions for easier application
extension View {
    func textStyle(_ style: TextStyleModifier) -> some View {
        self.modifier(style)
    }
    
    func largeTitleStyle() -> some View {
        self.modifier(BFTypography.largeTitle())
    }
    
    func titleStyle() -> some View {
        self.modifier(BFTypography.title())
    }
    
    func headlineStyle() -> some View {
        self.modifier(BFTypography.headline())
    }
    
    func subheadlineStyle() -> some View {
        self.modifier(BFTypography.subheadline())
    }
    
    func bodyStyle() -> some View {
        self.modifier(BFTypography.body())
    }
    
    func bodyBoldStyle() -> some View {
        self.modifier(BFTypography.bodyBold())
    }
    
    func smallStyle() -> some View {
        self.modifier(BFTypography.small())
    }
    
    func smallBoldStyle() -> some View {
        self.modifier(BFTypography.smallBold())
    }
} 