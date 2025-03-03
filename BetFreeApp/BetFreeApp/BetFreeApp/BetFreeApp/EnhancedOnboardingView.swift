// MARK: - TriggerMappingView
struct TriggerMappingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var selectedCategoryIndex = 0
    @State private var animateContent = false
    @State private var customTrigger = ""
    
    // Since we're now using the PuffCount-inspired design as the default
    private let isInPuffCountFlow = true
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Identify Your Triggers")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Select all that apply in each category")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.top, isInPuffCountFlow ? 0 : 20)
            .opacity(animateContent ? 1.0 : 0.0)
            
            // Category selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<viewModel.triggerCategories.count, id: \.self) { index in
                        Button(action: {
                            withAnimation {
                                selectedCategoryIndex = index
                            }
                        }) {
                            Text(viewModel.triggerCategories[index].name)
                                .font(.system(size: 16, weight: .medium))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(selectedCategoryIndex == index ? 
                                              BFColors.accent : Color.white.opacity(0.15))
                                )
                                .foregroundColor(selectedCategoryIndex == index ? 
                                                .white : .white.opacity(0.9))
                                .fontWeight(selectedCategoryIndex == index ? .semibold : .medium)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            
            // Triggers grid with modern styling
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.flexible())], // Single column for modern design
                    spacing: 16
                ) {
                    ForEach(viewModel.triggerCategories[selectedCategoryIndex].triggers, id: \.self) { trigger in
                        Button(action: {
                            toggleTrigger(trigger)
                        }) {
                            // Modern style
                            HStack {
                                // Selection indicator
                                ZStack {
                                    Circle()
                                        .stroke(viewModel.selectedTriggers.contains(trigger) ? BFColors.accent : Color.white.opacity(0.3), lineWidth: 2)
                                        .frame(minWidth: 26, minHeight: 26, alignment: .center)
                                    
                                    if viewModel.selectedTriggers.contains(trigger) {
                                        Circle()
                                            .fill(BFColors.accent)
                                            .frame(minWidth: 18, minHeight: 18, alignment: .center)
                                    }
                                }
                                
                                Text(trigger)
                                    .font(.system(size: 16, weight: viewModel.selectedTriggers.contains(trigger) ? .semibold : .regular))
                                    .foregroundColor(.white)
                                    .padding(.leading, 10)
                                
                                Spacer()
                            }
                            .padding(.vertical, 14)
                            .padding(.horizontal, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(viewModel.selectedTriggers.contains(trigger) ? 
                                          BFColors.accent.opacity(0.15) : Color.white.opacity(0.08))
                            )
                        }
                    }
                    
                    // Custom trigger input
                    HStack {
                        TextField("Add custom trigger...", text: $customTrigger)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.1))
                            )
                            .submitLabel(.done)
                            .onSubmit {
                                if !customTrigger.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    viewModel.selectedTriggers.append(customTrigger.trimmingCharacters(in: .whitespacesAndNewlines))
                                    viewModel.customTrigger = customTrigger
                                    customTrigger = ""
                                }
                            }
                    }
                    .padding(.top, 16)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            
            Spacer()
            
            // Continue button
            Button(action: {
                viewModel.nextScreen()
            }) {
                Text("Continue")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(minHeight: 24)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .cornerRadius(16)
                        .opacity(viewModel.selectedTriggers.isEmpty ? 0.5 : 1.0)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .disabled(viewModel.selectedTriggers.isEmpty)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .opacity(animateContent ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                animateContent = true
            }
        }
    }
    
    private func toggleTrigger(_ trigger: String) {
        if let index = viewModel.selectedTriggers.firstIndex(of: trigger) {
            viewModel.selectedTriggers.remove(at: index)
        } else {
            viewModel.selectedTriggers.append(trigger)
        }
    }
}

// Helper view for welcome screen
struct FeatureRow: View {
    let iconName: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.system(size: 24))
                .foregroundColor(BFColors.accent)
                .frame(minWidth: 50, minHeight: 50, alignment: .center)
                .background(Circle().fill(Color.white.opacity(0.1)))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
        )
    }
}

