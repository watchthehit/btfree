import SwiftUI
import Combine

@MainActor
class AppState: ObservableObject {
    // MARK: - Published Properties
    @Published var hasCompletedOnboarding: Bool = false
    @Published var userTriggers: [String] = []
    @Published var notificationPreferences: [String: Bool] = [:]
    
    // MARK: - User Settings
    @Published var username: String = ""
    @Published var dailyGoal: Int = 30  // Default to 30 days
    @Published var streakCount: Int = 0
    @Published var startDate: Date = Date()
    
    // MARK: - Recovery Metrics
    @Published var moneySaved: Double = 0.0
    @Published var averageDailySpend: Double = 0.0
    @Published var totalDaysGambleFree: Int = 0
    @Published var cravingReports: [CravingReport] = []
    @Published var dailyProgress: [DailyProgress] = []
    
    // MARK: - Support System
    @Published var supportContacts: [SupportContact] = []
    @Published var hasSetupSupportSystem: Bool = false
    
    // MARK: - Achievement System
    @Published var achievements: [UserAchievement] = []
    @Published var mindfulnessMinutesTotal: Int = 0
    @Published var mindfulnessExercisesCompleted: Int = 0
    
    // MARK: - Theme and UI Preferences
    @Published var preferredTheme: AppTheme = .standard
    @Published var useCalming: Bool = false
    
    enum AppTheme: String, Codable {
        case standard = "Standard"
        case calm = "Calm"
        case focus = "Focus"
        case hope = "Hope"
        
        var accentColor: Color {
            switch self {
            case .standard: return BFColors.primary
            case .calm: return BFColors.calm
            case .focus: return BFColors.focus
            case .hope: return BFColors.hope
            }
        }
    }
    
    // MARK: - Initialization
    init() {
        // Load saved data from UserDefaults
        loadUserData()
    }
    
    // MARK: - Methods
    func completeOnboarding() {
        hasCompletedOnboarding = true
        if startDate == Date() {
            // Only set start date on first onboarding completion
            startDate = Date()
        }
        saveUserData()
    }
    
    func addTrigger(_ trigger: String) {
        if !userTriggers.contains(trigger) {
            userTriggers.append(trigger)
            saveUserData()
        }
    }
    
    func removeTrigger(_ trigger: String) {
        if let index = userTriggers.firstIndex(of: trigger) {
            userTriggers.remove(at: index)
            saveUserData()
        }
    }
    
    func setNotificationPreference(for key: String, enabled: Bool) {
        notificationPreferences[key] = enabled
        saveUserData()
    }
    
    func addCravingReport(_ report: CravingReport) {
        cravingReports.append(report)
        updateDailyProgress(with: report)
        saveUserData()
        checkForAchievements()
    }
    
