import Foundation
import SwiftUI

@MainActor
public class AppState: ObservableObject {
    private let dataManager: BetFreeDataManager
    
    @Published public var username: String {
        didSet { 
            saveToUserDefaults()
            try? dataManager.createOrUpdateUser(name: username, email: (nil as String?), dailyLimit: dailyLimit)
        }
    }
    
    @Published public var currentStreak: Int {
        didSet { 
            saveToUserDefaults()
            try? dataManager.updateUserStreak()
            handleStreakMilestone()
            Task {
                await checkAchievements()
            }
        }
    }
    
    @Published public var totalSavings: Double {
        willSet {
            saveToUserDefaults()
            try? dataManager.updateTotalSavings(amount: newValue)
        }
        didSet {
            handleSavingsMilestone(oldValue: oldValue)
            Task {
                await checkAchievements()
            }
        }
    }
    
    @Published public var dailyLimit: Double {
        didSet { 
            saveToUserDefaults()
            try? dataManager.createOrUpdateUser(name: username, email: (nil as String?), dailyLimit: dailyLimit)
        }
    }
    
    @Published public var isOnboarded: Bool {
        didSet { saveToUserDefaults() }
    }
    
    @Published public var selectedTab: Int {
        didSet { saveToUserDefaults() }
    }
    
    // New published properties for achievement tracking
    @Published private var transactionCount: Int = 0 {
        didSet {
            saveToUserDefaults()
            Task {
                await checkAchievements()
            }
        }
    }
    
    @Published private var daysUnderLimit: Int = 0 {
        didSet {
            saveToUserDefaults()
            Task {
                await checkAchievements()
            }
        }
    }
    
    @Published private var lastCheckInTime: Date? {
        didSet {
            saveToUserDefaults()
            Task {
                await checkAchievements()
            }
        }
    }
    
    @Published private var goalReached: Bool = false {
        didSet {
            saveToUserDefaults()
            Task {
                await checkAchievements()
            }
        }
    }
    
    // Computed properties for UI
    public var streak: Int { currentStreak }
    public var savings: Double { totalSavings }
    
    public init(dataManager: BetFreeDataManager? = nil) async throws {
        let dataManager = dataManager ?? CoreDataManager.shared
        self.dataManager = dataManager
        
        // Initialize basic state
        self.isOnboarded = UserDefaults.standard.bool(forKey: "isOnboarded")
        self.selectedTab = UserDefaults.standard.integer(forKey: "selectedTab")
        self.username = UserDefaults.standard.string(forKey: "username") ?? "User"
        self.currentStreak = UserDefaults.standard.integer(forKey: "currentStreak")
        self.totalSavings = UserDefaults.standard.double(forKey: "totalSavings")
        self.dailyLimit = UserDefaults.standard.double(forKey: "dailyLimit")
        
        // Initialize from Core Data if available
        if let user = dataManager.getCurrentUser() {
            self.username = user.name.isEmpty ? "User" : user.name
            self.currentStreak = Int(user.streak)
            self.totalSavings = user.totalSavings
            self.dailyLimit = user.dailyLimit
        } else {
            try dataManager.createOrUpdateUser(name: username, email: (nil as String?), dailyLimit: dailyLimit)

            guard let _ = dataManager.getCurrentUser() else {
                throw AppStateError.userProfileCreationFailed
            }
        }
        
        // Initialize achievements
        try await AchievementManager.shared.initializeAchievements()
        
        // Initialize achievement tracking properties
        self.transactionCount = UserDefaults.standard.integer(forKey: "transactionCount")
        self.daysUnderLimit = UserDefaults.standard.integer(forKey: "daysUnderLimit")
        self.lastCheckInTime = UserDefaults.standard.object(forKey: "lastCheckInTime") as? Date
        self.goalReached = UserDefaults.standard.bool(forKey: "goalReached")
        
        // Check achievements
        await checkAchievements()
    }
    
    // New public initializer for previews
    public init(syncDataManager: BetFreeDataManager) {
        self.dataManager = syncDataManager
        self.username = ""
        self.currentStreak = 0
        self.totalSavings = 0
        self.dailyLimit = 0
        self.isOnboarded = false
        self.selectedTab = 0
        self.transactionCount = 0
        self.daysUnderLimit = 0
        self.lastCheckInTime = nil
        self.goalReached = false
    }
    
