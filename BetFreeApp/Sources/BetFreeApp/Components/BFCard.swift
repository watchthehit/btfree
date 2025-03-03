import SwiftUI

/**
 * BFCard - Card component for the BetFree app
 *
 * This component implements a card container using the "Serene Recovery" color scheme.
 * It provides a consistent container for content with appropriate styling and optional
 * header, footer, and accent color.
 */
@available(iOS 15.0, macOS 12.0, *)
public struct BFCard<Content: View>: View {
    // MARK: - Properties
    
    private let title: String?
    private let subtitle: String?
    private let footer: String?
    private let accentColor: Color?
    private let isSelectable: Bool
    private let action: (() -> Void)?
    private let content: Content
    
    // MARK: - Initializers
    
    /// Creates a new card with the specified parameters
    /// - Parameters:
    ///   - title: Optional title to display at the top of the card
    ///   - subtitle: Optional subtitle to display below the title
    ///   - footer: Optional footer text to display at the bottom of the card
    ///   - accentColor: Optional color for the accent bar at the top of the card
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
            }
            
            // Title and subtitle if provided
            if title != nil || subtitle != nil {
                VStack(alignment: .leading, spacing: 4) {
                    if let title = title {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(BFColors.textPrimary)
                    }
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(BFColors.textSecondary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)
            }
            
            // Main content
            content
                .padding(.horizontal, 16)
                .padding(.vertical, title == nil && subtitle == nil ? 16 : 0)
            
            // Footer if provided
            if let footer = footer {
                Divider()
                    .padding(.horizontal, 16)
                
                Text(footer)
                    .font(.footnote)
                    .foregroundColor(BFColors.textSecondary)
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
            if isSelectable {
                action?()
            }
        }
    }
}

// MARK: - Preview

@available(iOS 15.0, macOS 12.0, *)
struct BFCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            BFCard(title: "Recovery Progress", subtitle: "Last 7 days") {
                Text("Card content")
                    .frame(maxWidth: .infinity, minHeight: 80, alignment: .center)
            }
            
            BFCard(title: "Mindfulness Exercise", accentColor: BFColors.calm) {
                Text("Breathing exercise content")
                    .frame(maxWidth: .infinity, minHeight: 80, alignment: .center)
            }
            
            BFCard(title: "Daily Challenge", subtitle: "Complete for rewards", footer: "Tap to start") {
                Text("Challenge content")
                    .frame(maxWidth: .infinity, minHeight: 80, alignment: .center)
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
} 