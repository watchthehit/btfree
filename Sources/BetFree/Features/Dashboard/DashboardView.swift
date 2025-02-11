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
        VStack(spacing: BFDesignSystem.Spacing.large) {
            // Streak Circle
            ZStack {
                // Background Circle
                Circle()
                    .stroke(BFDesignSystem.Colors.primary.opacity(0.1), lineWidth: 12)
                    .frame(width: 160, height: 160)
                
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
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))
                
                // Center Content
                VStack(spacing: 4) {
                    Text("\(streak)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(BFDesignSystem.Colors.primary)
                    Text("DAYS")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
            }
            
            // Savings
            VStack(spacing: 8) {
                Text("Total Savings")
                    .font(BFDesignSystem.Typography.headlineMedium)
                    .foregroundColor(BFDesignSystem.Colors.textPrimary)
                Text("$\(String(format: "%.2f", savings))")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(BFDesignSystem.Colors.success)
            }
        }
        .padding(.vertical, BFDesignSystem.Spacing.large)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: BFDesignSystem.CornerRadius.large)
                .fill(BFDesignSystem.Colors.cardBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
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
        VStack(spacing: BFDesignSystem.Spacing.medium) {
            Image(systemName: icon)
                .font(.system(size: 28, weight: .medium))
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
        .padding()
        .background(
            RoundedRectangle(cornerRadius: BFDesignSystem.CornerRadius.medium)
                .fill(BFDesignSystem.Colors.cardBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
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
            
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: BFDesignSystem.Spacing.medium
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
        VStack(spacing: BFDesignSystem.Spacing.small) {
            Image(systemName: systemImage)
                .font(.system(size: 28, weight: .medium))
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
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
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
        VStack(spacing: BFDesignSystem.Spacing.medium) {
            Text("💪 Daily Motivation")
                .font(BFDesignSystem.Typography.headlineMedium)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            Text(motivationalMessage)
                .font(BFDesignSystem.Typography.bodyLarge)
                .multilineTextAlignment(.center)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .padding(.horizontal, BFDesignSystem.Spacing.small)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: BFDesignSystem.CornerRadius.medium)
                .fill(BFDesignSystem.Colors.cardBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    NavigationView {
        DashboardView()
            .environmentObject(AppState.shared)
    }
} 