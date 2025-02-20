import SwiftUI

@available(macOS 13.0, iOS 16.0, *)
public struct ViewShadow {
    public let radius: CGFloat
    public let y: CGFloat
    public let opacity: Double
    
    public init(radius: CGFloat, y: CGFloat, opacity: Double) {
        self.radius = radius
        self.y = y
        self.opacity = opacity
    }
}

@available(macOS 13.0, iOS 16.0, *)
public enum BFDesignSystem {
    // MARK: - Layout
    public enum Layout {
        public enum Spacing {
            public static let xxSmall: CGFloat = 4
            public static let xSmall: CGFloat = 8
            public static let small: CGFloat = 12
            public static let medium: CGFloat = 16
            public static let large: CGFloat = 24
            public static let xLarge: CGFloat = 32
            public static let xxLarge: CGFloat = 40
        }
        
        public enum CornerRadius {
            public static let small: CGFloat = 4
            public static let medium: CGFloat = 8
            public static let large: CGFloat = 12
            public static let card: CGFloat = 16
        }
        
        public enum Shadow {
            public static let small = ViewShadow(radius: 4, y: 2, opacity: 0.05)
            public static let medium = ViewShadow(radius: 8, y: 4, opacity: 0.1)
            public static let large = ViewShadow(radius: 12, y: 8, opacity: 0.15)
            public static let card = ViewShadow(radius: 8, y: 4, opacity: 0.1)
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
        public static let labelLarge = Font.callout
        public static let labelMedium = Font.subheadline
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
        public static let small: CGFloat = 4
        public static let medium: CGFloat = 8
        public static let large: CGFloat = 12
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

@available(macOS 13.0, iOS 16.0, *)
public extension View {
    func withViewShadow(_ shadow: ViewShadow) -> some View {
        self.shadow(
            color: Color.black.opacity(shadow.opacity),
            radius: shadow.radius,
            x: 0,
            y: shadow.y
        )
    }
}
