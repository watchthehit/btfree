import SwiftUI

// MARK: - OnboardingViewModel
@MainActor
class OnboardingViewModel: ObservableObject {
    // MARK: - Constants
    let screens: [OnboardingScreen] = [
        .valueProposition1,
        .valueProposition2,
        .valueProposition3,
        .signIn,
        .personalSetup,
        .notificationPrivacy,
        .paywall,
        .completion
    ]
    
    // MARK: - Published Properties
    @Published var currentScreenIndex = 0
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isSigningInWithApple = false
    @Published var dailyGoal = 20  // Default to 20 minutes
    @Published var userTriggers: [String] = []
    @Published var customTrigger = ""
    @Published var notificationTypes: [OnboardingNotificationType] = [
        OnboardingNotificationType(name: "Daily reminders", detail: "Get daily reminders to practice mindfulness", isEnabled: true),
        OnboardingNotificationType(name: "Progress milestones", detail: "Celebrate when you reach important milestones", isEnabled: true),
        OnboardingNotificationType(name: "Tips & advice", detail: "Receive helpful advice when you need it most", isEnabled: false)
    ]
    @Published var isTrialActive = false
    @Published var trialEndDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    @Published var selectedPlan = 1  // Default to annual plan (used by paywall screens)
    
    // Subscription plans
    let plans = [
        SubscriptionPlan(id: 0, name: "Monthly", price: "$9.99", period: "month", savings: ""),
        SubscriptionPlan(id: 1, name: "Annual", price: "$59.99", period: "year", savings: "Save 50%")
    ]
    
    // Completion callback
    var onComplete: (() -> Void)?
    
    // MARK: - Computed Properties
    var currentScreen: OnboardingScreen {
        screens[currentScreenIndex]
    }
    
    var isFirstScreen: Bool {
        currentScreenIndex == 0
    }
    
    var isLastScreen: Bool {
        currentScreenIndex == screens.count - 1
    }
    
    var screenProgress: Float {
        Float(currentScreenIndex) / Float(screens.count - 1)
    }
    
    var selectedPlanDetails: SubscriptionPlan {
        plans[selectedPlan]
    }
    
    // MARK: - Methods
    func addTrigger() {
        guard !customTrigger.isEmpty,
              !userTriggers.contains(customTrigger),
              userTriggers.count < 5 else {
            return
        }
        
        userTriggers.append(customTrigger)
        customTrigger = ""
    }
    
    func removeTrigger(_ trigger: String) {
        userTriggers.removeAll { $0 == trigger }
    }
    
    // MARK: - Navigation
    func nextScreen() {
        if currentScreenIndex < screens.count - 1 {
            currentScreenIndex += 1
        }
    }
    
    func previousScreen() {
        if currentScreenIndex > 0 {
            currentScreenIndex -= 1
        }
    }
    
    func skipToPaywall() {
        // Find the index of the paywall screen
        if let paywallIndex = screens.firstIndex(of: .paywall) {
            currentScreenIndex = paywallIndex
        }
    }
    
    // MARK: - Authentication
    func signInWithEmail() {
        // In a real app, this would authenticate with a backend service
        print("Signing in with email: \(email)")
        nextScreen()
    }
    
    func signInWithApple() {
        // In a real app, this would trigger Apple authentication
        print("Signing in with Apple")
        isSigningInWithApple = true
        nextScreen()
    }
    
    // MARK: - Data Persistence
    func saveToAppState() {
        // In a real app, you would save this data to UserDefaults, CoreData, or a backend service
        print("Saving user data:")
        print("Email: \(email)")
        print("Username: \(username)")
        print("Daily goal: \(dailyGoal) minutes")
        print("Triggers: \(userTriggers.joined(separator: ", "))")
        print("Notifications enabled: \(notificationTypes.filter { $0.isEnabled }.map { $0.name }.joined(separator: ", "))")
        print("Trial status: \(isTrialActive ? "Active" : "Inactive"), Expires: \(trialEndDate)")
        
        // Set User Defaults for onboarding completion
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        // Call the completion callback if provided
        onComplete?()
    }
}

