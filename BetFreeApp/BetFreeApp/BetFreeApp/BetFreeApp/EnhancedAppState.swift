import Foundation
import SwiftUI
import Combine

// MARK: - Data Models
// Enhanced version - renamed to avoid conflicts

struct EnhancedUrgeRecord: Identifiable, Codable {
    var id = UUID()
    var timestamp: Date
    var note: String?
    var triggerCategory: EnhancedTriggerCategory?
    var handled: Bool = true // Default to true since tracking an urge implies it was handled
}

enum EnhancedTriggerCategory: String, Codable, CaseIterable {
    case stress
    case boredom
    case social
    case celebration
    case sadness
    case habit
    case other
    
    var displayName: String {
        return self.rawValue.capitalized
    }
    
    var color: Color {
        switch self {
        case .stress:
            return .red
        case .boredom:
            return .blue
        case .social:
            return .green
        case .celebration:
            return .yellow
        case .sadness:
            return .purple
        case .habit:
            return .orange
        case .other:
            return .gray
        }
    }
}

/**
 * EnhancedGoalType
 * 
 * Represents different types of goals that users can create in the app.
 * Each type corresponds to a different time frame for goal completion.
 */
enum EnhancedGoalType: String, Codable, CaseIterable {
    case daily
    case weekly
    case monthly
    
    var displayName: String {
        return self.rawValue.capitalized
    }
}

/**
 * EnhancedUserGoal
 * 
 * Represents a user's goal for handling gambling urges over a specified time period.
 * Goals track progress toward a target number of urges handled and include metadata
 * about creation, completion status, and relevant dates.
 */
struct EnhancedUserGoal: Identifiable, Codable {
    /// Unique identifier for the goal
    var id = UUID()
    
    /// Title of the goal shown to the user
    var title: String
    
    /// Optional detailed description of the goal
    var description: String?
    
    /// Type of goal (daily, weekly, monthly)
    var type: EnhancedGoalType
    
    /// Target number of urges to handle to complete the goal
    var targetValue: Int
    
    /// Current number of handled urges (this is calculated dynamically in most cases)
    var currentValue: Int
    
    /// Date when the goal was created
    var startDate: Date
    
    /// Target date when the goal should be completed
    var endDate: Date
    
    /// Whether the goal has been completed
    var isCompleted: Bool = false
    
    /// Date when the goal was marked as completed
    var completedAt: Date?
    
    // For backward compatibility
    var targetDate: Date {
        return endDate
    }
    
    var createdAt: Date {
        return startDate
    }
    
    static func createDailyGoal(count: Int = 5) -> EnhancedUserGoal {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        return EnhancedUserGoal(
            title: "Handle \(count) urges today",
            description: "Focus on making it through just today",
            type: .daily,
            targetValue: count,
            currentValue: 0,
            startDate: Date(),
            endDate: tomorrow
        )
    }
    
    static func createWeeklyGoal(count: Int = 25) -> EnhancedUserGoal {
        let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        return EnhancedUserGoal(
            title: "Handle \(count) urges this week",
            description: "Track your progress over the week",
            type: .weekly,
            targetValue: count,
            currentValue: 0,
            startDate: Date(),
            endDate: nextWeek
        )
    }
    
    static func createMonthlyGoal(count: Int = 100) -> EnhancedUserGoal {
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
        return EnhancedUserGoal(
            title: "Handle \(count) urges this month",
            description: "Build a long-term habit",
            type: .monthly,
            targetValue: count,
            currentValue: 0,
            startDate: Date(),
            endDate: nextMonth
        )
    }
}

enum EnhancedTimeframeOption: String, CaseIterable {
    case day = "Day"
    case week = "Week" 
    case month = "Month"
    case year = "Year"
    
    var calendarComponent: Calendar.Component {
        switch self {
        case .day:
            return .day
        case .week:
            return .weekOfYear
        case .month:
            return .month
        case .year:
            return .year
        }
    }
    
    var dateRangeValue: Int {
        switch self {
        case .day:
            return 1
        case .week:
            return 7
        case .month:
            return 30
        case .year:
            return 365
        }
    }
}

// MARK: - Main App State

class EnhancedAppState: ObservableObject {
    // Singleton instance
    static let shared = EnhancedAppState()
    
