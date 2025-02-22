import Foundation
import SwiftUI
import Combine
import UserNotifications
import BetFreeModels

@MainActor
public class AppState: ObservableObject {
    public let dataManager: BetFreeDataManager
    
    private enum BFColorScheme {
        case system
        case light
        case dark
        
        var colorScheme: ColorScheme? {
            switch self {
            case .system: return nil
            case .light: return .light
            case .dark: return .dark
            }
        }
        
        init(colorScheme: ColorScheme?) {
            switch colorScheme {
            case .none: self = .system
            case .light: self = .light
            case .dark: self = .dark
            case .some(_): self = .system // Handle any future cases
            }
        }
    }
    
    @Published public var username: String = "" {
        didSet { 
            Task {
                do {
                    try await dataManager.createOrUpdateUser(name: username, email: nil, dailyLimit: dailyLimit)
                    saveSettings()
                } catch {
                    print("Error updating user: \(error)")
                }
            }
        }
    }
    
    @Published public var currentStreak: Int = 0 {
        didSet { 
            Task {
                do {
                    try await dataManager.updateUserStreak()
                    saveSettings()
                    handleStreakMilestone()
                } catch {
                    print("Error updating streak: \(error)")
                }
            }
        }
    }
    
    @Published public var totalSavings: Double = 0 {
        didSet {
            saveSettings()
            handleSavingsMilestone(oldValue: oldValue)
        }
    }
    
    @Published public var dailyLimit: Double = 0 {
        didSet {
            Task {
                do {
                    try await dataManager.createOrUpdateUser(name: username, email: nil, dailyLimit: dailyLimit)
                    saveSettings()
                } catch {
                    print("Error updating daily limit: \(error)")
                }
            }
        }
    }
    
    @Published public var isOnboarded: Bool = false {
        didSet {
            saveSettings()
        }
    }
    
    @Published public var selectedTab: Int = 0 {
        didSet {
            saveSettings()
        }
    }
    
    @Published public var hasBlockedApps: Bool = false {
        didSet {
            saveSettings()
        }
    }
    
    @Published public var typicalBetAmount: Double = 0 {
        didSet {
            saveSettings()
        }
    }
    
    @Published public var preferredSports: [String] = [] {
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
    
    @Published public var colorScheme: ColorScheme? = nil {
        didSet {
            if let scheme = colorScheme {
                switch scheme {
                case .dark:
                    defaults.set("dark", forKey: colorSchemeKey)
                case .light:
                    defaults.set("light", forKey: colorSchemeKey)
                default:
                    defaults.removeObject(forKey: colorSchemeKey)
                }
            } else {
                defaults.removeObject(forKey: colorSchemeKey)
            }
        }
    }
    
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
    private let colorSchemeKey = "BFColorScheme"
    
    @MainActor
    public static let preview: AppState = {
        let state = AppState(dataManager: MockCDManager.shared)
        state.username = "Preview User"
        state.currentStreak = 7
        state.totalSavings = 1234.56
        state.dailyLimit = 100
        state.isOnboarded = true
        state.hasBlockedApps = true
        return state
    }()
    
    @MainActor
    public init(dataManager: BetFreeDataManager) {
        print("📱 Initializing AppState")
        self.dataManager = dataManager
        
        // Load saved settings
        self.username = defaults.string(forKey: usernameKey) ?? ""
        self.currentStreak = defaults.integer(forKey: streakKey)
        self.totalSavings = defaults.double(forKey: savingsKey)
        self.dailyLimit = defaults.double(forKey: dailyLimitKey)
        self.isOnboarded = defaults.bool(forKey: isOnboardedKey, defaultValue: false)
        self.selectedTab = defaults.integer(forKey: selectedTabKey)
        self.hasBlockedApps = defaults.bool(forKey: hasBlockedAppsKey, defaultValue: false)
        self.typicalBetAmount = defaults.double(forKey: typicalBetAmountKey)
        self.preferredSports = defaults.stringArray(forKey: preferredSportsKey) ?? []
        
        // Load color scheme preference
        if let scheme = defaults.string(forKey: colorSchemeKey) {
            self.colorScheme = scheme == "dark" ? .dark : .light
        }
        
        // Load subscription status
        if let statusData = defaults.data(forKey: subscriptionStatusKey),
           let status = try? JSONDecoder().decode(BFUserState.self, from: statusData) {
            self.subscriptionStatus = status
        }
        
        print("📱 AppState initialized with settings")
    }
    
    @MainActor
    public func loadUserProfile() async {
        print("📱 Loading user profile")
        if let user = await dataManager.getCurrentUser() {
            print("📱 User profile found")
            self.username = user.name
            self.currentStreak = Int(user.streak)
            self.totalSavings = user.totalSavings
            self.dailyLimit = user.dailyLimit
            print("📱 User profile loaded: \(user.name)")
        } else {
            print("📱 No user profile found")
        }
    }
    
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
        
        // Save subscription status
        if let statusData = try? JSONEncoder().encode(subscriptionStatus) {
            defaults.set(statusData, forKey: subscriptionStatusKey)
        }
    }
    
