import SwiftUI

public struct BFCard<Content: View>: View {
    public enum Style {
        case elevated
        case outlined
    }
    
    private let style: Style
    private let content: Content
    
    public init(style: Style = .outlined, @ViewBuilder content: () -> Content) {
        self.style = style
        self.content = content()
    }
    
    public var body: some View {
        content
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.background)
                    .shadow(color: .black.opacity(style == .elevated ? 0.1 : 0), radius: 8, y: 4)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                if style == .outlined {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(BFDesignSystem.Colors.border, lineWidth: 1)
                }
            }
    }
}
