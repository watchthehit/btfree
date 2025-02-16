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
                        
                        // Sign Up
                        personalInfoStep
                            .tag(OnboardingStep.signUp)
                        
                        // Daily Limit
                        dailyLimitStep
                            .tag(OnboardingStep.dailyLimit)
                        
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
            
            // Animated logo
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 120, height: 120)
                    .scaleEffect(viewModel.isAnimating ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: viewModel.isAnimating)
                
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .scaleEffect(viewModel.isAnimating ? 1.1 : 0.9)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6).repeatForever(autoreverses: true), value: viewModel.isAnimating)
            }
            .onAppear { viewModel.isAnimating = true }
            
            VStack(spacing: 16) {
                Text("Welcome to BetFree")
                    .font(BFDesignSystem.Typography.displayLarge)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Your journey to freedom starts here")
                    .font(BFDesignSystem.Typography.titleMedium)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .transition(.opacity.combined(with: .move(edge: .bottom)))
            
            // Success Story
            VStack(spacing: 12) {
                Text("💪 Success Story")
                    .font(BFDesignSystem.Typography.labelLarge)
                    .foregroundColor(.white)
                
                Text("\"I've saved $12,450 and been bet-free for 185 days using BetFree\"")
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
            }
            .padding(.top, 32)
            .transition(.scale.combined(with: .opacity))
            
            Spacer()
            
            // Key Statistics
            HStack(spacing: 20) {
                StatisticView(value: "89%", label: "Success Rate")
                StatisticView(value: "50K+", label: "Users")
                StatisticView(value: "$2.5M", label: "Saved")
            }
            .padding(.bottom, 32)
        }
        .padding(.horizontal, 24)
        .slideUpOnAppear()
    }
    
    private struct StatisticView: View {
        let value: String
        let label: String
        
        var body: some View {
            VStack(spacing: 4) {
                Text(value)
                    .font(BFDesignSystem.Typography.titleLarge)
                    .foregroundColor(.white)
                Text(label)
                    .font(BFDesignSystem.Typography.bodySmall)
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    private var personalInfoStep: some View {
        VStack(spacing: 32) {
            VStack(spacing: 8) {
                Text("Join BetFree")
                    .font(BFDesignSystem.Typography.titleLarge)
                    .foregroundColor(.white)
                
                Text("Join 50,000+ people who've taken control")
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 24) {
                // Trust badges
                HStack(spacing: 16) {
                    TrustBadge(icon: "checkmark.shield.fill", text: "Privacy First")
                    TrustBadge(icon: "lock.fill", text: "Secure")
                    TrustBadge(icon: "hand.raised.fill", text: "No Gambling Ads")
                }
                
                // Sign in with Apple button
                Button(action: { viewModel.signInWithApple() }) {
                    HStack {
                        Image(systemName: "apple.logo")
                            .font(.title2)
                        Text("Continue with Apple")
                            .font(BFDesignSystem.Typography.labelLarge)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                }
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                
                // Or divider
                HStack {
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 1)
                    Text("or")
                        .font(BFDesignSystem.Typography.bodyMedium)
                        .foregroundColor(.white.opacity(0.8))
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 1)
                }
                
                // Email signup form
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Full Name")
                            .font(BFDesignSystem.Typography.labelMedium)
                            .foregroundColor(.white)
                        TextField("", text: $viewModel.name)
                            .textFieldStyle(OnboardingTextFieldStyle())
                            .textContentType(.name)
                            .autocapitalization(.words)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(BFDesignSystem.Typography.labelMedium)
                            .foregroundColor(.white)
                        TextField("", text: $viewModel.email)
                            .textFieldStyle(OnboardingTextFieldStyle())
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(BFDesignSystem.Typography.labelMedium)
                            .foregroundColor(.white)
                        SecureField("", text: $viewModel.password)
                            .textFieldStyle(OnboardingTextFieldStyle())
                            .textContentType(.newPassword)
                    }
                }
            }
            .padding(.horizontal, 24)
            
            if viewModel.isLoading {
                SwiftUI.ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
            }
            
            if let error = viewModel.error {
                Text(error)
                    .font(BFDesignSystem.Typography.bodySmall)
                    .foregroundColor(.red)
                    .padding(.top, 8)
            }
            
            // Privacy note
            Text("By continuing, you agree to our Terms of Service and Privacy Policy")
                .font(BFDesignSystem.Typography.bodySmall)
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .slideUpOnAppear()
    }
    
    private struct TrustBadge: View {
        let icon: String
        let text: String
        
        var body: some View {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                Text(text)
                    .font(BFDesignSystem.Typography.labelSmall)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.1))
            .foregroundColor(.white)
            .cornerRadius(16)
        }
    }
    
    private var dailyLimitStep: some View {
        VStack(spacing: 32) {
            VStack(spacing: 8) {
                Text("Set Your Daily Limit")
                    .font(BFDesignSystem.Typography.titleLarge)
                    .foregroundColor(.white)
                
                Text("Stay in control of your spending")
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 32) {
                // Amount display
                VStack(spacing: 8) {
                    Text("$\(viewModel.dailyLimitDouble, specifier: "%.0f")")
                        .font(BFDesignSystem.Typography.displayLarge)
                        .foregroundColor(.white)
                    
                    Text("per day")
                        .font(BFDesignSystem.Typography.bodyMedium)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                // Custom slider
                CustomSlider(value: $viewModel.dailyLimitDouble, range: 1...1000)
                    .frame(height: 40)
                
                // Preset buttons
                HStack(spacing: 12) {
                    ForEach([50, 100, 200, 500], id: \.self) { amount in
                        Button(action: { viewModel.dailyLimitDouble = Double(amount) }) {
                            Text("$\(amount)")
                                .font(BFDesignSystem.Typography.labelMedium)
                                .foregroundColor(viewModel.dailyLimitDouble == Double(amount) ? BFDesignSystem.Colors.primary : .white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(viewModel.dailyLimitDouble == Double(amount) ? Color.white : Color.white.opacity(0.1))
                                .cornerRadius(20)
                        }
                    }
                }
                
                // Savings projection
                VStack(spacing: 16) {
                    Text("Potential Monthly Savings")
                        .font(BFDesignSystem.Typography.titleSmall)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 20) {
                        SavingsProjection(
                            period: "1 Month",
                            amount: viewModel.dailyLimitDouble * 30,
                            icon: "calendar"
                        )
                        
                        SavingsProjection(
                            period: "6 Months",
                            amount: viewModel.dailyLimitDouble * 180,
                            icon: "calendar.badge.plus"
                        )
                        
                        SavingsProjection(
                            period: "1 Year",
                            amount: viewModel.dailyLimitDouble * 365,
                            icon: "calendar.circle.fill"
                        )
                    }
                }
                .padding(.vertical, 16)
                .background(Color.white.opacity(0.1))
                .cornerRadius(16)
            }
            .padding(.horizontal, 24)
            
            Text("You can adjust this anytime in settings")
                .font(BFDesignSystem.Typography.bodySmall)
                .foregroundColor(.white.opacity(0.6))
        }
        .slideUpOnAppear()
    }
    
    private struct CustomSlider: View {
        @Binding var value: Double
        let range: ClosedRange<Double>
        
        var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Track
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .cornerRadius(12)
                    
                    // Fill
                    Rectangle()
                        .fill(Color.white)
                        .cornerRadius(12)
                        .frame(width: thumbPosition(in: geometry))
                    
                    // Thumb
                    Circle()
                        .fill(Color.white)
                        .frame(width: 28, height: 28)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .offset(x: thumbPosition(in: geometry) - 14)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { gesture in
                                    updateValue(gesture: gesture, in: geometry)
                                }
                        )
                }
            }
        }
        
        private func thumbPosition(in geometry: GeometryProxy) -> CGFloat {
            let percent = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
            return geometry.size.width * CGFloat(percent)
        }
        
        private func updateValue(gesture: DragGesture.Value, in geometry: GeometryProxy) {
            let width = geometry.size.width
            let percent = max(0, min(1, gesture.location.x / width))
            value = range.lowerBound + (range.upperBound - range.lowerBound) * Double(percent)
        }
    }

    private struct SavingsProjection: View {
        let period: String
        let amount: Double
        let icon: String
        
        var body: some View {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                
                Text(period)
                    .font(BFDesignSystem.Typography.labelMedium)
                    .foregroundColor(.white)
                
                Text("$\(amount, specifier: "%.0f")")
                    .font(BFDesignSystem.Typography.titleMedium)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var goalsStep: some View {
        VStack(spacing: 32) {
            VStack(spacing: 8) {
                Text("Set Your Goals")
                    .font(BFDesignSystem.Typography.titleLarge)
                    .foregroundColor(.white)
                
                Text("What do you want to achieve?")
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            VStack(spacing: 24) {
                // Goal input section
                VStack(spacing: 16) {
                    ForEach(viewModel.goals.indices, id: \.self) { index in
                        GoalInputRow(
                            goal: $viewModel.goals[index],
                            placeholder: "Goal \(index + 1)",
                            suggestions: goalSuggestions(for: index)
                        )
                    }
                }
                
                if viewModel.goals.count < 3 {
                    Button(action: { viewModel.addGoal() }) {
                        Label("Add Another Goal", systemImage: "plus.circle.fill")
                            .font(BFDesignSystem.Typography.labelLarge)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(20)
                    }
                }
                
                // Milestone preview
                if !viewModel.goals.isEmpty {
                    VStack(spacing: 16) {
                        Text("Your Journey Milestones")
                            .font(BFDesignSystem.Typography.titleSmall)
                            .foregroundColor(.white)
                        
                        VStack(spacing: 12) {
                            ForEach(viewModel.goals.indices, id: \.self) { index in
                                if !viewModel.goals[index].isEmpty {
                                    MilestoneRow(
                                        goal: viewModel.goals[index],
                                        timeframe: ["1 month", "3 months", "6 months"][index]
                                    )
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(16)
                }
            }
            .padding(.horizontal, 24)
            
            // Motivation quote
            Text("\"Every goal achieved is a step towards freedom\"")
                .font(BFDesignSystem.Typography.bodyMedium)
                .foregroundColor(.white.opacity(0.8))
                .italic()
                .padding(.top, 16)
        }
        .slideUpOnAppear()
    }

    private struct GoalInputRow: View {
        @Binding var goal: String
        let placeholder: String
        let suggestions: [String]
        @State private var showSuggestions = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                TextField(placeholder, text: $goal)
                    .textFieldStyle(OnboardingTextFieldStyle())
                    .onTapGesture {
                        showSuggestions = true
                    }
                
                if showSuggestions && goal.isEmpty {
                    VStack(spacing: 8) {
                        ForEach(suggestions, id: \.self) { suggestion in
                            Button(action: {
                                goal = suggestion
                                showSuggestions = false
                            }) {
                                Text(suggestion)
                                    .font(BFDesignSystem.Typography.bodyMedium)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }

    private struct MilestoneRow: View {
        let goal: String
        let timeframe: String
        
        var body: some View {
            HStack {
                Image(systemName: "flag.fill")
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal)
                        .font(BFDesignSystem.Typography.bodyMedium)
                        .foregroundColor(.white)
                    
                    Text(timeframe)
                        .font(BFDesignSystem.Typography.labelSmall)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
    }

    private func goalSuggestions(for index: Int) -> [String] {
        switch index {
        case 0:
            return [
                "Save $1,000 in betting money",
                "Stay bet-free for 30 days",
                "Delete all betting apps"
            ]
        case 1:
            return [
                "Start a new hobby",
                "Pay off credit card debt",
                "Join a support group"
            ]
        case 2:
            return [
                "Help others quit betting",
                "Build emergency savings",
                "Improve relationships"
            ]
        default:
            return []
        }
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
    @Published var password = ""
    @Published var dailyLimit = ""
    @Published var goals: [String] = [""]
    @Published var selectedSports: Set<Sport> = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var showError = false
    @Published var isAnimating = false
    @Published var dailyLimitDouble: Double = 100.0
    
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
    
    func signInWithApple() {
        isLoading = true
        // TODO: Implement Sign in with Apple
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            self.nextStep()
        }
    }
}
