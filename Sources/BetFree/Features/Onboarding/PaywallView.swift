import SwiftUI
import ComposableArchitecture

class PaywallViewModel: ObservableObject {
    @Published var isPresented: Bool
    let onSubscribe: () -> Void
    
    init(isPresented: Bool, onSubscribe: @escaping () -> Void) {
        self.isPresented = isPresented
        self.onSubscribe = onSubscribe
    }
    
    func dismiss() {
        isPresented = false
    }
    
    func subscribe() {
        onSubscribe()
    }
}

struct PaywallView: View {
    @StateObject private var viewModel: PaywallViewModel
    
    init(isPresented: Binding<Bool>, onSubscribe: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: PaywallViewModel(
            isPresented: isPresented.wrappedValue,
            onSubscribe: onSubscribe
        ))
    }
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
            // Header
            VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                Text("Unlock Full Access")
                    .font(BFDesignSystem.Typography.titleLarge)
                    .multilineTextAlignment(.center)
                
                Text("Start your journey to a better life today")
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top)
            
            // Features
            VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Personalized Progress Tracking")
                FeatureRow(icon: "target", text: "Custom Goal Setting")
                FeatureRow(icon: "bell", text: "Smart Reminders")
                FeatureRow(icon: "sparkles", text: "Premium Resources")
            }
            .padding(.vertical)
            
            // Subscription Button
            Button(action: viewModel.subscribe) {
                Text("Start Free Trial")
                    .font(BFDesignSystem.Typography.headlineMedium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(BFDesignSystem.Colors.primary)
                    .cornerRadius(BFDesignSystem.Layout.CornerRadius.button)
            }
            
            // Terms
            Text("7-day free trial, then $9.99/month. Cancel anytime.")
                .font(BFDesignSystem.Typography.caption)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
            
            // Dismiss Button
            Button("Maybe Later", action: viewModel.dismiss)
                .font(BFDesignSystem.Typography.bodyMedium)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
        }
        .padding()
        .background(BFDesignSystem.Colors.background)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.large)
        .shadow(radius: 20)
        .padding()
    }
}

private struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(BFDesignSystem.Colors.primary)
                .frame(width: 32)
            
            Text(text)
                .font(BFDesignSystem.Typography.bodyLarge)
            
            Spacer()
        }
    }
}

#Preview {
    PaywallView(
        isPresented: .constant(true),
        onSubscribe: {}
    )
} 