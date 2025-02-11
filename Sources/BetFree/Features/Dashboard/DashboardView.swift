import SwiftUI
import ComposableArchitecture

public struct DashboardView: View {
    @EnvironmentObject private var appState: AppState
    
    public var body: some View {
        ScrollView {
            VStack(spacing: BFDesignSystem.Spacing.large) {
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
            .padding(.vertical, BFDesignSystem.Spacing.medium)
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
        VStack(spacing: BFDesignSystem.Spacing.medium) {
            // Streak Circle
            ZStack {
                Circle()
                    .stroke(BFDesignSystem.Colors.primary.opacity(0.2), lineWidth: 8)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: min(CGFloat(streak) / 30.0, 1.0))
                    .stroke(BFDesignSystem.Colors.primary, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 4) {
                    Text("\(streak)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(BFDesignSystem.Colors.primary)
                    Text("DAYS")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
            }
            .padding(.top)
            
            // Savings
            VStack(spacing: 4) {
                Text("Money Saved")
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                Text("$\(String(format: "%.2f", savings))")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(BFDesignSystem.Colors.success)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: BFDesignSystem.CornerRadius.large)
                .fill(BFDesignSystem.Colors.cardBackground)
        )
    }
}

// MARK: - Daily Goals Section
struct DailyGoalsSection: View {
    let dailyLimit: Double
    let hasCheckedIn: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: BFDesignSystem.Spacing.medium) {
            Text("Today's Goals")
                .font(BFDesignSystem.Typography.titleSmall)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            HStack(spacing: BFDesignSystem.Spacing.medium) {
                // Check-in Goal
                GoalCard(
                    title: "Daily Check-in",
                    isCompleted: hasCheckedIn,
                    icon: "checkmark.circle.fill"
                )
                
                // Spending Limit Goal
                GoalCard(
                    title: "Stay Under $\(String(format: "%.0f", dailyLimit))",
                    isCompleted: false,  // TODO: Add to state
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
        VStack(spacing: BFDesignSystem.Spacing.small) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(isCompleted ? BFDesignSystem.Colors.success : BFDesignSystem.Colors.textSecondary)
            
            Text(title)
                .font(BFDesignSystem.Typography.bodyMedium)
                .multilineTextAlignment(.center)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            Text(isCompleted ? "Completed" : "In Progress")
                .font(BFDesignSystem.Typography.bodySmall)
                .foregroundColor(isCompleted ? BFDesignSystem.Colors.success : BFDesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: BFDesignSystem.CornerRadius.medium)
                .fill(BFDesignSystem.Colors.cardBackground)
        )
    }
}

// MARK: - Quick Actions Grid
struct QuickActionsGrid: View {
    var body: some View {
        VStack(alignment: .leading, spacing: BFDesignSystem.Spacing.medium) {
            Text("Quick Actions")
                .font(BFDesignSystem.Typography.titleSmall)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: BFDesignSystem.Spacing.medium) {
                QuickActionButton(
                    title: "Log Progress",
                    systemImage: "chart.bar.fill",
                    color: BFDesignSystem.Colors.primary
                )
                
                QuickActionButton(
                    title: "Breathing Exercise",
                    systemImage: "lungs.fill",
                    color: BFDesignSystem.Colors.secondary
                )
                
                QuickActionButton(
                    title: "Set Goals",
                    systemImage: "target",
                    color: BFDesignSystem.Colors.success
                )
                
                QuickActionButton(
                    title: "View Stats",
                    systemImage: "chart.line.uptrend.xyaxis",
                    color: BFDesignSystem.Colors.primary
                )
            }
        }
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
        VStack(spacing: BFDesignSystem.Spacing.small) {
            Text("💪 Daily Motivation")
                .font(BFDesignSystem.Typography.headlineMedium)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            Text(motivationalMessage)
                .font(BFDesignSystem.Typography.bodyLarge)
                .multilineTextAlignment(.center)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: BFDesignSystem.CornerRadius.medium)
                .fill(BFDesignSystem.Colors.cardBackground)
        )
    }
}

// MARK: - Quick Action Button
struct QuickActionButton: View {
    let title: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Spacing.small) {
            Image(systemName: systemImage)
                .font(.system(size: 30))
                .foregroundColor(color)
            
            Text(title)
                .font(BFDesignSystem.Typography.bodyMedium)
                .multilineTextAlignment(.center)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: BFDesignSystem.CornerRadius.medium)
                .fill(BFDesignSystem.Colors.cardBackground)
        )
        .shadow(radius: 2)
    }
}

#Preview {
    NavigationView {
        DashboardView()
            .environmentObject(AppState.shared)
    }
} 