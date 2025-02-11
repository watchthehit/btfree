import SwiftUI

@MainActor
public class OnboardingViewModel: ObservableObject {
    @Published var currentStep = 0
    @Published var personalInfo: [String: String] = [:]
    @Published var assessmentAnswers: [String: Any] = [:]
    @Published var selectedGoal: String?
    @Published var selectedMilestones: [OnboardingStep.Milestone] = []
    @Published var selectedRewards: [OnboardingStep.Reward] = []
    @Published var situationInputs: [String: String] = [:]
    @Published var gamblingHistory: [String: Any] = [:]
    @Published var riskFactors: [OnboardingStep.RiskFactor] = []
    @Published var selectedSupports: Set<String> = []
    @Published var supportContacts: [OnboardingStep.Contact] = []
    @Published var commitmentLevels: [String: Double] = [:]
    @Published var identifiedTriggers: [OnboardingStep.Trigger] = []
    @Published var selectedStrategies: [OnboardingStep.Strategy] = []
    @Published var emergencyContacts: [OnboardingStep.Contact] = []
    @Published var showPaywall = false
    
    weak var appState: AppState?
    
    let steps: [OnboardingStep] = [
        // Welcome & Introduction
        .init(
            title: "Welcome to BetFree",
            subtitle: "Join thousands of others on their journey to freedom from gambling addiction",
            image: "star.fill",
            imageColor: BFDesignSystem.Colors.primary,
            background: BFDesignSystem.Colors.primary.opacity(0.1),
            type: .welcome
        ),
        .init(
            title: "Let's Get to Know You",
            subtitle: "Help us personalize your recovery journey",
            image: "person.fill",
            imageColor: BFDesignSystem.Colors.secondary,
            background: BFDesignSystem.Colors.secondary.opacity(0.1),
            type: .personalInfo([
                .init(title: "Name", placeholder: "Your name", type: .name, validation: nil),
                .init(title: "Age", placeholder: "Your age", type: .age, validation: .age(min: 18, max: 100)),
                .init(title: "Email", placeholder: "Your email", type: .email, validation: .email)
            ])
        ),
        .init(
            title: "Quick Assessment",
            subtitle: "Help us understand your current situation",
            image: "clipboard.fill",
            imageColor: BFDesignSystem.Colors.info,
            background: BFDesignSystem.Colors.info.opacity(0.1),
            type: .assessment([
                .init(
                    question: "How often do you gamble?",
                    options: ["Daily", "Weekly", "Monthly", "Occasionally"],
                    type: .singleChoice,
                    weight: 3
                ),
                .init(
                    question: "How would you rate your current control over gambling?",
                    options: [],
                    type: .scale(min: 1, max: 10),
                    weight: 2
                )
            ])
        ),
        
        // Goal Setting
        .init(
            title: "Set Your Goal",
            subtitle: "What's your primary motivation for quitting?",
            image: "target",
            imageColor: BFDesignSystem.Colors.primary,
            background: BFDesignSystem.Colors.primary.opacity(0.1),
            type: .goalSelection([
                "Save Money",
                "Build Better Habits",
                "Protect Relationships",
                "Mental Peace",
                "Career Focus"
            ])
        ),
        .init(
            title: "Your Milestones",
            subtitle: "Let's break down your goal into achievable steps",
            image: "flag.fill",
            imageColor: BFDesignSystem.Colors.success,
            background: BFDesignSystem.Colors.success.opacity(0.1),
            type: .milestones([
                .init(
                    title: "First Week Free",
                    duration: 7 * 24 * 60 * 60,
                    type: .shortTerm,
                    rewards: []
                ),
                .init(
                    title: "One Month Milestone",
                    duration: 30 * 24 * 60 * 60,
                    type: .mediumTerm,
                    rewards: []
                )
            ])
        ),
        
        // Current Situation
        .init(
            title: "Your Situation",
            subtitle: "Help us understand your current situation better",
            image: "chart.bar.fill",
            imageColor: BFDesignSystem.Colors.secondary,
            background: BFDesignSystem.Colors.secondary.opacity(0.1),
            type: .situationInput([
                .init(title: "Weekly Spend", placeholder: "Enter amount", keyboardType: .decimalPad, prefix: "$"),
                .init(title: "Main Trigger", placeholder: "e.g., Stress, Boredom", keyboardType: .default, prefix: nil)
            ])
        ),
        
        // Support System
        .init(
            title: "Build Your Support Network",
            subtitle: "Add people who can help you on your journey",
            image: "person.3.fill",
            imageColor: BFDesignSystem.Colors.primary,
            background: BFDesignSystem.Colors.primary.opacity(0.1),
            type: .supportNetwork([])
        ),
        .init(
            title: "Choose Your Support",
            subtitle: "Select the tools that will help you succeed",
            image: "hand.raised.fill",
            imageColor: BFDesignSystem.Colors.success,
            background: BFDesignSystem.Colors.success.opacity(0.1),
            type: .supportSelection([
                "Daily Check-ins",
                "Progress Tracking",
                "Community Support",
                "Expert Guidance",
                "Emergency Hotline"
            ])
        ),
        
        // Commitment & Planning
        .init(
            title: "Set Your Commitment",
            subtitle: "How much time can you dedicate to your recovery?",
            image: "clock.fill",
            imageColor: BFDesignSystem.Colors.info,
            background: BFDesignSystem.Colors.info.opacity(0.1),
            type: .commitmentLevel([
                .init(title: "Daily Time Commitment (minutes)", range: 5...60, step: 5, format: "%.0f min"),
                .init(title: "Weekly Savings Goal", range: 10...500, step: 10, format: "$%.0f")
            ])
        ),
        
        // Safety Planning
        .init(
            title: "Your Safety Plan",
            subtitle: "Let's prepare for challenging moments",
            image: "shield.fill",
            imageColor: BFDesignSystem.Colors.success,
            background: BFDesignSystem.Colors.success.opacity(0.1),
            type: .safetyPlan
        ),
        
        // Emergency Contacts
        .init(
            title: "Emergency Contacts",
            subtitle: "Add people to contact in critical moments",
            image: "phone.fill",
            imageColor: BFDesignSystem.Colors.error,
            background: BFDesignSystem.Colors.error.opacity(0.1),
            type: .emergencyContacts
        ),
        
        // Recap
        .init(
            title: "You're All Set!",
            subtitle: "Let's review your personalized recovery plan",
            image: "checkmark.circle.fill",
            imageColor: BFDesignSystem.Colors.success,
            background: BFDesignSystem.Colors.success.opacity(0.1),
            type: .recap
        )
    ]
    
