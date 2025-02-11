import SwiftUI

public enum BFDesignSystem {
    public enum Colors {
        public static let primary = Color.blue
        public static let secondary = Color.purple
        public static let accent = Color.orange
        public static let success = Color.green
        public static let info = Color.cyan
        public static let background = Color(.systemBackground)
        public static let cardBackground = Color(.secondarySystemBackground)
        public static let textPrimary = Color(.label)
        public static let textSecondary = Color(.secondaryLabel)
    }
    
    public enum Typography {
        public static let titleLarge = Font.system(size: 28, weight: .bold)
        public static let headlineLarge = Font.system(size: 24, weight: .bold)
        public static let headlineMedium = Font.system(size: 20, weight: .semibold)
        public static let bodyLarge = Font.system(size: 17)
        public static let bodyMedium = Font.system(size: 15)
        public static let bodySmall = Font.system(size: 13)
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
            public static let button: CGFloat = 12
        }
        
        public enum Size {
            public static let iconSmall: CGFloat = 24
            public static let iconMedium: CGFloat = 32
            public static let iconLarge: CGFloat = 48
            public static let progressCircleLarge: CGFloat = 120
        }
    }
} 