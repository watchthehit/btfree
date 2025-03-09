import SwiftUI

/// Typography for the BetFree app
/// A centralized system to manage all text styles with support for
/// Dynamic Type and device adaptability

struct BFTypography {
    // MARK: - Heading Styles
    
    /// Large title - Used for main screen titles
    static func largeTitle() -> Font {
        return .system(size: 34, weight: .bold, design: .rounded)
            .metrics(for: .largeTitle)
    }
    
    /// Title level 1 - Used for major section headers
    static func title1() -> Font {
        return .system(size: 28, weight: .bold, design: .rounded)
            .metrics(for: .title)
    }
    
    /// Title level 2 - Used for section headers
    static func title2() -> Font {
        return .system(size: 22, weight: .bold, design: .rounded)
            .metrics(for: .title2)
    }
    
    /// Title level 3 - Used for subsection headers
    static func title3() -> Font {
        return .system(size: 20, weight: .semibold, design: .rounded)
            .metrics(for: .title3)
    }
    
    // MARK: - Body Styles
    
    /// Body - Primary text style
    static func body() -> Font {
        return .system(size: 17, weight: .regular, design: .rounded)
            .metrics(for: .body)
    }
    
    /// Body bold - Emphasized body text
    static func bodyBold() -> Font {
        return .system(size: 17, weight: .semibold, design: .rounded)
            .metrics(for: .body)
    }
    
    /// Subheadline - Secondary text style
    static func subheadline() -> Font {
        return .system(size: 15, weight: .regular, design: .rounded)
            .metrics(for: .subheadline)
    }
    
    /// Subheadline bold - Emphasized secondary text
    static func subheadlineBold() -> Font {
        return .system(size: 15, weight: .semibold, design: .rounded)
            .metrics(for: .subheadline)
    }
    
    // MARK: - Special Styles
    
    /// Caption - Used for supplementary information
    static func caption() -> Font {
        return .system(size: 13, weight: .regular, design: .rounded)
            .metrics(for: .caption)
    }
    
    /// Caption bold - Emphasized supplementary information
    static func captionBold() -> Font {
        return .system(size: 13, weight: .semibold, design: .rounded)
            .metrics(for: .caption)
    }
    
    /// Footnote - Used for very small text
    static func footnote() -> Font {
        return .system(size: 12, weight: .regular, design: .rounded)
            .metrics(for: .footnote)
    }
    
    // MARK: - Button Styles
    
    /// Primary button text
    static func buttonPrimary() -> Font {
        return .system(size: 17, weight: .semibold, design: .rounded)
            .metrics(for: .body)
    }
    
    /// Secondary button text
    static func buttonSecondary() -> Font {
        return .system(size: 15, weight: .semibold, design: .rounded)
            .metrics(for: .subheadline)
    }
    
    /// Small button or tab text
    static func buttonSmall() -> Font {
        return .system(size: 13, weight: .medium, design: .rounded)
            .metrics(for: .caption)
    }
    
    // MARK: - Numeric Styles
    
    /// Large numbers (counters, stats)
    static func statLarge() -> Font {
        return .system(size: 40, weight: .bold, design: .rounded)
    }
    
    /// Medium numbers (secondary stats)
    static func statMedium() -> Font {
        return .system(size: 28, weight: .bold, design: .rounded)
    }
    
    /// Small numbers (tertiary stats)
    static func statSmall() -> Font {
        return .system(size: 20, weight: .semibold, design: .rounded)
    }
}

// MARK: - Helper Extensions

extension Font {
    /// Applies the system's Dynamic Type metrics to this font
    func metrics(for textStyle: TextStyle) -> Font {
        return self.dynamicTypeSize(.large...(.accessibility5))
    }
}

// MARK: - Text Style Modifiers

extension View {
    /// Applies the large title style to text
    func largeTitle() -> some View {
        return self.font(BFTypography.largeTitle())
            .foregroundColor(BFColors.textPrimary)
    }
    
    /// Applies the title 1 style to text
    func title1() -> some View {
        return self.font(BFTypography.title1())
            .foregroundColor(BFColors.textPrimary)
    }
    
    /// Applies the title 2 style to text
    func title2() -> some View {
        return self.font(BFTypography.title2())
            .foregroundColor(BFColors.textPrimary)
    }
    
    /// Applies the title 3 style to text
    func title3() -> some View {
        return self.font(BFTypography.title3())
            .foregroundColor(BFColors.textPrimary)
    }
    
    /// Applies the body style to text
    func bodyStyle() -> some View {
        return self.font(BFTypography.body())
            .foregroundColor(BFColors.textPrimary)
    }
    
    /// Applies the body bold style to text
    func bodyBold() -> some View {
        return self.font(BFTypography.bodyBold())
            .foregroundColor(BFColors.textPrimary)
    }
    
    /// Applies the subheadline style to text
    func subheadline() -> some View {
        return self.font(BFTypography.subheadline())
            .foregroundColor(BFColors.textSecondary)
    }
    
    /// Applies the caption style to text
    func captionStyle() -> some View {
        return self.font(BFTypography.caption())
            .foregroundColor(BFColors.textTertiary)
    }
} 