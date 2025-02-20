import SwiftUI
import BetFreeUI

public struct BFTestimonialCard: View {
    let quote: String
    let author: String
    
    public init(quote: String, author: String) {
        self.quote = quote
        self.author = author
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.medium) {
            Text("\"\(quote)\"")
                .font(BFDesignSystem.Typography.bodyLarge)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
                .multilineTextAlignment(.leading)
            
            Text("- \(author)")
                .font(BFDesignSystem.Typography.caption)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
        }
        .padding(BFDesignSystem.Layout.Spacing.large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.medium)
    }
} 