// Helper view for goal selection
struct GoalOptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 18, weight: isSelected ? .bold : .medium))
                        .foregroundColor(.white)
                    
                    // Description text based on goal type
                    Text(descriptionFor(goal: title))
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? BFColors.accent : Color.white.opacity(0.3), lineWidth: 2)
                        .frame(minWidth: 26, minHeight: 26, alignment: .center)
                    
                    if isSelected {
                        Circle()
                            .fill(BFColors.accent)
                            .frame(minWidth: 18, minHeight: 18, alignment: .center)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? BFColors.accent.opacity(0.2) : Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? BFColors.accent.opacity(0.5) : Color.clear, lineWidth: 1)
                    )
            )
        }
    }
    
    private func descriptionFor(goal: String) -> String {
        switch goal {
        case "Reduce":
            return "Cut back gradually and gain more control"
        case "Quit":
            return "Stop gambling completely"
        case "Maintain control":
            return "Keep your current habits in check"
        default:
            return ""
        }
    }
}

// Helper view for tracking method selection
struct TrackingMethodButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconFor(method: title))
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? BFColors.accent : .white.opacity(0.7))
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(isSelected ? BFColors.accent.opacity(0.2) : Color.white.opacity(0.1))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                        .foregroundColor(.white)
                    
                    Text(descriptionFor(method: title))
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? BFColors.accent : Color.white.opacity(0.3), lineWidth: 2)
                        .frame(minWidth: 26, minHeight: 26, alignment: .center)
                    
                    if isSelected {
                        Circle()
                            .fill(BFColors.accent)
                            .frame(minWidth: 18, minHeight: 18, alignment: .center)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? BFColors.accent.opacity(0.15) : Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? BFColors.accent.opacity(0.5) : Color.clear, lineWidth: 1)
                    )
            )
        }
    }
    
    private func iconFor(method: String) -> String {
        switch method {
        case "Manual":
            return "hand.tap.fill"
        case "Location-based":
            return "location.fill"
        case "Schedule-based":
            return "calendar"
        case "Urge detection":
            return "waveform.path.ecg"
        default:
            return "questionmark.circle"
        }
    }
    
    private func descriptionFor(method: String) -> String {
        switch method {
        case "Manual":
            return "You'll log each gambling activity or urge"
        case "Location-based":
            return "Get reminders when near gambling venues"
        case "Schedule-based":
            return "Set times when you typically gamble for reminders"
        case "Urge detection":
            return "Advanced AI detection of behavioral patterns"
        default:
            return ""
        }
    }
}

// Helper for profile summary
struct ProfileSummaryRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
        )
    }
}

// MARK: - Main OnboardingViewModel
@MainActor
class OnboardingViewModel: ObservableObject {
    // MARK: - Constants
    let screens: [OnboardingScreen] = [
        .welcome,
        .goalSelection,
        .trackingMethodSelection,
        .triggerIdentification,
        .scheduleSetup,
        .profileCompletion,
        .signIn,
        .personalSetup,
        .notificationSetup,
        .paywall,
        .completion
    ]
    
    // User profile properties
    @Published var trackingMethod = "Manual"  // Default tracking method
    @Published var availableTrackingMethods = ["Manual", "Location-based", "Schedule-based", "Urge detection"]
    @Published var selectedGoal = "Reduce"  // Default goal
    @Published var availableGoals = ["Reduce", "Quit", "Maintain control"]
    @Published var reminderDays: [Bool] = [true, true, true, true, true, true, true] // Default all days
    @Published var reminderTime = Date() // Default to current time
    
    // MARK: - Published Properties
    @Published var currentScreenIndex = 0
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isSigningInWithApple = false
    @Published var dailyGoal = 20  // Default to 20 minutes
    