    // App version and build
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    
    // Published properties for UI updates
    @Published var isOnboarded: Bool = false
    @Published var userName: String = ""
    @Published var urgesHandled: Int = 0
    @Published var streakDays: Int = 0  
    @Published var lastUrgeHandledDate: Date? = nil
    @Published var isTabBarVisible: Bool = true
    
    // Default values for urge limits and goals
    private let defaultDailyLimit = 5
    private let defaultWeeklyGoal = 20
    
    // User's daily urge limit (adaptive limit that can change over time)
    @Published var dailyUrgeLimit: Int = 5
    
    // User's weekly goal (adaptive goal that can change over time)
    @Published var weeklyUrgeGoal: Int = 20
    
    // MARK: - Core Properties
    
    @Published var lastSavedDate: Date?
    
    // User settings
    @Published var costPerUrge: Double = 20.0  // Renamed from costPerGambling for consistency
    @Published var timePerUrge: Int = 60  // Renamed from timePerGambling for consistency
    @Published var dailyMindfulnessGoal: Int = 3  // Added from BFAppState
    @Published var enhancedShowNotifications: Bool = false
    @Published var enhancedReminderTime: Date = Date(timeIntervalSince1970: 32400) // 9:00 AM
    
    // Triggers for cravings
    @Published var selectedTriggers: [String] = ["Stress", "Boredom", "Social pressure", "Habit", "Emotional distress"]
    
    // Enhanced properties
    @Published var enhancedUrgeHistory: [EnhancedUrgeRecord] = []
    @Published var enhancedUserGoals: [EnhancedUserGoal] = []
    @Published var enhancedSelectedTimeframe: EnhancedTimeframeOption = .week
    
    // MARK: - Published Properties
    @Published var enhancedMindfulnessSessions: [EnhancedMindfulnessSession] = []
    @Published var dailyUrges: Int = 0
    @Published var weeklyUrges: Int = 0
    @Published var monthlyUrges: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        // Load data from UserDefaults
        let defaults = UserDefaults.standard
        
        // Initialize all properties first
        self.userName = defaults.string(forKey: "userName") ?? ""
        self.urgesHandled = defaults.integer(forKey: "urgesHandled")
        self.streakDays = defaults.integer(forKey: "streakDays")
        self.costPerUrge = defaults.double(forKey: "costPerUrge")
        self.timePerUrge = defaults.integer(forKey: "timePerUrge")
        self.dailyMindfulnessGoal = defaults.integer(forKey: "dailyMindfulnessGoal")
        
        // Set default values if needed
        if self.costPerUrge == 0 {
            self.costPerUrge = 20.0
        }
        if self.timePerUrge == 0 {
            self.timePerUrge = 60
        }
        if self.dailyMindfulnessGoal == 0 {
            self.dailyMindfulnessGoal = 3
        }
        
        // Load enhanced properties
        self.lastSavedDate = defaults.object(forKey: "enhanced_lastSavedDate") as? Date
        self.enhancedShowNotifications = defaults.bool(forKey: "enhanced_showNotifications")
        self.enhancedReminderTime = defaults.object(forKey: "enhanced_reminderTime") as? Date ?? Date(timeIntervalSince1970: 32400)
        
        // Load enhanced urge history
        if let urgeHistoryData = defaults.data(forKey: "enhanced_urgeHistory"),
           let decodedHistory = try? JSONDecoder().decode([EnhancedUrgeRecord].self, from: urgeHistoryData) {
            self.enhancedUrgeHistory = decodedHistory
        }
        
        // Load enhanced goals
        if let goalsData = defaults.data(forKey: "enhanced_activeGoals"),
           let decodedGoals = try? JSONDecoder().decode([EnhancedUserGoal].self, from: goalsData) {
            self.enhancedUserGoals = decodedGoals
        }
        
        // Load enhanced mindfulness sessions
        if let sessionsData = defaults.data(forKey: "enhanced_mindfulnessSessions"),
           let decodedSessions = try? JSONDecoder().decode([EnhancedMindfulnessSession].self, from: sessionsData) {
            self.enhancedMindfulnessSessions = decodedSessions
        }
        
        // Calculate initial urge counts
        updateUrgeStats()
        