// MARK: - Main Onboarding View
struct EnhancedOnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    // Add completion handler property
    var onComplete: (() -> Void)?
    
    init(onComplete: (() -> Void)? = nil) {
        self.onComplete = onComplete
    }
    
    var body: some View {
        ZStack {
            // Apply background
            BFColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with navigation and progress
                HStack {
                    if !viewModel.isFirstScreen {
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                viewModel.previousScreen()
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Back")
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(BFColors.primary)
                        }
                    } else {
                        Text("") // Spacer element for alignment
                    }
                    
                    Spacer()
                    
                    // Skip button (only show for value proposition screens)
                    if [OnboardingScreen.valueProposition1, 
                        OnboardingScreen.valueProposition2, 
                        OnboardingScreen.valueProposition3].contains(viewModel.currentScreen) {
                        Button {
                            withAnimation {
                                viewModel.skipToPaywall()
                            }
                        } label: {
                            Text("Skip")
                                .fontWeight(.medium)
                                .foregroundColor(BFColors.textSecondary)
                        }
                    } else {
                        // Linear progress indicator
                        ProgressView(value: viewModel.screenProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: BFColors.textPrimary))
                            .frame(width: 100)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .frame(height: 44)
                
                // Current screen content
                Spacer(minLength: 0)
                
                screenForState(viewModel.currentScreen)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    ))
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.currentScreenIndex)
                
                Spacer(minLength: 0)
            }
        }
        .onAppear {
            // Setup the completion handler for the view model
            viewModel.onComplete = onComplete
        }
    }
    
    // Add method to handle screen content
    @ViewBuilder
    private func screenForState(_ screen: OnboardingScreen) -> some View {
        switch screen {
        case .valueProposition1:
            ValuePropositionView1(viewModel: viewModel)
        case .valueProposition2:
            ValuePropositionView2(viewModel: viewModel)
        case .valueProposition3:
            ValuePropositionView3(viewModel: viewModel)
        case .signIn:
            SignInView(viewModel: viewModel)
        case .personalSetup:
            PersonalSetupView(viewModel: viewModel)
        case .notificationPrivacy:
            NotificationsView(viewModel: viewModel)
        case .paywall:
            PaywallView(viewModel: viewModel)
        case .completion:
            CompletionView(viewModel: viewModel)
        }
    }
}

// MARK: - Value Proposition Views

struct ValuePropositionView1: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateIcon = false
    @State private var animateText = false
    
    var body: some View {
        ZStack {
            // Consistent background style across all screens
            BFBackgroundView(style: .waves, gradient: BFColors.brandGradient())
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Enhanced animated icon/logo with pulsating effect
                ZStack {
                    // Outer pulse effect
                    Circle()
                        .fill(BFColors.accent.opacity(0.15))
                        .frame(width: 140, height: 140)
                        .scaleEffect(animateIcon ? 1.2 : 0.9)
                        .opacity(animateIcon ? 0.6 : 0.0)
                        .animation(
                            Animation.easeInOut(duration: 1.8)
                                .repeatForever(autoreverses: true),
                            value: animateIcon
                        )
                    
                    // Icon container
                    Image(systemName: "heart.fill")
                        .font(.system(size: 70))
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Circle()
                                .fill(BFColors.accent.opacity(0.3))
                                .shadow(color: Color.black.opacity(0.2), radius: 10)
                        )
                        .scaleEffect(animateIcon ? 1.05 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: animateIcon
                        )
                }
                .onAppear {
                    animateIcon = true
                    
                    // Slight delay before text animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        animateText = true
                    }
                }
                
                // Welcome text with improved typography and animation
                VStack(spacing: 20) {
                    Text("Break Free From Gambling")
                        .heading1()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .opacity(animateText ? 1 : 0)
                        .offset(y: animateText ? 0 : 20)
                        .animation(.easeOut(duration: 0.6), value: animateText)
                    
                    Text("Take the first step toward a healthier relationship with gambling through evidence-based tools and support.")
                        .bodyLarge()
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .opacity(animateText ? 1 : 0)
                        .offset(y: animateText ? 0 : 15)
                        .animation(.easeOut(duration: 0.6).delay(0.2), value: animateText)
                }
                
                Spacer()
                
                // Enhanced next button with improved styling
                Button {
                    withAnimation {
                        viewModel.nextScreen()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text("Continue")
                            .font(.headline)
                            
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: BFColors.accent.opacity(0.4), radius: 8, x: 0, y: 4)
                    )
                    .opacity(animateText ? 1 : 0)
                    .offset(y: animateText ? 0 : 20)
                    .animation(.easeOut(duration: 0.5).delay(0.4), value: animateText)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
    }
}

struct ValuePropositionView2: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateChart = false
    
    var body: some View {
        ZStack {
            // Consistent background style across all screens
            BFBackgroundView(style: .waves, gradient: BFColors.brandGradient())
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                // Animated icon/illustration
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 70))
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        Circle()
                            .fill(BFColors.secondary.opacity(0.2))
                            .shadow(color: Color.black.opacity(0.2), radius: 10)
                    )
                    .rotationEffect(Angle(degrees: animateChart ? 5 : -5))
                    .animation(
                        Animation.easeInOut(duration: 2)
                            .repeatForever(autoreverses: true),
                        value: animateChart
                    )
                    .onAppear {
                        animateChart = true
                    }
                
                // Content text with improved typography
                Text("Track Your Progress")
                    .heading1()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text("Monitor your journey with personalized insights and celebrate your milestones along the way.")
                    .bodyLarge()
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Spacer()
                
                // Next button with consistent styling
                Button {
                    withAnimation {
                        viewModel.nextScreen()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text("Continue")
                            .font(.headline)
                            
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: BFColors.accent.opacity(0.4), radius: 8, x: 0, y: 4)
                    )
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
    }
}

