import SwiftUI

@MainActor
public class OnboardingViewModel: ObservableObject {
    @Published var currentStep = 0
    @Published var personalInfo: [String: String] = [:]
    @Published var assessmentAnswers: [String: Any] = [:]
    @Published var selectedGoal: String?
    @Published var selectedMilestones: [OnboardingStep.Milestone] = []
    @Published var situationInputs: [String: String] = [:]
    @Published var commitmentLevels: [String: Double] = [:]
    @Published var showPaywall = false
    
    weak var appState: AppState?
    
    let steps: [OnboardingStep] = [
        // Welcome & Introduction
        .init(
            title: "Welcome to BetFree",
            subtitle: "Your journey to freedom starts here",
            image: "star.fill",
            imageColor: BFDesignSystem.Colors.primary,
            background: BFDesignSystem.Colors.primary.opacity(0.1),
            type: .welcome
        ),
        
        // Personal Info with Apple Sign In
        .init(
            title: "Quick Setup",
            subtitle: "Sign in to get started",
            image: "person.fill",
            imageColor: BFDesignSystem.Colors.secondary,
            background: BFDesignSystem.Colors.secondary.opacity(0.1),
            type: .personalInfo([
                .init(title: "Name", placeholder: "Your name", type: .name, validation: nil),
                .init(title: "Email", placeholder: "Your email", type: .email, validation: .email)
            ])
        ),
        
        // Combined Assessment & Situation
        .init(
            title: "Your Profile",
            subtitle: "Help us personalize your experience",
            image: "chart.bar.fill",
            imageColor: BFDesignSystem.Colors.info,
            background: BFDesignSystem.Colors.info.opacity(0.1),
            type: .situationInput([
                .init(title: "Weekly Spend", placeholder: "Average weekly gambling spend", keyboardType: .decimalPad, prefix: "$"),
                .init(title: "Main Trigger", placeholder: "e.g., Stress, Boredom", keyboardType: .default, prefix: nil)
            ])
        ),
        
        // Goal Setting
        .init(
            title: "Set Your Goal",
            subtitle: "What motivates you to quit?",
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
        
        // Commitment
        .init(
            title: "Your Commitment",
            subtitle: "Set your recovery goals",
            image: "clock.fill",
            imageColor: BFDesignSystem.Colors.success,
            background: BFDesignSystem.Colors.success.opacity(0.1),
            type: .commitmentLevel([
                .init(title: "Daily Check-in Time", range: 5...30, step: 5, format: "%.0f min"),
                .init(title: "Weekly Savings Goal", range: 10...500, step: 10, format: "$%.0f")
            ])
        ),
        
        // Success Preview
        .init(
            title: "You're Ready!",
            subtitle: "Let's start your journey to freedom",
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
        case .situationInput(let fields):
            return fields.allSatisfy { field in
                situationInputs[field.title]?.isEmpty == false
            }
        case .goalSelection:
            return selectedGoal != nil
        case .commitmentLevel(let sliders):
            return sliders.allSatisfy { slider in
                commitmentLevels[slider.title] != nil
            }
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
        
        // Update savings
        let weeklySpend = Double(commitmentLevels["Weekly Spend"] ?? 0)
        let saving = Saving(
            amount: weeklySpend,
            description: "Initial weekly spend estimate",
            date: Date(),
            sport: "All"
        )
        appState.addSaving(saving)
        
        // Save commitment levels
        if let dailyTime = commitmentLevels["Daily Check-in Time"] {
            // Store daily commitment time if needed
            print("Daily commitment time: \(dailyTime) minutes")
        }
        
        if let weeklySavings = commitmentLevels["Weekly Savings Goal"] {
            appState.updateDailyLimit(weeklySavings / 7.0)
        }
        
        showPaywall = false
    }
} 