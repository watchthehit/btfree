import SwiftUI
import Foundation

/// Manages when and how the paywall is presented to users
class PaywallManager: ObservableObject {
    // MARK: - Published Properties
    @Published var shouldShowPaywall = false
    @Published var paywallTriggerCounter = 0
    @Published var lastPaywallDismissalDate: Date?
    @Published var hasSeenInitialPaywall = false
    
    // MARK: - Constants
    private let minSessionsBeforePaywall = 3
    private let minDaysBetweenPaywalls = 3
    private let paywallTriggerThreshold = 5
    private let keyShouldShowPaywall = "bf_should_show_paywall"
    private let keyPaywallTriggerCounter = "bf_paywall_trigger_counter"
    private let keyLastPaywallDismissal = "bf_last_paywall_dismissal"
    private let keyHasSeenInitialPaywall = "bf_has_seen_initial_paywall"
    
    // MARK: - Initialization
    init() {
        loadState()
    }
    
    // MARK: - Public Methods
    
    /// Evaluates whether to show the paywall based on various triggers and conditions
    func evaluateShowingPaywall(
        sessionCount: Int,
        isValueFeatureAccessed: Bool = false,
        completedActionCount: Int = 0
    ) -> Bool {
        // Skip evaluation if user is already a subscriber
        if UserDefaults.standard.bool(forKey: "is_premium_user") {
            return false
        }
        
        // Initial paywall check - show after X sessions
        if !hasSeenInitialPaywall && sessionCount >= minSessionsBeforePaywall {
            hasSeenInitialPaywall = true
            saveState()
            return true
        }
        
        // Respect cooling period between paywalls
        if let lastDismissal = lastPaywallDismissalDate {
            let daysSinceLastDismissal = Calendar.current.dateComponents([.day], from: lastDismissal, to: Date()).day ?? 0
            if daysSinceLastDismissal < minDaysBetweenPaywalls {
                return false
            }
        }
        
        // Value feature trigger
        if isValueFeatureAccessed {
            incrementTriggerCounter()
            return paywallTriggerCounter >= paywallTriggerThreshold
        }
        
        // Engagement trigger
        if completedActionCount > 0 {
            incrementTriggerCounter(amount: min(completedActionCount, 3))
            return paywallTriggerCounter >= paywallTriggerThreshold
        }
        
        return false
    }
    
    /// Records when user dismisses the paywall to respect cooling period
    func recordPaywallDismissal() {
        lastPaywallDismissalDate = Date()
        paywallTriggerCounter = 0
        saveState()
    }
    
    /// Increments the counter that tracks user engagement with premium-adjacent features
    func incrementTriggerCounter(amount: Int = 1) {
        paywallTriggerCounter += amount
        saveState()
    }
    
    /// Resets all paywall triggers and state
    func resetPaywallState() {
        shouldShowPaywall = false
        paywallTriggerCounter = 0
        lastPaywallDismissalDate = nil
        hasSeenInitialPaywall = false
        saveState()
    }
    
    // MARK: - Private Methods
    
    /// Saves paywall state to UserDefaults
    private func saveState() {
        UserDefaults.standard.set(shouldShowPaywall, forKey: keyShouldShowPaywall)
        UserDefaults.standard.set(paywallTriggerCounter, forKey: keyPaywallTriggerCounter)
        UserDefaults.standard.set(lastPaywallDismissalDate, forKey: keyLastPaywallDismissal)
        UserDefaults.standard.set(hasSeenInitialPaywall, forKey: keyHasSeenInitialPaywall)
    }
    
    /// Loads paywall state from UserDefaults
    private func loadState() {
        shouldShowPaywall = UserDefaults.standard.bool(forKey: keyShouldShowPaywall)
        paywallTriggerCounter = UserDefaults.standard.integer(forKey: keyPaywallTriggerCounter)
        lastPaywallDismissalDate = UserDefaults.standard.object(forKey: keyLastPaywallDismissal) as? Date
        hasSeenInitialPaywall = UserDefaults.standard.bool(forKey: keyHasSeenInitialPaywall)
    }
}

// MARK: - PaywallView Modifier
struct PaywallViewModifier: ViewModifier {
    @ObservedObject var paywallManager: PaywallManager
    @State private var isShowingPaywall = false
    
    func body(content: Content) -> some View {
        content
            .onChange(of: paywallManager.shouldShowPaywall) { newValue in
                isShowingPaywall = newValue
            }
            .fullScreenCover(isPresented: $isShowingPaywall) {
                EnhancedPaywallScreen()
                    .environmentObject(paywallManager)
            }
    }
}

extension View {
    func withPaywall(manager: PaywallManager) -> some View {
        self.modifier(PaywallViewModifier(paywallManager: manager))
    }
} 