struct ValuePropositionView3: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateBrain = false
    
    var body: some View {
        ZStack {
            // Consistent background style across all screens
            BFBackgroundView(style: .waves, gradient: BFColors.brandGradient())
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                // Animated icon/illustration
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 70))
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        Circle()
                            .fill(BFColors.focus.opacity(0.2))
                            .shadow(color: Color.black.opacity(0.2), radius: 10)
                    )
                    .scaleEffect(animateBrain ? 1.05 : 0.95)
                    .animation(
                        Animation.easeInOut(duration: 2)
                            .repeatForever(autoreverses: true),
                        value: animateBrain
                    )
                    .onAppear {
                        animateBrain = true
                    }
                
                // Content text with improved typography
                Text("Find Your Calm")
                    .heading1()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text("Access mindfulness exercises and breathing techniques to help manage urges and reduce stress.")
                    .bodyLarge()
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Spacer()
                
                // Next button with consistent styling
                Button {
                    withAnimation {
                        viewModel.nextScreen()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text("Get Started")
                            .font(.headline)
                            
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: BFColors.accent.opacity(0.4), radius: 8, x: 0, y: 4)
                    )
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
    }
}

// MARK: - Sign In View
struct SignInView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @State private var showingPassword = false
    @State private var animateIcon = false
    @State private var emailErrorMessage: String? = nil
    @State private var passwordErrorMessage: String? = nil
    
    var isEmailValid: Bool {
        viewModel.email.contains("@") && viewModel.email.contains(".")
    }
    
    var isPasswordValid: Bool {
        viewModel.password.count >= 6
    }
    
    var canContinue: Bool {
        isEmailValid && isPasswordValid
    }
    
    var body: some View {
        ZStack {
            // Consistent background style across all screens
            BFBackgroundView(style: .waves, gradient: BFColors.brandGradient())
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 28) {
                    // Animated icon
                    Image(systemName: "person.crop.circle.fill.badge.plus")
                        .font(.system(size: 60))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .shadow(color: Color.black.opacity(0.1), radius: 10)
                        )
                        .scaleEffect(animateIcon ? 1.05 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 1.8)
                                .repeatForever(autoreverses: true),
                            value: animateIcon
                        )
                        .onAppear {
                            animateIcon = true
                        }
                        .padding(.top, 20)

                    // Header text
                    Text("Create Your Account")
                        .heading2()
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                        .multilineTextAlignment(.center)
                    
                    Text("Start your recovery journey with personalized support")
                        .bodyMedium()
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 10)
                    
                    // Input form with improved styling
                    VStack(spacing: 20) {
                        // Email field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(BFTypography.bodySmall)
                                .foregroundColor(.white)
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(isEmailFocused ? BFColors.accent : .white.opacity(0.7))
                                    .font(.system(size: 16))
                                
                                TextField("your@email.com", text: $viewModel.email)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .focused($isEmailFocused)
                                    .foregroundColor(BFColors.textPrimary)
                                    .onChange(of: viewModel.email) { _ in
                                        // Clear error when typing
                                        emailErrorMessage = nil
                                    }
                                
                                if !viewModel.email.isEmpty {
                                    Button(action: {
                                        viewModel.email = ""
                                        emailErrorMessage = nil
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 16))
                                    }
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.9))
                                    .shadow(color: isEmailFocused ? BFColors.accent.opacity(0.4) : Color.black.opacity(0.15), 
                                            radius: isEmailFocused ? 6 : 3, 
                                            x: 0, 
                                            y: isEmailFocused ? 3 : 2)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(emailErrorMessage != nil ? Color.red : (isEmailFocused ? BFColors.accent : Color.clear), lineWidth: 1.5)
                            )
                            
                            if let errorMessage = emailErrorMessage {
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.leading, 4)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Password field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(BFTypography.bodySmall)
                                .foregroundColor(.white)
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(isPasswordFocused ? BFColors.accent : .white.opacity(0.7))
                                    .font(.system(size: 16))
                                
                                if showingPassword {
                                    TextField("Your password", text: $viewModel.password)
                                        .focused($isPasswordFocused)
                                        .foregroundColor(BFColors.textPrimary)
                                        .onChange(of: viewModel.password) { _ in
                                            // Clear error when typing
                                            passwordErrorMessage = nil
                                        }
                                } else {
                                    SecureField("Your password", text: $viewModel.password)
                                        .focused($isPasswordFocused)
                                        .foregroundColor(BFColors.textPrimary)
                                        .onChange(of: viewModel.password) { _ in
                                            // Clear error when typing
                                            passwordErrorMessage = nil
                                        }
                                }
                                
                                Button(action: {
                                    showingPassword.toggle()
                                }) {
                                    Image(systemName: showingPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 16))
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.9))
                                    .shadow(color: isPasswordFocused ? BFColors.accent.opacity(0.4) : Color.black.opacity(0.15), 
                                            radius: isPasswordFocused ? 6 : 3, 
                                            x: 0, 
                                            y: isPasswordFocused ? 3 : 2)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(passwordErrorMessage != nil ? Color.red : (isPasswordFocused ? BFColors.accent : Color.clear), lineWidth: 1.5)
                            )
                            
                            if let errorMessage = passwordErrorMessage {
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.leading, 4)
                            } else if !viewModel.password.isEmpty && viewModel.password.count < 6 {
                                Text("Password must be at least 6 characters")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.leading, 4)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    // Sign in with email button
                    Button {
                        // Validate email and password
                        if !isEmailValid {
                            emailErrorMessage = "Please enter a valid email address"
                        }
                        
                        if !isPasswordValid {
                            passwordErrorMessage = "Password must be at least 6 characters"
                        }
                        
                        if canContinue {
                            viewModel.signInWithEmail()
                        }
                    } label: {
                        HStack {
                            Text("Continue with Email")
                                .font(.headline)
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: canContinue ? 
                                                 [BFColors.accent, BFColors.accent.opacity(0.8)] : 
                                                 [Color.gray.opacity(0.5), Color.gray.opacity(0.3)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: canContinue ? Color.black.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
                        )
                    }
                    .disabled(!canContinue)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    
                    // Divider
                    HStack {
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                            .frame(height: 1)
                        
                        Text("OR")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    
                    // Sign in with Apple button
                    Button {
                        viewModel.signInWithApple()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "apple.logo")
                                .font(.system(size: 20))
                            
                            Text("Continue with Apple")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Color.black
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                        )
                    }
                    .padding(.horizontal, 24)
                    
                    // Terms text
                    Text("By continuing, you agree to our [Terms of Service](https://example.com) and [Privacy Policy](https://example.com)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.top, 16)
                        .padding(.bottom, 32)
                }
            }
        }
        .onTapGesture {
            isEmailFocused = false
            isPasswordFocused = false
        }
    }
}

