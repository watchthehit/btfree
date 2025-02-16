import Foundation

public enum OnboardingStep: Int, CaseIterable {
    case welcome = 0
    case signUp
    case dailyLimit
    case goals
    case sports
    case features
    
    public var title: String {
        switch self {
        case .welcome: return "Welcome"
        case .signUp: return "Sign Up"
        case .dailyLimit: return "Daily Limit"
        case .goals: return "Goals"
        case .sports: return "Sports"
        case .features: return "Premium Features"
        }
    }
    
    public var description: String {
        switch self {
        case .welcome:
            return "Welcome to BetFree, your companion for overcoming sports betting addiction."
        case .signUp:
            return "Create your account to start your journey."
        case .dailyLimit:
            return "Set a daily spending limit to help manage your betting."
        case .goals:
            return "Set your goals and track your progress towards a betting-free life."
        case .sports:
            return "Which sports do you typically bet on? This helps us personalize your experience."
        case .features:
            return "Unlock premium features and start your journey with a 7-day free trial."
        }
    }
} 