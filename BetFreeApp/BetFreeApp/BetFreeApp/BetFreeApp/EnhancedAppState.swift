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
    // MARK: - Core Properties
    
    @Published var urgesHandled: Int
    @Published var streakDays: Int
    @Published var lastSavedDate: Date?
    
    // User settings
    @Published var costPerGambling: Double
    @Published var timePerGambling: Int
    @Published var enhancedShowNotifications: Bool
    @Published var enhancedReminderTime: Date
    
    // Enhanced properties
    @Published var enhancedUrgeHistory: [EnhancedUrgeRecord]
    @Published var enhancedUserGoals: [EnhancedUserGoal]
    @Published var enhancedSelectedTimeframe: EnhancedTimeframeOption = .week
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        // Load data from UserDefaults
        let defaults = UserDefaults.standard
        
        // Initialize all properties first
        self.urgesHandled = defaults.integer(forKey: "enhanced_urgesHandled")
        self.streakDays = defaults.integer(forKey: "enhanced_streakDays")
        self.lastSavedDate = defaults.object(forKey: "enhanced_lastSavedDate") as? Date
        self.costPerGambling = defaults.double(forKey: "enhanced_costPerGambling")
        self.timePerGambling = defaults.integer(forKey: "enhanced_timePerGambling")
        self.enhancedShowNotifications = defaults.bool(forKey: "enhanced_showNotifications")
        self.enhancedReminderTime = defaults.object(forKey: "enhanced_reminderTime") as? Date ?? Date(timeIntervalSince1970: 32400) // 9:00 AM
        self.enhancedUrgeHistory = []
        self.enhancedUserGoals = []
        
        // Set default values if needed
        if self.costPerGambling == 0 {
            self.costPerGambling = 20.0 // Default value
        }
        
        if self.timePerGambling == 0 {
            self.timePerGambling = 60 // Default value (60 minutes)
        }
        
        // Load enhanced data
        if let historyData = defaults.data(forKey: "enhanced_urgeHistory") {
            do {
                self.enhancedUrgeHistory = try JSONDecoder().decode([EnhancedUrgeRecord].self, from: historyData)
            } catch {
                print("Error decoding urge history: \(error)")
                self.enhancedUrgeHistory = []
            }
        } else {
            self.enhancedUrgeHistory = []
        }
        
        if let goalsData = defaults.data(forKey: "enhanced_userGoals") {
            do {
                self.enhancedUserGoals = try JSONDecoder().decode([EnhancedUserGoal].self, from: goalsData)
            } catch {
                print("Error decoding user goals: \(error)")
                self.enhancedUserGoals = []
            }
        } else {
            self.enhancedUserGoals = []
            // Create default goals if none exist
            if self.enhancedUserGoals.isEmpty {
                self.enhancedUserGoals = [
                    EnhancedUserGoal.createDailyGoal(),
                    EnhancedUserGoal.createWeeklyGoal()
                ]
            }
        }
        
        // Setup publishers for auto-saving
        setupPublishers()
        
        // Check and update streak
        checkAndUpdateStreak()
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
        
        defaults.set(urgesHandled, forKey: "enhanced_urgesHandled")
        defaults.set(streakDays, forKey: "enhanced_streakDays")
        defaults.set(lastSavedDate, forKey: "enhanced_lastSavedDate")
        
        // Save enhanced data
        do {
            let historyData = try JSONEncoder().encode(enhancedUrgeHistory)
            defaults.set(historyData, forKey: "enhanced_urgeHistory")
            
            let goalsData = try JSONEncoder().encode(enhancedUserGoals)
            defaults.set(goalsData, forKey: "enhanced_userGoals")
        } catch {
            print("Error encoding data: \(error)")
        }
    }
    
    func enhancedSaveSettings() {
        let defaults = UserDefaults.standard
        
        defaults.set(costPerGambling, forKey: "enhanced_costPerGambling")
        defaults.set(timePerGambling, forKey: "enhanced_timePerGambling")
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
                "costPerGambling": costPerGambling,
                "timePerGambling": timePerGambling,
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
                let goalStart = goal.createdAt
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
}

// MARK: - Supporting Types

// Simple mindfulness session data model
struct EnhancedMindfulnessSession: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var duration: Int // in minutes
    var type: String
} 