    private func saveToUserDefaults() {
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
        UserDefaults.standard.set(totalSavings, forKey: "totalSavings")
        UserDefaults.standard.set(dailyLimit, forKey: "dailyLimit")
        UserDefaults.standard.set(isOnboarded, forKey: "isOnboarded")
        UserDefaults.standard.set(selectedTab, forKey: "selectedTab")
        UserDefaults.standard.set(transactionCount, forKey: "transactionCount")
        UserDefaults.standard.set(daysUnderLimit, forKey: "daysUnderLimit")
        UserDefaults.standard.set(lastCheckInTime, forKey: "lastCheckInTime")
        UserDefaults.standard.set(goalReached, forKey: "goalReached")
    }
    
    private func handleStreakMilestone() {
        Task {
            // Check if notifications are enabled
            guard UserDefaults.standard.bool(forKey: "milestoneAlertsEnabled", defaultValue: true) else {
                return
            }
            
            // Check for streak milestones
            if currentStreak == 7 {
                try? await NotificationService.shared.scheduleMilestoneCelebration(milestone: "a 7-day streak")
            } else if currentStreak == 30 {
                try? await NotificationService.shared.scheduleMilestoneCelebration(milestone: "a 30-day streak")
            } else if currentStreak == 90 {
                try? await NotificationService.shared.scheduleMilestoneCelebration(milestone: "a 90-day streak")
            } else if currentStreak == 365 {
                try? await NotificationService.shared.scheduleMilestoneCelebration(milestone: "a 1-year streak")
            }
        }
    }
    
    private func handleSavingsMilestone(oldValue: Double) {
        Task {
            // Check if notifications are enabled
            guard UserDefaults.standard.bool(forKey: "milestoneAlertsEnabled", defaultValue: true) else {
                return
            }
            
            // Check for savings milestones
            let milestones = [100, 500, 1000, 5000, 10000]
            for milestone in milestones {
                if totalSavings >= Double(milestone) && totalSavings - oldValue < Double(milestone) {
                    try? await NotificationService.shared.scheduleMilestoneCelebration(
                        milestone: "saving $\(milestone)"
                    )
                    break
                }
            }
        }
    }
    
    private func checkAchievements() async {
        do {
            try await AchievementManager.shared.checkProgress(
                streak: Int32(currentStreak),
                savings: totalSavings,
                checkInTime: lastCheckInTime,
                transactionCount: transactionCount,
                daysUnderLimit: daysUnderLimit,
                goalReached: goalReached
            )
        } catch {
            print("Error checking achievements: \(error)")
        }
    }
    
    public func updateStreak(_ value: Int) {
        currentStreak = value
        do {
            try dataManager.updateUserStreak()
        } catch {
            print("Error updating streak: \(error)")
        }
    }
    
    public func updateSavings(_ value: Double) {
        totalSavings = value
        do {
            try dataManager.updateTotalSavings(amount: value)
        } catch {
            print("Error updating savings: \(error)")
        }
    }
    
    public func updateDailyLimit(_ value: Double) {
        dailyLimit = value
        do {
            try dataManager.createOrUpdateUser(name: username, email: (nil as String?), dailyLimit: value)
        } catch {
            print("Error updating daily limit: \(error)")
        }
    }
    
    public func updateUsername(_ newUsername: String) {
        self.username = newUsername
    }
    
    public func completeOnboarding() {
        isOnboarded = true
    }
    
    public func logout() {
        currentStreak = 0
        totalSavings = 0
        dailyLimit = 0
        isOnboarded = false
        selectedTab = 0
        transactionCount = 0
        daysUnderLimit = 0
        lastCheckInTime = nil
        goalReached = false
        dataManager.reset()
    }
    
    // New public methods for updating achievement metrics
    public func incrementTransactionCount() {
        transactionCount += 1
    }
    
    public func updateDaysUnderLimit(_ days: Int) {
        daysUnderLimit = days
    }
    
    public func recordCheckIn() {
        lastCheckInTime = Date()
    }
    
    public func markGoalReached() {
        goalReached = true
    }
    
    public enum AppStateError: LocalizedError {
        case userProfileCreationFailed
        
        public var errorDescription: String? {
            switch self {
            case .userProfileCreationFailed:
                return "Failed to create user profile"
            }
        }
    }
}

extension UserDefaults {
    func bool(forKey key: String, defaultValue: Bool) -> Bool {
        if object(forKey: key) == nil {
            return defaultValue
        }
        return bool(forKey: key)
    }
}

extension AppState {
    static func preview() -> AppState {
        let state = AppState(syncDataManager: MockCoreDataManager.shared)
        state.username = "Preview User"
        state.currentStreak = 7
        state.totalSavings = 500.0
        state.dailyLimit = 50.0
        state.isOnboarded = true
        state.selectedTab = 0
        return state
    }
} 