    private func scheduleTrialEndNotification(endDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Trial Ending Soon"
        content.body = "Your BetFree trial is ending soon. Subscribe now to keep your recovery on track!"
        content.sound = .default
        
        // Schedule for 24 hours before trial ends
        let triggerDate = Calendar.current.date(byAdding: .day, value: -1, to: endDate) ?? endDate
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "trial_end_reminder",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule trial end notification: \(error)")
            }
        }
    }
    
    private func handleStreakMilestone() {
        // Check if notifications are enabled
        guard defaults.bool(forKey: "milestoneAlertsEnabled", defaultValue: true) else {
            return
        }
        
        // Check for streak milestones
        let milestones = [7, 30, 90, 180, 365]
        for milestone in milestones {
            if currentStreak == milestone {
                Task {
                    try? await NotificationService.shared.scheduleMilestoneCelebration(
                        milestone: "\(milestone) days bet-free"
                    )
                }
                break
            }
        }
    }
    
    private func handleSavingsMilestone(oldValue: Double) {
        Task {
            // Check if notifications are enabled
            guard defaults.bool(forKey: "milestoneAlertsEnabled", defaultValue: true) else {
                return
            }
            
            // Check for savings milestones
            let milestones = [100, 500, 1000, 5000, 10000]
            for milestone in milestones {
                if totalSavings >= Double(milestone) && oldValue < Double(milestone) {
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
    }
    
    public func updateDailyLimit(_ value: Double) {
        dailyLimit = value
        do {
            try dataManager.createOrUpdateUser(name: username, email: nil, dailyLimit: value)
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
    
    public func logout() async {
        // First reset Core Data
        await dataManager.reset()
        
        // Then reset app state
        currentStreak = 0
        totalSavings = 0
        dailyLimit = 0
        isOnboarded = false
        selectedTab = 0
        typicalBetAmount = 0.0
        preferredSports = []
        hasBlockedApps = false
        subscriptionStatus = .expired
        
        // Clear user defaults
        for key in [
            usernameKey, streakKey, savingsKey, dailyLimitKey,
            isOnboardedKey, selectedTabKey, hasBlockedAppsKey,
            typicalBetAmountKey, preferredSportsKey, subscriptionStatusKey
        ] {
            defaults.removeObject(forKey: key)
        }
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
    
    public func createOrUpdateUser(name: String, email: String?, dailyLimit: Double) throws {
        try dataManager.createOrUpdateUser(name: name, email: email, dailyLimit: dailyLimit)
    }
    
    public func toggleColorScheme() {
        withAnimation {
            let currentScheme = BFColorScheme(colorScheme: colorScheme)
            switch currentScheme {
            case .system:
                colorScheme = .dark
            case .dark:
                colorScheme = .light
            case .light:
                colorScheme = nil
            }
        }
    }
}

extension UserDefaults {
    func bool(forKey key: String, defaultValue: Bool) -> Bool {
        if object(forKey: key) == nil {
            set(defaultValue, forKey: key)
        }
        return bool(forKey: key)
    }
    
    func stringArray(forKey key: String) -> [String]? {
        return array(forKey: key) as? [String]
    }
}