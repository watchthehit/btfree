import SwiftUI

// MARK: - View Modifiers for Consistent Styling

extension View {
    /// Apply standard card styling to any view
    func bfCardStyle() -> some View {
        self
            .padding(BFDesignSystem.Spacing.cardPadding)
            .background(
                RoundedRectangle(cornerRadius: BFDesignSystem.Radius.card)
                    .fill(BFDesignSystem.Colors.cardBackground)
                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: BFDesignSystem.Radius.card)
                    .strokeBorder(BFDesignSystem.Colors.textPrimary.opacity(0.1), lineWidth: 1)
            )
    }
    
    /// Apply standard screen padding
    func bfScreenPadding() -> some View {
        self.padding(.horizontal, BFDesignSystem.Spacing.standardHorizontal)
    }
    
    /// Apply standard entrance animation
    func withBFEntranceAnimation(
        delay: Double = 0,
        offset: CGFloat = 20,
        shouldAnimate: Bool = true
    ) -> some View {
        self.modifier(BFEntranceAnimationModifier(
            delay: delay,
            offset: offset,
            shouldAnimate: shouldAnimate
        ))
    }
    
    /// Apply subtle pulse animation
    func withBFPulseAnimation(intensity: CGFloat = 1.0) -> some View {
        self.modifier(BFPulseAnimationModifier(intensity: intensity))
    }
}

// MARK: - Custom Modifiers

/// Entrance animation with fade and slide
struct BFEntranceAnimationModifier: ViewModifier {
    let delay: Double
    let offset: CGFloat
    let shouldAnimate: Bool
    
    @State private var opacity: Double = 0
    @State private var yOffset: CGFloat
    
    init(delay: Double, offset: CGFloat, shouldAnimate: Bool) {
        self.delay = delay
        self.offset = offset
        self.shouldAnimate = shouldAnimate
        self._yOffset = State(initialValue: offset)
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .offset(y: yOffset)
            .onAppear {
                guard shouldAnimate else {
                    opacity = 1
                    yOffset = 0
                    return
                }
                
                withAnimation(BFDesignSystem.Animation.entrance.delay(delay)) {
                    opacity = 1
                    yOffset = 0
                }
            }
    }
}

/// Subtle pulsing animation
struct BFPulseAnimationModifier: ViewModifier {
    let intensity: CGFloat
    @State private var isPulsing = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1 + (0.05 * intensity) : 1)
            .opacity(isPulsing ? 1 : 0.9)
            .onAppear {
                withAnimation(BFDesignSystem.Animation.subtle) {
                    isPulsing = true
                }
            }
    }
} 