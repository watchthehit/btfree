import SwiftUI
import BetFreeUI
import BetFreeModels

public struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel: OnboardingViewModel
    @State private var showPaywall = false
    
    @MainActor
    public init() {
        print("Initializing OnboardingView...")
        _viewModel = StateObject(wrappedValue: OnboardingViewModel(dataManager: CoreDataManager.shared))
        print("OnboardingView initialized with viewModel")
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [BFDesignSystem.Colors.primary, BFDesignSystem.Colors.primary.opacity(0.6)],
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
                    .padding(.top, geometry.safeAreaInsets.top + 16)
                    .padding(.bottom, 24)
                    
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
        .onAppear {
            print("OnboardingView appeared, updating AppState and DataManager...")
            viewModel.updateAppState(appState)
            viewModel.updateDataManager(appState.dataManager)
            print("AppState and DataManager updated in viewModel")
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {
                viewModel.error = nil
            }
        } message: {
            if let error = viewModel.error {
                Text(error)
            }
        }
    }
    
    private var welcomeStep: some View {
        VStack(spacing: Dimensions.standardSpacing * 1.5) {
            Spacer()
            
            // Animated logo
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: Dimensions.iconSize * 3.75, height: Dimensions.iconSize * 3.75)
                    .scaleEffect(viewModel.isAnimating ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: viewModel.isAnimating)
                
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: Dimensions.iconSize * 2.5))
                    .foregroundColor(.white)
                    .scaleEffect(viewModel.isAnimating ? 1.1 : 0.9)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6).repeatForever(autoreverses: true), value: viewModel.isAnimating)
            }
            .onAppear { viewModel.isAnimating = true }
            
            VStack(spacing: Dimensions.standardSpacing) {
                Text("Welcome to BetFree")
                    .font(BFDesignSystem.Typography.displayLarge)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Your journey to freedom starts here")
                    .font(BFDesignSystem.Typography.titleMedium)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            // Success Story
            VStack(spacing: Dimensions.standardSpacing) {
                Text("💪 Success Story")
                    .font(BFDesignSystem.Typography.labelLarge)
                    .foregroundColor(.white)
                
                Text("\"I've saved $12,450 and been bet-free for 185 days using BetFree\"")
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .standardBox()
            }
            
            Spacer()
            
            // Key Statistics
            HStack(spacing: Dimensions.standardSpacing) {
                StatisticView(value: "89%", label: "Success Rate")
                StatisticView(value: "50K+", label: "Users")
                StatisticView(value: "$2.5M", label: "Saved")
            }
        }
        .padding(.horizontal, Dimensions.standardPadding)
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
            .padding(.top, 16)
            
            VStack(spacing: 24) {
                // Trust badges
                HStack(spacing: 12) {
                    TrustBadge(icon: "checkmark.shield.fill", text: "Privacy First")
                    TrustBadge(icon: "lock.fill", text: "Secure")
                    TrustBadge(icon: "hand.raised.fill", text: "No Gambling Ads")
                }
                
                // Sign in with Apple button
                Button(action: {
                    Task {
                        do {
                            try await viewModel.signInWithApple()
                        } catch {
                            viewModel.error = error.localizedDescription
                            viewModel.showError = true
                        }
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "apple.logo")
                            .font(.system(size: 18))
                        Text("Continue with Apple")
                            .font(BFDesignSystem.Typography.labelLarge)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
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
                .padding(.horizontal, 8)
                
                // Email signup form
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Full Name")
                            .font(BFDesignSystem.Typography.labelMedium)
                            .foregroundColor(.white)
                        TextField("", text: $viewModel.name)
                            .textFieldStyle(OnboardingTextFieldStyle())
                            #if os(iOS)
                            .textContentType(.name)
                            #endif
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Email")
                            .font(BFDesignSystem.Typography.labelMedium)
                            .foregroundColor(.white)
                        TextField("", text: $viewModel.email)
                            .textFieldStyle(OnboardingTextFieldStyle())
                            #if os(iOS)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            #endif
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Password")
                            .font(BFDesignSystem.Typography.labelMedium)
                            .foregroundColor(.white)
                        SecureField("", text: $viewModel.password)
                            .textFieldStyle(OnboardingTextFieldStyle())
                            #if os(iOS)
                            .textContentType(.newPassword)
                            #endif
                    }
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
    
    private struct TrustBadge: View {
        let icon: String
        let text: String
        
        var body: some View {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                Text(text)
                    .font(BFDesignSystem.Typography.bodySmall)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.1))
            .foregroundColor(.white)
            .cornerRadius(16)
        }
    }
    
    private struct OnboardingTextFieldStyle: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .frame(height: 56)
                .padding(.horizontal, 16)
                .background(Color.white)
                .cornerRadius(12)
        }
    }
    
    private var dailyLimitStep: some View {
        VStack(spacing: Dimensions.standardSpacing) {
            // Header
            VStack(spacing: Dimensions.smallSpacing) {
                Text("Stay in control of your spending")
                    .font(BFDesignSystem.Typography.titleLarge)
                    .foregroundColor(.white)
            }
            .padding(.top, Dimensions.standardSpacing)
            
            // Amount display
            VStack(spacing: Dimensions.smallSpacing) {
                Text("$\(Int(viewModel.dailyLimitDouble))")
                    .font(BFDesignSystem.Typography.displayLarge)
                    .foregroundColor(.white)
                    .contentTransition(.numericText())
                
                Text("per day")
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Dimensions.standardSpacing)
            .background(Color.white.opacity(0.08))
            .cornerRadius(Dimensions.cornerRadius)
            
            // Custom slider
            CustomSlider(value: $viewModel.dailyLimitDouble, range: 1...1000)
                .frame(height: 24)
                .padding(.horizontal, Dimensions.standardSpacing * 0.5)
            
            // Preset buttons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Dimensions.standardSpacing * 0.75) {
                    ForEach([50, 100, 200, 500], id: \.self) { amount in
                        Button(action: { 
                            withAnimation {
                                viewModel.dailyLimitDouble = Double(amount)
                            }
                        }) {
                            Text("$\(amount)")
                                .font(BFDesignSystem.Typography.titleMedium)
                                .foregroundColor(viewModel.dailyLimitDouble == Double(amount) ? BFDesignSystem.Colors.primary : .white)
                                .frame(width: 80, height: 40)
                                .background(viewModel.dailyLimitDouble == Double(amount) ? Color.white : Color.white.opacity(0.08))
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal, Dimensions.standardSpacing)
            }
            
            // Savings projection
            VStack(spacing: Dimensions.standardSpacing) {
                Text("Potential Monthly Savings")
                    .font(BFDesignSystem.Typography.titleMedium)
                    .foregroundColor(.white)
                
                HStack(spacing: Dimensions.standardSpacing) {
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
                        icon: "calendar.circle"
                    )
                }
            }
            .padding(Dimensions.standardSpacing)
            .background(Color.white.opacity(0.08))
            .cornerRadius(Dimensions.cornerRadius)
            
            Spacer(minLength: 0)
            
            Text("You can adjust this anytime in settings")
                .font(BFDesignSystem.Typography.bodySmall)
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.horizontal, Dimensions.standardSpacing)
    }

    private struct CustomSlider: View {
        @Binding var value: Double
        let range: ClosedRange<Double>
        @State private var isDragging = false
        
        var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Track
                    Capsule()
                        .fill(Color.white.opacity(0.15))
                        .frame(height: 6)
                    
                    // Fill
                    Capsule()
                        .fill(Color.white)
                        .frame(width: thumbPosition(in: geometry), height: 6)
                    
                    // Thumb
                    Circle()
                        .fill(Color.white)
                        .frame(width: 24, height: 24)
                        .shadow(color: Color.black.opacity(isDragging ? 0.2 : 0.1), 
                               radius: isDragging ? 6 : 3, 
                               x: 0, 
                               y: isDragging ? 3 : 1)
                        .offset(x: thumbPosition(in: geometry) - 12)
                        .scaleEffect(isDragging ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3), value: isDragging)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { gesture in
                                    isDragging = true
                                    updateValue(gesture: gesture, in: geometry)
                                }
                                .onEnded { _ in
                                    isDragging = false
                                }
                        )
                }
            }
        }
        
        private func thumbPosition(in geometry: GeometryProxy) -> CGFloat {
            let percent = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
            return max(12, min(geometry.size.width - 12, geometry.size.width * CGFloat(percent)))
        }
        
        private func updateValue(gesture: DragGesture.Value, in geometry: GeometryProxy) {
            let width = geometry.size.width - 24 // Account for thumb width
            let xPos = gesture.location.x - 12 // Center of thumb
            let percent = max(0, min(1, xPos / width))
            value = range.lowerBound + (range.upperBound - range.lowerBound) * Double(percent)
        }
    }

    private struct SavingsProjection: View {
        let period: String
        let amount: Double
        let icon: String
        
        private var formattedAmount: String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: amount)) ?? "\(Int(amount))"
        }
        
        var body: some View {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                
                Text(period)
                    .font(BFDesignSystem.Typography.bodySmall)
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                
                Text("$\(formattedAmount)")
                    .font(BFDesignSystem.Typography.titleSmall)
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
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
        VStack(spacing: 0) {
            Text("Which sports do you typically bet on?")
                .font(BFDesignSystem.Typography.displayMedium)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 48)
                .padding(.bottom, 32)
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: 12
                ) {
                    ForEach(Sport.allCases) { sport in
                        SportButton(
                            sport: sport,
                            isSelected: viewModel.selectedSports.contains(sport)
                        ) {
                            viewModel.toggleSport(sport)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            
            Spacer()
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
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                    Text(sport.name)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .background(Color.white.opacity(0.1))
                .cornerRadius(16)
            }
        }
    }
    
    private var featuresStep: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Transform Your Life")
                        .font(BFDesignSystem.Typography.titleLarge)
                        .foregroundColor(.white)
                        .padding(.top, 8)
                }
                
                // Features section
                VStack(spacing: 16) {
                    FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Progress Tracking", description: "Monitor your journey with detailed insights")
                    FeatureRow(icon: "brain.head.profile", title: "Craving Management", description: "Tools to handle betting urges effectively")
                    FeatureRow(icon: "dollarsign.circle.fill", title: "Savings Calculator", description: "See how much you're saving")
                    FeatureRow(icon: "trophy.fill", title: "Achievement System", description: "Celebrate your milestones")
                }
                .padding(.horizontal, 24)
                
                // Pricing section
                VStack(spacing: 16) {
                    Text("Choose Your Plan")
                        .font(BFDesignSystem.Typography.titleMedium)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 16) {
                        // Monthly plan
                        PlanCard(
                            title: "Monthly",
                            price: "$9.99",
                            period: "month",
                            isSelected: viewModel.selectedPlan == .monthly,
                            action: { viewModel.selectedPlan = .monthly }
                        )
                        
                        // Yearly plan
                        PlanCard(
                            title: "Yearly",
                            price: "$59.99",
                            period: "year",
                            savings: "Save 50%",
                            isSelected: viewModel.selectedPlan == .yearly,
                            action: { viewModel.selectedPlan = .yearly }
                        )
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 8)
                
                // Trial section
                VStack(spacing: 12) {
                    Button(action: {
                        Task {
                            do {
                                try await viewModel.completeOnboarding()
                            } catch {
                                viewModel.error = error.localizedDescription
                                viewModel.showError = true
                            }
                        }
                    }) {
                        Text("Start 7-Day Free Trial")
                            .font(BFDesignSystem.Typography.titleMedium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                    }
                    .disabled(viewModel.isLoading)
                    
                    Text("Cancel anytime. No commitment required.")
                        .font(BFDesignSystem.Typography.bodyMedium)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 16)
                .padding(.horizontal, 24)
                
                if viewModel.isLoading {
                    SwiftUI.ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                        .padding(.top, 8)
                }
                
                // Terms and privacy
                Text("By continuing, you agree to our Terms of Service and Privacy Policy")
                    .font(BFDesignSystem.Typography.bodySmall)
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
            }
            .padding(.bottom, 32)
        }
        .slideUpOnAppear()
    }
    
    private struct PlanCard: View {
        let title: String
        let price: String
        let period: String
        var savings: String? = nil
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                VStack(spacing: 8) {
                    Text(title)
                        .font(BFDesignSystem.Typography.titleSmall)
                    
                    Text(price)
                        .font(BFDesignSystem.Typography.displaySmall)
                    
                    Text("per \(period)")
                        .font(BFDesignSystem.Typography.bodySmall)
                    
                    if let savings = savings {
                        Text(savings)
                            .font(BFDesignSystem.Typography.labelMedium)
                            .foregroundColor(BFDesignSystem.Colors.success)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(BFDesignSystem.Colors.success.opacity(0.2))
                            .cornerRadius(12)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(isSelected ? Color.white : Color.white.opacity(0.1))
                .foregroundColor(isSelected ? BFDesignSystem.Colors.primary : .white)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
                )
            }
        }
    }
    
    private var navigationButtons: some View {
        HStack {
            if viewModel.currentStep != .welcome {
                Button(action: { viewModel.previousStep() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.white)
                    .frame(height: Dimensions.buttonHeight)
                    .padding(.horizontal, Dimensions.standardPadding)
                }
            }
            
            Spacer()
            
            if viewModel.currentStep == .features {
                Button(action: {
                    Task {
                        do {
                            try await viewModel.completeOnboarding()
                        } catch {
                            viewModel.error = error.localizedDescription
                            viewModel.showError = true
                        }
                    }
                }) {
                    Text("Get Started")
                        .font(BFDesignSystem.Typography.labelLarge)
                        .frame(width: 160)
                }
                .standardButton(isSelected: true)
                .disabled(viewModel.isLoading)
            } else {
                Button(action: { viewModel.nextStep() }) {
                    HStack {
                        Text("Continue")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.white)
                    .frame(height: Dimensions.buttonHeight)
                    .padding(.horizontal, Dimensions.standardPadding)
                }
            }
        }
        .padding(.horizontal, Dimensions.standardPadding)
    }
}

