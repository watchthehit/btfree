import SwiftUI
import StoreKit

public struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var storeManager = BFStoreManager.shared
    @State private var selectedProduct: Product?
    @State private var isLoading = false
    @State private var error: String?
    
    private let onComplete: () -> Void
    
    public init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "shield.fill")
                            .font(.system(size: 64))
                            .foregroundColor(BFDesignSystem.Colors.primary)
                        
                        Text("BetFree Premium")
                            .font(BFDesignSystem.Typography.titleLarge)
                        
                        Text("Take control of your betting habits")
                            .font(BFDesignSystem.Typography.bodyLarge)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 32)
                    
                    // Features
                    VStack(spacing: 16) {
                        featureRow(icon: "lock.shield.fill", title: "Block Betting Apps", description: "Prevent access to betting apps")
                        featureRow(icon: "chart.line.uptrend.xyaxis", title: "Track Progress", description: "Monitor your recovery journey")
                        featureRow(icon: "dollarsign.circle.fill", title: "Track Savings", description: "See how much you've saved")
                    }
                    .padding(.horizontal)
                    
                    // Subscription Options
                    VStack(spacing: 16) {
                        ForEach(storeManager.products, id: \.id) { product in
                            subscriptionButton(for: product)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Trial Info
                    if case .trial = storeManager.subscriptionStatus {
                        Text("7-day free trial, then \(selectedProduct?.displayPrice ?? "$9.99")/month")
                            .font(BFDesignSystem.Typography.bodyMedium)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    }
                    
                    // Error
                    if let error = error {
                        Text(error)
                            .font(BFDesignSystem.Typography.bodyMedium)
                            .foregroundColor(BFDesignSystem.Colors.error)
                    }
                    
                    // Restore Button
                    Button {
                        Task {
                            await restorePurchases()
                        }
                    } label: {
                        Text("Restore Purchases")
                            .font(BFDesignSystem.Typography.labelMedium)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    }
                    .padding(.top)
                }
                .padding(.bottom, 32)
            }
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if case .trial = storeManager.subscriptionStatus {
                        Button("Skip") {
                            dismiss()
                        }
                    }
                }
            }
            .overlay {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.black.opacity(0.3))
                }
            }
        }
    }
    
    private func featureRow(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(BFDesignSystem.Colors.primary)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(BFDesignSystem.Typography.titleSmall)
                
                Text(description)
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
            
            Spacer()
        }
    }
    
    private func subscriptionButton(for product: Product) -> some View {
        Button {
            selectedProduct = product
            Task {
                await purchase(product)
            }
        } label: {
            VStack(spacing: 8) {
                Text(product.displayName)
                    .font(BFDesignSystem.Typography.titleMedium)
                
                Text(product.displayPrice)
                    .font(BFDesignSystem.Typography.titleLarge)
                    .foregroundColor(BFDesignSystem.Colors.primary)
                
                if product.id == BFSubscriptionProduct.yearly.id {
                    Text("Save 33%")
                        .font(BFDesignSystem.Typography.labelSmall)
                        .foregroundColor(BFDesignSystem.Colors.success)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(BFDesignSystem.Colors.success.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(selectedProduct?.id == product.id ? BFDesignSystem.Colors.primary.opacity(0.1) : BFDesignSystem.Colors.background)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(selectedProduct?.id == product.id ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.border, lineWidth: 1)
            )
        }
    }
    
    private func purchase(_ product: Product) async {
        isLoading = true
        error = nil
        
        do {
            if let transaction = try await storeManager.purchase(product) {
                onComplete()
                dismiss()
            }
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func restorePurchases() async {
        isLoading = true
        error = nil
        
        do {
            try await storeManager.restorePurchases()
            if case .subscribed = storeManager.subscriptionStatus {
                onComplete()
                dismiss()
            } else {
                error = "No active subscription found"
            }
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
}