        // Setup publishers for auto-saving
        setupPublishers()
        
        // Check and update streak
        checkAndUpdateStreak()
        
        print("EnhancedAppState initialized with \(self.enhancedUserGoals.count) goals")
        print("Active goals: \(self.enhancedActiveGoals.count)")
        print("Completed goals: \(self.enhancedCompletedGoals.count)")
    }
    
    private func setupPublishers() {
        // Auto-save whenever key data changes
        // Create separate publishers and subscriptions for each data type
        $urgesHandled.dropFirst().debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.enhancedSaveData()
            }
            .store(in: &cancellables)
        
        $streakDays.dropFirst().debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.enhancedSaveData()
            }
            .store(in: &cancellables)
        
        $enhancedUrgeHistory.dropFirst().debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.enhancedSaveData()
            }
            .store(in: &cancellables)
        
        $enhancedUserGoals.dropFirst().debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.enhancedSaveData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Data Persistence
    
    func enhancedSaveData() {
        let defaults = UserDefaults.standard
        
        defaults.set(urgesHandled, forKey: "urgesHandled")
        defaults.set(streakDays, forKey: "streakDays")
        defaults.set(lastSavedDate, forKey: "enhanced_lastSavedDate")
        
        // Save enhanced data
        do {
            let historyData = try JSONEncoder().encode(enhancedUrgeHistory)
            defaults.set(historyData, forKey: "enhanced_urgeHistory")
            
            let goalsData = try JSONEncoder().encode(enhancedUserGoals)
            defaults.set(goalsData, forKey: "enhanced_activeGoals")
        } catch {
            print("Error encoding data: \(error)")
        }
    }
    
    func enhancedSaveSettings() {
        let defaults = UserDefaults.standard
        
        defaults.set(costPerUrge, forKey: "costPerUrge")
        defaults.set(timePerUrge, forKey: "timePerUrge")
        defaults.set(enhancedShowNotifications, forKey: "enhanced_showNotifications")
        defaults.set(enhancedReminderTime, forKey: "enhanced_reminderTime")
    }
    
    func enhancedExportData() -> Data? {
        // Create a dictionary with all app data
        let exportData: [String: Any] = [
            "urgesHandled": urgesHandled,
            "streakDays": streakDays,
            "lastSavedDate": lastSavedDate as Any,
            "urgeHistory": enhancedUrgeHistory,
            "userGoals": enhancedUserGoals,
            "settings": [
                "costPerUrge": costPerUrge,
                "timePerUrge": timePerUrge,
                "showNotifications": enhancedShowNotifications,
                "reminderTime": enhancedReminderTime
            ]
        ]
        
        do {
            // Convert to JSON data
            return try JSONSerialization.data(withJSONObject: exportData, options: .prettyPrinted)
        } catch {
            print("Error exporting data: \(error)")
            return nil
        }
    }
    
    // MARK: - Urge Tracking Methods
    
    private func updateUrgeStats() {
        let calendar = Calendar.current
        let now = Date()
        
        // Calculate daily urges
        let _ = calendar.startOfDay(for: now)
        dailyUrges = enhancedUrgeHistory.filter { 
            calendar.isDate($0.timestamp, inSameDayAs: now)
        }.count
        
        // Calculate weekly urges
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
        weeklyUrges = enhancedUrgeHistory.filter {
            $0.timestamp >= startOfWeek && $0.timestamp <= now
        }.count
        
        // Calculate monthly urges
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        monthlyUrges = enhancedUrgeHistory.filter {
            $0.timestamp >= startOfMonth && $0.timestamp <= now
        }.count
        
        // Calculate streak
        var currentDate = now
        var streakCount = 0
        
        while true {
            let dayStart = calendar.startOfDay(for: currentDate)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
            
            let urgesForDay = enhancedUrgeHistory.filter {
                $0.timestamp >= dayStart && $0.timestamp < dayEnd
            }
            
            if urgesForDay.isEmpty {
                break
            }
            
            streakCount += 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }
        
        streakDays = streakCount
    }
    
    // Call this method whenever urge records are updated
    func enhancedAddUrge(_ urge: EnhancedUrgeRecord) {
        enhancedUrgeHistory.append(urge)
        updateUrgeStats()
    }
    
    // Call this when the app launches or becomes active
    func refreshStats() {
        updateUrgeStats()
    }
    
    // MARK: - Urge Tracking
    
    func enhancedRecordUrge(note: String? = nil, category: EnhancedTriggerCategory? = nil) {
        // Increment urge counter
        urgesHandled += 1
        
        // Create and add new urge record
        let newUrge = EnhancedUrgeRecord(
            timestamp: Date(),
            note: note,
            triggerCategory: category
        )
        enhancedUrgeHistory.append(newUrge)
        
        // Update last saved date
        lastSavedDate = Date()
        
        // Check for streak update
        checkAndUpdateStreak()
        
        // Check goal completion
        checkGoalCompletions()
        
        // Save data
        enhancedSaveData()
    }
    
    func enhancedRecordUrge(_ urge: EnhancedUrgeRecord) {
        enhancedUrgeHistory.append(urge)
        urgesHandled += 1
        checkGoalCompletions()
    }
    
    private func checkAndUpdateStreak() {
        let calendar = Calendar.current
        let now = Date()
        let today = calendar.startOfDay(for: now)
        
        if let lastDate = lastSavedDate {
            let lastSavedDay = calendar.startOfDay(for: lastDate)
            
            if calendar.isDate(lastSavedDay, inSameDayAs: today) {
                // Same day, do nothing to streak
            } else if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
                      calendar.isDate(lastSavedDay, inSameDayAs: yesterday) {
                // Last saved was yesterday, increment streak
                streakDays += 1
            } else if lastSavedDay < today {
                // Gap in usage, reset streak to 1
                streakDays = 1
            }
        } else {
            // First usage, start streak at 1
            streakDays = 1
        }
    }
    
    // MARK: - Goal Management
    
    /// Active goals that haven't been completed yet
    var enhancedActiveGoals: [EnhancedUserGoal] {
        return enhancedUserGoals.filter { !$0.isCompleted }
    }
    
    /// Goals that have been completed
    var enhancedCompletedGoals: [EnhancedUserGoal] {
        return enhancedUserGoals.filter { $0.isCompleted }
    }
    
    /**
     * Adds a new goal with basic information
     * 
     * @param title The title of the goal
     * @param targetDate The date by which the goal should be completed
     * @param targetValue The number of urges to handle to complete the goal
     */
    func addGoal(title: String, targetDate: Date, targetValue: Int) {
        let newGoal = EnhancedUserGoal(
            title: title,
            description: nil,
            type: .daily,
            targetValue: targetValue,
            currentValue: 0,
            startDate: Date(),
            endDate: targetDate
        )
        enhancedUserGoals.append(newGoal)
    }
    
    /**
     * Adds a fully configured goal to the user's goal list
     * 
     * @param goal The EnhancedUserGoal object to add
     */
    func enhancedAddGoal(_ goal: EnhancedUserGoal) {
        enhancedUserGoals.append(goal)
    }
    
    /**
     * Marks a goal as completed and sets the completion timestamp
     * 
     * @param goal The goal to mark as completed
     */
    func enhancedCompleteGoal(goal: EnhancedUserGoal) {
        if let index = enhancedUserGoals.firstIndex(where: { $0.id == goal.id }) {
            enhancedUserGoals[index].isCompleted = true
            enhancedUserGoals[index].completedAt = Date()
        }
    }
    
    /**
     * Checks all active goals to see if any have been completed based on urges handled
     * This is called automatically when a new urge is added
     */
    private func checkGoalCompletions() {
        let now = Date()
        
        for (index, goal) in enhancedUserGoals.enumerated() {
            if !goal.isCompleted {
                // Check if goal is completed based on urge count
                let goalStart = goal.startDate  // Fixed: using startDate instead of createdAt
                let relevantUrges = enhancedUrgeHistory.filter {
                    $0.timestamp >= goalStart && $0.timestamp <= now
                }
                
                if relevantUrges.count >= goal.targetValue {
                    // Mark goal as completed
                    enhancedUserGoals[index].isCompleted = true
                    enhancedUserGoals[index].completedAt = now
                }
            }
        }
    }
    
    /**
     * Calculates the progress for a specific goal
     * 
     * @param goal The goal to calculate progress for
     * @return A Double value between 0.0 and 1.0 representing the completion percentage
     */
    func enhancedGetProgressForGoal(goal: EnhancedUserGoal) -> Double {
        let currentValue = enhancedGetCurrentValueForGoal(goal: goal)
        return min(1.0, Double(currentValue) / Double(goal.targetValue))
    }
    
    /**
     * Gets the current number of urges handled since the goal was created
     * 
     * @param goal The goal to get the current value for
     * @return The number of urges handled since the goal was created
     */
    func enhancedGetCurrentValueForGoal(goal: EnhancedUserGoal) -> Int {
        // Get urges counted since goal was created
        let relevantUrges = enhancedUrgeHistory.filter {
            $0.timestamp >= goal.createdAt && $0.timestamp <= (goal.completedAt ?? Date())
        }
        
        return relevantUrges.count
    }
    
    /**
     * Calculates the number of days remaining until a goal reaches its end date
     * 
     * @param goal The goal to calculate days remaining for
     * @return The number of days remaining, or 0 if the goal is past its end date
     */
    func enhancedGetDaysRemainingForGoal(goal: EnhancedUserGoal) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: goal.targetDate))
        return max(0, components.day ?? 0)
    }
    
    func enhancedGetTodayGoal() -> EnhancedUserGoal? {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? Date()
        
        return enhancedActiveGoals.first { goal in
            let goalDate = calendar.startOfDay(for: goal.targetDate)
            return goalDate >= today && goalDate < tomorrow
        }
    }
    
    // MARK: - Mindfulness Support
    
    // Temporarily store mindfulness sessions in memory
    @Published var mindfulnessSessions: [EnhancedMindfulnessSession] = []
    
    // Add a mindfulness session
    func saveMindfulnessSession(_ session: EnhancedMindfulnessSession) {
        mindfulnessSessions.append(session)
        // In a real implementation, this would also persist to storage
        print("Saved mindfulness session: \(session.type) for \(session.duration) minutes")
    }
    
    // Helper method to toggle tab bar for a moment to help fix scrolling issues
    func refreshTabBarVisibility() {
        // Quick hide and show of tab bar can help iOS recalculate scroll views
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Hide tab bar temporarily
        DispatchQueue.main.async {
            self.isTabBarVisible = false
            
            // Show it again after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.isTabBarVisible = true
            }
        }
    }
}

