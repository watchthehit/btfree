import SwiftUI

/**
 * BFCard - Card component for the BetFree app
 *
 * This component implements a card container using the "Serene Recovery" color scheme.
 * It provides a consistent container for content with appropriate styling and optional
 * header, footer, and accent color.
 */
public struct BFCard<Content: View>: View {
    // MARK: - Properties
    
    private let content: Content
    private let title: String?
    private let subtitle: String?
    private let footer: String?
    private let accentColor: Color?
    private let isSelectable: Bool
    private let action: (() -> Void)?
    
    // MARK: - Initializers
    
    /// Creates a new card with the specified parameters
    /// - Parameters:
    ///   - title: Optional title to display in the header
    ///   - subtitle: Optional subtitle to display in the header
    ///   - footer: Optional footer text to display at the bottom
    ///   - accentColor: Optional accent color for the top border
    ///   - isSelectable: Whether the card can be tapped
    ///   - action: Optional action to perform when the card is tapped
    ///   - content: The content to display in the card
    public init(
        title: String? = nil,
        subtitle: String? = nil,
        footer: String? = nil,
        accentColor: Color? = nil,
        isSelectable: Bool = false,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.footer = footer
        self.accentColor = accentColor
        self.isSelectable = isSelectable
        self.action = action
        self.content = content()
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Accent color bar at top if provided
            if let accentColor = accentColor {
                accentColor
                    .frame(height: 4)
                    .frame(maxWidth: .infinity)
            }
            
            // Card header if title is provided
            if let title = title {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(BFColors.textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 14))
                            .foregroundColor(BFColors.textSecondary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)
            }
            
            // Card content
            content
                .padding(.horizontal, 16)
                .padding(.vertical, title == nil ? 16 : 8)
            
            // Card footer if provided
            if let footer = footer {
                Divider()
                    .padding(.horizontal, 16)
                
                Text(footer)
                    .font(.system(size: 12))
                    .foregroundColor(BFColors.textTertiary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
            }
        }
        .background(BFColors.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(BFColors.divider, lineWidth: 1)
        )
        .onTapGesture {
            if isSelectable, let action = action {
                action()
            }
        }
        .opacity(isSelectable ? 0.99 : 1.0) // Slight opacity change for selectable cards
    }
}

// MARK: - Preview

struct BFCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            BFCard(title: "Recovery Progress", subtitle: "Last 7 days") {
                Text("Card content goes here")
                    .frame(maxWidth: .infinity, minHeight: 100, alignment: .center)
            }
            
            BFCard(title: "Mindfulness Exercise", accentColor: BFColors.calm) {
                Text("Breathing exercise content")
                    .frame(maxWidth: .infinity, minHeight: 80, alignment: .center)
            }
            
            BFCard(footer: "Updated 2 hours ago") {
                Text("Card with footer only")
                    .frame(maxWidth: .infinity, minHeight: 60, alignment: .center)
            }
            
            BFCard(title: "Tap Me", isSelectable: true, action: {
                print("Card tapped")
            }) {
                Text("This card is tappable")
                    .frame(maxWidth: .infinity, minHeight: 60, alignment: .center)
            }
        }
        .padding()
        .background(BFColors.background)
        .previewLayout(.sizeThatFits)
    }
} 