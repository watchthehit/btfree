import SwiftUI
import BetFreeUI
import BetFreeModels

public struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var showPaywall = false
    
    public init() {}
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Progress dots
                    HStack(spacing: 8) {
                        ForEach(OnboardingStep.allCases, id: \.self) { step in
                            Circle()
                                .fill(step.rawValue <= viewModel.currentStep.rawValue ? Color.white : Color.white.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .scaleEffect(step == viewModel.currentStep ? 1.2 : 1)
                                .animation(.spring(response: 0.3), value: viewModel.currentStep)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Page content
                    TabView(selection: $viewModel.currentStep) {
                        // Welcome
                        welcomeStep
                            .tag(OnboardingStep.welcome)
                        
                        // Personal Info
                        personalInfoStep
                            .tag(OnboardingStep.personalInfo)
                        
                        // Goals
                        goalsStep
                            .tag(OnboardingStep.goals)
                        
                        // Sports
                        sportsStep
                            .tag(OnboardingStep.sports)
                        
                        // Features
                        featuresStep
                            .tag(OnboardingStep.features)
                        
                        // Trial
                        trialStep
                            .tag(OnboardingStep.trial)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.easeInOut, value: viewModel.currentStep)
                    
                    // Navigation buttons
                    navigationButtons
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                }
            }
        }
        .preferredColorScheme(.light)
    }
    
    private var welcomeStep: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // App icon or logo
            #if os(iOS)
            if #available(iOS 17.0, *) {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .symbolEffect(.bounce, value: viewModel.currentStep)
            } else {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .scaleEffect(1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.currentStep)
            }
            #else
            Image(systemName: "heart.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.white)
                .scaleEffect(1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.currentStep)
            #endif
            
            Text("Welcome to BetFree")
                .font(BFDesignSystem.Typography.displayLarge)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("Your journey to freedom starts here")
                .font(BFDesignSystem.Typography.titleMedium)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .slideUpOnAppear()
    }
    
    private var personalInfoStep: some View {
        VStack(spacing: 24) {
            Text("Tell us about yourself")
                .font(BFDesignSystem.Typography.titleLarge)
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                TextField("Your Name", text: $viewModel.name)
                    .textFieldStyle(OnboardingTextFieldStyle())
                
                TextField("Email (Optional)", text: $viewModel.email)
                    .textFieldStyle(OnboardingTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                TextField("Daily Limit ($)", text: $viewModel.dailyLimit)
                    .textFieldStyle(OnboardingTextFieldStyle())
                    .keyboardType(.decimalPad)
            }
            .padding(.horizontal, 24)
        }
        .slideUpOnAppear()
    }
    
    private var goalsStep: some View {
        VStack(spacing: 24) {
            Text("Set Your Goals")
                .font(BFDesignSystem.Typography.titleLarge)
                .foregroundColor(.white)
            
            Text("What do you want to achieve?")
                .font(BFDesignSystem.Typography.bodyLarge)
                .foregroundColor(.white.opacity(0.8))
            
            VStack(spacing: 16) {
                ForEach(viewModel.goals.indices, id: \.self) { index in
                    TextField("Goal \(index + 1)", text: $viewModel.goals[index])
                        .textFieldStyle(OnboardingTextFieldStyle())
                }
                
                if viewModel.goals.count < 3 {
                    Button(action: { viewModel.addGoal() }) {
                        Label("Add Another Goal", systemImage: "plus.circle.fill")
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 24)
        }
        .slideUpOnAppear()
    }
    
    private var sportsStep: some View {
        VStack(spacing: 24) {
            Text("Select Your Sports")
                .font(BFDesignSystem.Typography.titleLarge)
                .foregroundColor(.white)
            
            Text("Which sports do you typically bet on?")
                .font(BFDesignSystem.Typography.bodyLarge)
                .foregroundColor(.white.opacity(0.8))
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(Sport.allCases) { sport in
                    SportButton(
                        sport: sport,
                        isSelected: viewModel.selectedSports.contains(sport)
                    ) {
                        viewModel.toggleSport(sport)
                    }
                }
            }
            .padding(.horizontal, 24)
        }
        .slideUpOnAppear()
    }
    
    private var featuresStep: some View {
        VStack(spacing: 24) {
            Text("Powerful Features")
                .font(BFDesignSystem.Typography.titleLarge)
                .foregroundColor(.white)
            
            VStack(spacing: 20) {
                FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Progress Tracking", description: "Monitor your journey with detailed insights")
                FeatureRow(icon: "brain.head.profile", title: "Craving Management", description: "Tools to handle betting urges effectively")
                FeatureRow(icon: "dollarsign.circle.fill", title: "Savings Calculator", description: "See how much you're saving")
                FeatureRow(icon: "trophy.fill", title: "Achievement System", description: "Celebrate your milestones")
            }
            .padding(.horizontal, 24)
        }
        .slideUpOnAppear()
    }
    
    private var trialStep: some View {
        VStack(spacing: 24) {
            Text("Start Your Journey")
                .font(BFDesignSystem.Typography.titleLarge)
                .foregroundColor(.white)
            
            VStack(spacing: 20) {
                Text("Try BetFree Premium Free")
                    .font(BFDesignSystem.Typography.displaySmall)
                    .foregroundColor(.white)
                
                Text("7 days free trial")
                    .font(BFDesignSystem.Typography.titleMedium)
                    .foregroundColor(.white.opacity(0.8))
                
                VStack(spacing: 12) {
                    PremiumFeatureRow(text: "Unlimited progress tracking")
                    PremiumFeatureRow(text: "Advanced analytics")
                    PremiumFeatureRow(text: "Personalized strategies")
                    PremiumFeatureRow(text: "Priority support")
                }
                .padding(.vertical, 20)
            }
            .padding(.horizontal, 24)
        }
        .slideUpOnAppear()
    }
    
    private var navigationButtons: some View {
        HStack(spacing: 16) {
            if viewModel.currentStep != .welcome {
                Button(action: viewModel.previousStep) {
                    Text("Back")
                        .font(BFDesignSystem.Typography.labelLarge)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
            
            Button(action: {
                if viewModel.currentStep == .trial {
                    viewModel.completeOnboarding()
                    appState.completeOnboarding()
                } else {
                    viewModel.nextStep()
                }
            }) {
                Text(viewModel.currentStep == .trial ? "Start Free Trial" : "Continue")
                    .font(BFDesignSystem.Typography.labelLarge)
                    .foregroundColor(BFDesignSystem.Colors.primary)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
    }
}

// MARK: - Supporting Views
private struct OnboardingTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white)
            .cornerRadius(12)
    }
}

private struct SportButton: View {
    let sport: Sport
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: sport.iconName)
                    .font(.system(size: 32))
                Text(sport.name)
                    .font(BFDesignSystem.Typography.labelMedium)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSelected ? Color.white : Color.white.opacity(0.2))
            .foregroundColor(isSelected ? BFDesignSystem.Colors.primary : .white)
            .cornerRadius(12)
        }
    }
}

private struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(.white)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(BFDesignSystem.Typography.titleSmall)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

private struct PremiumFeatureRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.white)
            
            Text(text)
                .font(BFDesignSystem.Typography.bodyLarge)
                .foregroundColor(.white)
        }
    }
}

// MARK: - ViewModel
@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .welcome
    @Published var name = ""
    @Published var email = ""
    @Published var dailyLimit = ""
    @Published var goals: [String] = [""]
    @Published var selectedSports: Set<Sport> = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var showError = false
    
    func nextStep() {
        withAnimation {
            if let nextIndex = OnboardingStep(rawValue: currentStep.rawValue + 1) {
                currentStep = nextIndex
            }
        }
    }
    
    func previousStep() {
        withAnimation {
            if let prevIndex = OnboardingStep(rawValue: currentStep.rawValue - 1) {
                currentStep = prevIndex
            }
        }
    }
    
    func toggleSport(_ sport: Sport) {
        if selectedSports.contains(sport) {
            selectedSports.remove(sport)
        } else {
            selectedSports.insert(sport)
        }
    }
    
    func addGoal() {
        goals.append("")
    }
    
    func completeOnboarding() {
        isLoading = true
        // Save onboarding data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
        }
    }
}