    // Trigger identification properties
    @Published var userTriggers: [String] = []
    @Published var triggerCategories: [TriggerCategory] = [
        TriggerCategory(name: "Emotional", triggers: ["Stress", "Boredom", "Loneliness", "Excitement", "Depression"]),
        TriggerCategory(name: "Social", triggers: ["Friends gambling", "Work events", "Family gatherings", "Social media"]),
        TriggerCategory(name: "Environmental", triggers: ["Passing casinos", "Seeing ads", "Promotional emails", "Sports events"]),
        TriggerCategory(name: "Financial", triggers: ["Payday", "Financial stress", "Unexpected money", "Bills due"])
    ]
    @Published var selectedTriggers: [String] = []
    @Published var triggerIntensities: [String: Int] = [:]
    @Published var triggerStrategies: [String: [String]] = [:]
    @Published var customTrigger = ""
    
    // Notification settings
    @Published var notificationTypes: [OnboardingNotificationType] = [
        OnboardingNotificationType(name: "Daily reminders", detail: "Get daily reminders to practice mindfulness", isEnabled: true),
        OnboardingNotificationType(name: "Progress milestones", detail: "Celebrate when you reach important milestones", isEnabled: true),
        OnboardingNotificationType(name: "Tips & advice", detail: "Receive helpful advice when you need it most", isEnabled: false)
    ]
    
    // Subscription settings
    @Published var isTrialActive = false
    @Published var trialEndDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    @Published var selectedPlan = 1  // Default to annual plan (used by paywall screens)
    
    // Completion callback
    var onComplete: (() -> Void)?
    
    // Subscription plans
    let plans = [
        SubscriptionPlan(id: 0, name: "Monthly", price: "$9.99", period: "month", savings: ""),
        SubscriptionPlan(id: 1, name: "Annual", price: "$59.99", period: "year", savings: "Save 50%")
    ]
    
    // Strategy options for different trigger categories
    let triggerStrategyOptions: [String: [String]] = [
        "Emotional": [
            "5-minute guided breathing exercise",
            "Mindfulness meditation for emotions",
            "Journal about your feelings",
            "Call a supportive friend"
        ],
        "Social": [
            "Practice saying 'no' with confidence",
            "Suggest alternative activities",
            "Have an exit plan ready",
            "Remind yourself of your goals before events"
        ],
        "Environmental": [
            "Take alternative routes to avoid triggers",
            "Block gambling websites and apps",
            "Unsubscribe from promotional emails",
            "Use ad blockers to limit exposure"
        ],
        "Financial": [
            "Set up automatic savings transfers",
            "Create spending alerts on your accounts",
            "Give account access to a trusted person",
            "Use cash-only budgeting for a period"
        ]
    ]
    
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
    
    func skipToSignIn() {
        if let signInIndex = screens.firstIndex(of: .signIn) {
            currentScreenIndex = signInIndex
        }
    }
    
    func skipToPaywall() {
        // Find the index of the paywall screen
        if let paywallIndex = screens.firstIndex(of: .paywall) {
            currentScreenIndex = paywallIndex
        }
    }
    
    func completeProfileAndContinue() {
        // Go to sign in screen after completing profile
        skipToSignIn()
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
        print("Daily Goal: \(dailyGoal) minutes")
        print("Selected goal: \(selectedGoal)")
        print("Tracking method: \(trackingMethod)")
        print("Triggers: \(selectedTriggers.joined(separator: ", "))")
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
            // Background color gradient
            LinearGradient(
                gradient: Gradient(colors: [BFColors.primary, BFColors.primary.opacity(0.85)]),
                startPoint: .top,
                endPoint: .bottom
            )
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
                            .foregroundColor(.white)
                        }
                    } else {
                        Text("") // Spacer element for alignment
                    }
                    
                    Spacer()
                    
                    // Progress indicator
                    ProgressView(value: viewModel.screenProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .white))
                        .frame(width: 100)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .frame(height: 60)
                
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
            
            withAnimation(.easeOut(duration: 0.8)) {
                animateContent = true
            }
            
            // Automatically complete in case user doesn't tap button
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if animateContent {
                    viewModel.saveToAppState()
                }
            }
        }
    }
    
    // Add method to handle screen content
    @ViewBuilder
    private func screenForState(_ screen: OnboardingScreen) -> some View {
        switch screen {
        case .welcome:
            PuffInspiredWelcomeView(viewModel: viewModel)
        case .goalSelection:
            GoalSelectionView(viewModel: viewModel)
        case .trackingMethodSelection:
            TrackingMethodView(viewModel: viewModel)
        case .triggerIdentification:
            TriggerMappingView(viewModel: viewModel)
        case .scheduleSetup:
            ScheduleSetupView(viewModel: viewModel)
        case .profileCompletion:
            CompleteProfileSetupView(viewModel: viewModel)
        case .signIn:
            SignInView(viewModel: viewModel)
        case .personalSetup:
            PersonalSetupView(viewModel: viewModel)
        case .notificationSetup:
            NotificationsView(viewModel: viewModel)
        case .paywall:
            PaywallView(viewModel: viewModel)
        case .completion:
            CompletionView(viewModel: viewModel)
        }
    }
}