// MARK: - Supporting Views
private struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: Dimensions.standardSpacing) {
            Image(systemName: icon)
                .font(.system(size: Dimensions.iconSize))
                .foregroundColor(.white)
                .frame(width: Dimensions.iconSize)
            
            VStack(alignment: .leading, spacing: Dimensions.smallSpacing) {
                Text(title)
                    .font(BFDesignSystem.Typography.titleSmall)
                    .foregroundColor(.white)
                Text(description)
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .standardBox()
    }
}

// MARK: - ViewModel
@MainActor
final class OnboardingViewModel: ObservableObject {
    enum SubscriptionPlan {
        case monthly
        case yearly
    }
    
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
    @Published var selectedPlan: SubscriptionPlan = .monthly
    
    private var dataManager: BetFreeDataManager
    private weak var appState: AppState?
    
    init(dataManager: BetFreeDataManager) {
        print("📱 Initializing OnboardingViewModel with dataManager")
        self.dataManager = dataManager
    }
    
    func updateAppState(_ newAppState: AppState) {
        print("📱 Updating AppState in OnboardingViewModel")
        self.appState = newAppState
    }
    
    func updateDataManager(_ newDataManager: BetFreeDataManager) {
        print("📱 Updating DataManager in OnboardingViewModel")
        self.dataManager = newDataManager
    }
    
