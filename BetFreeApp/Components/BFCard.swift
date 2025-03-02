import SwiftUI

/**
 * BFCard
 * A reusable card component that implements the BetFree design system
 * Supports various styling options to maintain consistent UI
 */
struct BFCard<Content: View>: View {
    enum CardStyle {
        case standard
        case elevated
        case outlined
        case interactive
    }
    
    var style: CardStyle = .standard
    var cornerRadius: CGFloat = 12
    var padding: CGFloat = 16
    var content: Content
    var action: (() -> Void)? = nil
    
    init(
        style: CardStyle = .standard,
        cornerRadius: CGFloat = 12,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }
    
    init(
        style: CardStyle = .interactive,
        cornerRadius: CGFloat = 12,
        padding: CGFloat = 16,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
        self.action = action
    }
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Group {
            if let action = action {
                Button(action: action) {
                    cardContent
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                cardContent
            }
        }
    }
    
    private var cardContent: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        style == .outlined ? borderColor : Color.clear,
                        lineWidth: 1.5
                    )
            )
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: 0,
                y: shadowY
            )
    }
    
    // Dynamic properties based on style and color scheme
    private var backgroundColor: Color {
        if colorScheme == .dark {
            return style == .standard || style == .elevated || style == .interactive ?
                BFColors.oxfordBlue : Color.clear
        } else {
            return style == .standard || style == .elevated || style == .interactive ?
                .white : Color.clear
        }
    }
    
    private var borderColor: Color {
        colorScheme == .dark ? BFColors.oxfordBlue.opacity(0.6) : Color.gray.opacity(0.3)
    }
    
    private var shadowColor: Color {
        colorScheme == .dark ? 
            Color.black.opacity(style == .elevated ? 0.5 : 0.0) :
            Color.black.opacity(style == .elevated ? 0.1 : 0.0)
    }
    
    private var shadowRadius: CGFloat {
        switch style {
        case .elevated:
            return 8
        case .interactive:
            return 4
        default:
            return 0
        }
    }
    
    private var shadowY: CGFloat {
        style == .elevated ? 4 : 0
    }
}

// MARK: - Preview
struct BFCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Standard Card
                BFCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Standard Card")
                            .font(.headline)
                        Text("This is a standard card with no special effects. Use for most content sections.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Elevated Card
                BFCard(style: .elevated) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Elevated Card")
                            .font(.headline)
                        Text("This card has elevation and casts a shadow. Use for important content that needs to stand out.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Outlined Card
                BFCard(style: .outlined) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Outlined Card")
                            .font(.headline)
                        Text("This card has a border outline but no background. Use for secondary content that needs less emphasis.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Interactive Card
                BFCard(style: .interactive, action: {
                    print("Card tapped")
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Interactive Card")
                                .font(.headline)
                            Text("This card responds to taps. Use for navigation or actions.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(BFColors.oceanBlue)
                    }
                }
            }
            .padding()
        }
        .background(BFColors.adaptiveBackground(for: .light))
        .previewDisplayName("Light Mode")
        
        ScrollView {
            VStack(spacing: 20) {
                // Standard Card
                BFCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Standard Card")
                            .font(.headline)
                        Text("This is a standard card with no special effects. Use for most content sections.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Elevated Card
                BFCard(style: .elevated) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Elevated Card")
                            .font(.headline)
                        Text("This card has elevation and casts a shadow. Use for important content that needs to stand out.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Outlined Card
                BFCard(style: .outlined) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Outlined Card")
                            .font(.headline)
                        Text("This card has a border outline but no background. Use for secondary content that needs less emphasis.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Interactive Card
                BFCard(style: .interactive, action: {
                    print("Card tapped")
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Interactive Card")
                                .font(.headline)
                            Text("This card responds to taps. Use for navigation or actions.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(BFColors.oceanBlue)
                    }
                }
            }
            .padding()
        }
        .background(BFColors.adaptiveBackground(for: .dark))
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    }
} 