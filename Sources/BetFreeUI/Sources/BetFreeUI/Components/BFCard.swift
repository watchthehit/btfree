import SwiftUI

@available(macOS 11.0, *)
public struct BFCard<Content: View>: View {
    public enum Style {
        case elevated
        case outlined
    }
    
    private let content: Content
    private let style: Style
    private let gradient: LinearGradient?
    
    public init(style: Style = .elevated, gradient: LinearGradient? = nil, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.style = style
        self.gradient = gradient
    }
    
    public var body: some View {
        if #available(macOS 12.0, *) {
            content
                .padding()
                .background(gradient)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(style == .elevated ? 0.1 : 0), radius: 8, y: 4)
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay {
                    if style == .outlined {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.gray.opacity(0.2), lineWidth: 1)
                    }
                }
        } else {
            content
                .padding()
                .background(gradient)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(style == .elevated ? 0.1 : 0), radius: 8, y: 4)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    Group {
                        if style == .outlined {
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.gray.opacity(0.2), lineWidth: 1)
                        }
                    }
                )
        }
    }
}

extension View {
    @ViewBuilder
    fileprivate func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    fileprivate func `if`<TrueContent: View, FalseContent: View>(_ condition: Bool, transform: (Self) -> TrueContent, else elseTransform: (Self) -> FalseContent) -> some View {
        if condition {
            transform(self)
        } else {
            elseTransform(self)
        }
    }
}
