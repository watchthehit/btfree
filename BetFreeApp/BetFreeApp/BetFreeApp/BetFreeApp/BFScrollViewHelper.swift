import SwiftUI

/**
 * BFScrollViewHelper
 * Provides standardized scroll view implementations and modifiers for consistent
 * scrolling behavior across the app.
 */

// MARK: - Scroll View Modifiers
extension View {
    /// Applies standard BF app scrolling configuration to any ScrollView
    func withBFScrollingBehavior() -> some View {
        self.modifier(BFScrollingBehaviorModifier())
    }
    
    /// Forces content to be scrollable by ensuring minimum height based on screen dimensions
    func forceScrollable(multiplier: CGFloat = 1.2) -> some View {
        GeometryReader { geometry in
            self
                .frame(minHeight: geometry.size.height * multiplier)
        }
    }
    
    /// Adds bottom spacing to prevent content from being hidden behind the tab bar
    func withTabBarBottomSpacing() -> some View {
        self.padding(.bottom, 100)
    }
}

// MARK: - Scroll Behavior Modifier
struct BFScrollingBehaviorModifier: ViewModifier {
    @EnvironmentObject var appState: EnhancedAppState
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                // Ensure scroll view bounces properly
                UIScrollView.appearance().bounces = true
                UIScrollView.appearance().alwaysBounceVertical = true
                
                // Refresh tab bar to help with scrolling issues
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    appState.refreshTabBarVisibility()
                }
            }
    }
}

// MARK: - Reusable Scroll View Component
struct BFScrollView<Content: View>: View {
    let showsIndicators: Bool
    let content: Content
    let bottomSpacing: CGFloat
    let forceScrollable: Bool
    let heightMultiplier: CGFloat
    
    init(
        showsIndicators: Bool = true,
        bottomSpacing: CGFloat = 100,
        forceScrollable: Bool = true,
        heightMultiplier: CGFloat = 1.2,
        @ViewBuilder content: () -> Content
    ) {
        self.showsIndicators = showsIndicators
        self.content = content()
        self.bottomSpacing = bottomSpacing
        self.forceScrollable = forceScrollable
        self.heightMultiplier = heightMultiplier
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: showsIndicators) {
                content
                    .padding(.bottom, bottomSpacing)
                    .frame(
                        minWidth: geometry.size.width,
                        minHeight: forceScrollable ? geometry.size.height * heightMultiplier : nil
                    )
            }
            .withBFScrollingBehavior()
        }
    }
}

// MARK: - Preview
struct BFScrollView_Previews: PreviewProvider {
    static var previews: some View {
        BFScrollView {
            VStack(spacing: 20) {
                ForEach(0..<10) { i in
                    Text("Item \(i)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
        }
        .environmentObject(EnhancedAppState())
    }
} 