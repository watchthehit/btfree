import SwiftUI

public struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @State private var username: String = ""
    @State private var dailyLimit: String = ""
    @State private var currentStep = 0
    @State private var showPaywall = false
    
    let onboardingSteps = [
        OnboardingStep(
            title: "Take Control",
            subtitle: "Your journey to financial freedom and better habits starts here",
            image: "arrow.up.forward",
            imageColor: BFDesignSystem.Colors.primary,
            background: Color.blue.opacity(0.1)
        ),
        OnboardingStep(
            title: "Track Your Progress",
            subtitle: "Watch your streaks grow and savings multiply day by day",
            image: "chart.line.uptrend.xyaxis.circle.fill",
            imageColor: BFDesignSystem.Colors.success,
            background: Color.green.opacity(0.1)
        ),
        OnboardingStep(
            title: "Build Better Habits",
            subtitle: "Daily goals and exercises to help you stay on track",
            image: "target",
            imageColor: BFDesignSystem.Colors.secondary,
            background: Color.purple.opacity(0.1)
        )
    ]
    
    public var body: some View {
        ZStack {
            VStack(spacing: BFDesignSystem.Spacing.large) {
                // Skip Button
                if currentStep < onboardingSteps.count {
                    HStack {
                        Spacer()
                        Button("Skip") {
                            withAnimation {
                                currentStep = onboardingSteps.count
                            }
                        }
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                        .padding()
                    }
                }
                
                Spacer()
                
                // Content
                switch currentStep {
                case ..<onboardingSteps.count:
                    // Feature Introduction Steps
                    FeatureStep(step: onboardingSteps[currentStep])
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                case onboardingSteps.count:
                    // Profile Setup
                    ProfileSetupStep(username: $username)
                        .transition(.move(edge: .trailing))
                case onboardingSteps.count + 1:
                    // Goal Setting
                    GoalSettingStep(dailyLimit: $dailyLimit)
                        .transition(.move(edge: .trailing))
                default:
                    EmptyView()
                }
                
                Spacer()
                
                // Progress & Navigation
                VStack(spacing: BFDesignSystem.Spacing.medium) {
                    if currentStep < onboardingSteps.count {
                        // Progress Dots
                        HStack(spacing: BFDesignSystem.Spacing.small) {
                            ForEach(0..<onboardingSteps.count, id: \.self) { index in
                                Circle()
                                    .fill(currentStep == index ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.cardBackground)
                                    .frame(width: 8, height: 8)
                            }
                        }
                    }
                    
                    // Navigation Buttons
                    NavigationButtons(
                        currentStep: currentStep,
                        maxSteps: onboardingSteps.count + 1,
                        isNextDisabled: isNextDisabled,
                        onNext: handleNext,
                        onBack: handleBack
                    )
                }
                .padding(.bottom)
            }
            
            // Paywall Sheet
            if showPaywall {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                PaywallView(isPresented: $showPaywall, onSubscribe: completeOnboarding)
                    .transition(.move(edge: .bottom))
            }
        }
    }
    
    private var isNextDisabled: Bool {
        switch currentStep {
        case onboardingSteps.count:
            return username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case onboardingSteps.count + 1:
            return dailyLimit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        default:
            return false
        }
    }
    
    private func handleNext() {
        withAnimation {
            if currentStep == onboardingSteps.count + 1 {
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
    let background: Color
}

// MARK: - Supporting Views
struct FeatureStep: View {
    let step: OnboardingStep
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Spacing.xxLarge) {
            // Image
            ZStack {
                Circle()
                    .fill(step.background)
                    .frame(width: 240, height: 240)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                
                Image(systemName: step.image)
                    .font(.system(size: 80, weight: .medium))
                    .foregroundColor(step.imageColor)
                    .offset(y: isAnimating ? -5 : 5)
            }
            .animation(
                Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                value: isAnimating
            )
            
            // Text
            VStack(spacing: BFDesignSystem.Spacing.medium) {
                Text(step.title)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                
                Text(step.subtitle)
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .multilineTextAlignment(.center)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    .padding(.horizontal, BFDesignSystem.Spacing.large)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct ProfileSetupStep: View {
    @Binding var username: String
    @FocusState private var isUsernameFocused: Bool
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Spacing.xxLarge) {
            Image(systemName: "person.crop.circle.fill.badge.plus")
                .font(.system(size: 80))
                .foregroundColor(BFDesignSystem.Colors.primary)
                .symbolRenderingMode(.hierarchical)
            
            VStack(spacing: BFDesignSystem.Spacing.large) {
                Text("What's your name?")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                
                TextField("Enter your name", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, BFDesignSystem.Spacing.xxLarge)
                    .focused($isUsernameFocused)
                
                Text("This helps personalize your experience")
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
        }
        .onAppear {
            isUsernameFocused = true
        }
    }
}

struct GoalSettingStep: View {
    @Binding var dailyLimit: String
    @FocusState private var isDailyLimitFocused: Bool
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Spacing.xxLarge) {
            Image(systemName: "target")
                .font(.system(size: 80))
                .foregroundStyle(
                    .linearGradient(
                        colors: [BFDesignSystem.Colors.primary, BFDesignSystem.Colors.secondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .symbolRenderingMode(.hierarchical)
            
            VStack(spacing: BFDesignSystem.Spacing.large) {
                Text("Set Your Daily Limit")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                
                HStack {
                    Text("$")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    
                    TextField("Amount", text: $dailyLimit)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(BFDesignSystem.Typography.bodyLarge)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .focused($isDailyLimitFocused)
                }
                .padding(.horizontal, BFDesignSystem.Spacing.xxLarge)
                
                Text("You can adjust this anytime in settings")
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
        }
        .onAppear {
            isDailyLimitFocused = true
        }
    }
}

struct NavigationButtons: View {
    let currentStep: Int
    let maxSteps: Int
    let isNextDisabled: Bool
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        HStack {
            if currentStep > 0 {
                Button(action: onBack) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
            }
            
            Spacer()
            
            Button(action: onNext) {
                HStack {
                    Text(currentStep == maxSteps ? "Start Free Trial" : "Continue")
                    if currentStep < maxSteps {
                        Image(systemName: "chevron.right")
                    }
                }
                .font(BFDesignSystem.Typography.headlineMedium)
                .foregroundColor(.white)
                .padding(.horizontal, BFDesignSystem.Spacing.large)
                .padding(.vertical, BFDesignSystem.Spacing.medium)
                .background(
                    isNextDisabled ? BFDesignSystem.Colors.primary.opacity(0.5) : BFDesignSystem.Colors.primary
                )
                .cornerRadius(BFDesignSystem.CornerRadius.large)
            }
            .disabled(isNextDisabled)
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