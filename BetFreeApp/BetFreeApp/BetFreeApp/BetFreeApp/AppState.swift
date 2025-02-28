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
    
    // MARK: - Subscription Status
    @Published var isTrialActive: Bool = false
    @Published var trialEndDate: Date?
    @Published var hasProAccess: Bool = false
    @Published var subscriptionTier: SubscriptionTier = .free
    @Published var subscriptionExpiryDate: Date?
    
    // MARK: - Feature Access Control
    var canAccessAdvancedAnalytics: Bool {
        return hasProAccess || isTrialActive
    }
    
    var canAccessFullMindfulnessLibrary: Bool {
        return hasProAccess || isTrialActive
    }
    
    var canAccessUnlimitedTriggers: Bool {
        return hasProAccess || isTrialActive
    }
    
    var daysRemainingInTrial: Int {
        guard let endDate = trialEndDate, isTrialActive else { return 0 }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: endDate)
        return max(0, components.day ?? 0)
    }
    
    var trialProgress: Double {
        guard let _ = trialEndDate, isTrialActive else { return 1.0 }
        let totalDays = 7.0
        let daysRemaining = Double(daysRemainingInTrial)
        return (totalDays - daysRemaining) / totalDays
    }
    
    // MARK: - Initialization
    init() {
        // Load saved data from UserDefaults
        loadUserData()
        
        // Check if trial has expired
        checkTrialStatus()
    }
    
    // MARK: - Subscription Methods
    func checkTrialStatus() {
        if isTrialActive, let endDate = trialEndDate, Date() >= endDate {
            isTrialActive = false
            hasProAccess = false
            saveUserData()
        }
    }
    
    func startFreeTrial() {
        let sevenDaysLater = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        trialEndDate = sevenDaysLater
        isTrialActive = true
        hasProAccess = true
        saveUserData()
    }
    
    func activateSubscription(_ tier: SubscriptionTier, expiryDate: Date? = nil) {
        subscriptionTier = tier
        subscriptionExpiryDate = expiryDate
        hasProAccess = true
        saveUserData()
    }
    
    func cancelSubscription() {
        // In a real app, this would involve API calls to your backend
        // We'll just update the local state for now
        hasProAccess = false
        subscriptionTier = .free
        saveUserData()
    }
    
    // MARK: - Methods
    func completeOnboarding() {
        hasCompletedOnboarding = true
        saveUserData()
    }
    
    func addTrigger(_ trigger: String) {
        // Check if user is on free tier and already has max triggers
        if !canAccessUnlimitedTriggers && userTriggers.count >= 5 {
            return
        }
        
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
        
        // Save subscription data
        UserDefaults.standard.set(isTrialActive, forKey: "isTrialActive")
        UserDefaults.standard.set(hasProAccess, forKey: "hasProAccess")
        UserDefaults.standard.set(subscriptionTier.rawValue, forKey: "subscriptionTier")
        
        if let trialDate = trialEndDate {
            UserDefaults.standard.set(trialDate.timeIntervalSince1970, forKey: "trialEndDate")
        }
        
        if let expiryDate = subscriptionExpiryDate {
            UserDefaults.standard.set(expiryDate.timeIntervalSince1970, forKey: "subscriptionExpiryDate")
        }
    }
    
    private func loadUserData() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        userTriggers = UserDefaults.standard.stringArray(forKey: "userTriggers") ?? []
        notificationPreferences = UserDefaults.standard.dictionary(forKey: "notificationPreferences") as? [String: Bool] ?? [:]
        username = UserDefaults.standard.string(forKey: "username") ?? ""
        dailyGoal = UserDefaults.standard.integer(forKey: "dailyGoal")
        streakCount = UserDefaults.standard.integer(forKey: "streakCount")
        
        // Load subscription data
        isTrialActive = UserDefaults.standard.bool(forKey: "isTrialActive")
        hasProAccess = UserDefaults.standard.bool(forKey: "hasProAccess")
        
        if let tierRawValue = UserDefaults.standard.string(forKey: "subscriptionTier"),
           let tier = SubscriptionTier(rawValue: tierRawValue) {
            subscriptionTier = tier
        }
        
        if let trialTimestamp = UserDefaults.standard.object(forKey: "trialEndDate") as? TimeInterval {
            trialEndDate = Date(timeIntervalSince1970: trialTimestamp)
        }
        
        if let expiryTimestamp = UserDefaults.standard.object(forKey: "subscriptionExpiryDate") as? TimeInterval {
            subscriptionExpiryDate = Date(timeIntervalSince1970: expiryTimestamp)
        }
    }
}

// MARK: - Subscription Tier Enum
enum SubscriptionTier: String, Codable {
    case free = "Free"
    case monthly = "Monthly"
    case annual = "Annual"
    case lifetime = "Lifetime"
} 