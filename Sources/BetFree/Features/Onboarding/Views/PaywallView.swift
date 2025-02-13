import SwiftUI

public struct PaywallView: View {
    @Binding var isPresented: Bool
    let onSubscribe: () -> Void
    @State private var selectedPlan = 1 // 0: Monthly, 1: Annual
    
    let plans = [
        (name: "Monthly", price: "$9.99", period: "month", savings: ""),
        (name: "Annual", price: "$79", period: "year", savings: "Save 33%")
    ]
    
    public var body: some View {
        ZStack {
            // Full screen background
            BFDesignSystem.Colors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
                    // Header
                    VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                        Text("Transform Your Life")
                            .font(BFDesignSystem.Typography.display)
                            .foregroundStyle(BFDesignSystem.Colors.calmingGradient)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("Join thousands who have reclaimed control")
                            .font(BFDesignSystem.Typography.titleSmall)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, BFDesignSystem.Layout.Spacing.xxLarge)
                    
                    // Features
                    VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                        FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Personalized Progress")
                        FeatureRow(icon: "target", text: "Custom Goal Setting")
                        FeatureRow(icon: "bell", text: "Smart Reminders")
                        FeatureRow(icon: "sparkles", text: "Premium Resources")
                    }
                    .padding(.vertical, BFDesignSystem.Layout.Spacing.large)
                    
                    // Plan Selection
                    HStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                        ForEach(0..<2) { index in
                            PaywallPlanView(
                                plan: plans[index],
                                isSelected: selectedPlan == index
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedPlan = index
                                }
                            }
                        }
                    }
                    
                    // Action Buttons
                    VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                        Button(action: onSubscribe) {
                            Text("Start Free Trial")
                                .font(BFDesignSystem.Typography.button)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: BFDesignSystem.Layout.Size.buttonHeight)
                                .background(BFDesignSystem.Colors.primary)
                                .cornerRadius(BFDesignSystem.Layout.CornerRadius.button)
                        }
                        
                        // Money Back Guarantee
                        HStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                            Image(systemName: "checkmark.shield.fill")
                                .foregroundColor(BFDesignSystem.Colors.success)
                            Text("30-day money-back guarantee")
                                .font(BFDesignSystem.Typography.caption)
                                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                        }
                        
                        // Terms
                        Text("7-day free trial, then \(plans[selectedPlan].price)/\(plans[selectedPlan].period). Cancel anytime.")
                            .font(BFDesignSystem.Typography.caption)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        // Dismiss Button
                        Button("Maybe Later") {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                isPresented = false
                            }
                        }
                        .font(BFDesignSystem.Typography.button)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                        .padding(.top, BFDesignSystem.Layout.Spacing.medium)
                    }
                }
                .padding(BFDesignSystem.Layout.Spacing.xxLarge)
            }
            .background(BFDesignSystem.Colors.cardBackground)
            .cornerRadius(BFDesignSystem.Layout.CornerRadius.xLarge)
            .withShadow(BFDesignSystem.Layout.Shadow.large)
            .padding(.horizontal, BFDesignSystem.Layout.Spacing.large)
        }
    }
}

private struct FeatureRow: View {
    let icon: String
    let text: String
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            Image(systemName: icon)
                .font(.system(size: BFDesignSystem.Layout.Size.iconLarge))
                .foregroundStyle(BFDesignSystem.Colors.calmingGradient)
                .frame(width: 32)
            
            Text(text)
                .font(BFDesignSystem.Typography.bodyLarge)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, BFDesignSystem.Layout.Spacing.large)
        .padding(.vertical, BFDesignSystem.Layout.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.large)
                .fill(BFDesignSystem.Colors.cardBackground)
                .withShadow(isHovered ? BFDesignSystem.Layout.Shadow.medium : BFDesignSystem.Layout.Shadow.small)
        )
        .onHover { hovering in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isHovered = hovering
            }
        }
    }
}

private struct PaywallPlanView: View {
    let plan: (name: String, price: String, period: String, savings: String)
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                Text(plan.name)
                    .font(BFDesignSystem.Typography.bodyLargeMedium)
                    .padding(.bottom, 4)
                
                if plan.name == "Annual" {
                    Text("$79.99")
                        .font(BFDesignSystem.Typography.titleLarge)
                } else {
                    Text(plan.price)
                        .font(BFDesignSystem.Typography.titleLarge)
                }
                
                Text("per \(plan.period)")
                    .font(BFDesignSystem.Typography.caption)
                    .padding(.top, 2)
                
                if !plan.savings.isEmpty {
                    Text(plan.savings)
                        .font(BFDesignSystem.Typography.caption)
                        .foregroundColor(isSelected ? .white : BFDesignSystem.Colors.success)
                        .padding(.top, 2)
                }
            }
            .padding(.vertical, BFDesignSystem.Layout.Spacing.large)
            .padding(.horizontal, BFDesignSystem.Layout.Spacing.medium)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.large)
                    .fill(isSelected ? BFDesignSystem.Colors.calmingGradient : LinearGradient(
                        colors: [BFDesignSystem.Colors.cardBackground, BFDesignSystem.Colors.cardBackground],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
            )
            .foregroundColor(isSelected ? .white : BFDesignSystem.Colors.textPrimary)
            .withShadow(isSelected ? BFDesignSystem.Layout.Shadow.medium : BFDesignSystem.Layout.Shadow.small)
        }
        .buttonStyle(.plain)
    }
}

#if DEBUG
struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Light mode
            PaywallView(isPresented: .constant(true)) {
                print("Subscribe tapped")
            }
            .previewDisplayName("Light Mode")
            
            // Dark mode
            PaywallView(isPresented: .constant(true)) {
                print("Subscribe tapped")
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
            
            // Compact width
            PaywallView(isPresented: .constant(true)) {
                print("Subscribe tapped")
            }
            .previewLayout(.fixed(width: 320, height: 800))
            .previewDisplayName("Compact Width")
        }
    }
} 
#endif 