    func completeOnboarding() async throws {
        print("📱 Starting onboarding completion...")
        guard let appState = appState else {
            print("❌ AppState is nil!")
            throw OnboardingError.appStateNotFound
        }
        
        print("📱 Validating fields...")
        // Validate required fields
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { 
            print("❌ Name is empty")
            throw OnboardingError.nameRequired 
        }
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { 
            print("❌ Email is empty")
            throw OnboardingError.emailRequired 
        }
        guard !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { 
            print("❌ Password is empty")
            throw OnboardingError.passwordRequired 
        }
        guard let firstGoal = goals.first, !firstGoal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { 
            print("❌ No goals set")
            throw OnboardingError.goalRequired 
        }
        guard !selectedSports.isEmpty else { 
            print("❌ No sports selected")
            throw OnboardingError.sportsRequired 
        }
        
        print("✅ All fields validated, proceeding with onboarding completion...")
        await MainActor.run {
            isLoading = true
            error = nil
            showError = false
        }
        
        do {
            print("📱 Saving user data...")
            // Save user data
            try await dataManager.createOrUpdateUser(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                dailyLimit: dailyLimitDouble
            )
            
            print("📱 Updating app state...")
            // Update app state on the main actor
            await MainActor.run {
                appState.completeOnboarding()
                appState.username = name.trimmingCharacters(in: .whitespacesAndNewlines)
                appState.dailyLimit = dailyLimitDouble
                appState.preferredSports = Array(selectedSports.map(\.rawValue))
                isLoading = false
                print("✅ App state updated successfully")
            }
            
            print("✅ Onboarding completed successfully")
        } catch {
            await MainActor.run {
                isLoading = false
                self.error = error.localizedDescription
                showError = true
            }
            print("❌ Error during onboarding completion: \(error)")
            throw error
        }
    }
    