// MARK: - Welcome Screen
struct PuffInspiredWelcomeView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    
    var body: some View {
        VStack(spacing: 30) {
            // Logo and title section
            VStack(spacing: 16) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 60))
                    .foregroundColor(BFColors.accent)
                    .padding(20)
                    .background(Circle().fill(Color.white).opacity(0.15))
                    .scaleEffect(animateContent ? 1.0 : 0.8)
                    .opacity(animateContent ? 1.0 : 0.0)
                
                Text("Welcome to BetFree")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(animateContent ? 1.0 : 0.0)
                
                Text("Your journey to freedom starts here")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .opacity(animateContent ? 1.0 : 0.0)
            }
            .padding(.top, 60)
            
            Spacer()
            
            // Brief overview of app
            VStack(spacing: 20) {
                FeatureRow(iconName: "chart.bar.fill", title: "Track Progress", description: "Monitor your journey with personalized insights")
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 20)
                
                FeatureRow(iconName: "brain.head.profile", title: "Understand Triggers", description: "Identify what leads to gambling urges")
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 20)
                
                FeatureRow(iconName: "heart.text.square.fill", title: "Build Better Habits", description: "Replace gambling with healthy alternatives")
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 20)
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            // Continue button
            Button {
                viewModel.nextScreen()
            } label: {
                Text("Get Started")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]), 
                                    startPoint: .leading, 
                                    endPoint: .trailing
                                )
                            )
                    )
                    .shadow(color: BFColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
            .opacity(animateContent ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateContent = true
            }
        }
    }
}

// MARK: - Goal Selection Screen
struct GoalSelectionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 12) {
                Text("Set Your Goal")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                
                Text("What would you like to achieve with BetFree?")
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .padding(.top, 40)
            
            Spacer()
            
            // Goal options
            VStack(spacing: 16) {
                ForEach(viewModel.availableGoals, id: \.self) { goal in
                    GoalOptionButton(
                        title: goal,
                        isSelected: viewModel.selectedGoal == goal,
                        action: {
                            withAnimation {
                                viewModel.selectedGoal = goal
                            }
                        }
                    )
                    .offset(y: animateContent ? 0 : 20)
                    .opacity(animateContent ? 1.0 : 0.0)
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            // Continue button
            Button {
                viewModel.nextScreen()
            } label: {
                Text("Continue")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]), 
                                    startPoint: .leading, 
                                    endPoint: .trailing
                                )
                            )
                    )
                    .shadow(color: BFColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
            .opacity(animateContent ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateContent = true
            }
        }
    }
}

// MARK: - Tracking Method Screen
struct TrackingMethodView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 12) {
                Text("How Will You Track?")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Choose how you'd like to monitor your gambling activity")
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .padding(.top, 40)
            
            Spacer()
            
