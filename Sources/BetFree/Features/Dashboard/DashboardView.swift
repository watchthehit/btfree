import SwiftUI
import ComposableArchitecture

public struct DashboardView: View {
    @EnvironmentObject private var appState: AppState
    
    public var body: some View {
        ScrollView {
            VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
                // Main Progress Card
                ProgressCard(
                    streak: appState.streak,
                    savings: appState.savings
                )
                .padding(.horizontal)
                
                // Daily Limit Card
                DailyLimitCard(limit: appState.dailyLimit)
                    .padding(.horizontal)
                
                // Motivation Card
                MotivationCard()
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Dashboard")
    }
    
    public init() {}
}

private struct ProgressCard: View {
    let streak: Int
    let savings: Double
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            // Header
            HStack {
                Text("Your Progress")
                    .font(BFDesignSystem.Typography.titleMedium)
                    .foregroundColor(BFDesignSystem.Colors.textPrimary)
                Spacer()
            }
            
            // Stats
            HStack(spacing: BFDesignSystem.Layout.Spacing.large) {
                // Streak
                VStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                    Text("\(streak)")
                        .font(BFDesignSystem.Typography.titleLarge)
                        .foregroundColor(BFDesignSystem.Colors.primary)
                    Text("Day Streak")
                        .font(BFDesignSystem.Typography.caption)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
                
                Divider()
                
                // Savings
                VStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                    Text("$\(savings, specifier: "%.2f")")
                        .font(BFDesignSystem.Typography.titleLarge)
                        .foregroundColor(BFDesignSystem.Colors.success)
                    Text("Saved")
                        .font(BFDesignSystem.Typography.caption)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
            }
            .padding()
            .background(BFDesignSystem.Colors.cardBackground)
            .cornerRadius(BFDesignSystem.Layout.CornerRadius.medium)
            .withShadow(BFDesignSystem.Layout.Shadow.small)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.card)
                .fill(BFDesignSystem.Colors.cardBackground)
                .withShadow(BFDesignSystem.Layout.Shadow.card)
        )
    }
}

private struct DailyLimitCard: View {
    let limit: Double
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            // Header
            HStack {
                Text("Daily Limit")
                    .font(BFDesignSystem.Typography.titleMedium)
                    .foregroundColor(BFDesignSystem.Colors.textPrimary)
                Spacer()
            }
            
            // Limit Display
            HStack {
                Text("$\(limit, specifier: "%.2f")")
                    .font(BFDesignSystem.Typography.titleLarge)
                    .foregroundColor(BFDesignSystem.Colors.primary)
                
                Spacer()
                
                Button(action: {
                    // Edit limit action
                }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: BFDesignSystem.Layout.Size.iconLarge))
                        .foregroundColor(BFDesignSystem.Colors.primary)
                }
            }
            .padding()
            .background(BFDesignSystem.Colors.cardBackground)
            .cornerRadius(BFDesignSystem.Layout.CornerRadius.medium)
            .withShadow(BFDesignSystem.Layout.Shadow.small)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.card)
                .fill(BFDesignSystem.Colors.cardBackground)
                .withShadow(BFDesignSystem.Layout.Shadow.card)
        )
    }
}

private struct MotivationCard: View {
    let quotes = [
        "Every day is a new opportunity to stay strong.",
        "Small steps lead to big changes.",
        "You are stronger than you think.",
        "Focus on progress, not perfection.",
        "Your future self will thank you."
    ]
    
    var randomQuote: String {
        quotes.randomElement() ?? quotes[0]
    }
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            Text("💪 Daily Motivation")
                .font(BFDesignSystem.Typography.titleMedium)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            Text(randomQuote)
                .font(BFDesignSystem.Typography.bodyLarge)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.card)
                .fill(BFDesignSystem.Colors.cardBackground)
                .withShadow(BFDesignSystem.Layout.Shadow.card)
        )
    }
}

#Preview {
    NavigationView {
        DashboardView()
            .environmentObject(AppState())
    }
} 