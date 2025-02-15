import SwiftUI

public struct BFCardStyle {
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    let shadowOpacity: Double
    let backgroundColor: Color
    let contentPadding: EdgeInsets
    
    public static let `default` = BFCardStyle(
        cornerRadius: 12,
        shadowRadius: 8,
        shadowOpacity: 0.1,
        backgroundColor: BFDesignSystem.Colors.cardBackground,
        contentPadding: EdgeInsets(
            top: BFDesignSystem.Layout.Spacing.medium,
            leading: BFDesignSystem.Layout.Spacing.medium,
            bottom: BFDesignSystem.Layout.Spacing.medium,
            trailing: BFDesignSystem.Layout.Spacing.medium
        )
    )
    
    public static let compact = BFCardStyle(
        cornerRadius: 8,
        shadowRadius: 4,
        shadowOpacity: 0.05,
        backgroundColor: BFDesignSystem.Colors.cardBackground,
        contentPadding: EdgeInsets(
            top: BFDesignSystem.Layout.Spacing.small,
            leading: BFDesignSystem.Layout.Spacing.small,
            bottom: BFDesignSystem.Layout.Spacing.small,
            trailing: BFDesignSystem.Layout.Spacing.small
        )
    )
    
    public static let elevated = BFCardStyle(
        cornerRadius: 16,
        shadowRadius: 12,
        shadowOpacity: 0.15,
        backgroundColor: BFDesignSystem.Colors.cardBackground,
        contentPadding: EdgeInsets(
            top: BFDesignSystem.Layout.Spacing.large,
            leading: BFDesignSystem.Layout.Spacing.large,
            bottom: BFDesignSystem.Layout.Spacing.large,
            trailing: BFDesignSystem.Layout.Spacing.large
        )
    )
}

public struct BFCard<Content: View>: View {
    private let content: Content
    private let style: BFCardStyle
    private let gradient: LinearGradient?
    private let isInteractive: Bool
    
    public init(
        style: BFCardStyle = .default,
        gradient: LinearGradient? = nil,
        isInteractive: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.style = style
        self.gradient = gradient
        self.isInteractive = isInteractive
    }
    
    public var body: some View {
        content
            .padding(style.contentPadding)
            .background(
                Group {
                    if let gradient = gradient {
                        gradient
                    } else {
                        style.backgroundColor
                    }
                }
            )
            .cornerRadius(style.cornerRadius)
            .shadow(
                color: Color.black.opacity(style.shadowOpacity),
                radius: style.shadowRadius,
                y: 2
            )
            .contentShape(Rectangle())  // Makes entire card tappable
            .opacity(isInteractive ? (isPressed ? 0.7 : 1.0) : 1.0)
            .scaleEffect(isInteractive ? (isPressed ? 0.98 : 1.0) : 1.0)
            .animation(BFAnimation.Spring.tight, value: isPressed)
            .fadeInOnAppear()
            .gesture(dragGesture)
    }
    
    @State private var isPressed: Bool = false
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                if !isPressed {
                    isPressed = true
                    BFHaptics.softTap()
                }
            }
            .onEnded { _ in
                isPressed = false
            }
    }
}
