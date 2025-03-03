import SwiftUI
import Foundation

/// Represents different screens in the onboarding flow
public enum OnboardingScreen: Equatable {
    case welcome
    case valueProposition1
    case valueProposition2
    case valueProposition3
    case goalSelection
    case trackingMethodSelection
    case triggerIdentification
    case scheduleSetup
    case profileCompletion
    case signIn
    case personalSetup
    case notificationSetup
    case enhancedPaywall
    case completion
}

/// Represents a notification type that can be enabled/disabled during onboarding
public struct OnboardingNotificationType: Identifiable {
    public let id = UUID()
    public let name: String
    public let detail: String
    public var isEnabled: Bool
}

@MainActor
public class OnboardingViewModel: ObservableObject {
    // MARK: - Constants
    let screens: [OnboardingScreen] = [
        .welcome,
        .valueProposition1,
        .valueProposition2,
        .valueProposition3,
        .goalSelection,
        .combinedProfileSetup, // New consolidated screen that will replace profileCompletion and personalSetup
        .notificationSetup,
        .completion
        // enhancedPaywall moved to post-onboarding
    ]
    
    // User profile properties
    @Published var trackingMethod = "Manual"  // Default tracking method
    @Published var availableTrackingMethods = ["Manual", "Location-based", "Schedule-based", "Urge detection"]
    @Published var selectedGoal = "Reduce"  // Default goal
    @Published var availableGoals = ["Reduce", "Quit", "Maintain control"]
    @Published var reminderDays: [Bool] = [true, true, true, true, true, true, true] // Default all days
    @Published var reminderTime = Date() // Default to current time
    
    // MARK: - Published Properties
    @Published var currentScreenIndex = 0
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isSigningInWithApple = false
    @Published var dailyGoal = 20  // Default to 20 minutes
    @Published var isTrialActive = false  // Default to not in trial
    
    // Added for partial progress tracking
    @Published var hasStartedOnboarding = false
    @Published var lastCompletedScreenIndex = -1
    
    // Trigger identification properties
    @Published var userTriggers: [String] = []
    @Published var triggerCategories: [TriggerCategory] = [
        TriggerCategory(name: "Emotional", triggers: ["Stress", "Boredom", "Loneliness", "Excitement", "Depression"]),
        TriggerCategory(name: "Social", triggers: ["Friends gambling", "Work events", "Family gatherings", "Social media"]),
        TriggerCategory(name: "Environmental", triggers: ["Passing casinos", "Seeing ads", "Promotional emails", "Sports events"]),
        TriggerCategory(name: "Financial", triggers: ["Payday", "Financial stress", "Unexpected money", "Bills due"])
    ]
    @Published var selectedTriggers: [String] = []
    @Published var triggerIntensities: [String: Int] = [:]
    @Published var triggerStrategies: [String: [String]] = [:]
    @Published var customTrigger = ""
    
    // Notification settings
    @Published var notificationTypes: [OnboardingNotificationType] = [
        OnboardingNotificationType(name: "Daily reminders", detail: "Get daily reminders to practice mindfulness", isEnabled: true),
        OnboardingNotificationType(name: "Progress milestones", detail: "Celebrate when you reach important milestones", isEnabled: true),
        OnboardingNotificationType(name: "Tips & advice", detail: "Receive helpful advice when you need it most", isEnabled: false)
    ]
    
    // Completion handler
    public var onComplete: (() -> Void)?
    
    // MARK: - Methods
    
    /// Moves to the next screen in the onboarding flow
    public func nextScreen() {
        if currentScreenIndex < screens.count - 1 {
            currentScreenIndex += 1
            lastCompletedScreenIndex = max(lastCompletedScreenIndex, currentScreenIndex - 1)
            hasStartedOnboarding = true
            savePartialProgress()
        }
    }
    
    /// Moves to the previous screen in the onboarding flow
    public func previousScreen() {
        if currentScreenIndex > 0 {
            currentScreenIndex -= 1
        }
    }
    