    var canProceed: Bool {
        switch steps[currentStep].type {
        case .welcome:
            return true
        case .personalInfo(let fields):
            return fields.allSatisfy { field in
                guard let value = personalInfo[field.title] else { return false }
                if let validation = field.validation {
                    switch validation {
                    case .email:
                        return value.contains("@") && value.contains(".")
                    case .phone:
                        return value.count >= 10
                    case .age(let min, let max):
                        guard let age = Int(value) else { return false }
                        return age >= min && age <= max
                    case .custom(let validator):
                        return validator(value)
                    }
                }
                return !value.isEmpty
            }
        case .assessment:
            return !assessmentAnswers.isEmpty
        case .goalSelection:
            return selectedGoal != nil
        case .milestones:
            return !selectedMilestones.isEmpty
        case .situationInput(let fields):
            return fields.allSatisfy { field in
                situationInputs[field.title]?.isEmpty == false
            }
        case .supportNetwork:
            return supportContacts.count >= 1
        case .supportSelection:
            return !selectedSupports.isEmpty
        case .commitmentLevel(let sliders):
            return sliders.allSatisfy { slider in
                commitmentLevels[slider.title] != nil
            }
        case .safetyPlan:
            return !identifiedTriggers.isEmpty && !selectedStrategies.isEmpty
        case .emergencyContacts:
            return emergencyContacts.count >= 1
        case .recap:
            return true
        default:
            return true
        }
    }
    
    func nextStep() {
        if currentStep < steps.count - 1 {
            currentStep += 1
        } else {
            showPaywall = true
        }
    }
    
    func previousStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }
    
    func completeOnboarding() {
        guard let appState = appState else { return }
        
        // Save user preferences and complete onboarding
        appState.completeOnboarding()
        
        // Save user data
        if let name = personalInfo["Name"] {
            appState.updateUsername(name)
        }
        
        // Save financial goals
        if let weeklySpend = Double(situationInputs["Weekly Spend"] ?? "0") {
            appState.updateSavings(weeklySpend)
        }
        
        // Save other preferences
        // TODO: Save additional user data and preferences
        
        showPaywall = false
    }
} 