struct PersonalSetupView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @FocusState private var isUsernameFocused: Bool
    @State private var isAnimating = false
    @State private var selectedGoalPreset: Int? = nil
    
    let goalPresets = [
        (minutes: 10, label: "Quick", description: "Perfect for busy days"),
        (minutes: 20, label: "Standard", description: "Recommended for best results"),
        (minutes: 45, label: "Extended", description: "For deeper practice")
    ]
    
    var body: some View {
        ZStack {
            // Consistent background style across all screens
            BFBackgroundView(style: .waves, gradient: BFColors.brandGradient())
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header with animation
                    VStack(spacing: 12) {
                        Text("Personalize Your Experience")
                            .heading2()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Let's customize the app to fit your needs")
                            .bodyMedium()
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    .padding(.top, 20)
                    
                    // Username field with animation
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What should we call you?")
                            .font(BFTypography.heading3)
                            .foregroundColor(.white)
                        
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(isUsernameFocused ? BFColors.accent : .white.opacity(0.7))
                                .font(.system(size: 16))
                            
                            TextField("Your name", text: $viewModel.username)
                                .font(BFTypography.bodyMedium)
                                .focused($isUsernameFocused)
                                .foregroundColor(BFColors.textPrimary)
                                .submitLabel(.done)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: isUsernameFocused ? BFColors.accent.opacity(0.4) : Color.black.opacity(0.15), 
                                        radius: isUsernameFocused ? 6 : 3, 
                                        x: 0, 
                                        y: isUsernameFocused ? 3 : 2)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isUsernameFocused ? BFColors.accent : Color.clear, lineWidth: 1.5)
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                    
                    // Enhanced daily goal selection
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(BFColors.accent.opacity(0.3))
                                    .frame(width: 36, height: 36)
                                
                                Image(systemName: "timer")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                            }
                            
                            Text("Daily Mindfulness Goal")
                                .font(BFTypography.heading3)
                                .foregroundColor(.white)
                        }
                        
                        // Preset goal buttons
                        VStack(spacing: 10) {
                            Text("Choose a preset:")
                                .font(BFTypography.bodySmall)
                                .foregroundColor(.white.opacity(0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 10) {
                                ForEach(0..<goalPresets.count, id: \.self) { index in
                                    let preset = goalPresets[index]
                                    
                                    Button {
                                        withAnimation(.spring()) {
                                            viewModel.dailyGoal = preset.minutes
                                            selectedGoalPreset = index
                                        }
                                    } label: {
                                        VStack(spacing: 4) {
                                            Text(preset.label)
                                                .font(.system(size: 14, weight: .medium))
                                            
                                            Text("\(preset.minutes) min")
                                                .font(.system(size: 16, weight: .bold))
                                            
                                            Text(preset.description)
                                                .font(.system(size: 10))
                                                .lineLimit(1)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                        .foregroundColor(selectedGoalPreset == index ? BFColors.accent : .white)
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 8)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(selectedGoalPreset == index ? Color.white.opacity(0.9) : Color.white.opacity(0.15))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(selectedGoalPreset == index ? BFColors.accent : Color.clear, lineWidth: 1.5)
                                        )
                                    }
                                }
                            }
                        }
                        
                        // Custom slider for fine adjustment
                        VStack(spacing: 12) {
                            Text("Or customize:")
                                .font(BFTypography.bodySmall)
                                .foregroundColor(.white.opacity(0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Custom slider with minute markers
                            VStack(spacing: 8) {
                                // Slider with animation
                                Slider(value: Binding(
                                    get: { Double(viewModel.dailyGoal) },
                                    set: { 
                                        viewModel.dailyGoal = Int($0)
                                        
                                        // Reset the selected preset if user manually adjusts
                                        if let presetIndex = selectedGoalPreset, 
                                           goalPresets[presetIndex].minutes != viewModel.dailyGoal {
                                            selectedGoalPreset = nil
                                        }
                                    }
                                ), in: 5...60, step: 5)
                                .accentColor(BFColors.accent)
                                .padding(.horizontal, 4)
                                
                                // Minute markers
                                HStack {
                                    Text("5")
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                    Spacer()
                                    
                                    Text("30")
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                    Spacer()
                                    
                                    Text("60")
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .padding(.horizontal, 4)
                            }
                            
                            // Current selection with visual emphasis
                            HStack {
                                Spacer()
                                
                                VStack(spacing: 2) {
                                    Text("\(viewModel.dailyGoal)")
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(.white)
                                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                                        .animation(
                                            Animation.easeInOut(duration: 0.5),
                                            value: viewModel.dailyGoal
                                        )
                                    
                                    Text("minutes daily")
                                        .font(BFTypography.bodySmall)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                Spacer()
                            }
                        }
                        
                        // Enhanced recommendation card
                        HStack(spacing: 12) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(BFColors.accent)
                                .font(.system(size: 16))
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(BFColors.accent.opacity(0.2))
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Pro Tip")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                Text("Consistency is more important than duration. Even a short daily practice can make a big difference.")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.9))
                                    .lineLimit(2)
                            }
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.15))
                                .shadow(color: Color.black.opacity(0.1), radius: 4)
                        )
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.15))
                            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
                    )
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                    
                    // Next button
                    Button {
                        withAnimation {
                            viewModel.nextScreen()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Text("Continue")
                                .font(.headline)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }
            .onAppear {
                // Set initial selection to the recommended preset (20 min)
                if viewModel.dailyGoal == 20 {
                    selectedGoalPreset = 1 // Index of the "Standard" preset
                }
                isAnimating = true
            }
        }
        .onTapGesture {
            isUsernameFocused = false
        }
    }
}

