import SwiftUI

public enum BFAccessibility {
    // MARK: - Dynamic Type
    public enum TextSize {
        /// Returns a scaled font size based on the user's preferred content size
        public static func scaled(_ size: CGFloat) -> CGFloat {
            let metrics = UIFontMetrics(forTextStyle: .body)
            return metrics.scaledValue(for: size)
        }
        
        /// Returns a font with dynamic type support
        public static func scaledFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
            Font.system(size: scaled(size), weight: weight)
        }
    }
    
    // MARK: - Reduced Motion
    public enum Motion {
        /// Returns true if the user has enabled reduced motion
        public static var isReduced: Bool {
            UIAccessibility.isReduceMotionEnabled
        }
        
        /// Returns an animation respecting reduced motion preferences
        public static func animation(_ animation: Animation?) -> Animation? {
            isReduced ? nil : animation
        }
        
        /// Returns a transition respecting reduced motion preferences
        public static func transition(_ transition: AnyTransition) -> AnyTransition {
            isReduced ? .opacity : transition
        }
    }
    
    // MARK: - High Contrast
    public enum Contrast {
        /// Returns true if the user has enabled increased contrast
        public static var isIncreased: Bool {
            UIAccessibility.isDarkerSystemColorsEnabled
        }
        
        /// Returns a color with increased contrast when needed
        public static func color(_ color: Color, increased: Color) -> Color {
            isIncreased ? increased : color
        }
        
        /// Returns opacity value adjusted for contrast
        public static func opacity(_ value: Double) -> Double {
            isIncreased ? min(1.0, value * 1.3) : value
        }
    }
    
    // MARK: - VoiceOver
    public enum VoiceOver {
        /// Returns true if VoiceOver is running
        public static var isRunning: Bool {
            UIAccessibility.isVoiceOverRunning
        }
        
        /// Combines multiple strings into a single announcement
        public static func combine(_ elements: String..., separator: String = ", ") -> String {
            elements.filter { !$0.isEmpty }.joined(separator: separator)
        }
    }
}

// MARK: - View Extensions
public extension View {
    /// Adds semantic meaning to the view for VoiceOver
    func semanticMeaning(_ meaning: String) -> some View {
        self.accessibilityLabel(meaning)
    }
    
    /// Adds a description of the view's value for VoiceOver
    func semanticValue(_ value: String) -> some View {
        self.accessibilityValue(value)
    }
    
    /// Adds a hint about what the view does for VoiceOver
    func semanticHint(_ hint: String) -> some View {
        self.accessibilityHint(hint)
    }
    
    /// Groups multiple elements together for VoiceOver
    func semanticGroup(_ label: String) -> some View {
        self.accessibilityElement(children: .combine)
            .accessibilityLabel(label)
    }
    
    /// Adds a custom trait to the view for VoiceOver
    func semanticTrait(_ trait: AccessibilityTraits) -> some View {
        self.accessibilityAddTraits(trait)
    }
    
    /// Makes the view respond to reduced motion settings
    func respectReducedMotion() -> some View {
        self.animation(BFAccessibility.Motion.animation(.default))
    }
    
    /// Adjusts the view's contrast based on user settings
    func respectIncreaseContrast() -> some View {
        self.environment(\.colorSchemeContrast, BFAccessibility.Contrast.isIncreased ? .increased : .standard)
    }
}
