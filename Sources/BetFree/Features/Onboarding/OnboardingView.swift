import SwiftUI

public struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @State private var username: String = ""
    @State private var dailyLimit: String = ""
    @State private var currentStep = 0
    @State private var showPaywall = false
    
    let onboardingSteps = [
        OnboardingStep(
            title: "Welcome to BetFree",
            subtitle: "Your journey to a healthier relationship with gambling starts here",
            image: "heart.fill",
            imageColor: BFDesignSystem.Colors.primary
        ),
        OnboardingStep(
            title: "Track Your Progress",
            subtitle: "See your daily streaks and savings grow as you make positive changes",
            image: "chart.line.uptrend.xyaxis",
            imageColor: BFDesignSystem.Colors.success
        ),
        OnboardingStep(
            title: "24/7 Support",
            subtitle: "Access to professional resources and emergency help whenever you need it",
            image: "phone.fill",
            imageColor: BFDesignSystem.Colors.secondary
        ),
        OnboardingStep(
            title: "Personalize Your Journey",
            subtitle: "Let's set up your profile for a tailored experience",
            image: "person.fill",
            imageColor: BFDesignSystem.Colors.primary
        )
    ]
    
    public var body: some View {
        ZStack {
            VStack(spacing: BFDesignSystem.Spacing.large) {
                // Progress Bar
                ProgressBar(currentStep: currentStep, totalSteps: onboardingSteps.count + 2)
                    .padding(.top)
                
                Spacer()
                
                // Content
                switch currentStep {
                case ..<onboardingSteps.count:
                    // Feature Introduction Steps
                    FeatureStep(step: onboardingSteps[currentStep])
                case onboardingSteps.count:
                    // Profile Setup
                    ProfileSetupStep(username: $username)
                case onboardingSteps.count + 1:
                    // Goal Setting
                    GoalSettingStep(dailyLimit: $dailyLimit)
                default:
                    EmptyView()
                }
                
                Spacer()
                
                // Navigation Buttons
                NavigationButtons(
                    currentStep: currentStep,
                    maxSteps: onboardingSteps.count + 1,
                    onNext: handleNext,
                    onBack: handleBack
                )
                .padding(.bottom)
            }
            .padding()
            
            // Paywall Sheet
            if showPaywall {
                PaywallView(isPresented: $showPaywall, onSubscribe: completeOnboarding)
            }
        }
    }
    
    private func handleNext() {
        withAnimation {
            if currentStep == onboardingSteps.count + 1 {
                // Show paywall before completing onboarding
                showPaywall = true
            } else {
                currentStep += 1
            }
        }
    }
    
    private func handleBack() {
        withAnimation {
            currentStep -= 1
        }
    }
    
    private func completeOnboarding() {
        appState.updateUsername(username)
        if let limit = Double(dailyLimit) {
            appState.updateDailyLimit(limit)
        }
        appState.completeOnboarding()
    }
    
    public init() {}
}

// MARK: - Supporting Types
struct OnboardingStep {
    let title: String
    let subtitle: String
    let image: String
    let imageColor: Color
}

// MARK: - Supporting Views
struct ProgressBar: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: BFDesignSystem.Spacing.small) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Capsule()
                    .fill(currentStep >= index ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.cardBackground)
                    .frame(height: 4)
            }
        }
    }
}

struct FeatureStep: View {
    let step: OnboardingStep
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Spacing.large) {
            Image(systemName: step.image)
                .font(.system(size: 60))
                .foregroundColor(step.imageColor)
                .padding()
                .background(
                    Circle()
                        .fill(step.imageColor.opacity(0.1))
                        .frame(width: 120, height: 120)
                )
            
            Text(step.title)
                .font(BFDesignSystem.Typography.titleLarge)
                .multilineTextAlignment(.center)
            
            Text(step.subtitle)
                .font(BFDesignSystem.Typography.bodyLarge)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
    }
}

struct ProfileSetupStep: View {
    @Binding var username: String
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Spacing.large) {
            Text("What should we call you?")
                .font(BFDesignSystem.Typography.titleMedium)
            
            TextField("Your name", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Text("This helps us personalize your experience")
                .font(BFDesignSystem.Typography.bodyMedium)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
        }
    }
}

struct GoalSettingStep: View {
    @Binding var dailyLimit: String
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Spacing.large) {
            Text("Set Your Daily Limit")
                .font(BFDesignSystem.Typography.titleMedium)
            
            TextField("Amount ($)", text: $dailyLimit)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding(.horizontal)
            
            Text("You can adjust this later in settings")
                .font(BFDesignSystem.Typography.bodyMedium)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
        }
    }
}

struct NavigationButtons: View {
    let currentStep: Int
    let maxSteps: Int
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        HStack {
            if currentStep > 0 {
                Button("Back") {
                    onBack()
                }
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
            
            Spacer()
            
            Button(currentStep == maxSteps ? "Start Free Trial" : "Next") {
                onNext()
            }
            .foregroundColor(BFDesignSystem.Colors.primary)
            .bold()
        }
        .padding(.horizontal)
    }
}

struct PaywallView: View {
    @Binding var isPresented: Bool
    let onSubscribe: () -> Void
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Spacing.large) {
            // Header
            VStack(spacing: BFDesignSystem.Spacing.medium) {
                Text("Unlock Full Access")
                    .font(BFDesignSystem.Typography.titleLarge)
                
                Text("Start your journey to recovery today")
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
            
            // Features
            VStack(spacing: BFDesignSystem.Spacing.medium) {
                FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Detailed progress tracking")
                FeatureRow(icon: "bell.fill", text: "Custom notifications and reminders")
                FeatureRow(icon: "person.fill", text: "24/7 professional support access")
                FeatureRow(icon: "lock.fill", text: "Privacy focused, secure data")
            }
            .padding()
            
            // Pricing
            VStack(spacing: BFDesignSystem.Spacing.small) {
                Text("$9.99/month")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                
                Text("after 7-day free trial")
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
            
            // Buttons
            VStack(spacing: BFDesignSystem.Spacing.medium) {
                Button(action: {
                    onSubscribe()
                }) {
                    Text("Start 7-Day Free Trial")
                        .font(BFDesignSystem.Typography.headlineMedium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(BFDesignSystem.Colors.primary)
                        .cornerRadius(BFDesignSystem.CornerRadius.medium)
                }
                
                Button("Restore Purchase") {
                    // TODO: Implement restore purchase
                }
                .font(BFDesignSystem.Typography.bodyMedium)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
            
            // Terms
            Text("Cancel anytime. Terms apply.")
                .font(BFDesignSystem.Typography.bodySmall)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
        }
        .padding()
        .background(BFDesignSystem.Colors.background)
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: BFDesignSystem.Spacing.medium) {
            Image(systemName: icon)
                .foregroundColor(BFDesignSystem.Colors.primary)
                .frame(width: 24)
            
            Text(text)
                .font(BFDesignSystem.Typography.bodyLarge)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState.shared)
} 