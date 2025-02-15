import SwiftUI

public struct ProgressView: View {
    @EnvironmentObject var appState: AppState
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
                // Progress Summary
                VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.medium) {
                    Text("Your Progress")
                        .font(BFDesignSystem.Typography.titleLarge)
                        .foregroundStyle(BFDesignSystem.Colors.primaryGradient)
                    
                    Text("Keep going! Every day is a step forward.")
                        .font(BFDesignSystem.Typography.bodyLarge)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Stats Grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: BFDesignSystem.Layout.Spacing.medium) {
                    // Streak Card
                    VStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                        Text("Longest Streak")
                            .font(BFDesignSystem.Typography.caption)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                        
                        Text("\(appState.streak) days")
                            .font(BFDesignSystem.Typography.titleMedium)
                            .foregroundColor(BFDesignSystem.Colors.textPrimary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(BFDesignSystem.Colors.cardBackground)
                    .cornerRadius(BFDesignSystem.Layout.CornerRadius.medium)
                    
                    // Savings Card
                    VStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                        Text("Total Savings")
                            .font(BFDesignSystem.Typography.caption)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                        
                        Text("$\(String(format: "%.2f", appState.savings))")
                            .font(BFDesignSystem.Typography.titleMedium)
                            .foregroundColor(BFDesignSystem.Colors.textPrimary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(BFDesignSystem.Colors.cardBackground)
                    .cornerRadius(BFDesignSystem.Layout.CornerRadius.medium)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(BFDesignSystem.Colors.background)
        .navigationTitle("Progress")
    }
}
