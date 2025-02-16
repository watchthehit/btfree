import SwiftUI

public struct ProgressTrackingView: View {
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
                            
                            if savingsInPeriod > 0 {
                                Divider()
                                
                                HStack {
                                    SwiftUI.ProgressView(value: savingsInPeriod, total: dailyLimit)
                                        .progressViewStyle(.linear)
                                        .tint(BFDesignSystem.Colors.success)
                                }
                                .padding(.top, 8)
                            }
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                    
                    // Streak Info
                    BFCard(style: .elevated) {
                        VStack(spacing: 16) {
                            StatRow(
                                title: "Current Streak",
                                value: "\(appState.currentStreak) days",
                                icon: "flame.fill",
                                color: BFDesignSystem.Colors.success
                            )
                            
                            if let nextMilestone = nextStreakMilestone {
                                Divider()
                                
                                StatRow(
                                    title: "Next Milestone",
                                    value: "\(nextMilestone) days",
                                    icon: "flag.fill",
                                    color: BFDesignSystem.Colors.primary
                                )
                            }
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Progress")
        }
    }
    
    private var weekView: some View {
        VStack(spacing: 16) {
            HStack {
                ForEach(weekDays, id: \.self) { date in
                    DayProgressView(
                        date: date,
                        isClean: savingsManager.savings(for: date) > 0,
                        savings: savingsManager.savings(for: date)
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var monthView: some View {
        VStack(spacing: 16) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(monthDays, id: \.self) { date in
                    DayProgressView(
                        date: date,
                        isClean: savingsManager.savings(for: date) > 0,
                        savings: savingsManager.savings(for: date)
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var weekDays: [Date] {
        let calendar = Calendar.current
        let today = Date()
        return (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: -dayOffset, to: today)
        }.reversed()
    }
    
    private var monthDays: [Date] {
        let calendar = Calendar.current
        let today = Date()
        return (0..<30).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: -dayOffset, to: today)
        }.reversed()
    }
    
    private var cleanDays: Int {
        switch selectedTimeframe {
        case .week:
            return weekDays.filter { savingsManager.savings(for: $0) > 0 }.count
        case .month:
            return monthDays.filter { savingsManager.savings(for: $0) > 0 }.count
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
    
    private var nextStreakMilestone: Int? {
        let streak = appState.currentStreak
        let milestones = [7, 14, 30, 60, 90, 180, 365]
        return milestones.first { $0 > streak }
    }
    
    private var dailyLimit: Double {
        appState.dailyLimit
    }
}

// MARK: - Supporting Types

private enum Timeframe: String, CaseIterable, Identifiable {
    case week
    case month
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .week:
            return "Week"
        case .month:
            return "Month"
        }
    }
}

private struct DayProgressView: View {
    let date: Date
    let isClean: Bool
    let savings: Double
    
    private var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    private var dayOfMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(dayOfWeek)
                .font(BFDesignSystem.Typography.labelSmall)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
            
            Circle()
                .fill(isClean ? BFDesignSystem.Colors.success : Color.gray.opacity(0.2))
                .frame(width: 32, height: 32)
                .overlay {
                    Text(dayOfMonth)
                        .font(BFDesignSystem.Typography.labelMedium)
                        .foregroundColor(isClean ? .white : BFDesignSystem.Colors.textSecondary)
                }
            
            if savings > 0 {
                Text("$\(Int(savings))")
                    .font(BFDesignSystem.Typography.labelSmall)
                    .foregroundColor(BFDesignSystem.Colors.success)
            } else {
                Text("-")
                    .font(BFDesignSystem.Typography.labelSmall)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
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
                .foregroundColor(color)
                .font(.title2)
            
            Text(title)
                .font(BFDesignSystem.Typography.bodyMedium)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(BFDesignSystem.Typography.bodyLarge)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
        }
    }
}