            // Tracking method options
            VStack(spacing: 16) {
                ForEach(viewModel.availableTrackingMethods, id: \.self) { method in
                    TrackingMethodButton(
                        title: method,
                        isSelected: viewModel.trackingMethod == method,
                        action: {
                            withAnimation {
                                viewModel.trackingMethod = method
                            }
                        }
                    )
                    .offset(y: animateContent ? 0 : 20)
                    .opacity(animateContent ? 1.0 : 0.0)
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            // Continue button
            Button {
                viewModel.nextScreen()
            } label: {
                Text("Continue")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]), 
                                    startPoint: .leading, 
                                    endPoint: .trailing
                                )
                            )
                    )
                    .shadow(color: BFColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
            .opacity(animateContent ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateContent = true
            }
        }
    }
}

// MARK: - Schedule Setup Screen
struct ScheduleSetupView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    
    private let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 12) {
                Text("Set Your Schedule")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                
                Text("When would you like to receive check-ins and reminders?")
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .padding(.top, 0)
            
            Spacer()
            
            // Day selection
            VStack(spacing: 24) {
                Text("Days")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 8) {
                    ForEach(0..<7) { index in
                        Button {
                            viewModel.reminderDays[index].toggle()
                        } label: {
                            Text(weekdays[index])
                                .font(.system(size: 15, weight: .medium))
                                .frame(minWidth: 40, minHeight: 40, alignment: .center)
                                .background(
                                    Circle()
                                        .fill(viewModel.reminderDays[index] ? BFColors.accent : Color.white.opacity(0.1))
                                )
                                .foregroundColor(viewModel.reminderDays[index] ? .white : .white.opacity(0.6))
                        }
                    }
                }
                
                // Time picker
                VStack(spacing: 12) {
                    Text("Time")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    DatePicker("", selection: $viewModel.reminderTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.1))
                        )
                        .accentColor(BFColors.accent)
                        .colorScheme(.dark) // Force dark mode for better visibility
                }
            }
            .padding(.horizontal, 30)
            .offset(y: animateContent ? 0 : 30)
            .opacity(animateContent ? 1.0 : 0.0)
            
            Spacer()
            
            // Continue button
            Button {
                viewModel.nextScreen()
            } label: {
                Text("Continue")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(minHeight: 56)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]), 
                                    startPoint: .leading, 
                                    endPoint: .trailing
                                )
                            )
                    )
                    .shadow(color: BFColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
            .opacity(animateContent ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateContent = true
            }
        }
    }
}

// MARK: - Profile Completion Screen
struct CompleteProfileSetupView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    
    var body: some View {
        VStack(spacing: 30) {
            // Success icon
            ZStack {
                Circle()
                    .fill(BFColors.accent.opacity(0.2))
                    .frame(minWidth: 120, minHeight: 120, alignment: .center)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(BFColors.accent)
            }
            .scaleEffect(animateContent ? 1.0 : 0.8)
            .opacity(animateContent ? 1.0 : 0.0)
            .padding(.top, 40)
            
            // Title and description
            VStack(spacing: 12) {
                Text("Profile Complete!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text("You're ready to create your account and start your journey to freedom")
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            
            // Profile summary
            VStack(spacing: 24) {
                ProfileSummaryRow(title: "Goal", value: viewModel.selectedGoal)
                ProfileSummaryRow(title: "Tracking Method", value: viewModel.trackingMethod)
                ProfileSummaryRow(title: "Selected Triggers", value: "\(viewModel.selectedTriggers.count) triggers identified")
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            .opacity(animateContent ? 1.0 : 0.0)
            
            Spacer()
            
            // Continue to account creation button
            Button {
                viewModel.completeProfileAndContinue()
            } label: {
                Text("Continue to Account Creation")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]), 
                                    startPoint: .leading, 
                                    endPoint: .trailing
                                )
                            )
                    )
                    .shadow(color: BFColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
            .opacity(animateContent ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateContent = true
            }
        }
    }
}

// MARK: - SignInView
struct SignInView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 12) {
                Text("Create Account")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Set up your account to save your progress")
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .padding(.top, 30)
            
            Spacer()
            
