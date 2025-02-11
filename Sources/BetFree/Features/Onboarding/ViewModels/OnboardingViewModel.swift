import SwiftUI

@MainActor
public class OnboardingViewModel: ObservableObject {
    @Published var currentStep = 0
    @Published var selectedGoal: String?
    @Published var situationInputs: [String: String] = [:]
    @Published var selectedSupports: Set<String> = []
    @Published var commitmentLevels: [String: Double] = [:]
    @Published var showPaywall = false
    
    weak var appState: AppState?
    
    let steps: [OnboardingStep] = [
        .init(
            title: "Welcome to BetFree",
            subtitle: "Join thousands of others on their journey to freedom from gambling addiction",
            image: "star.fill",
            imageColor: BFDesignSystem.Colors.primary,
            background: BFDesignSystem.Colors.primary.opacity(0.1),
            type: .welcome
        ),
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
        )
    ]
    
    var canProceed: Bool {
        switch steps[currentStep].type {
        case .welcome:
            return true
        case .goalSelection:
            return selectedGoal != nil
        case .situationInput(let fields):
            return fields.allSatisfy { field in
                situationInputs[field.title]?.isEmpty == false
            }
        case .supportSelection:
            return !selectedSupports.isEmpty
        case .commitmentLevel(let sliders):
            return sliders.allSatisfy { slider in
                commitmentLevels[slider.title] != nil
            }
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
        
        // Save user preferences
        if let weeklySpend = Double(situationInputs["Weekly Spend"] ?? "0") {
            appState.updateSavings(weeklySpend)
        }
        
        showPaywall = false
    }
} 