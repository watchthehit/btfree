import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

@available(macOS 10.15, iOS 13.0, *)
public enum BFDesignSystem {
    // MARK: - Colors
    public static let primaryColor = Color.blue
    public static let backgroundColor = Color.white
    public static let surfaceColor = Color.gray.opacity(0.1)
    public static let primaryTextColor = Color.black
    public static let secondaryTextColor = Color.gray
    public static let shadowColor = Color.black.opacity(0.1)
    public static let borderColor = Color.gray.opacity(0.5)
    public static let errorColor = Color.red
    public static let successColor = Color.green
    public static let warningColor = Color.yellow
    public static let infoColor = Color.blue
    public static let primaryOnColor = Color.white
    public static let secondaryOnColor = Color.black
    public static let backgroundOnColor = Color.black
    public static let surfaceOnColor = Color.black
    public static let errorOnColor = Color.white
    public static let successOnColor = Color.black
    public static let warningOnColor = Color.black
    public static let infoOnColor = Color.white
    
    #if canImport(UIKit)
    public static let backgroundUIKitColor = Color(UIColor.systemBackground)
    public static let surfaceUIKitColor = Color(UIColor.secondarySystemBackground)
    public static let primaryTextUIKitColor = Color(UIColor.label)
    public static let secondaryTextUIKitColor = Color(UIColor.secondaryLabel)
    public static let borderUIKitColor = Color(UIColor.separator)
    #elseif canImport(AppKit)
    public static let backgroundAppKitColor = Color(NSColor.windowBackgroundColor)
    public static let surfaceAppKitColor = Color(NSColor.controlBackgroundColor)
    public static let primaryTextAppKitColor = Color(NSColor.labelColor)
    public static let secondaryTextAppKitColor = Color(NSColor.secondaryLabelColor)
    public static let borderAppKitColor = Color(NSColor.separatorColor)
    #endif
    
    // MARK: - Typography
    public static let titleLargeFont = Font.title
    #if os(macOS)
    @available(macOS 11.0, *)
    public static let titleMediumFont = Font.title2
    @available(macOS 11.0, *)
    public static let titleSmallFont = Font.title3
    #else
    public static let titleMediumFont = Font.title2
    public static let titleSmallFont = Font.title3
    #endif
    public static let bodyLargeFont = Font.body
    public static let bodyMediumFont = Font.callout
    public static let bodySmallFont = Font.footnote
    public static let displayLargeFont = Font.system(size: 34, weight: .bold)
    public static let displayMediumFont = Font.system(size: 28, weight: .bold)
    public static let displaySmallFont = Font.system(size: 24, weight: .bold)
    public static let labelLargeFont = Font.system(size: 15, weight: .medium)
    public static let labelMediumFont = Font.system(size: 13, weight: .medium)
    public static let labelSmallFont = Font.system(size: 11, weight: .medium)
    public static let captionFont = Font.system(size: 10, weight: .regular)
    
    // MARK: - Spacing
    public static let spacingSmall: CGFloat = 8
    public static let spacingMedium: CGFloat = 16
    public static let spacingLarge: CGFloat = 24
    
    public static let horizontalEdge = Edge.Set.horizontal
    public static let verticalEdge = Edge.Set.vertical
    public static let allEdges = Edge.Set.all
    
    // MARK: - Corner Radius
    public static let cornerRadiusSmall: CGFloat = 4
    public static let cornerRadiusMedium: CGFloat = 8
    public static let cornerRadiusLarge: CGFloat = 12
    
    // MARK: - Shadows
    public static let shadowSmall: CGFloat = 4
    public static let shadowMedium: CGFloat = 8
    public static let shadowLarge: CGFloat = 16
    
    public static let shadowSmallYOffset: CGFloat = 2
    public static let shadowMediumYOffset: CGFloat = 4
    public static let shadowLargeYOffset: CGFloat = 8
    
    // MARK: - Border Widths
    public static let borderWidthThin: CGFloat = 1
    public static let borderWidthMedium: CGFloat = 2
    public static let borderWidthThick: CGFloat = 4
    
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
}
