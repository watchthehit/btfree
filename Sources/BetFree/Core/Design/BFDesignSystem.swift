import SwiftUI
import UIKit

public enum BFDesignSystem {
    public enum Colors {
        public static let primary = Color.blue
        public static let secondary = Color.purple
        public static let success = Color.green
        public static let error = Color.red
        
        #if os(iOS)
        public static let background = Color(uiColor: .systemBackground)
        public static let cardBackground = Color(uiColor: .secondarySystemBackground)
        public static let textPrimary = Color(uiColor: .label)
        public static let textSecondary = Color(uiColor: .secondaryLabel)
        #else
        public static let background = Color(.windowBackgroundColor)
        public static let cardBackground = Color(.controlBackgroundColor)
        public static let textPrimary = Color(.labelColor)
        public static let textSecondary = Color(.secondaryLabelColor)
        #endif
    }
    
    public enum Typography {
        public static let titleLarge = Font.largeTitle
        public static let titleMedium = Font.title
        public static let titleSmall = Font.title2
        public static let headlineLarge = Font.headline
        public static let headlineMedium = Font.subheadline
        public static let bodyLarge = Font.body
        public static let bodyMedium = Font.callout
        public static let bodySmall = Font.caption
    }
    
    public enum Spacing {
        public static let xxxSmall: CGFloat = 2
        public static let xxSmall: CGFloat = 4
        public static let xSmall: CGFloat = 8
        public static let small: CGFloat = 12
        public static let medium: CGFloat = 16
        public static let large: CGFloat = 24
        public static let xLarge: CGFloat = 32
        public static let xxLarge: CGFloat = 40
        public static let xxxLarge: CGFloat = 48
    }
    
    public enum CornerRadius {
        public static let small: CGFloat = 4
        public static let medium: CGFloat = 8
        public static let large: CGFloat = 12
        public static let xLarge: CGFloat = 16
        public static let circle: CGFloat = 9999
    }
} 