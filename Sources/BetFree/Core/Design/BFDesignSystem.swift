import SwiftUI
import UIKit

public enum BFDesignSystem {
    public enum Colors {
        // MARK: - Brand Colors
        public static let primary = Color(hex: "007AFF")
        public static let secondary = Color(hex: "5856D6")
        public static let accent = Color(hex: "FF2D55")
        
        // MARK: - Semantic Colors
        public static let success = Color(hex: "34C759")
        public static let warning = Color(hex: "FF9500")
        public static let error = Color(hex: "FF3B30")
        public static let info = Color(hex: "5856D6")
        
        // MARK: - Neutral Colors
        #if os(iOS)
        public static let background = Color(uiColor: .systemBackground)
        public static let cardBackground = Color(uiColor: .secondarySystemBackground)
        public static let textPrimary = Color(uiColor: .label)
        public static let textSecondary = Color(uiColor: .secondaryLabel)
        public static let textTertiary = Color(uiColor: .tertiaryLabel)
        public static let separator = Color(uiColor: .separator)
        public static let groupedBackground = Color(uiColor: .systemGroupedBackground)
        #else
        public static let background = Color(.windowBackgroundColor)
        public static let cardBackground = Color(.controlBackgroundColor)
        public static let textPrimary = Color(.labelColor)
        public static let textSecondary = Color(.secondaryLabelColor)
        public static let textTertiary = Color(.tertiaryLabelColor)
        public static let separator = Color(.separatorColor)
        public static let groupedBackground = Color(.windowBackgroundColor)
        #endif
        
        // MARK: - Gradient Presets
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
        
        public static let successGradient = LinearGradient(
            colors: [success, success.opacity(0.8)],
            startPoint: .top,
            endPoint: .bottom
        )
        
        // MARK: - Semantic Mapping
        public static let buttonPrimary = primary
        public static let buttonSecondary = secondary
        public static let progressPrimary = success
        public static let progressSecondary = accent
        public static let achievementBackground = Color(hex: "FFD700").opacity(0.15)
        public static let cardShadow = Color.black.opacity(0.1)
    }
    
    public enum Typography {
        // MARK: - Font Sizes
        private static let displaySize: CGFloat = 48
        private static let titleLargeSize: CGFloat = 34
        private static let titleMediumSize: CGFloat = 28
        private static let titleSmallSize: CGFloat = 24
        private static let headlineSize: CGFloat = 20
        private static let bodyLargeSize: CGFloat = 17
        private static let bodyMediumSize: CGFloat = 15
        private static let bodySmallSize: CGFloat = 13
        private static let captionSize: CGFloat = 12
        
        // MARK: - Font Weights
        private static let regular = Font.Weight.regular
        private static let medium = Font.Weight.medium
        private static let semibold = Font.Weight.semibold
        private static let bold = Font.Weight.bold
        
        // MARK: - Display
        public static let display = Font.system(size: displaySize, weight: bold, design: .rounded)
        
        // MARK: - Titles
        public static let titleLarge = Font.system(size: titleLargeSize, weight: bold, design: .rounded)
        public static let titleMedium = Font.system(size: titleMediumSize, weight: semibold, design: .rounded)
        public static let titleSmall = Font.system(size: titleSmallSize, weight: semibold, design: .rounded)
        
        // MARK: - Headlines
        public static let headlineLarge = Font.system(size: headlineSize, weight: semibold)
        public static let headlineMedium = Font.system(size: headlineSize, weight: medium)
        
        // MARK: - Body
        public static let bodyLarge = Font.system(size: bodyLargeSize, weight: regular)
        public static let bodyLargeMedium = Font.system(size: bodyLargeSize, weight: medium)
        public static let bodyMedium = Font.system(size: bodyMediumSize, weight: regular)
        public static let bodyMediumMedium = Font.system(size: bodyMediumSize, weight: medium)
        public static let bodySmall = Font.system(size: bodySmallSize, weight: regular)
        public static let bodySmallMedium = Font.system(size: bodySmallSize, weight: medium)
        