            // Sign in form
            VStack(spacing: 20) {
                // Email field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                    
                    TextField("", text: $viewModel.email)
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.1))
                        )
                }
                
                // Password field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                    
                    SecureField("", text: $viewModel.password)
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.1))
                        )
                }
            }
            .padding(.horizontal, 30)
            .opacity(animateContent ? 1.0 : 0.0)
            
            Spacer()
            
            // Sign in buttons
            VStack(spacing: 16) {
                // Email sign in
                Button {
                    viewModel.signInWithEmail()
                } label: {
                    Text("Create Account")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]), 
                                        startPoint: .leading, 
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .opacity(viewModel.email.isEmpty || viewModel.password.isEmpty ? 0.5 : 1.0)
                }
                .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
                
                // Apple sign in
                Button {
                    viewModel.signInWithApple()
                } label: {
                    HStack {
                        Image(systemName: "apple.logo")
                            .font(.system(size: 20))
                        
                        Text("Sign in with Apple")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
            .opacity(animateContent ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateContent = true
            }
        }
    }
}

// MARK: - PersonalSetupView
struct PersonalSetupView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    @State private var sliderValue: Double = 20 // Default to 20 minutes
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 12) {
                Text("Personal Setup")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Set your daily time limit for gambling activities")
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .padding(.top, 30)
            
            Spacer()
            
            // Daily goal slider
            VStack(spacing: 30) {
                // Current value display
                VStack(spacing: 4) {
                    Text("\(Int(sliderValue))")
                        .font(.system(size: 72, weight: .bold))
                        .foregroundColor(BFColors.accent)
                    
                    Text("minutes per day")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                // Slider
                VStack(spacing: 15) {
                    Slider(value: $sliderValue, in: 0...120, step: 5)
                        .accentColor(BFColors.accent)
                        .onChange(of: sliderValue) { _ in
                            viewModel.dailyGoal = Int(sliderValue)
                        }
                    
                    // Labels
                    HStack {
                        Text("0 min")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Spacer()
                        
                        Text("120 min")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, 30)
            .opacity(animateContent ? 1.0 : 0.0)
            
            Spacer()
            
            // Continue button
            Button {
                viewModel.nextScreen()
            } label: {
                Text("Continue")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]), 
                                    startPoint: .leading, 
                                    endPoint: .trailing
                                )
                            )
                    )
                    .shadow(color: BFColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
            .opacity(animateContent ? 1.0 : 0.0)
        }
        .onAppear {
            // Set initial slider value to match viewModel
            sliderValue = Double(viewModel.dailyGoal)
            
            withAnimation(.easeOut(duration: 0.8)) {
                animateContent = true
            }
        }
    }
}

// MARK: - NotificationsView
struct NotificationsView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 12) {
                Text("Notifications")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Choose which notifications you want to receive")
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .padding(.top, 30)
            
            Spacer()
            
            // Notification toggles
            VStack(spacing: 16) {
                ForEach(0..<viewModel.notificationTypes.count, id: \.self) { index in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.notificationTypes[index].name)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                            
                            if let detail = viewModel.notificationTypes[index].detail {
                                Text(detail)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                                    .lineLimit(2)
                            }
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: Binding(
                            get: { viewModel.notificationTypes[index].isEnabled },
                            set: { viewModel.notificationTypes[index].isEnabled = $0 }
                        ))
                        .toggleStyle(SwitchToggleStyle(tint: BFColors.accent))
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.1))
                    )
                }
            }
            .padding(.horizontal, 30)
            .opacity(animateContent ? 1.0 : 0.0)
            
            Spacer()
            
            // Continue button
            Button {
                viewModel.nextScreen()
            } label: {
                Text("Continue")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]), 
                                    startPoint: .leading, 
                                    endPoint: .trailing
                                )
                            )
                    )
                    .shadow(color: BFColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
            .opacity(animateContent ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateContent = true
            }
        }
    }
}

// MARK: - PaywallView
struct PaywallView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 12) {
                Text("Upgrade to Premium")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Get unlimited access to all BetFree features")
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .padding(.top, 30)
            
