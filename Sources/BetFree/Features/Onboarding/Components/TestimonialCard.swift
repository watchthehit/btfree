import SwiftUI

struct TestimonialCard: View {
    let quote: String
    let author: String
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            Text("\u{201C}") // Using Unicode for opening quote
                .font(.system(size: 48))
                .foregroundColor(BFDesignSystem.Colors.primary)
            
            Text(quote)
                .font(BFDesignSystem.Typography.bodyLarge)
                .multilineTextAlignment(.center)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            Text("- \(author)")
                .font(BFDesignSystem.Typography.bodyMedium)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
        }
        .padding()
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.large)
    }
} 