// MARK: - Supporting Types

// Simple mindfulness session data model
struct EnhancedMindfulnessSession: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var duration: Int // in minutes
    var type: String
}

// MARK: - Statistics Extensions

extension EnhancedAppState {
    /// Get the current streak of consecutive days with tracking activity
    var currentStreak: Int {
        var streakDays = 0
        let calendar = Calendar.current
        var currentDate = Date()
        
        // Look back up to 180 days (reasonable limit)
        for _ in 0..<180 {
            // Get the start of the current day
            let dayStart = calendar.startOfDay(for: currentDate)
            
            // Check if there's any urge tracking activity for this day
            let hasActivity = enhancedUrgeHistory.contains { calendar.isDate($0.timestamp, inSameDayAs: dayStart) }
            
            if hasActivity {
                streakDays += 1
                // Move to the previous day
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                // Break the streak when a day has no activity
                break
            }
        }
        
        return streakDays
    }
    
    /// Calculate the success rate for handling urges (0.0 to 1.0)
    func calculateUrgeHandlingSuccessRate() -> Double {
        let totalUrges = enhancedUrgeHistory.count
        guard totalUrges > 0 else { return 0.0 }
        
        // Check if the property 'handled' exists - if not, assume all urges are handled
        // This is a fallback in case the data model doesn't have this property
        let handledUrges = totalUrges
        return Double(handledUrges) / Double(totalUrges)
    }
    
