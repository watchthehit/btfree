import SwiftUI
import Charts

/// Enum defining the time range for progress data
enum TimeRange: String, CaseIterable, Identifiable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
    case all = "All Time"
    
    var id: String { self.rawValue }
}

/// A view that displays detailed analytics and progress tracking for the user's journey
struct ProgressTrackingView: View {
    @StateObject private var viewModel = ProgressViewModel()
    @State private var selectedTimeRange: TimeRange = .week
    @State private var showingGoalSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Top summary cards
                VStack(spacing: 16) {
                    HStack {
                        Text("Your Progress")
                            .font(BFTypography.title())
                            .foregroundColor(BFColors.textPrimary)
                        
                        Spacer()
                        
                        TimeRangeMenu(
                            selectedTimeRange: $selectedTimeRange,
                            onRangeSelected: { range in
                                viewModel.loadData(for: range)
                            }
                        )
                    }
                    .padding(.horizontal)
                    
                    // Summary Cards
                    StatCardsSection(viewModel: viewModel)
                }
                
                // Charts section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Betting Urges Over Time")
                        .font(BFTypography.headline())
                        .foregroundColor(BFColors.textPrimary)
                        .padding(.horizontal)
                    
                    // Urges chart
                    UrgesChartView(
                        chartData: viewModel.chartData, 
                        showGoalLine: viewModel.showGoalLine, 
                        dailyUrgeGoal: viewModel.dailyUrgeGoal
                    )
                    .frame(height: 200)
                    .padding()
                    .background(BFColors.cardBackground)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // Weekly comparison
                VStack(alignment: .leading, spacing: 16) {
                    Text("Week by Week Comparison")
                        .font(BFTypography.headline())
                        .foregroundColor(BFColors.textPrimary)
                        .padding(.horizontal)
                    
                    // Week comparison chart
                    WeeklyComparisonChart(weeklyData: viewModel.weeklyData)
                    .frame(height: 200)
                    .padding()
                    .background(BFColors.cardBackground)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // Achievement section
                AchievementsSection(achievements: viewModel.achievements)
                
                // Update goal button
                Button {
                    showingGoalSheet = true
                } label: {
                    HStack {
                        Image(systemName: "target")
                            .font(.system(size: 18))
                        Text("Update Your Goals")
                            .font(BFTypography.button())
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [BFColors.primary, BFColors.primary.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .cornerRadius(12)
                    )
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
            .padding(.top)
        }
        .navigationTitle("Progress")
        .background(BFColors.background.ignoresSafeArea())
        .onAppear {
            viewModel.loadData(for: selectedTimeRange)
        }
        .sheet(isPresented: $showingGoalSheet) {
            GoalSettingsSheet(
                currentGoal: viewModel.dailyUrgeGoal,
                onSave: { newGoal in
                    viewModel.updateGoal(newGoal)
                }
            )
        }
    }
}

// MARK: - Support Components

/// A card that displays a statistic with trend information
struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    let trend: TrendDirection
    let trendValue: String?
    
    enum TrendDirection {
        case positive, negative, neutral
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
                
                Text(title)
                    .font(BFTypography.caption())
                    .foregroundColor(BFColors.textSecondary)
                
                Spacer()
            }
            
            Text(value)
                .font(BFTypography.title())
                .foregroundColor(BFColors.textPrimary)
            
            HStack {
                Text(unit)
                    .font(BFTypography.caption())
                    .foregroundColor(BFColors.textSecondary)
                
                Spacer()
                
                if let trendValue = trendValue {
                    HStack(spacing: 2) {
                        Image(systemName: trendDirection)
                            .font(.system(size: 10))
                        
                        Text(trendValue)
                            .font(BFTypography.caption(12))
                    }
                    .foregroundColor(trendColor)
                }
            }
        }
        .padding(12)
        .background(BFColors.cardBackground)
        .cornerRadius(12)
        .frame(maxWidth: .infinity)
    }
    
    var trendDirection: String {
        switch trend {
        case .positive:
            return "arrow.up"
        case .negative:
            return "arrow.down"
        case .neutral:
            return "arrow.right"
        }
    }
    
    var trendColor: Color {
        switch trend {
        case .positive:
            return .green
        case .negative:
            return .red
        case .neutral:
            return BFColors.textSecondary
        }
    }
}

