import Foundation
import SwiftUI
import Combine

@MainActor
public class AppState: ObservableObject {
    private let dataManager: BetFreeDataManager
    
    @Published public var username: String {
        didSet { 
            try? dataManager.createOrUpdateUser(name: username, email: (nil as String?), dailyLimit: dailyLimit)
            saveSettings()
        }
    }
    
    @Published public var currentStreak: Int {
        didSet { 
            try? dataManager.updateUserStreak()
            handleStreakMilestone()
            saveSettings()
        }
    }
    
    @Published public var totalSavings: Double {
        willSet {
            try? dataManager.updateTotalSavings(amount: newValue)
        }
        didSet {
            handleSavingsMilestone(oldValue: oldValue)
            saveSettings()
        }
    }
    
    @Published public var dailyLimit: Double {
        didSet {
            saveSettings()
        }
    }
    
    @Published public var isOnboarded: Bool {
        didSet {
            saveSettings()
        }
    }
    
    @Published public var selectedTab: Int {
        didSet {
            saveSettings()
        }
    }
    
    @Published public var hasBlockedApps: Bool {
        didSet {
            saveSettings()
        }
    }
    
    @Published public var typicalBetAmount: Double {
        didSet {
            saveSettings()
        }
    }
    
    @Published public var preferredSports: [String] {
        didSet {
            saveSettings()
        }
    }
    
    @Published public var subscriptionStatus: BFUserState = .expired {
        didSet {
            saveSettings()
            if case .trial(let endDate) = subscriptionStatus {
                defaults.set(true, forKey: "BF_HAS_HAD_TRIAL")
                scheduleTrialEndNotification(endDate: endDate)
            }
        }
    }
    
    @Published public var savings: [Saving] = []
    
    // Computed properties for UI
    public var streak: Int { currentStreak }
    public var savingsAmount: Double { totalSavings }
    
    private let defaults = UserDefaults.standard
    private let usernameKey = "BFUsername"
    private let streakKey = "BFStreak"
    private let savingsKey = "BFSavings"
    private let dailyLimitKey = "BFDailyLimit"
    private let isOnboardedKey = "BFIsOnboarded"
    private let selectedTabKey = "BFSelectedTab"
    private let hasBlockedAppsKey = "BFHasBlockedApps"
    private let typicalBetAmountKey = "BFTypicalBetAmount"
    private let preferredSportsKey = "BFPreferredSports"
    private let subscriptionStatusKey = "BFSubscriptionStatus"
    
    public init(dataManager: BetFreeDataManager? = nil) async throws {
        let dataManager = dataManager ?? CoreDataManager.shared
        self.dataManager = dataManager
        
        // Initialize from UserDefaults
        self.username = defaults.string(forKey: usernameKey) ?? ""
        self.isOnboarded = defaults.bool(forKey: isOnboardedKey)
        self.selectedTab = defaults.integer(forKey: selectedTabKey)
        self.currentStreak = defaults.integer(forKey: streakKey)
        self.totalSavings = defaults.double(forKey: savingsKey)
        self.dailyLimit = defaults.double(forKey: dailyLimitKey)
        self.typicalBetAmount = defaults.double(forKey: typicalBetAmountKey)
        self.preferredSports = defaults.stringArray(forKey: preferredSportsKey) ?? []
        self.hasBlockedApps = defaults.bool(forKey: hasBlockedAppsKey)
        self.subscriptionStatus = BFUserState(rawValue: defaults.integer(forKey: subscriptionStatusKey)) ?? .expired
        
        // Initialize from Core Data if available
        if let user = dataManager.getCurrentUser() {
            self.username = user.name
            self.dailyLimit = user.dailyLimit
            self.isOnboarded = true
        } else {
            throw AppStateError.userProfileCreationFailed
        }
    }
    
    public init(syncDataManager: BetFreeDataManager) {
        self.dataManager = syncDataManager
        self.username = "Preview User"
        self.currentStreak = 7
        self.totalSavings = 1234.56
        self.dailyLimit = 50.0
        self.isOnboarded = true
        self.selectedTab = 0
        self.typicalBetAmount = 0.0
        self.preferredSports = []
        self.hasBlockedApps = false
        self.subscriptionStatus = .expired
    }
    
    // MARK: - Transaction Methods
    
    public func getTodaysTransactions() -> [Transaction] {
        dataManager.getTodaysTransactions()
    }
    
    public func addTransaction(amount: Double, note: String? = nil) throws {
        try dataManager.addTransaction(amount: amount, note: note)
    }
    
    public func getTotalSpentToday() -> Double {
        dataManager.getTotalSpentToday()
    }
    
    // MARK: - Private Methods
    
    private func saveSettings() {
        defaults.set(username, forKey: usernameKey)
        defaults.set(currentStreak, forKey: streakKey)
        defaults.set(totalSavings, forKey: savingsKey)
        defaults.set(dailyLimit, forKey: dailyLimitKey)
        defaults.set(isOnboarded, forKey: isOnboardedKey)
        defaults.set(selectedTab, forKey: selectedTabKey)
        defaults.set(typicalBetAmount, forKey: typicalBetAmountKey)
        defaults.set(preferredSports, forKey: preferredSportsKey)
        defaults.set(hasBlockedApps, forKey: hasBlockedAppsKey)
        defaults.set(subscriptionStatus.rawValue, forKey: subscriptionStatusKey)
    }
    
    private func scheduleTrialEndNotification(endDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Trial Ending Soon"
        content.body = "Your BetFree trial is ending soon. Subscribe now to keep your recovery on track!"
        content.sound = .default
        
        // Schedule for 24 hours before trial ends
        let triggerDate = Calendar.current.date(byAdding: .day, value: -1, to: endDate) ?? endDate
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate),
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "trial_end_reminder",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func handleStreakMilestone() {
        Task {
            // Check if notifications are enabled
            guard UserDefaults.standard.bool(forKey: "milestoneAlertsEnabled", defaultValue: true) else {
                return
            }
            
            // Check for streak milestones
            let milestones = [7, 30, 90, 180, 365]
            for milestone in milestones {
                if currentStreak == milestone {
                    try? await NotificationService.shared.scheduleMilestoneCelebration(
                        milestone: "\(milestone) days bet-free"
                    )
                    break
                }
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
    
    public func updateStreak(_ value: Int) {
        currentStreak = value
        do {
            try dataManager.updateUserStreak()
        } catch {
            print("Error updating streak: \(error)")
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
        typicalBetAmount = 0.0
        preferredSports = []
        hasBlockedApps = false
        subscriptionStatus = .expired
        dataManager.reset()
    }
    
    public func addSaving(_ saving: Saving) {
        savings.append(saving)
        totalSavings += saving.amount
    }
    
    public func wasCleanOn(_ date: Date) -> Bool {
        // Implementation for checking if a specific date was clean
        return true // Placeholder
    }
    
    public enum AppStateError: LocalizedError {
        case userProfileCreationFailed
        
        public var errorDescription: String? {
            switch self {
            case .userProfileCreationFailed:
                return "Failed to create or retrieve user profile"
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
    
    func stringArray(forKey key: String) -> [String]? {
        return array(forKey: key) as? [String]
    }
}

extension AppState {
    public static var preview: AppState {
        let state = AppState(syncDataManager: MockCoreDataManager.shared)
        return state
    }
}