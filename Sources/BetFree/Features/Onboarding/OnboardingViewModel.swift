import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentStep = 0
    @Published var selectedGoal: String?
    @Published var situationInputs: [String: String] = [:]
    @Published var selectedSupports: Set<String> = []
    @Published var commitmentLevels: [String: Double] = [:]
    @Published var showPaywall = false
    
    let steps = [
        OnboardingStep(
            title: "Your Journey Starts Here",
            subtitle: "Join thousands of others taking control of their lives",
            image: "heart.fill",
            imageColor: BFDesignSystem.Colors.accent,
            background: BFDesignSystem.Colors.accent.opacity(0.1),
            type: .welcome
        ),
        OnboardingStep(
            title: "What's Your Goal?",
            subtitle: "Choose what matters most to you",
            image: "target",
            imageColor: BFDesignSystem.Colors.primary,
            background: BFDesignSystem.Colors.primary.opacity(0.1),
            type: .goalSelection(options: [
                "Save Money",
                "Build Better Habits",
                "Support Family",
                "Reduce Stress"
            ])
        ),
        OnboardingStep(
            title: "Your Starting Point",
            subtitle: "Understanding where you are helps us personalize your journey",
            image: "figure.walk",
            imageColor: BFDesignSystem.Colors.secondary,
            background: BFDesignSystem.Colors.secondary.opacity(0.1),
            type: .situationInput(fields: [
                .init(title: "Weekly Spend", placeholder: "Enter amount", keyboardType: .decimalPad, prefix: "$"),
                .init(title: "Main Trigger", placeholder: "e.g., Stress, Boredom", keyboardType: .default, prefix: nil)
            ])
        ),
        OnboardingStep(
            title: "You're Not Alone",
            subtitle: "Choose your support preferences",
            image: "hands.sparkles",
            imageColor: BFDesignSystem.Colors.success,
            background: BFDesignSystem.Colors.success.opacity(0.1),
            type: .supportSelection(options: [
                "Daily Check-ins",
                "Progress Tracking",
                "Community Support",
                "Expert Guidance"
            ])
        ),
        OnboardingStep(
            title: "Set Your Pace",
            subtitle: "Start with achievable goals",
            image: "chart.line.uptrend.xyaxis",
            imageColor: BFDesignSystem.Colors.info,
            background: BFDesignSystem.Colors.info.opacity(0.1),
            type: .commitmentLevel(sliders: [
                .init(title: "Daily Time Commitment (minutes)", range: 5...60, step: 5, format: "%.0f min"),
                .init(title: "Weekly Savings Goal", range: 10...500, step: 10, format: "$%.0f")
            ])
        )
    ]
    
    var canProceed: Bool {
        switch steps[currentStep].type {
        case .welcome:
            return true
        case .goalSelection:
            return selectedGoal != nil
        case .situationInput:
            return !situationInputs.isEmpty && situationInputs.values.allSatisfy { !$0.isEmpty }
        case .supportSelection:
            return !selectedSupports.isEmpty
        case .commitmentLevel:
            return !commitmentLevels.isEmpty
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
        // Save all collected data
        // Update app state
        showPaywall = false
    }
} 