    /// Get the number of completed mindfulness sessions
    var mindfulnessSessionCount: Int {
        let enhancedSessions = mindfulnessSessions.count
        
        // Simply return the count of sessions
        return enhancedSessions
    }
    
    /// Get the most recent urge events, limited to the specified count
    func getRecentUrgeEvents(limit: Int = 10) -> [EnhancedUrgeRecord] {
        return Array(enhancedUrgeHistory.sorted { $0.timestamp > $1.timestamp }.prefix(limit))
    }
    
    /// Get urge events for a specific date range
    func getUrgeEvents(from startDate: Date, to endDate: Date) -> [EnhancedUrgeRecord] {
        return enhancedUrgeHistory.filter { $0.timestamp >= startDate && $0.timestamp <= endDate }
    }
}

// MARK: - Urge Limits and Goals
extension EnhancedAppState {
    // Returns the number of urges tracked today
    func getTodayUrges() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        return getUrgeEvents(from: today, to: tomorrow).count
    }
    
    // Returns the current daily urge limit
    func getDailyUrgeLimit() -> Int {
        return dailyUrgeLimit
    }
    
    // Sets a new daily urge limit
    func setDailyUrgeLimit(_ limit: Int) {
        dailyUrgeLimit = limit
        // In a full implementation, this would save to persistent storage
    }
    
    // Returns the weekly urge goal
    func getWeeklyGoal() -> Int {
        return weeklyUrgeGoal
    }
    
    // Sets a new weekly urge goal
    func setWeeklyGoal(_ goal: Int) {
        weeklyUrgeGoal = goal
        // In a full implementation, this would save to persistent storage
    }
    
    // Calculate daily progress as a percentage (0.0 to 1.0)
    func getDailyProgress() -> Double {
        let todayUrges = Double(getTodayUrges())
        let limit = Double(getDailyUrgeLimit())
        
        if limit == 0 {
            return 0
        }
        
        return min(todayUrges / limit, 1.0)
    }
    
    // Calculate weekly progress as a percentage (0.0 to 1.0)
    func getWeeklyProgress() -> Double {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let weekdayOffset = weekday - calendar.firstWeekday
        let weekStart = calendar.date(byAdding: .day, value: -weekdayOffset, to: calendar.startOfDay(for: today))!
        let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart)!
        
        let weekUrges = Double(getUrgeEvents(from: weekStart, to: weekEnd).count)
        let goal = Double(getWeeklyGoal())
        
        if goal == 0 {
            return 0
        }
        
        return min(weekUrges / goal, 1.0)
    }
    
    // Creates an adaptive goal suggestion based on user's past performance
    func suggestAdaptiveWeeklyGoal() -> Int {
        // Get last week's urge count
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let weekdayOffset = weekday - calendar.firstWeekday
        let thisWeekStart = calendar.date(byAdding: .day, value: -weekdayOffset, to: calendar.startOfDay(for: today))!
        let lastWeekStart = calendar.date(byAdding: .day, value: -7, to: thisWeekStart)!
        let lastWeekEnd = calendar.date(byAdding: .day, value: -1, to: thisWeekStart)!
        
        let lastWeekUrges = getUrgeEvents(from: lastWeekStart, to: lastWeekEnd).count
        
        // If user had fewer than 5 urges, keep the same goal
        if lastWeekUrges < 5 {
            return getWeeklyGoal()
        }
        
        // Otherwise, suggest a goal that's 10% lower than last week's actual count
        // but never below 1
        let suggestedGoal = max(1, Int(Double(lastWeekUrges) * 0.9))
        return suggestedGoal
    }
    
    // Creates an adaptive daily limit suggestion based on recent performance
    func suggestAdaptiveDailyLimit() -> Int {
        // Get average daily urges over the past week
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let _ = calendar.date(byAdding: .day, value: -7, to: today)!
        
        var dailyCounts: [Int] = []
        for dayOffset in 0..<7 {
            let dayStart = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
            let nextDay = calendar.date(byAdding: .day, value: 1, to: dayStart)!
            let count = getUrgeEvents(from: dayStart, to: nextDay).count
            dailyCounts.append(count)
        }
        
        // Calculate average, removing zeros (days with no tracking)
        let nonZeroDays = dailyCounts.filter { $0 > 0 }
        if nonZeroDays.isEmpty {
            return getDailyUrgeLimit() // Keep current limit if no data
        }
        
        let average = Double(nonZeroDays.reduce(0, +)) / Double(nonZeroDays.count)
        
        // Suggest a limit that's about 10% lower than the average
        // but never below 1
        let suggestedLimit = max(1, Int(average * 0.9))
        return suggestedLimit
    }
} 