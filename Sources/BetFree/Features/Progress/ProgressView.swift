import SwiftUI
import BetFreeUI

public struct ProgressTrackingView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var savingsManager = SavingsManager()
    @StateObject private var cravingManager = CravingManager()
    @State private var selectedTimeframe: Timeframe = .week
    @State private var isAnimated = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Timeframe Picker
                    Picker("Timeframe", selection: $selectedTimeframe) {
                        ForEach(Timeframe.allCases) { timeframe in
                            Text(timeframe.title).tag(timeframe)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 20)
                    
                    // Progress Overview
                    BFCard(style: .elevated, gradient: LinearGradient(
                        colors: [BFDesignSystem.Colors.primary, BFDesignSystem.Colors.primary.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )) {
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Current Streak")
                                        .font(BFDesignSystem.Typography.titleMedium)
                                        .foregroundColor(.white)
                                    Text("\(appState.currentStreak) days")
                                        .font(BFDesignSystem.Typography.displayLarge)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 48))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            Divider()
                                .background(Color.white.opacity(0.2))
                            
                            HStack {
                                ProgressStat(
                                    title: "Total Saved",
                                    value: "$\(String(format: "%.0f", savingsManager.totalSaved))",
                                    icon: "dollarsign.circle.fill"
                                )
                                
                                Divider()
                                    .background(Color.white.opacity(0.2))
                                
                                ProgressStat(
                                    title: "Urges Resisted",
                                    value: "\(cravingManager.totalCravingsResisted)",
                                    icon: "hand.raised.fill"
                                )
                            }
                        }
                        .padding()
                    }
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 20)
                    
                    // Calendar/Progress View
                    BFCard(style: .elevated) {
                        VStack(spacing: 16) {
                            switch selectedTimeframe {
                            case .week:
                                weekView
                            case .month:
                                monthView
                            }
                        }
                        .padding()
                    }
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 20)
                    
                    // Achievements
                    BFCard(style: .elevated, gradient: LinearGradient(
                        colors: [BFDesignSystem.Colors.success, BFDesignSystem.Colors.success.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Achievements")
                                .font(BFDesignSystem.Typography.titleMedium)
                                .foregroundColor(.white)
                            
                            ForEach(achievements) { achievement in
                                AchievementRow(achievement: achievement)
                            }
                        }
                        .padding()
                    }
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 20)
                }
                .padding(.horizontal)
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Progress")
            .onAppear {
                withAnimation(.spring(response: 0.6)) {
                    isAnimated = true
                }
            }
        }
    }
    
    private var weekView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
            ForEach(weekDays, id: \.self) { date in
                DayCell(date: date)
            }
        }
    }
    
    private var monthView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
            ForEach(monthDays, id: \.self) { date in
                DayCell(date: date)
            }
        }
    }
    
    private var achievements: [Achievement] {
        [
            Achievement(
                title: "First Week Clean",
                description: "Completed 7 days without betting",
                isUnlocked: appState.currentStreak >= 7,
                icon: "star.fill"
            ),
            Achievement(
                title: "Savings Master",
                description: "Saved over $1,000",
                isUnlocked: savingsManager.totalSaved >= 1000,
                icon: "dollarsign.circle.fill"
            ),
            Achievement(
                title: "Strong Willpower",
                description: "Resisted 10 urges",
                isUnlocked: cravingManager.totalCravingsResisted >= 10,
                icon: "hand.raised.fill"
            )
        ]
    }
}

private struct ProgressStat: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
            
            Text(value)
                .font(BFDesignSystem.Typography.titleLarge)
                .foregroundColor(.white)
            
            Text(title)
                .font(BFDesignSystem.Typography.bodySmall)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
    }
}

private struct DayCell: View {
    let date: Date
    @EnvironmentObject private var appState: AppState
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    private var wasClean: Bool {
        appState.wasCleanOn(date)
    }
    
    var body: some View {
        VStack {
            Text(date.formatted(.dateTime.day()))
                .font(BFDesignSystem.Typography.labelMedium)
                .foregroundColor(isToday ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.textSecondary)
            
            Circle()
                .fill(wasClean ? BFDesignSystem.Colors.success : Color.gray.opacity(0.2))
                .frame(width: 32, height: 32)
                .overlay(
                    Group {
                        if wasClean {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                        }
                    }
                )
        }
        .padding(.vertical, 4)
    }
}

private struct AchievementRow: View {
    let achievement: Achievement
    
    var body: some View {
        HStack {
            Image(systemName: achievement.icon)
                .font(.system(size: 24))
                .foregroundColor(achievement.isUnlocked ? .white : .white.opacity(0.5))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(.white)
                
                Text(achievement.description)
                    .font(BFDesignSystem.Typography.bodySmall)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.white)
            }
        }
    }
}

private struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let isUnlocked: Bool
    let icon: String
}

private enum Timeframe: Int, CaseIterable, Identifiable {
    case week
    case month
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .week: return "Week"
        case .month: return "Month"
        }
    }
}

// Helper computed properties
private extension ProgressTrackingView {
    var weekDays: [Date] {
        let calendar = Calendar.current
        let today = Date()
        return (0..<7).map { dayOffset in
            calendar.date(byAdding: .day, value: -dayOffset, to: today)!
        }.reversed()
    }
    
    var monthDays: [Date] {
        let calendar = Calendar.current
        let today = Date()
        return (0..<30).map { dayOffset in
            calendar.date(byAdding: .day, value: -dayOffset, to: today)!
        }.reversed()
    }
}