struct NotificationsView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Consistent background style across all screens
            BFBackgroundView(style: .waves, gradient: BFColors.brandGradient())
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Animated notification icon
                    ZStack {
                        // Outer pulse animation
                        ForEach(0..<2) { i in
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 120 + CGFloat(i * 20), height: 120 + CGFloat(i * 20))
                                .scaleEffect(isAnimating ? 1.2 : 0.8)
                                .opacity(isAnimating ? 0.0 : 0.6)
                                .animation(
                                    Animation.easeInOut(duration: 1.5)
                                        .repeatForever(autoreverses: false)
                                        .delay(Double(i) * 0.5),
                                    value: isAnimating
                                )
                        }
                        
                        // Bell icon
                        Image(systemName: "bell.badge.fill")
                            .font(.system(size: 50))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.white)
                            .padding(24)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .shadow(color: Color.black.opacity(0.1), radius: 10)
                            )
                    }
                    .frame(height: 140)
                    .padding(.top, 20)
                    .onAppear {
                        isAnimating = true
                    }
                    
                    // Header with improved typography
                    VStack(spacing: 12) {
                        Text("Stay Connected")
                            .heading2()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Customize your notifications to get the most out of your recovery journey")
                            .bodyMedium()
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    
                    // Visually enhanced notification toggles
                    VStack(spacing: 16) {
                        ForEach(0..<viewModel.notificationTypes.count, id: \.self) { index in
                            let notificationType = viewModel.notificationTypes[index]
                            
                            HStack {
                                // Icon based on notification type
                                Image(systemName: iconFor(index: index))
                                    .font(.system(size: 24))
                                    .foregroundColor(notificationType.isEnabled ? BFColors.accent : .white.opacity(0.5))
                                    .frame(width: 40, height: 40)
                                    .background(
                                        Circle()
                                            .fill(notificationType.isEnabled ? BFColors.accent.opacity(0.2) : Color.white.opacity(0.1))
                                    )
                                
                                // Notification details
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(notificationType.name)
                                        .font(BFTypography.bodyMedium)
                                        .fontWeight(.medium)
                                    
                                    if let detail = notificationType.detail {
                                        Text(detail)
                                            .font(BFTypography.bodySmall)
                                            .foregroundColor(.white.opacity(0.8))
                                            .lineLimit(2)
                                    }
                                }
                                
                                Spacer()
                                
                                // Toggle switch
                                Toggle("", isOn: Binding(
                                    get: { viewModel.notificationTypes[index].isEnabled },
                                    set: { viewModel.notificationTypes[index].isEnabled = $0 }
                                ))
                                .toggleStyle(SwitchToggleStyle(tint: BFColors.accent))
                                .labelsHidden()
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.15))
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            )
                            .padding(.horizontal, 24)
                        }
                    }
                    .padding(.vertical, 10)
                    
                    // Privacy info card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Image(systemName: "lock.shield.fill")
                                .foregroundColor(BFColors.accent)
                                .font(.system(size: 20))
                            
                            Text("Privacy Information")
                                .font(BFTypography.heading3)
                                .foregroundColor(.white)
                        }
                        
                        Text("We value your privacy. All notifications can be customized later in the app settings. No data is ever shared with third parties.")
                            .font(BFTypography.bodySmall)
                            .foregroundColor(.white.opacity(0.8))
                            .lineSpacing(4)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                    
                    Spacer(minLength: 40)
                    
                    // Continue button
                    Button {
                        withAnimation {
                            viewModel.nextScreen()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Text("Continue")
                                .font(.headline)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: BFColors.accent.opacity(0.4), radius: 8, x: 0, y: 4)
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }
        }
    }
    
    // Return appropriate icon for each notification type
    private func iconFor(index: Int) -> String {
        switch index {
        case 0: return "clock.badge.checkmark.fill" // Daily reminders
        case 1: return "chart.bar.fill" // Progress milestones
        case 2: return "lightbulb.fill" // Tips & advice
        default: return "bell.fill"
        }
    }
}

