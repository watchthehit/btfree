import SwiftUI

@available(macOS 10.15, iOS 13.0, *)
public enum BFDesignSystem {
    // MARK: - Colors
    public enum Colors {
        public static let primary = Color("Primary", bundle: .module)
        public static let success = Color("Success", bundle: .module)
        public static let error = Color("Error", bundle: .module)
        public static let border = Color("Border", bundle: .module)
        public static let textPrimary = Color("TextPrimary", bundle: .module)
        public static let textSecondary = Color("TextSecondary", bundle: .module)
    }
    
    // MARK: - Typography
    public enum Typography {
        public static let titleLarge = Font.title
        public static let titleMedium = Font.title2
        public static let titleSmall = Font.title3
        public static let bodyLarge = Font.body.weight(.medium)
        public static let bodyMedium = Font.body
        public static let bodySmall = Font.footnote
        public static let labelLarge = Font.callout.weight(.medium)
        public static let labelMedium = Font.callout
        public static let labelSmall = Font.caption
    }
    
    // MARK: - Spacing
    public enum Spacing {
        public static let small: CGFloat = 8
        public static let medium: CGFloat = 16
        public static let large: CGFloat = 24
        public static let extraLarge: CGFloat = 32
    }
    
    // MARK: - Corner Radius
    public enum Radius {
        public static let small: CGFloat = 8
        public static let medium: CGFloat = 12
        public static let large: CGFloat = 16
        public static let extraLarge: CGFloat = 24
    }
    
    // MARK: - Shadows
    public enum Shadow {
        public static let small = Color.black.opacity(0.1)
        public static let medium = Color.black.opacity(0.15)
        public static let large = Color.black.opacity(0.2)
    }
    
    // MARK: - Animations
    public static let animationDefault: Double = 0.3
    public static let animationFast: Double = 0.15
    public static let animationSlow: Double = 0.6
    public static let animationStandard = Animation.easeInOut(duration: 0.2)
    public static let animationSpring = Animation.spring(response: 0.3, dampingFraction: 0.7)
    public static let animationEaseOut = Animation.easeOut(duration: 0.2)
    public static let animationEaseIn = Animation.easeIn(duration: 0.2)
    
    // MARK: - Opacity
    public static let opacityDisabled: Double = 0.5
    public static let opacityInactive: Double = 0.7
    public static let opacityActive: Double = 1.0
    public static let opacityDim: CGFloat = 0.7
    public static let opacityTransparent: CGFloat = 0.0
    
    // MARK: - Icon Sizes
    public static let iconSizeSmall: CGFloat = 16
    public static let iconSizeMedium: CGFloat = 24
    public static let iconSizeLarge: CGFloat = 32
    
    // MARK: - Elevation
    public static let elevationNone: CGFloat = 0
    public static let elevationLow: CGFloat = 2
    public static let elevationMedium: CGFloat = 4
    public static let elevationHigh: CGFloat = 8
    public static let elevationLevel0: CGFloat = 0
    public static let elevationLevel1: CGFloat = 1
    public static let elevationLevel2: CGFloat = 2
    public static let elevationLevel3: CGFloat = 3
    public static let elevationLevel4: CGFloat = 4
    public static let elevationLevel5: CGFloat = 5
    
    // MARK: - Font Weights
    public static let fontWeightRegular = Font.Weight.regular
    public static let fontWeightMedium = Font.Weight.medium
    public static let fontWeightSemibold = Font.Weight.semibold
    public static let fontWeightBold = Font.Weight.bold
    public static let fontWeightThin = Font.Weight.thin
    public static let fontWeightLight = Font.Weight.light
    public static let fontWeightHeavy = Font.Weight.heavy
    public static let fontWeightBlack = Font.Weight.black
    
    // MARK: - Edges
    public static let horizontalEdge = Edge.Set.horizontal
    public static let verticalEdge = Edge.Set.vertical
    public static let allEdges = Edge.Set.all
    
    // MARK: - Border Widths
    public static let borderWidthThin: CGFloat = 1
    public static let borderWidthMedium: CGFloat = 2
    public static let borderWidthThick: CGFloat = 4
}
