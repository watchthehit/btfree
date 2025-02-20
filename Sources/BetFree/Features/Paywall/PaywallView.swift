import SwiftUI
import BetFreeUI
import BetFreeModels

@available(macOS 10.15, iOS 13.0, *)
public struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: PaywallViewModel
    @State private var selectedPlan: Plan?
    @State private var isPurchasing = false
    
    public init(dataManager: BetFreeDataManager) {
        _viewModel = StateObject(wrappedValue: PaywallViewModel(dataManager: dataManager))
    }
    
    fileprivate let features: [Feature] = [
        Feature(icon: "chart.line.uptrend.xyaxis", title: "Advanced Analytics", description: "Track your progress with detailed insights"),
        Feature(icon: "bell.badge.fill", title: "Smart Reminders", description: "Get personalized notifications"),
        Feature(icon: "lock.shield.fill", title: "App Blocking", description: "Block gambling apps and websites"),
        Feature(icon: "person.2.fill", title: "Community Support", description: "Connect with others on the same journey")
    ]
    
    fileprivate let plans: [Plan] = [
        Plan(id: 1, title: "Monthly Plan", description: "Perfect for trying out", price: "$9.99/month"),
        Plan(id: 2, title: "Yearly Plan", description: "Save 40% compared to monthly", price: "$59.99/year")
    ]
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "shield.fill")
                            .font(.system(size: 64))
                            .foregroundColor(BFDesignSystem.Colors.primary)
                        
                        Text("Unlock Premium Features")
                            .font(BFDesignSystem.Typography.displayMedium)
                            .foregroundColor(BFDesignSystem.Colors.textPrimary)
                        
                        Text("Get access to advanced features and support our mission")
                            .font(BFDesignSystem.Typography.bodyLarge)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 24)
                    
                    // Features
                    VStack(spacing: 16) {
                        ForEach(features) { feature in
                            FeatureRow(
                                icon: feature.icon,
                                title: feature.title,
                                description: feature.description
                            )
                        }
                    }
                    
                    // Plans
                    VStack(spacing: 16) {
                        ForEach(plans) { plan in
                            PlanCard(
                                plan: plan,
                                isSelected: selectedPlan?.id == plan.id,
                                action: { selectedPlan = plan }
                            )
                        }
                    }
                    
                    // Purchase Button
                    Button(action: {
                        guard let selectedPlan = selectedPlan else { return }
                        isPurchasing = true
                        Task {
                            await viewModel.purchase(plan: selectedPlan)
                            isPurchasing = false
                            if viewModel.purchaseSuccessful {
                                dismiss()
                            }
                        }
                    }) {
                        if isPurchasing {
                            SwiftUI.ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .tint(.white)
                        } else {
                            Text("Subscribe Now")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(BFDesignSystem.Colors.primary)
                    .cornerRadius(8)
                    .disabled(selectedPlan == nil || isPurchasing)
                    .opacity(selectedPlan == nil ? 0.5 : 1)
                }
                .padding()
            }
            .navigationTitle("Premium")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
                #else
                ToolbarItem(placement: .automatic) {
                    Button("Close") {
                        dismiss()
                    }
                }
                #endif
            }
        }
    }
}

@available(macOS 10.15, iOS 13.0, *)
private struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(BFDesignSystem.Colors.primary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(BFDesignSystem.Colors.textPrimary)
                
                Text(description)
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(BFDesignSystem.Colors.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(BFDesignSystem.Colors.textSecondary.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

@available(macOS 10.15, iOS 13.0, *)
private struct PlanCard: View {
    let plan: Plan
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(plan.title)
                        .font(BFDesignSystem.Typography.bodyLarge)
                        .foregroundColor(BFDesignSystem.Colors.textPrimary)
                    
                    Text(plan.description)
                        .font(BFDesignSystem.Typography.bodyMedium)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    
                    Text(plan.price)
                        .font(BFDesignSystem.Typography.titleMedium)
                        .foregroundColor(BFDesignSystem.Colors.primary)
                        .padding(.top, 8)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.textSecondary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? BFDesignSystem.Colors.primary.opacity(0.1) : BFDesignSystem.Colors.background)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                isSelected ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.textSecondary.opacity(0.2),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

fileprivate struct Feature: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}