struct PaywallView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateFeatures = false
    
    var body: some View {
        ZStack {
            // Consistent background style across all screens
            BFBackgroundView(style: .waves, gradient: BFColors.brandGradient())
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 28) {
                    // Enhanced header with icon
                    VStack(spacing: 16) {
                        Image(systemName: "star.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                            .background(
                                Circle()
                                    .fill(BFColors.accent.opacity(0.3))
                                    .frame(width: 80, height: 80)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10)
                            )
                            .padding(.top, 20)
                        
                        Text("Unlock Full Access")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Start your recovery journey with premium tools")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    
                    // Enhanced premium features presentation
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Premium Features")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.bottom, 4)
                        
                        EnhancedFeatureRow(
                            icon: "chart.line.uptrend.xyaxis.circle.fill", 
                            text: "Advanced progress tracking",
                            description: "Track your journey with detailed insights",
                            color: BFColors.accent,
                            delay: 0.1
                        )
                        .offset(x: animateFeatures ? 0 : -20)
                        .opacity(animateFeatures ? 1 : 0)
                        .animation(.easeOut(duration: 0.4).delay(0.1), value: animateFeatures)
                        
                        EnhancedFeatureRow(
                            icon: "brain.head.profile", 
                            text: "Unlimited mindfulness exercises",
                            description: "Access our full library of exercises anytime",
                            color: BFColors.accent,
                            delay: 0.2
                        )
                        .offset(x: animateFeatures ? 0 : -20)
                        .opacity(animateFeatures ? 1 : 0)
                        .animation(.easeOut(duration: 0.4).delay(0.2), value: animateFeatures)
                        
                        EnhancedFeatureRow(
                            icon: "person.2.fill", 
                            text: "Community support access",
                            description: "Connect with others on similar journeys",
                            color: BFColors.accent,
                            delay: 0.3
                        )
                        .offset(x: animateFeatures ? 0 : -20)
                        .opacity(animateFeatures ? 1 : 0)
                        .animation(.easeOut(duration: 0.4).delay(0.3), value: animateFeatures)
                        
                        EnhancedFeatureRow(
                            icon: "lock.shield.fill", 
                            text: "No ads or interruptions",
                            description: "Focus on your recovery without distractions",
                            color: BFColors.accent,
                            delay: 0.4
                        )
                        .offset(x: animateFeatures ? 0 : -20)
                        .opacity(animateFeatures ? 1 : 0)
                        .animation(.easeOut(duration: 0.4).delay(0.4), value: animateFeatures)
                    }
                    .padding(.horizontal, 24)
                    .onAppear {
                        animateFeatures = true
                    }
                    
                    // Subscription plan selector with improved visuals
                    VStack(spacing: 16) {
                        Text("Choose Your Plan")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                        
                        HStack(spacing: 12) {
                            ForEach(0..<viewModel.plans.count, id: \.self) { index in
                                let plan = viewModel.plans[index]
                                
                                VStack(spacing: 12) {
                                    // Most popular badge (for annual plan)
                                    if index == 1 {
                                        Text("MOST POPULAR")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(BFColors.accent)
                                            .cornerRadius(4)
                                    } else {
                                        // Spacer to maintain alignment
                                        Color.clear
                                            .frame(height: 22)
                                    }
                                    
                                    Text(plan.name)
                                        .font(.headline)
                                        .foregroundColor(viewModel.selectedPlan == index ? BFColors.accent : .white)
                                    
                                    Text(plan.price)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(viewModel.selectedPlan == index ? BFColors.accent : .white)
                                    
                                    Text("per \(plan.period)")
                                        .font(.subheadline)
                                        .foregroundColor(viewModel.selectedPlan == index ? BFColors.accent.opacity(0.8) : .white.opacity(0.8))
                                    
                                    if !plan.savings.isEmpty {
                                        Text(plan.savings)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(viewModel.selectedPlan == index ? .white : BFColors.accent)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(viewModel.selectedPlan == index ? BFColors.accent.opacity(0.3) : Color.white.opacity(0.15))
                                            )
                                    }
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .background(
                                    ZStack {
                                        // Base background
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(viewModel.selectedPlan == index ? Color.white.opacity(0.9) : Color.white.opacity(0.15))
                                        
                                        // Selected highlight
                                        if viewModel.selectedPlan == index {
                                            RoundedRectangle(cornerRadius: 12)
                                                .strokeBorder(BFColors.accent, lineWidth: 2)
                                                .scaleEffect(1.02)
                                                .opacity(0.7)
                                        }
                                    }
                                )
                                .shadow(
                                    color: viewModel.selectedPlan == index ? BFColors.accent.opacity(0.3) : Color.black.opacity(0.1),
                                    radius: viewModel.selectedPlan == index ? 10 : 4,
                                    x: 0,
                                    y: viewModel.selectedPlan == index ? 5 : 2
                                )
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        viewModel.selectedPlan = index
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                // Trial benefits
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(BFColors.accent)
                        
                        Text("7-day free trial")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(BFColors.accent)
                        
                        Text("Cancel anytime")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    
                    Text("Then \(viewModel.selectedPlanDetails.price)/\(viewModel.selectedPlanDetails.period)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 8)
                
                // Start trial button
                Button {
                    // Set trial as active
                    viewModel.isTrialActive = true
                    
                    withAnimation {
                        viewModel.nextScreen()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text("Start 7-Day Free Trial")
                            .font(.headline)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: BFColors.accent.opacity(0.4), radius: 8, x: 0, y: 4)
                    )
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                // Terms text and skip option
                VStack(spacing: 16) {
                    Text("Cancel anytime. Payment will be charged to your Apple ID account at the confirmation of purchase.")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    Button {
                        withAnimation {
                            viewModel.nextScreen()
                        }
                    } label: {
                        Text("Continue with Limited Version")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .underline()
                    }
                }
                .padding(.vertical, 16)
            }
            .padding(.bottom, 32)
        }
    }
}

struct EnhancedFeatureRow: View {
    var icon: String
    var text: String
    var description: String
    var color: Color
    var delay: Double
    
    @State private var animateIcon = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Enhanced animated icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 20))
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true)
                            .delay(delay),
                        value: animateIcon
                    )
            }
            .onAppear {
                animateIcon = true
            }
            
            // Feature text with description
            VStack(alignment: .leading, spacing: 4) {
                Text(text)
                    .foregroundColor(.white)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(description)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.caption)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.15))
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

