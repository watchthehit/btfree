import SwiftUI

struct PaywallView: View {
    @Binding var isPresented: Bool
    let onSubscribe: () -> Void
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
            // Header
            VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                Text("Unlock Full Access")
                    .font(BFDesignSystem.Typography.titleLarge)
                
                Text("Start your journey to recovery today")
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
            
            // Features
            VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Detailed progress tracking")
                FeatureRow(icon: "bell.fill", text: "Custom notifications and reminders")
                FeatureRow(icon: "person.fill", text: "24/7 professional support access")
                FeatureRow(icon: "lock.fill", text: "Privacy focused, secure data")
            }
            .padding()
            
            // Pricing
            VStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                Text("$9.99/month")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                
                Text("after 7-day free trial")
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
            
            // Buttons
            VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                Button(action: onSubscribe) {
                    Text("Start 7-Day Free Trial")
                        .font(BFDesignSystem.Typography.headlineMedium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(BFDesignSystem.Colors.primary)
                        .cornerRadius(BFDesignSystem.Layout.CornerRadius.button)
                }
                
                Button("Restore Purchase") {
                    // TODO: Implement restore purchase
                }
                .font(BFDesignSystem.Typography.bodyMedium)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
            
            // Terms
            Text("Cancel anytime. Terms apply.")
                .font(BFDesignSystem.Typography.bodySmall)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
        }
        .padding()
        .background(BFDesignSystem.Colors.background)
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            Image(systemName: icon)
                .foregroundColor(BFDesignSystem.Colors.primary)
                .frame(width: BFDesignSystem.Layout.Size.iconMedium)
            
            Text(text)
                .font(BFDesignSystem.Typography.bodyLarge)
            
            Spacer()
        }
    }
} 