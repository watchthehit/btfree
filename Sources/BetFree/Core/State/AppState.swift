import Foundation
import SwiftUI

@MainActor
public class AppState: ObservableObject {
    @Published public var username: String {
        didSet { 
            saveToUserDefaults()
            try? CoreDataManager.shared.createOrUpdateUser(name: username, email: nil, dailyLimit: dailyLimit)
        }
    }
    
    @Published public var currentStreak: Int {
        didSet { 
            saveToUserDefaults()
            try? CoreDataManager.shared.updateUserStreak()
            handleStreakMilestone()
            checkAchievements()
        }
    }
    
    @Published public var totalSavings: Double {
        willSet {
            saveToUserDefaults()
            try? CoreDataManager.shared.updateTotalSavings(amount: newValue)
        }
        didSet {
            handleSavingsMilestone(oldValue: oldValue)
            checkAchievements()
        }
    }
    
    @Published public var dailyLimit: Double {
        didSet { 
            saveToUserDefaults()
            try? CoreDataManager.shared.createOrUpdateUser(name: username, email: nil, dailyLimit: dailyLimit)
        }
    }
    
    @Published public var isOnboarded: Bool {
        didSet { saveToUserDefaults() }
    }
    
    @Published public var selectedTab: Int {
        didSet { saveToUserDefaults() }
    }
    
    // Computed properties for UI
    public var streak: Int { currentStreak }
    public var savings: Double { totalSavings }
    
    public init() {
        // Load from UserDefaults first
        self.username = UserDefaults.standard.string(forKey: "username") ?? ""
        self.currentStreak = UserDefaults.standard.integer(forKey: "currentStreak")
        self.totalSavings = UserDefaults.standard.double(forKey: "totalSavings")
        self.dailyLimit = UserDefaults.standard.double(forKey: "dailyLimit")
        self.isOnboarded = UserDefaults.standard.bool(forKey: "isOnboarded")
        self.selectedTab = UserDefaults.standard.integer(forKey: "selectedTab")
        
        // Then try to load from Core Data
        if let user = CoreDataManager.shared.getCurrentUser() {
            self.username = user.name
            self.currentStreak = Int(user.streak)
            self.totalSavings = user.totalSavings
            self.dailyLimit = user.dailyLimit
        } else {
            // Create initial user profile in Core Data
            try? CoreDataManager.shared.createOrUpdateUser(
                name: username,
                email: nil,
                dailyLimit: dailyLimit
            )
        }
        
        // Setup notification categories
        NotificationService.shared.setupNotificationCategories()
        
        // Initialize achievements
        try? AchievementManager.shared.initializeAchievements()
        checkAchievements()
    }
    
    private func saveToUserDefaults() {
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
        UserDefaults.standard.set(totalSavings, forKey: "totalSavings")
        UserDefaults.standard.set(dailyLimit, forKey: "dailyLimit")
        UserDefaults.standard.set(isOnboarded, forKey: "isOnboarded")
        UserDefaults.standard.set(selectedTab, forKey: "selectedTab")
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
    
    private func checkAchievements() {
        Task {
            try? await AchievementManager.shared.checkProgress(
                streak: Int32(currentStreak),
                savings: totalSavings
            )
        }
    }
    
    public func updateStreak(_ newStreak: Int) {
        self.currentStreak = newStreak
    }
    
    public func updateSavings(_ amount: Double) {
        self.totalSavings = amount
    }
    
    public func updateDailyLimit(_ newLimit: Double) {
        self.dailyLimit = newLimit
    }
    
    public func updateUsername(_ newUsername: String) {
        self.username = newUsername
    }
    
    public func completeOnboarding() {
        isOnboarded = true
        
        // Request notification permissions after onboarding
        Task {
            do {
                if try await NotificationService.shared.requestAuthorization() {
                    // Schedule initial daily check-in if enabled
                    if UserDefaults.standard.bool(forKey: "dailyCheckInEnabled", defaultValue: true) {
                        let defaultTime = Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date()
                        try? await NotificationService.shared.scheduleDailyCheckIn(at: defaultTime)
                    }
                }
            } catch {
                print("Failed to request notification authorization: \(error)")
            }
        }
    }
    
    public func selectTab(_ tab: Int) {
        selectedTab = tab
    }
    
    public func logout() {
        // Cancel all notifications
        Task {
            NotificationService.shared.cancelAllNotifications()
        }
        
        // Reset all user data
        username = ""
        currentStreak = 0
        totalSavings = 0
        dailyLimit = 0
        isOnboarded = false
        selectedTab = 0
        
        // Reset UserDefaults
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "currentStreak")
        UserDefaults.standard.removeObject(forKey: "totalSavings")
        UserDefaults.standard.removeObject(forKey: "dailyLimit")
        UserDefaults.standard.removeObject(forKey: "isOnboarded")
        UserDefaults.standard.removeObject(forKey: "selectedTab")
        
        // Reset Core Data
        CoreDataManager.shared.reset()
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