struct CompletionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var showConfetti = false
    @State private var animateIcon = false
    @State private var showNextSteps = false
    
    var body: some View {
        ZStack {
            // Consistent background style across all screens
            BFBackgroundView(style: .waves, gradient: BFColors.brandGradient())
                .ignoresSafeArea()
            
            // Enhanced confetti animation
            if showConfetti {
                EnhancedConfettiView()
            }
            
            VStack(spacing: 32) {
                Spacer()
                
                // Success icon with enhanced animation
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(BFColors.success.opacity(0.2))
                        .frame(width: 160, height: 160)
                        .scaleEffect(animateIcon ? 1.2 : 0.9)
                        .opacity(animateIcon ? 0.6 : 0.1)
                        .animation(
                            Animation.easeInOut(duration: 2)
                                .repeatForever(autoreverses: true),
                            value: animateIcon
                        )
                    
                    // Inner glow
                    Circle()
                        .fill(BFColors.success.opacity(0.3))
                        .frame(width: 120, height: 120)
                        .scaleEffect(animateIcon ? 1.1 : 0.95)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true)
                                .delay(0.5),
                            value: animateIcon
                        )
                    
                    // Success icon
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(BFColors.success)
                        .scaleEffect(animateIcon ? 1.05 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 1)
                                .repeatForever(autoreverses: true)
                                .delay(0.2),
                            value: animateIcon
                        )
                }
                .onAppear {
                    animateIcon = true
                    
                    // Show confetti with a slight delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showConfetti = true
                        
                        // Hide confetti after delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            // Show next steps with an animation
                            withAnimation {
                                showNextSteps = true
                            }
                        }
                    }
                }
                
                // Completion text with animation
                VStack(spacing: 16) {
                    if viewModel.username.isEmpty {
                        Text("You're All Set!")
                            .heading1()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("You're All Set, \(viewModel.username)!")
                            .heading1()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    
                    if viewModel.isTrialActive {
                        Text("Your 7-day free trial has started. Your journey to mindful recovery begins now.")
                            .bodyLarge()
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    } else {
                        Text("Your journey to mindful recovery begins now.")
                            .bodyLarge()
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                }
                
                if showNextSteps {
                    // Next steps with animation
                    VStack(spacing: 20) {
                        Text("Your Next Steps")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                        
                        // Next step cards
                        VStack(spacing: 16) {
                            NextStepCard(
                                number: "1",
                                title: "Complete Your First Session",
                                description: "Start with a \(viewModel.dailyGoal)-minute guided meditation",
                                icon: "play.circle.fill"
                            )
                            
                            NextStepCard(
                                number: "2",
                                title: "Set Up Reminders",
                                description: "Schedule your daily practice time",
                                icon: "bell.fill"
                            )
                            
                            NextStepCard(
                                number: "3",
                                title: "Explore Exercises",
                                description: "Browse our library of mindfulness tools",
                                icon: "book.fill"
                            )
                        }
                        .padding(.horizontal, 24)
                    }
                    .opacity(showNextSteps ? 1 : 0)
                    .offset(y: showNextSteps ? 0 : 30)
                    .animation(.easeOut(duration: 0.5), value: showNextSteps)
                } else {
                    // Benefits cards (shown before next steps)
                    VStack(spacing: 16) {
                        benefitCard(
                            icon: "chart.line.uptrend.xyaxis.circle.fill",
                            title: "Track Your Progress",
                            description: "Monitor your journey and celebrate milestones"
                        )
                        
                        benefitCard(
                            icon: "brain.head.profile",
                            title: "Mindfulness Tools",
                            description: "Access exercises to manage urges and reduce stress"
                        )
                        
                        benefitCard(
                            icon: "bell.badge.fill",
                            title: "Smart Reminders",
                            description: "Get personalized notifications to stay on track"
                        )
                    }
                    .padding(.horizontal, 24)
                }
                
                Spacer(minLength: 40)
                
                // Finish button
                Button {
                    // Save user settings and complete onboarding
                    viewModel.saveToAppState()
                } label: {
                    HStack(spacing: 8) {
                        Text("Start My Journey")
                            .font(.headline)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: BFColors.accent.opacity(0.4), radius: 8, x: 0, y: 4)
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
    
    private func benefitCard(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(BFColors.accent)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(BFTypography.heading3)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(BFTypography.bodySmall)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.15))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

struct NextStepCard: View {
    var number: String
    var title: String
    var description: String
    var icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Step number
            ZStack {
                Circle()
                    .fill(BFColors.accent.opacity(0.2))
                    .frame(width: 32, height: 32)
                
                Text(number)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(BFColors.accent)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(BFColors.accent)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.15))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

// Enhanced confetti animation view
struct EnhancedConfettiView: View {
    let colors: [Color] = [.red, .blue, .green, .yellow, .pink, .purple, .orange]
    
    var body: some View {
        ZStack {
            // Create multiple confetti pieces
            ForEach(0..<50, id: \.self) { i in
                ConfettiPiece(
                    color: colors[i % colors.count],
                    position: randomPosition(),
                    size: CGFloat.random(in: 5...10),
                    rotation: Double.random(in: 0...360),
                    delay: Double.random(in: 0...0.5)
                )
            }
        }
    }
    
    // Generate random position within screen bounds
    private func randomPosition() -> CGPoint {
        return CGPoint(
            x: CGFloat.random(in: -UIScreen.main.bounds.width/2...UIScreen.main.bounds.width/2),
            y: -100
        )
    }
}

struct ConfettiPiece: View {
    let color: Color
    let position: CGPoint
    let size: CGFloat
    let rotation: Double
    let delay: Double
    
    @State private var isAnimating = false
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: size, height: size)
            .rotationEffect(.degrees(rotation))
            .position(x: position.x + (isAnimating ? CGFloat.random(in: -100...100) : 0),
                      y: position.y + (isAnimating ? UIScreen.main.bounds.height + 100 : 0))
            .opacity(isAnimating ? 0 : 1)
            .onAppear {
                withAnimation(Animation.easeOut(duration: 3).delay(delay)) {
                    isAnimating = true
                }
            }
    }
}

// MARK: - Supporting Types

struct OnboardingNotificationType {
    var name: String
    var detail: String? = nil
    var isEnabled: Bool
}

struct SubscriptionPlan {
    var id: Int
    var name: String
    var price: String
    var period: String
    var savings: String
}

// OnboardingScreen enum is now in a separate file: OnboardingScreen.swift
