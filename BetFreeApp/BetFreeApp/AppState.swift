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
    @Published var dailyGoal: Int = 0
    @Published var streakCount: Int = 0
    
    // MARK: - Initialization
    init() {
        // Load saved data from UserDefaults
        loadUserData()
    }
    
    // MARK: - Methods
    func completeOnboarding() {
        hasCompletedOnboarding = true
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
    
    // MARK: - Private Methods
    private func saveUserData() {
        UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        UserDefaults.standard.set(userTriggers, forKey: "userTriggers")
        UserDefaults.standard.set(notificationPreferences, forKey: "notificationPreferences")
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(dailyGoal, forKey: "dailyGoal")
        UserDefaults.standard.set(streakCount, forKey: "streakCount")
    }
    
    private func loadUserData() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        userTriggers = UserDefaults.standard.stringArray(forKey: "userTriggers") ?? []
        notificationPreferences = UserDefaults.standard.dictionary(forKey: "notificationPreferences") as? [String: Bool] ?? [:]
        username = UserDefaults.standard.string(forKey: "username") ?? ""
        dailyGoal = UserDefaults.standard.integer(forKey: "dailyGoal")
        streakCount = UserDefaults.standard.integer(forKey: "streakCount")
    }
} 