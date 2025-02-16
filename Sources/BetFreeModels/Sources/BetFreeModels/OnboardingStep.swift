import Foundation

public enum OnboardingStep: Int, CaseIterable {
    case welcome
    case sports
    case goals
    case paywall
    
    public var title: String {
        switch self {
        case .welcome: return "Welcome"
        case .sports: return "Sports"
        case .goals: return "Goals"
        case .paywall: return "Subscription"
        }
    }
    
    public var description: String {
        switch self {
        case .welcome:
            return "Welcome to BetFree, your companion for overcoming sports betting addiction."
        case .sports:
            return "Which sports do you typically bet on? This helps us personalize your experience."
        case .goals:
            return "Set your goals and track your progress towards a betting-free life."
        case .paywall:
            return "Get full access to all features and start your journey to recovery."
        }
    }
}