    /// Skip to a specific screen (e.g., for resuming onboarding)
    public func skipToScreen(_ screenIndex: Int) {
        guard screenIndex >= 0 && screenIndex < screens.count else { return }
        currentScreenIndex = screenIndex
        hasStartedOnboarding = true
    }
    
    /// Skip directly to the paywall screen (now removed from onboarding flow)
    public func skipToPaywall() {
        // Save this for when we add the paywall back outside of onboarding
        // Functionality remains for future use in the main app
    }
    
    /// Save partial progress to UserDefaults
    private func savePartialProgress() {
        UserDefaults.standard.set(currentScreenIndex, forKey: "onboarding_last_screen")
        UserDefaults.standard.set(username, forKey: "onboarding_username")
        UserDefaults.standard.set(dailyGoal, forKey: "onboarding_daily_goal")
        
        // Save more state as needed
    }
    
    /// Restore partial progress from UserDefaults
    public func restorePartialProgress() {
        if let lastScreen = UserDefaults.standard.object(forKey: "onboarding_last_screen") as? Int {
            lastCompletedScreenIndex = lastScreen
            // Optionally set current screen to the last completed one
            // currentScreenIndex = lastScreen
        }
        
        if let savedUsername = UserDefaults.standard.string(forKey: "onboarding_username") {
            username = savedUsername
        }
        
        if let savedDailyGoal = UserDefaults.standard.object(forKey: "onboarding_daily_goal") as? Int {
            dailyGoal = savedDailyGoal
        }
        
        // Restore more state as needed
    }
    
    /// Toggles a trigger in the selected triggers list
    public func toggleTrigger(_ trigger: String) {
        if selectedTriggers.contains(trigger) {
            selectedTriggers.removeAll { $0 == trigger }
            triggerIntensities.removeValue(forKey: trigger)
            triggerStrategies.removeValue(forKey: trigger)
        } else {
            selectedTriggers.append(trigger)
            triggerIntensities[trigger] = 5 // Default intensity
            triggerStrategies[trigger] = [] // Empty strategies list
        }
    }
    
    /// Adds a custom trigger to the user's triggers list
    public func addCustomTrigger(_ trigger: String) {
        guard !trigger.isEmpty else { return }
        userTriggers.append(trigger)
        toggleTrigger(trigger)
    }
    
    /// Adds a trigger to the selected triggers list
    public func addTrigger(_ trigger: String) {
        if !selectedTriggers.contains(trigger) {
            selectedTriggers.append(trigger)
            triggerIntensities[trigger] = 5 // Default intensity
            triggerStrategies[trigger] = [] // Empty strategies list
        }
    }
    
    /// Removes a trigger from the selected triggers list
    public func removeTrigger(_ trigger: String) {
        selectedTriggers.removeAll { $0 == trigger }
        triggerIntensities.removeValue(forKey: trigger)
        triggerStrategies.removeValue(forKey: trigger)
    }
    
    /// Updates the intensity for a specific trigger
    public func updateIntensity(_ intensity: Int, for trigger: String) {
        triggerIntensities[trigger] = intensity
    }
    
    /// Adds a strategy for a specific trigger
    public func addStrategy(_ strategy: String, for trigger: String) {
        if var strategies = triggerStrategies[trigger] {
            strategies.append(strategy)
            triggerStrategies[trigger] = strategies
        } else {
            triggerStrategies[trigger] = [strategy]
        }
    }
    
    /// Removes a strategy for a specific trigger
    public func removeStrategy(_ strategy: String, for trigger: String) {
        if var strategies = triggerStrategies[trigger] {
            strategies.removeAll { $0 == strategy }
            triggerStrategies[trigger] = strategies
        }
    }
    
    /// Updates notification settings
    public func updateNotificationSetting(for type: OnboardingNotificationType, isEnabled: Bool) {
        if let index = notificationTypes.firstIndex(where: { $0.id == type.id }) {
            notificationTypes[index] = OnboardingNotificationType(
                name: type.name,
                detail: type.detail,
                isEnabled: isEnabled
            )
        }
    }
} 