import SwiftUI

public enum BFAnimation {
    // MARK: - Timing
    public enum Duration {
        /// Quick micro-interactions (100ms)
        public static let quick: Double = 0.1
        
        /// Standard interactions (200ms)
        public static let standard: Double = 0.2
        
        /// Emphasized interactions (300ms)
        public static let emphasized: Double = 0.3
        
        /// Long animations (500ms)
        public static let long: Double = 0.5
    }
    
    // MARK: - Spring Configurations
    public enum Spring {
        /// Default spring for most UI interactions
        public static let `default` = Animation.spring(
            response: 0.3,
            dampingFraction: 0.7,
            blendDuration: 0
        )
        
        /// Bouncy spring for playful interactions
        public static let bouncy = Animation.spring(
            response: 0.5,
            dampingFraction: 0.5,
            blendDuration: 0
        )
        
        /// Tight spring for micro-interactions
        public static let tight = Animation.spring(
            response: 0.2,
            dampingFraction: 0.8,
            blendDuration: 0
        )
    }
    
    // MARK: - Easing Curves
    public enum Easing {
        /// Standard easing for appearing elements
        public static let easeOut = Animation.easeOut(duration: Duration.standard)
        
        /// Easing for disappearing elements
        public static let easeIn = Animation.easeIn(duration: Duration.standard)
        
        /// Smooth easing for transitions
        public static let easeInOut = Animation.easeInOut(duration: Duration.standard)
    }
    
    // MARK: - Common Animations
    public enum Transition {
        /// Fade in from 0 opacity
        public static let fadeIn = AnyTransition.opacity
            .animation(.easeOut(duration: Duration.standard))
        
        /// Scale up from 95% with fade
        public static let scaleUp = AnyTransition.asymmetric(
            insertion: AnyTransition.opacity.combined(with: .scale(scale: 0.95))
                .animation(.spring(response: 0.3, dampingFraction: 0.7)),
            removal: AnyTransition.opacity.combined(with: .scale(scale: 0.95))
                .animation(.easeIn(duration: Duration.quick))
        )
        
        /// Slide in from bottom with fade
        public static let slideUp = AnyTransition.asymmetric(
            insertion: AnyTransition.move(edge: .bottom).combined(with: .opacity)
                .animation(.spring(response: 0.4, dampingFraction: 0.7)),
            removal: AnyTransition.move(edge: .bottom).combined(with: .opacity)
                .animation(.easeIn(duration: Duration.quick))
        )
    }
}

// MARK: - View Extensions
public extension View {
    /// Applies standard fade in animation when view appears
    func fadeInOnAppear() -> some View {
        self.modifier(FadeInModifier())
    }
    
    /// Applies scale up animation when view appears
    func scaleUpOnAppear() -> some View {
        self.modifier(ScaleUpModifier())
    }
    
    /// Applies slide up animation when view appears
    func slideUpOnAppear() -> some View {
        self.modifier(SlideUpModifier())
    }
}

// MARK: - Animation Modifiers
private struct FadeInModifier: ViewModifier {
    @State private var isVisible = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                withAnimation(BFAnimation.Easing.easeOut) {
                    isVisible = true
                }
            }
    }
}

private struct ScaleUpModifier: ViewModifier {
    @State private var isVisible = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.95)
            .onAppear {
                withAnimation(BFAnimation.Spring.default) {
                    isVisible = true
                }
            }
    }
}

private struct SlideUpModifier: ViewModifier {
    @State private var isVisible = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .onAppear {
                withAnimation(BFAnimation.Spring.default) {
                    isVisible = true
                }
            }
    }
}