/// A card that displays an achievement
struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 12) {
            // Badge/Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [achievement.color, achievement.color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            .padding(.top, 12)
            
            // Title and description
            VStack(spacing: 4) {
                Text(achievement.title)
                    .font(BFTypography.headline(16))
                    .foregroundColor(BFColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(achievement.description)
                    .font(BFTypography.caption())
                    .foregroundColor(BFColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 8)
            
            // Unlocked date if available
            if let date = achievement.unlockedDate {
                Text("Unlocked \(date.formatted(.dateTime.month().day()))")
                    .font(BFTypography.caption(12))
                    .foregroundColor(BFColors.textSecondary)
            } else {
                // Progress indicator if not unlocked
                VStack(spacing: 4) {
                    ProgressView(value: achievement.progress, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: achievement.color))
                    
                    Text("\(Int(achievement.progress * 100))% Complete")
                        .font(BFTypography.caption(12))
                        .foregroundColor(BFColors.textSecondary)
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.bottom, 12)
        .frame(width: 140)
        .background(BFColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [
                            achievement.color.opacity(0.3),
                            achievement.color.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
}

/// A sheet that allows the user to update their goals
struct GoalSettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedGoal: Int
    private let onSave: (Int) -> Void
    
    init(currentGoal: Int, onSave: @escaping (Int) -> Void) {
        _selectedGoal = State(initialValue: currentGoal)
        self.onSave = onSave
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Set Your Daily Urge Goal")
                    .font(BFTypography.title())
                    .foregroundColor(BFColors.textPrimary)
                
                Text("How many urges do you want to limit yourself to each day?")
                    .font(BFTypography.body())
                    .foregroundColor(BFColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Goal picker
            VStack(spacing: 16) {
                Text("\(selectedGoal)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(BFColors.accent)
                
                Slider(value: Binding(
                    get: { Double(selectedGoal) },
                    set: { selectedGoal = Int($0) }
                ), in: 0...20, step: 1)
                .tint(BFColors.accent)
                .padding(.horizontal)
                
                HStack {
                    Text("No urges")
                        .font(BFTypography.caption())
                        .foregroundColor(BFColors.textSecondary)
                    
                    Spacer()
                    
                    Text("20 urges")
                        .font(BFTypography.caption())
                        .foregroundColor(BFColors.textSecondary)
                }
                .padding(.horizontal)
            }
            .padding()
            .background(BFColors.cardBackground)
            .cornerRadius(16)
            .padding(.horizontal)
            
            // Recommendations
            VStack(alignment: .leading, spacing: 8) {
                Text("Recommendations:")
                    .font(BFTypography.headline())
                    .foregroundColor(BFColors.textPrimary)
                
                Text("• Start with a realistic goal based on your current average")
                    .font(BFTypography.body())
                    .foregroundColor(BFColors.textSecondary)
                
                Text("• Gradually decrease your limit as you build resistance")
                    .font(BFTypography.body())
                    .foregroundColor(BFColors.textSecondary)
                
                Text("• Consider your triggers and time of day when setting goals")
                    .font(BFTypography.body())
                    .foregroundColor(BFColors.textSecondary)
            }
            .padding()
            .background(BFColors.cardBackground)
            .cornerRadius(16)
            .padding(.horizontal)
            
            Spacer()
            
            // Save button
            Button {
                onSave(selectedGoal)
                dismiss()
            } label: {
                Text("Save Goal")
                    .font(BFTypography.button())
                    .foregroundColor(.white)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(
                        BFColors.accent
                            .cornerRadius(12)
                    )
            }
            .padding(.horizontal)
        }
        .padding(.top, 40)
        .padding(.bottom, 30)
        .background(BFColors.background.ignoresSafeArea())
    }
}

/// A menu for selecting time ranges
struct TimeRangeMenu: View {
    @Binding var selectedTimeRange: TimeRange
    let onRangeSelected: (TimeRange) -> Void
    
    var body: some View {
        Menu {
            ForEach(TimeRange.allCases) { range in
                Button(range.rawValue) {
                    selectedTimeRange = range
                    onRangeSelected(range)
                }
            }
        } label: {
            HStack {
                Text(selectedTimeRange.rawValue)
                    .font(BFTypography.caption())
                    .foregroundColor(BFColors.primary)
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 12))
                    .foregroundColor(BFColors.primary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(BFColors.primary.opacity(0.15))
            )
        }
    }
}

/// A view for displaying stat cards
struct StatCardsSection: View {
    let viewModel: ProgressViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            // Primary stats
            HStack(spacing: 12) {
                StatCard(
                    title: "Current Streak",
                    value: viewModel.currentStreak.formatted(),
                    unit: "days",
                    icon: "flame.fill",
                    color: BFColors.accent,
                    trend: .positive,
                    trendValue: "+\(viewModel.streakChange)%"
                )
                
                StatCard(
                    title: "Money Saved",
                    value: "$\(viewModel.moneySaved)",
                    unit: "estimated",
                    icon: "dollarsign.circle.fill",
                    color: .green,
                    trend: .positive,
                    trendValue: "+\(viewModel.moneySavedChange)%"
                )
            }
            
            // Secondary stats
            HStack(spacing: 12) {
                StatCard(
                    title: "Urges Resisted",
                    value: viewModel.urgesResisted.formatted(),
                    unit: "total",
                    icon: "hand.raised.fill",
                    color: .blue,
                    trend: viewModel.urgesChange > 0 ? .negative : .positive,
                    trendValue: viewModel.urgesChange > 0 ? "+\(viewModel.urgesChange)%" : "-\(abs(viewModel.urgesChange))%"
                )
                
                StatCard(
                    title: "Goal Progress",
                    value: "\(viewModel.goalProgress)%",
                    unit: "complete",
                    icon: "target",
                    color: .purple,
                    trend: .neutral,
                    trendValue: nil
                )
            }
        }
        .padding(.horizontal)
    }
}

/// A view that displays the urges chart
struct UrgesChartView: View {
    let chartData: [ChartDataPoint]
    let showGoalLine: Bool
    let dailyUrgeGoal: Int
    
    var body: some View {
        Chart {
            ForEach(chartData) { dataPoint in
                AreaMark(
                    x: .value("Date", dataPoint.date),
                    y: .value("Urges", dataPoint.urges)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [BFColors.accent, BFColors.accent.opacity(0.3)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
                
                LineMark(
                    x: .value("Date", dataPoint.date),
                    y: .value("Urges", dataPoint.urges)
                )
                .foregroundStyle(BFColors.accent)
                .interpolationMethod(.catmullRom)
                
                PointMark(
                    x: .value("Date", dataPoint.date),
                    y: .value("Urges", dataPoint.urges)
                )
                .foregroundStyle(BFColors.textPrimary)
                .symbolSize(30)
            }
            
            if showGoalLine {
                RuleMark(
                    y: .value("Goal", dailyUrgeGoal)
                )
                .foregroundStyle(Color.red.opacity(0.7))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                .annotation(position: .trailing) {
                    Text("Goal")
                        .font(BFTypography.caption(12))
                        .foregroundColor(Color.red.opacity(0.7))
                }
            }
        }
        .chartXAxis {
            // ... existing code ...
        }
        .tint(BFColors.accent)
    }
}

/// A view that displays the weekly comparison chart
struct WeeklyComparisonChart: View {
    let weeklyData: [WeeklyDataPoint]
    
    var body: some View {
        Chart {
            ForEach(weeklyData) { dataPoint in
                BarMark(
                    x: .value("Day", dataPoint.day),
                    y: .value("Value", dataPoint.thisWeek)
                )
                .foregroundStyle(BFColors.accent)
                .position(by: .value("Week", "This Week"))
                .annotation(position: .top) {
                    if dataPoint.thisWeek > 0 {
                        Text("\(dataPoint.thisWeek)")
                            .font(BFTypography.caption(10))
                            .foregroundColor(BFColors.textSecondary)
                    }
                }
                
                BarMark(
                    x: .value("Day", dataPoint.day),
                    y: .value("Value", dataPoint.lastWeek)
                )
                .foregroundStyle(BFColors.primary.opacity(0.5))
                .position(by: .value("Week", "Last Week"))
                .annotation(position: .top) {
                    if dataPoint.lastWeek > 0 {
                        Text("\(dataPoint.lastWeek)")
                            .font(BFTypography.caption(10))
                            .foregroundColor(BFColors.textSecondary)
                    }
                }
            }
        }
    }
}

/// A view that displays the achievements section
struct AchievementsSection: View {
    let achievements: [Achievement]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Achievements")
                .font(BFTypography.headline())
                .foregroundColor(BFColors.textPrimary)
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
}

// MARK: - View Model

/// View model for the progress view
class ProgressViewModel: ObservableObject {
    @Published var currentStreak: Int = 0
    @Published var streakChange: Int = 0
    @Published var moneySaved: Int = 0
    @Published var moneySavedChange: Int = 0
    @Published var urgesResisted: Int = 0
    @Published var urgesChange: Int = 0
    @Published var goalProgress: Int = 0
    @Published var dailyUrgeGoal: Int = 5
    @Published var showGoalLine: Bool = true
    @Published var chartData: [ChartDataPoint] = []
    @Published var weeklyData: [WeeklyDataPoint] = []
    @Published var achievements: [Achievement] = []
    
    func loadData(for timeRange: TimeRange) {
        // In a real app, this would load data from persistence
        // For this demo, we'll use sample data
        loadSampleData(for: timeRange)
    }
    
    func updateGoal(_ newGoal: Int) {
        dailyUrgeGoal = newGoal
        // In a real app, save this to UserDefaults or your backend
        UserDefaults.standard.set(newGoal, forKey: "dailyUrgeGoal")
        // Recalculate goal progress with new goal
        calculateGoalProgress()
    }
    
    private func loadSampleData(for timeRange: TimeRange) {
        // Sample data generation based on time range
        switch timeRange {
        case .week:
            generateWeekData()
        case .month:
            generateMonthData()
        case .year:
            generateYearData()
        case .all:
            generateAllTimeData()
        }
        
        // Generate weekly comparison data
        generateWeeklyComparisonData()
        
        // Generate achievements
        generateAchievements()
        
        // Calculate goal progress
        calculateGoalProgress()
    }
    
    private func generateWeekData() {
        // Sample week data
        currentStreak = 3
        streakChange = 50
        moneySaved = 120
        moneySavedChange = 30
        urgesResisted = 18
        urgesChange = -15
        
        // Generate chart data for the week
        let now = Date()
        var dateComponents = DateComponents()
        chartData = (0..<7).map { day in
            dateComponents.day = -6 + day
            let date = Calendar.current.date(byAdding: dateComponents, to: now) ?? now
            let urgeCount = [4, 3, 5, 3, 2, 1, 0][day] // Decreasing trend
            return ChartDataPoint(date: date, urges: urgeCount)
        }
    }
    
    private func generateMonthData() {
        // Sample month data
        currentStreak = 3
        streakChange = 200
        moneySaved = 480
        moneySavedChange = 120
        urgesResisted = 70
        urgesChange = -40
        
        // Generate chart data for the month
        let now = Date()
        var dateComponents = DateComponents()
        chartData = (0..<30).map { day in
            dateComponents.day = -29 + day
            let date = Calendar.current.date(byAdding: dateComponents, to: now) ?? now
            // More variance for a month view, but still with an improving trend
            let variance = Int.random(in: 0...3)
            let baseTrend = 8 - (day / 5)
            let urgeCount = max(0, min(baseTrend + variance, 10))
            return ChartDataPoint(date: date, urges: urgeCount)
        }
    }
    
    private func generateYearData() {
        // Sample year data
        currentStreak = 3
        streakChange = 50
        moneySaved = 5800
        moneySavedChange = 400
        urgesResisted = 850
        urgesChange = -60
        
        // Generate chart data for the year (simplified to 12 points)
        let now = Date()
        var dateComponents = DateComponents()
        chartData = (0..<12).map { month in
            dateComponents.month = -11 + month
            let date = Calendar.current.date(byAdding: dateComponents, to: now) ?? now
            // More variance for a year view with seasonal patterns
            let seasonalFactor = abs(6 - month) / 2 // Higher in middle of year
            let improvementFactor = month / 2 // Gradual improvement
            let urgeCount = max(0, 8 + seasonalFactor - improvementFactor + Int.random(in: 0...2))
            return ChartDataPoint(date: date, urges: urgeCount)
        }
    }
    
    private func generateAllTimeData() {
        // Sample all time data
        currentStreak = 3
        streakChange = 100
        moneySaved = 12000
        moneySavedChange = 1100
        urgesResisted = 1240
        urgesChange = -75
        
        // All time data uses same structure as year but with different values
        let now = Date()
        var dateComponents = DateComponents()
        chartData = (0..<24).map { month in
            dateComponents.month = -23 + month
            let date = Calendar.current.date(byAdding: dateComponents, to: now) ?? now
            let startValue = 12
            let improvementFactor = month / 3
            let urgeCount = max(0, startValue - improvementFactor + Int.random(in: 0...3))
            return ChartDataPoint(date: date, urges: urgeCount)
        }
    }
    
    private func generateWeeklyComparisonData() {
        // Generate data comparing this week to last week
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        
        // Today's index in the week
        let today = Calendar.current.component(.weekday, from: Date())
        let adjustedToday = today == 1 ? 6 : today - 2 // Convert to Mon=0, Sun=6
        
        weeklyData = (0..<7).map { index in
            // This week data is only available up to today
            let thisWeekValue = index <= adjustedToday ? [4, 3, 5, 2, 0, 0, 0][index] : 0
            
            // Last week data is available for all days
            let lastWeekValue = [5, 6, 5, 4, 3, 5, 4][index]
            
            return WeeklyDataPoint(
                day: days[index],
                thisWeek: thisWeekValue,
                lastWeek: lastWeekValue
            )
        }
    }
    
    private func generateAchievements() {
        achievements = [
            Achievement(
                id: "first_day",
                title: "First Day Clean",
                description: "Complete 24 hours without gambling",
                icon: "1.circle.fill",
                color: .blue,
                unlockedDate: Calendar.current.date(byAdding: .day, value: -5, to: Date())
            ),
            Achievement(
                id: "three_days",
                title: "Three Day Streak",
                description: "Complete 3 days without gambling",
                icon: "3.circle.fill",
                color: .green,
                unlockedDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())
            ),
            Achievement(
                id: "week_streak",
                title: "Week Warrior",
                description: "Complete 7 days without gambling",
                icon: "7.circle.fill",
                color: .purple,
                unlockedDate: nil,
                progress: 3.0/7.0
            ),
            Achievement(
                id: "month_streak",
                title: "Monthly Master",
                description: "Complete 30 days without gambling",
                icon: "30.circle.fill",
                color: .orange,
                unlockedDate: nil,
                progress: 0.1
            ),
            Achievement(
                id: "money_saved_100",
                title: "Money Saver",
                description: "Save $100 by not gambling",
                icon: "dollarsign.circle.fill",
                color: .green,
                unlockedDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())
            ),
            Achievement(
                id: "urges_logged_10",
                title: "Awareness Pro",
                description: "Log 10 urges in the app",
                icon: "hand.raised.fill",
                color: .blue,
                unlockedDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())
            )
        ]
    }
    
    private func calculateGoalProgress() {
        // Calculate progress towards goal based on latest data
        if let latestUrges = chartData.last?.urges {
            goalProgress = min(100, Int((1.0 - (Double(latestUrges) / Double(dailyUrgeGoal))) * 100))
            if goalProgress < 0 {
                goalProgress = 0
            }
        } else {
            goalProgress = 0
        }
    }
}

// MARK: - Data Models

/// Data point for charts
struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let urges: Int
}

/// Data point for weekly comparison chart
struct WeeklyDataPoint: Identifiable {
    let id = UUID()
    let day: String
    let thisWeek: Int
    let lastWeek: Int
}

/// Model for achievement data
struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let color: Color
    let unlockedDate: Date?
    var progress: Double = 1.0
    
    init(id: String, title: String, description: String, icon: String, color: Color, unlockedDate: Date? = nil, progress: Double = 1.0) {
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
        self.color = color
        self.unlockedDate = unlockedDate
        self.progress = unlockedDate != nil ? 1.0 : progress
    }
}

#Preview {
    ProgressTrackingView()
        .preferredColorScheme(.dark)
} 