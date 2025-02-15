import SwiftUI

public struct BFProgressView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var savingsManager = SavingsManager()
    @State private var selectedTimeframe: Timeframe = .week
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Timeframe Picker
                    Picker("Timeframe", selection: $selectedTimeframe) {
                        ForEach(Timeframe.allCases) { timeframe in
                            Text(timeframe.title).tag(timeframe)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Calendar/Progress View
                    switch selectedTimeframe {
                    case .week:
                        weekView
                    case .month:
                        monthView
                    }
                    
                    // Stats Summary
                    BFCard(style: .elevated) {
                        VStack(spacing: 16) {
                            StatRow(
                                title: "Clean Days",
                                value: "\(cleanDays)",
                                icon: "checkmark.circle.fill",
                                color: BFDesignSystem.Colors.success
                            )
                            
                            Divider()
                            
                            StatRow(
                                title: "Money Saved",
                                value: "$\(Int(savingsInPeriod))",
                                icon: "dollarsign.circle.fill",
                                color: BFDesignSystem.Colors.primary
                            )
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                    
                    // Achievements
                    if !achievements.isEmpty {
                        achievementsSection
                    }
                }
            }
            .navigationTitle("Progress")
        }
    }
    
    private var weekView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
            ForEach(weekDays, id: \.self) { date in
                DayCell(
                    date: date,
                    isClean: appState.wasCleanOn(date),
                    amount: savingsManager.savings(for: date)
                )
            }
        }
        .padding(.horizontal)
    }
    
    private var monthView: some View {
        VStack(spacing: 16) {
            ForEach(monthWeeks, id: \.self) { week in
                HStack(spacing: 8) {
                    ForEach(week, id: \.self) { date in
                        DayCell(
                            date: date,
                            isClean: appState.wasCleanOn(date),
                            amount: savingsManager.savings(for: date)
                        )
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(BFDesignSystem.Typography.titleMedium)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(achievements) { achievement in
                        AchievementCard(achievement: achievement)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Helper Properties
    
    private var weekDays: [Date] {
        let calendar = Calendar.current
        let today = Date()
        return (0..<7).map { days in
            calendar.date(byAdding: .day, value: -days, to: today) ?? today
        }.reversed()
    }
    
    private var monthDays: [Date] {
        let calendar = Calendar.current
        let today = Date()
        return (0..<30).map { days in
            calendar.date(byAdding: .day, value: -days, to: today) ?? today
        }.reversed()
    }
    
    private var monthWeeks: [[Date]] {
        let days = monthDays
        return stride(from: 0, to: days.count, by: 7).map {
            Array(days[days.index(days.startIndex, offsetBy: $0)..<min(days.index(days.startIndex, offsetBy: $0+7), days.endIndex)])
        }
    }
    
    private var cleanDays: Int {
        switch selectedTimeframe {
        case .week:
            return weekDays.filter { appState.wasCleanOn($0) }.count
        case .month:
            return monthDays.filter { appState.wasCleanOn($0) }.count
        }
    }
    
    private var savingsInPeriod: Double {
        switch selectedTimeframe {
        case .week:
            return weekDays.reduce(0) { $0 + savingsManager.savings(for: $1) }
        case .month:
            return monthDays.reduce(0) { $0 + savingsManager.savings(for: $1) }
        }
    }
    
    private var achievements: [Achievement] {
        var result: [Achievement] = []
        
        // Week achievements
        if appState.currentStreak >= 7 {
            result.append(Achievement(
                id: "week",
                title: "First Week",
                description: "Completed first week bet-free",
                icon: "star.fill",
                color: BFDesignSystem.Colors.success
            ))
        }
        
        // Month achievements
        if appState.currentStreak >= 30 {
            result.append(Achievement(
                id: "month",
                title: "First Month",
                description: "Completed first month bet-free",
                icon: "star.circle.fill",
                color: BFDesignSystem.Colors.primary
            ))
        }
        
        // Savings achievements
        if savingsManager.totalSaved >= 1000 {
            result.append(Achievement(
                id: "savings1k",
                title: "$1,000 Saved",
                description: "Saved your first thousand",
                icon: "dollarsign.circle.fill",
                color: BFDesignSystem.Colors.success
            ))
        }
        
        return result
    }
}

// MARK: - Supporting Types

private enum Timeframe: String, CaseIterable, Identifiable {
    case week
    case month
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .week: return "Week"
        case .month: return "Month"
        }
    }
}

private struct StatRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(BFDesignSystem.Typography.bodyMedium)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(BFDesignSystem.Typography.titleMedium)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
        }
    }
}

private struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        BFCard(style: .elevated) {
            VStack(spacing: 8) {
                Image(systemName: achievement.icon)
                    .font(.title)
                    .foregroundColor(achievement.color)
                
                Text(achievement.title)
                    .font(BFDesignSystem.Typography.labelLarge)
                
                Text(achievement.description)
                    .font(BFDesignSystem.Typography.bodySmall)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 120)
            .padding()
        }
    }
}

private struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let color: Color
}

private struct DayCell: View {
    let date: Date
    let isClean: Bool
    let amount: Double
    
    var body: some View {
        VStack(spacing: 4) {
            Text(date, format: .dateTime.weekday(.narrow))
                .font(BFDesignSystem.Typography.labelSmall)
            
            Circle()
                .fill(backgroundColor)
                .frame(width: 32, height: 32)
                .overlay {
                    if amount > 0 {
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
        }
    }
    
    private var backgroundColor: Color {
        if !isClean {
            return BFDesignSystem.Colors.error
        } else {
            return BFDesignSystem.Colors.success
        }
    }
}