        // MARK: - Special
        public static let caption = Font.system(size: captionSize, weight: regular)
        public static let captionMedium = Font.system(size: captionSize, weight: medium)
        public static let button = Font.system(size: bodyLargeSize, weight: semibold)
        
        // MARK: - Semantic Mapping
        public static let buttonLabel = bodyLargeMedium
        public static let inputText = bodyLarge
        public static let inputPlaceholder = bodyMedium
        public static let cardTitle = headlineMedium
        public static let cardBody = bodyMedium
        public static let navigationTitle = titleMedium
        public static let tabLabel = caption
    }
    
    public enum Layout {
        // MARK: - Spacing
        public enum Spacing {
            // Base unit = 4pt
            public static let xxxSmall: CGFloat = 2
            public static let xxSmall: CGFloat = 4
            public static let xSmall: CGFloat = 8
            public static let small: CGFloat = 12
            public static let medium: CGFloat = 16
            public static let large: CGFloat = 24
            public static let xLarge: CGFloat = 32
            public static let xxLarge: CGFloat = 40
            public static let xxxLarge: CGFloat = 48
            
            // Semantic Spacing
            public static let cardPadding = medium
            public static let sectionSpacing = large
            public static let contentSpacing = small
            public static let stackSpacing = xSmall
            public static let buttonPadding = medium
            public static let listRowSpacing = medium
            public static let gridSpacing = small
        }
        
        // MARK: - Corner Radius
        public enum CornerRadius {
            public static let small: CGFloat = 8
            public static let medium: CGFloat = 12
            public static let large: CGFloat = 16
            public static let xLarge: CGFloat = 24
            public static let button: CGFloat = 12
            public static let card: CGFloat = 16
            
            // Semantic Mapping
            public static let input = medium
            public static let modal = xLarge
        }
        
        // MARK: - Sizing
        public enum Size {
            public static let minimumTapArea: CGFloat = 44
            public static let buttonHeight: CGFloat = 48
            public static let inputHeight: CGFloat = 44
            public static let iconSmall: CGFloat = 20
            public static let iconMedium: CGFloat = 24
            public static let iconLarge: CGFloat = 32
            public static let iconXLarge: CGFloat = 48
            
            // Card Sizes
            public static let cardMinWidth: CGFloat = 160
            public static let cardMaxWidth: CGFloat = 500
            public static let cardMinHeight: CGFloat = 80
            
            // Progress Indicators
            public static let progressCircleLarge: CGFloat = 160
            public static let progressCircleMedium: CGFloat = 120
            public static let progressCircleSmall: CGFloat = 80
        }
        
        // MARK: - Shadows
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
            
            // Semantic Mapping
            public static let card = small
            public static let modal = large
        }
        
        // MARK: - Animation
        public enum Animation {
            public static let spring = SwiftUI.Animation.spring(
                response: 0.5,
                dampingFraction: 0.7,
                blendDuration: 0
            )
            
            public static let easeOut = SwiftUI.Animation.easeOut(duration: 0.3)
            public static let easeIn = SwiftUI.Animation.easeIn(duration: 0.3)
            
            public static func springWithDelay(_ delay: Double) -> SwiftUI.Animation {
                SwiftUI.Animation.spring(
                    response: 0.5,
                    dampingFraction: 0.7,
                    blendDuration: 0
                ).delay(delay)
            }
        }
        
        // MARK: - Grid
        public enum Grid {
            public static let columns = [
                GridItem(.flexible(), spacing: Spacing.medium),
                GridItem(.flexible(), spacing: Spacing.medium)
            ]
            
            public static let adaptiveColumns = [
                GridItem(.adaptive(minimum: Size.cardMinWidth), spacing: Spacing.medium)
            ]
        }
    }
}

// MARK: - Shadow Style
public struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Modifiers
extension View {
    func withShadow(_ style: ShadowStyle) -> some View {
        self.shadow(color: style.color, radius: style.radius, x: style.x, y: style.y)
    }
}

// MARK: - Color Helpers
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