    func signInWithApple() async throws {
        isLoading = true
        
        do {
            // Simulate authentication
            try await Task.sleep(for: .seconds(1))
            isLoading = false
            nextStep()
        } catch {
            isLoading = false
            throw error
        }
    }
    
    func nextStep() {
        if let nextIndex = OnboardingStep(rawValue: currentStep.rawValue + 1) {
            withAnimation {
                currentStep = nextIndex
            }
        }
    }
    
    func previousStep() {
        if let prevIndex = OnboardingStep(rawValue: currentStep.rawValue - 1) {
            withAnimation {
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
    
    enum OnboardingError: LocalizedError {
        case appStateNotFound
        case nameRequired
        case emailRequired
        case passwordRequired
        case goalRequired
        case sportsRequired
        
        var errorDescription: String? {
            switch self {
            case .appStateNotFound:
                return "Internal error: App state not found"
            case .nameRequired:
                return "Please enter your name"
            case .emailRequired:
                return "Please enter your email"
            case .passwordRequired:
                return "Please enter a password"
            case .goalRequired:
                return "Please set at least one goal"
            case .sportsRequired:
                return "Please select at least one sport"
            }
        }
    }
}

// MARK: - Standard Dimensions and Styles
private enum Dimensions {
    static let buttonHeight: CGFloat = 56
    static let standardPadding: CGFloat = 24
    static let cornerRadius: CGFloat = 12
    static let boxHeight: CGFloat = 64
    static let iconSize: CGFloat = 32
    static let standardSpacing: CGFloat = 16
    static let smallSpacing: CGFloat = 8
}

// MARK: - Standard Button Style
private struct StandardButtonStyle: ViewModifier {
    let isSelected: Bool
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: Dimensions.buttonHeight)
            .background(isSelected ? Color.white : Color.white.opacity(0.1))
            .foregroundColor(isSelected ? BFDesignSystem.Colors.primary : .white)
            .cornerRadius(Dimensions.cornerRadius)
            .shadow(color: isSelected ? Color.black.opacity(0.1) : .clear, radius: 8, x: 0, y: 4)
    }
}

// MARK: - Standard Box Style
private struct StandardBoxStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(Dimensions.standardPadding)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.1))
            .cornerRadius(Dimensions.cornerRadius)
    }
}

extension View {
    func standardButton(isSelected: Bool = false) -> some View {
        modifier(StandardButtonStyle(isSelected: isSelected))
    }
    
    func standardBox() -> some View {
        modifier(StandardBoxStyle())
    }
}