    func updateDailyProgress(with report: CravingReport) {
        let calendar = Calendar.current
        let reportDate = calendar.startOfDay(for: report.date)
        
        if let index = dailyProgress.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: reportDate) }) {
            dailyProgress[index].cravingsReported += 1
            if !report.didGiveIn {
                dailyProgress[index].cravingsResisted += 1
            }
        } else {
            var newProgress = DailyProgress(date: reportDate, cravingsReported: 1)
            if !report.didGiveIn {
                newProgress.cravingsResisted = 1
            }
            dailyProgress.append(newProgress)
        }
        
        calculateStreak()
        updateTotalDaysGambleFree()
        updateMoneySaved()
        saveUserData()
    }
    
    func addSupportContact(_ contact: SupportContact) {
        supportContacts.append(contact)
        hasSetupSupportSystem = true
        saveUserData()
    }
    
    func removeSupportContact(at index: Int) {
        supportContacts.remove(at: index)
        hasSetupSupportSystem = supportContacts.count > 0
        saveUserData()
    }
    
    func logMindfulnessSession(minutes: Int) {
        mindfulnessMinutesTotal += minutes
        mindfulnessExercisesCompleted += 1
        
        // Update today's progress
        let today = Calendar.current.startOfDay(for: Date())
        if let index = dailyProgress.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            dailyProgress[index].mindfulnessMinutes += minutes
        } else {
            dailyProgress.append(DailyProgress(date: today, mindfulnessMinutes: minutes))
        }
        
        checkForAchievements()
        saveUserData()
    }
    
    func setDailyGoalCompleted(_ completed: Bool) {
        let today = Calendar.current.startOfDay(for: Date())
        if let index = dailyProgress.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            dailyProgress[index].goalCompleted = completed
        } else {
            dailyProgress.append(DailyProgress(date: today, goalCompleted: completed))
        }
        
        if completed {
            checkForAchievements()
        }
        
        calculateStreak()
        saveUserData()
    }
    
    // Add this method to mark the current day as completed
    func markDayAsCompleted() {
        setDailyGoalCompleted(true)
    }
    
    // MARK: - Private Methods
    private func calculateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var currentStreak = 0
        var date = today
        
        // Sort progress by date in descending order
        let sortedProgress = dailyProgress.sorted { $0.date > $1.date }
        
        for i in 0..<sortedProgress.count {
            let entry = sortedProgress[i]
            
            // Check if this date is the expected next date in the streak
            if i == 0 || calendar.isDate(entry.date, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: date)!) {
                // Make sure the user didn't give in on this day
                if entry.goalCompleted && entry.cravingsResisted >= entry.cravingsReported {
                    currentStreak += 1
                    date = entry.date
                } else {
                    break
                }
            } else {
                // Gap in dates, streak is broken
                break
            }
        }
        
        streakCount = currentStreak
    }
    
    private func updateTotalDaysGambleFree() {
        totalDaysGambleFree = dailyProgress.filter { 
            $0.goalCompleted && $0.cravingsResisted >= $0.cravingsReported 
        }.count
    }
    
    private func updateMoneySaved() {
        // Use the average daily spend multiplied by gambling-free days
        moneySaved = averageDailySpend * Double(totalDaysGambleFree)
    }
    
    private func checkForAchievements() {
        // Check for streak-based achievements
        checkStreakAchievements()
        
        // Check for mindfulness achievements
        checkMindfulnessAchievements()
        
        // Check for craving management achievements
        checkCravingManagementAchievements()
    }
    
    private func checkStreakAchievements() {
        let streakMilestones = [1, 3, 7, 14, 30, 60, 90, 180, 365]
        
        for milestone in streakMilestones {
            if streakCount >= milestone {
                let title = "\(milestone) Day Streak"
                
                // Only add if we don't already have this achievement
                if !achievements.contains(where: { $0.title == title }) {
                    let achievement = UserAchievement(
                        title: title,
                        description: "You've maintained your gambling-free commitment for \(milestone) consecutive days!",
                        iconName: "calendar.badge.clock"
                    )
                    achievements.append(achievement)
                }
            }
        }
    }
    
    private func checkMindfulnessAchievements() {
        let minuteMilestones = [10, 30, 60, 120, 300, 600, 1200]
        
        for milestone in minuteMilestones {
            if mindfulnessMinutesTotal >= milestone {
                let title = "\(milestone) Mindful Minutes"
                
                if !achievements.contains(where: { $0.title == title }) {
                    let achievement = UserAchievement(
                        title: title,
                        description: "You've completed \(milestone) minutes of mindfulness practice!",
                        iconName: "brain.head.profile"
                    )
                    achievements.append(achievement)
                }
            }
        }
    }
    
    private func checkCravingManagementAchievements() {
        let resistedCravings = cravingReports.filter { !$0.didGiveIn }.count
        let resistedMilestones = [1, 5, 10, 25, 50, 100]
        
        for milestone in resistedMilestones {
            if resistedCravings >= milestone {
                let title = "Resisted \(milestone) Cravings"
                
                if !achievements.contains(where: { $0.title == title }) {
                    let achievement = UserAchievement(
                        title: title,
                        description: "You've successfully managed and overcome \(milestone) gambling urges!",
                        iconName: "hand.raised.fill"
                    )
                    achievements.append(achievement)
                }
            }
        }
    }
    
    private func saveUserData() {
        UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        UserDefaults.standard.set(userTriggers, forKey: "userTriggers")
        UserDefaults.standard.set(notificationPreferences, forKey: "notificationPreferences")
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(dailyGoal, forKey: "dailyGoal")
        UserDefaults.standard.set(streakCount, forKey: "streakCount")
        UserDefaults.standard.set(startDate, forKey: "startDate")
        UserDefaults.standard.set(averageDailySpend, forKey: "averageDailySpend")
        UserDefaults.standard.set(totalDaysGambleFree, forKey: "totalDaysGambleFree")
        UserDefaults.standard.set(mindfulnessMinutesTotal, forKey: "mindfulnessMinutesTotal")
        UserDefaults.standard.set(mindfulnessExercisesCompleted, forKey: "mindfulnessExercisesCompleted")
        UserDefaults.standard.set(preferredTheme.rawValue, forKey: "preferredTheme")
        UserDefaults.standard.set(useCalming, forKey: "useCalming")
        UserDefaults.standard.set(hasSetupSupportSystem, forKey: "hasSetupSupportSystem")
        
        // Save complex objects
        if let cravingData = try? JSONEncoder().encode(cravingReports) {
            UserDefaults.standard.set(cravingData, forKey: "cravingReports")
        }
        
        if let progressData = try? JSONEncoder().encode(dailyProgress) {
            UserDefaults.standard.set(progressData, forKey: "dailyProgress")
        }
        
        if let contactsData = try? JSONEncoder().encode(supportContacts) {
            UserDefaults.standard.set(contactsData, forKey: "supportContacts")
        }
        
        if let achievementsData = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(achievementsData, forKey: "achievements")
        }
    }
    
    private func loadUserData() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        userTriggers = UserDefaults.standard.stringArray(forKey: "userTriggers") ?? []
        notificationPreferences = UserDefaults.standard.dictionary(forKey: "notificationPreferences") as? [String: Bool] ?? [:]
        username = UserDefaults.standard.string(forKey: "username") ?? ""
        dailyGoal = UserDefaults.standard.integer(forKey: "dailyGoal")
        streakCount = UserDefaults.standard.integer(forKey: "streakCount")
        startDate = UserDefaults.standard.object(forKey: "startDate") as? Date ?? Date()
        averageDailySpend = UserDefaults.standard.double(forKey: "averageDailySpend")
        totalDaysGambleFree = UserDefaults.standard.integer(forKey: "totalDaysGambleFree")
        mindfulnessMinutesTotal = UserDefaults.standard.integer(forKey: "mindfulnessMinutesTotal")
        mindfulnessExercisesCompleted = UserDefaults.standard.integer(forKey: "mindfulnessExercisesCompleted")
        hasSetupSupportSystem = UserDefaults.standard.bool(forKey: "hasSetupSupportSystem")
        
        if let themeString = UserDefaults.standard.string(forKey: "preferredTheme"),
           let theme = AppTheme(rawValue: themeString) {
            preferredTheme = theme
        }
        
        useCalming = UserDefaults.standard.bool(forKey: "useCalming")
        
        // Load complex objects
        if let cravingData = UserDefaults.standard.data(forKey: "cravingReports"),
           let loadedReports = try? JSONDecoder().decode([CravingReport].self, from: cravingData) {
            cravingReports = loadedReports
        }
        
        if let progressData = UserDefaults.standard.data(forKey: "dailyProgress"),
           let loadedProgress = try? JSONDecoder().decode([DailyProgress].self, from: progressData) {
            dailyProgress = loadedProgress
        }
        
        if let contactsData = UserDefaults.standard.data(forKey: "supportContacts"),
           let loadedContacts = try? JSONDecoder().decode([SupportContact].self, from: contactsData) {
            supportContacts = loadedContacts
        }
        
        if let achievementsData = UserDefaults.standard.data(forKey: "achievements"),
           let loadedAchievements = try? JSONDecoder().decode([UserAchievement].self, from: achievementsData) {
            achievements = loadedAchievements
        }
    }
}

// Support Contact Model
struct SupportContact: Identifiable, Codable {
    var id = UUID()
    var name: String
    var relationship: String
    var phoneNumber: String?
    var email: String?
    var isEmergencyContact: Bool
    
    init(name: String, relationship: String, phoneNumber: String? = nil, email: String? = nil, isEmergencyContact: Bool = false) {
        self.name = name
        self.relationship = relationship
        self.phoneNumber = phoneNumber
        self.email = email
        self.isEmergencyContact = isEmergencyContact
    }
} 