            // Premium features
            VStack(spacing: 20) {
                FeatureRow(iconName: "chart.bar.fill", title: "Advanced Analytics", description: "Get detailed insights about your gambling patterns")
                
                FeatureRow(iconName: "brain.head.profile", title: "AI-Powered Strategies", description: "Custom strategies based on your unique triggers")
                
                FeatureRow(iconName: "bell.badge.fill", title: "Smart Notifications", description: "Receive just-in-time support when you need it most")
            }
            .padding(.horizontal, 30)
            .opacity(animateContent ? 1.0 : 0.0)
            
            Spacer()
            
            // Plan selection
            VStack(spacing: 20) {
                // Plan options
                ForEach(viewModel.plans, id: \.id) { plan in
                    Button {
                        viewModel.selectedPlan = plan.id
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(plan.name)
                                        .font(.system(size: 18, weight: .semibold))
                                    
                                    if !plan.savings.isEmpty {
                                        Text(plan.savings)
                                            .font(.system(size: 14, weight: .medium))
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 3)
                                                .background(
                                                    Capsule()
                                                        .fill(BFColors.accent)
                                                )
                                    }
                                }
                                
                                Text("\(plan.price) per \(plan.period)")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            // Selection indicator
                            ZStack {
                                Circle()
                                    .stroke(viewModel.selectedPlan == plan.id ? BFColors.accent : Color.white.opacity(0.3), lineWidth: 2)
                                    .frame(minWidth: 26, minHeight: 26, alignment: .center)
                                
                                if viewModel.selectedPlan == plan.id {
                                    Circle()
                                        .fill(BFColors.accent)
                                        .frame(minWidth: 18, minHeight: 18, alignment: .center)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(viewModel.selectedPlan == plan.id ? BFColors.accent.opacity(0.15) : Color.white.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(viewModel.selectedPlan == plan.id ? BFColors.accent.opacity(0.5) : Color.clear, lineWidth: 1)
                                )
                        )
                    }
                    .foregroundColor(.white)
                }
                
                // 7-day free trial note
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(BFColors.accent)
                    
                    Text("7-day free trial, cancel anytime")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 30)
            .opacity(animateContent ? 1.0 : 0.0)
            
            // Buttons
            VStack(spacing: 16) {
                // Subscribe button
                Button {
                    viewModel.isTrialActive = true
                    viewModel.nextScreen()
                } label: {
                    Text("Start Free Trial")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]), 
                                        startPoint: .leading, 
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .shadow(color: BFColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                
                // Skip button
                Button {
                    viewModel.nextScreen()
                } label: {
                    Text("Continue with Limited Version")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
            .opacity(animateContent ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateContent = true
            }
        }
    }
}

// MARK: - CompletionView
struct CompletionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Success animation and icon
            ZStack {
                Circle()
                    .fill(BFColors.accent.opacity(0.2))
                    .frame(minWidth: 150, minHeight: 150, alignment: .center)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(BFColors.accent)
            }
            .scaleEffect(animateContent ? 1.0 : 0.8)
            .opacity(animateContent ? 1.0 : 0.0)
            
            // Title and description
            VStack(spacing: 16) {
                Text("You're All Set!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Your journey to freedom begins today. We're here to support you every step of the way.")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            
            Spacer()
            
            // Start button
            Button {
                viewModel.saveToAppState()
            } label: {
                Text("Start Now")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(minHeight: 56)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]), 
                                    startPoint: .leading, 
                                    endPoint: .trailing
                                )
                            )
                    )
                    .shadow(color: BFColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
            .opacity(animateContent ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateContent = true
            }
            
            // Automatically complete in case user doesn't tap button
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if animateContent {
                    viewModel.saveToAppState()
                }
            }
        }
    }
}

// MARK: - OnboardingNotificationType
struct OnboardingNotificationType {
    var name: String
    var detail: String? = nil
    var isEnabled: Bool
}

// MARK: - SubscriptionPlan
struct SubscriptionPlan {
    var id: Int
    var name: String
    var price: String
    var period: String
    var savings: String
} 