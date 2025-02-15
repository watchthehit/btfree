import SwiftUI

public struct ProgressView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var cravingManager = CravingManager()
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Streak Card
                    BFCard(style: .elevated) {
                        VStack(spacing: 12) {
                            Text("Bet-Free Streak")
                                .font(BFDesignSystem.Typography.titleMedium)
                            
                            Text("\(appState.currentStreak)")
                                .font(BFDesignSystem.Typography.displayLarge)
                                .foregroundColor(BFDesignSystem.Colors.success)
                            
                            Text("Days Strong")
                                .font(BFDesignSystem.Typography.bodyMedium)
                                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                            
                            if appState.currentStreak > 0 {
                                Text("Next milestone: \(nextMilestone) days")
                                    .font(BFDesignSystem.Typography.labelMedium)
                                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                            }
                        }
                        .padding()
                    }
                    
                    // Weekly Calendar
                    BFCard(style: .elevated) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Weekly Progress")
                                .font(BFDesignSystem.Typography.titleMedium)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                                ForEach(lastSevenDays, id: \.self) { date in
                                    DayCell(
                                        date: date,
                                        isClean: appState.wasCleanOn(date),
                                        hadCraving: cravingManager.hadCravingOn(date)
                                    )
                                }
                            }
                        }
                        .padding()
                    }
                    
                    // Achievement Stats
                    BFCard(style: .elevated) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recovery Achievements")
                                .font(BFDesignSystem.Typography.titleMedium)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                StatBox(
                                    title: "Games Resisted",
                                    value: "\(appState.currentStreak * 2)",
                                    icon: "sportscourt.fill",
                                    color: BFDesignSystem.Colors.success
                                )
                                
                                StatBox(
                                    title: "Clean Weekends",
                                    value: "\(appState.currentStreak / 7)",
                                    icon: "calendar.badge.clock",
                                    color: BFDesignSystem.Colors.primary
                                )
                                
                                StatBox(
                                    title: "Urges Overcome",
                                    value: "\(cravingManager.totalCravingsResisted)",
                                    icon: "hand.raised.fill",
                                    color: BFDesignSystem.Colors.warning
                                )
                                
                                StatBox(
                                    title: "High Risk Days",
                                    value: "\(cravingManager.highRiskDaysSurvived)",
                                    icon: "exclamationmark.triangle.fill",
                                    color: BFDesignSystem.Colors.error
                                )
                            }
                        }
                        .padding()
                    }
                    
                    // Recent Milestones
                    if !recentMilestones.isEmpty {
                        BFCard(style: .elevated) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Recent Milestones")
                                    .font(BFDesignSystem.Typography.titleMedium)
                                
                                ForEach(recentMilestones, id: \.title) { milestone in
                                    HStack {
                                        Image(systemName: milestone.icon)
                                            .foregroundColor(BFDesignSystem.Colors.primary)
                                        
                                        VStack(alignment: .leading) {
                                            Text(milestone.title)
                                                .font(BFDesignSystem.Typography.bodyLarge)
                                            Text(milestone.date, style: .date)
                                                .font(BFDesignSystem.Typography.bodySmall)
                                                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                                        }
                                    }
                                    
                                    if milestone.title != recentMilestones.last?.title {
                                        Divider()
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Progress")
        }
    }
    
    private var nextMilestone: Int {
        let milestones = [1, 3, 7, 14, 30, 60, 90, 180, 365]
        return milestones.first { $0 > appState.currentStreak } ?? (milestones.last! + 365)
    }
    
    private var lastSevenDays: [Date] {
        (0..<7).map { index in
            Calendar.current.date(byAdding: .day, value: -index, to: Date()) ?? Date()
        }.reversed()
    }
    
    private var recentMilestones: [Milestone] {
        [
            Milestone(
                title: "First Game Day Clean",
                date: Date().addingTimeInterval(-7 * 24 * 3600),
                icon: "1.circle.fill"
            ),
            Milestone(
                title: "Survived March Madness",
                date: Date().addingTimeInterval(-5 * 24 * 3600),
                icon: "trophy.fill"
            ),
            Milestone(
                title: "Week Without Betting",
                date: Date().addingTimeInterval(-2 * 24 * 3600),
                icon: "calendar.circle.fill"
            )
        ]
    }
}

private struct Milestone {
    let title: String
    let date: Date
    let icon: String
}

private struct DayCell: View {
    let date: Date
    let isClean: Bool
    let hadCraving: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text(date, format: .dateTime.weekday(.narrow))
                .font(BFDesignSystem.Typography.labelSmall)
            
            Circle()
                .fill(backgroundColor)
                .frame(width: 32, height: 32)
                .overlay {
                    if hadCraving {
                        Image(systemName: "bolt.fill")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
        }
    }
    
    private var backgroundColor: Color {
        if !isClean {
            return BFDesignSystem.Colors.error
        } else if hadCraving {
            return BFDesignSystem.Colors.warning
        } else {
            return BFDesignSystem.Colors.success
        }
    }
}

private struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(BFDesignSystem.Typography.titleLarge)
                .foregroundColor(color)
            
            Text(title)
                .font(BFDesignSystem.Typography.labelMedium)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    ProgressView()
        .environmentObject(AppState.preview)
}
