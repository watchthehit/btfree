import SwiftUI
import ComposableArchitecture

public struct DashboardView: View {
    @EnvironmentObject private var appState: AppState
    
    public var body: some View {
        ScrollView {
            VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
                // Main Progress Card
                ProgressCard(
                    streak: appState.currentStreak,
                    savings: appState.totalSavings
                )
                .padding(.horizontal)
                
                // Daily Goals Section
                DailyGoalsSection(
                    dailyLimit: appState.dailyLimit,
                    hasCheckedIn: false  // TODO: Add to state
                )
                .padding(.horizontal)
                
                // Quick Actions Grid
                QuickActionsGrid()
                    .padding(.horizontal)
                
                // Motivation Quote
                MotivationCard(streak: appState.currentStreak)
                    .padding(.horizontal)
            }
            .padding(.vertical, BFDesignSystem.Layout.Spacing.medium)
        }
        .background(BFDesignSystem.Colors.background)
        .navigationTitle("Dashboard")
    }
    
    public init() {}
}

// MARK: - Progress Card
struct ProgressCard: View {
    let streak: Int
    let savings: Double
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
            // Streak Circle
            ZStack {
                // Background Circle
                Circle()
                    .stroke(BFDesignSystem.Colors.primary.opacity(0.1), lineWidth: 12)
                    .frame(width: BFDesignSystem.Layout.Size.progressCircleLarge, height: BFDesignSystem.Layout.Size.progressCircleLarge)
                
                // Progress Circle
                Circle()
                    .trim(from: 0, to: min(CGFloat(streak) / 30.0, 1.0))
                    .stroke(
                        AngularGradient(
                            colors: [BFDesignSystem.Colors.primary, BFDesignSystem.Colors.secondary],
                            center: .center,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(270)
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: BFDesignSystem.Layout.Size.progressCircleLarge, height: BFDesignSystem.Layout.Size.progressCircleLarge)
                    .rotationEffect(.degrees(-90))
                
                // Center Content
                VStack(spacing: BFDesignSystem.Layout.Spacing.xxSmall) {
                    Text("\(streak)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(BFDesignSystem.Colors.primary)
                    Text("DAYS")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
            }
            
            // Savings
            VStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                Text("Total Savings")
                    .font(BFDesignSystem.Typography.headlineMedium)
                    .foregroundColor(BFDesignSystem.Colors.textPrimary)
                Text("$\(String(format: "%.2f", savings))")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(BFDesignSystem.Colors.success)
            }
        }
        .padding(.vertical, BFDesignSystem.Layout.Spacing.large)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.card)
                .fill(BFDesignSystem.Colors.cardBackground)
                .withShadow(BFDesignSystem.Layout.Shadow.card)
        )
    }
}

// MARK: - Daily Goals Section
struct DailyGoalsSection: View {
    let dailyLimit: Double
    let hasCheckedIn: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.medium) {
            Text("Today's Goals")
                .font(BFDesignSystem.Typography.titleSmall)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            HStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                GoalCard(
                    title: "Daily Check-in",
                    isCompleted: hasCheckedIn,
                    icon: "checkmark.circle.fill"
                )
                
                GoalCard(
                    title: "Stay Under $\(String(format: "%.0f", dailyLimit))",
                    isCompleted: false,
                    icon: "dollarsign.circle.fill"
                )
            }
        }
    }
}

struct GoalCard: View {
    let title: String
    let isCompleted: Bool
    let icon: String
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            Image(systemName: icon)
                .font(.system(size: BFDesignSystem.Layout.Size.iconLarge, weight: .medium))
                .foregroundColor(isCompleted ? BFDesignSystem.Colors.success : BFDesignSystem.Colors.textSecondary)
            
            Text(title)
                .font(BFDesignSystem.Typography.bodyMedium)
                .multilineTextAlignment(.center)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(isCompleted ? "Completed" : "In Progress")
                .font(BFDesignSystem.Typography.bodySmall)
                .foregroundColor(isCompleted ? BFDesignSystem.Colors.success : BFDesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(BFDesignSystem.Layout.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.card)
                .fill(BFDesignSystem.Colors.cardBackground)
                .withShadow(BFDesignSystem.Layout.Shadow.card)
        )
    }
}

// MARK: - Quick Actions Grid
struct QuickActionsGrid: View {
    var body: some View {
        VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.medium) {
            Text("Quick Actions")
                .font(BFDesignSystem.Typography.titleSmall)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            LazyVGrid(
                columns: BFDesignSystem.Layout.Grid.columns,
                spacing: BFDesignSystem.Layout.Spacing.medium
            ) {
                QuickActionButton(
                    title: "Log Progress",
                    systemImage: "chart.bar.fill",
                    color: BFDesignSystem.Colors.primary
                )
                
                QuickActionButton(
                    title: "Breathing",
                    systemImage: "lungs.fill",
                    color: BFDesignSystem.Colors.secondary
                )
                
                QuickActionButton(
                    title: "Set Goals",
                    systemImage: "target",
                    color: BFDesignSystem.Colors.success
                )
                
                QuickActionButton(
                    title: "Statistics",
                    systemImage: "chart.line.uptrend.xyaxis",
                    color: BFDesignSystem.Colors.primary
                )
            }
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.small) {
            Image(systemName: systemImage)
                .font(.system(size: BFDesignSystem.Layout.Size.iconMedium, weight: .medium))
                .foregroundColor(color)
            
            Text(title)
                .font(BFDesignSystem.Typography.bodyMedium)
                .multilineTextAlignment(.center)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(BFDesignSystem.Layout.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.card)
                .fill(BFDesignSystem.Colors.cardBackground)
                .withShadow(BFDesignSystem.Layout.Shadow.card)
        )
    }
}

// MARK: - Motivation Card
struct MotivationCard: View {
    let streak: Int
    
    var motivationalMessage: String {
        if streak == 0 {
            return "Every journey begins with a single step. You've got this!"
        } else if streak < 7 {
            return "Amazing start! The first week is crucial, and you're crushing it!"
        } else if streak < 30 {
            return "You're building a powerful new habit. Keep going!"
        } else {
            return "You're an inspiration! Look at how far you've come!"
        }
    }
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            Text("💪 Daily Motivation")
                .font(BFDesignSystem.Typography.headlineMedium)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            Text(motivationalMessage)
                .font(BFDesignSystem.Typography.bodyLarge)
                .multilineTextAlignment(.center)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .padding(.horizontal, BFDesignSystem.Layout.Spacing.small)
        }
        .padding(BFDesignSystem.Layout.Spacing.medium)
        .frame(maxWidth: .infinity)
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
            .environmentObject(AppState.shared)
    }
} 