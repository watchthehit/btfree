import SwiftUI

// MARK: - TriggerCategory
struct TriggerCategory: Identifiable {
    var id = UUID()
    var name: String
    var triggers: [String]
}

// MARK: - OnboardingViewModel
@MainActor
class OnboardingViewModel: ObservableObject {
    // MARK: - Constants
    let screens: [OnboardingScreen] = [
        .combinedValueProposition,
        .assessmentIntro,
        .assessmentQuiz,
        .assessmentResults,
        .triggerIdentificationIntro,
        .triggerMapping,
        .triggerIntensity,
        .triggerStrategies,
        .triggerSummary,
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
    
    // Assessment quiz properties
    @Published var currentQuizQuestionIndex = 0
    @Published var gamblingFrequency = ""
    @Published var gamblingTypes: [String] = []
    @Published var primaryMotivation = ""
    @Published var biggestChallenge = ""
    @Published var supportNetwork: [String] = []
    @Published var customMotivation = ""
    @Published var customChallenge = ""
    @Published var personalizationAreas: [String] = []
    
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
    @Published var currentTriggerCategory = 0
    @Published var currentTriggerForIntensity = ""
    @Published var currentTriggerForStrategy = ""
    
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
    
    // Assessment quiz questions
    let assessmentQuestions = [
        "How often have you gambled in the past month?",
        "What types of gambling have you engaged with?",
        "What's your primary reason for wanting to reduce or stop gambling?",
        "When you've tried to cut back before, what has been most difficult?",
        "Who knows about your decision to address your gambling habits?"
    ]
    
    let frequencyOptions = [
        "Not at all",
        "Once or twice",
        "Weekly",
        "Several times a week",
        "Daily"
    ]
    
    let gamblingTypeOptions = [
        "Sports betting",
        "Casino games (slots, poker, etc.)",
        "Lottery tickets",
        "Online gambling",
        "Mobile gambling apps",
        "Other"
    ]
    
    let motivationOptions = [
        "Financial concerns",
        "Relationship impact",
        "Mental wellbeing",
        "Work performance",
        "Taking back control",
        "Other"
    ]
    
    let challengeOptions = [
        "Dealing with cravings",
        "Finding alternative activities",
        "Social pressure",
        "Stress management",
        "Never tried before",
        "Other"
    ]
    
    let supportNetworkOptions = [
        "Close family",
        "Friends",
        "Partner/spouse",
        "Professional support",
        "No one yet",
        "Prefer not to say"
    ]
    
    // Strategy suggestions for triggers
    let strategyOptions: [String: [String]] = [
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
    
    var currentAssessmentQuestion: String {
        assessmentQuestions[currentQuizQuestionIndex]
    }
    
    var quizProgress: Float {
        Float(currentQuizQuestionIndex) / Float(assessmentQuestions.count)
    }
    
    var currentTriggerCategoryName: String {
        triggerCategories[currentTriggerCategory].name
    }
    
    var currentTriggerCategoryTriggers: [String] {
        triggerCategories[currentTriggerCategory].triggers
    }
    
    var highIntensityTriggers: [String] {
        triggerIntensities.filter { $0.value >= 7 }.map { $0.key }
    }
    
    var mediumIntensityTriggers: [String] {
        triggerIntensities.filter { $0.value >= 4 && $0.value < 7 }.map { $0.key }
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
    
    func toggleTriggerSelection(_ trigger: String) {
        if selectedTriggers.contains(trigger) {
            selectedTriggers.removeAll { $0 == trigger }
            triggerIntensities.removeValue(forKey: trigger)
            triggerStrategies.removeValue(forKey: trigger)
        } else {
            selectedTriggers.append(trigger)
        }
    }
    
    func setTriggerIntensity(for trigger: String, intensity: Int) {
        triggerIntensities[trigger] = intensity
    }
    
    func addTriggerStrategy(for trigger: String, strategy: String) {
        if triggerStrategies[trigger] == nil {
            triggerStrategies[trigger] = [strategy]
        } else {
            triggerStrategies[trigger]?.append(strategy)
        }
    }
    
    func removeTriggerStrategy(for trigger: String, strategy: String) {
        triggerStrategies[trigger]?.removeAll { $0 == strategy }
    }
    
    func generatePersonalizedAreas() {
        personalizationAreas = []
        
        // Generate based on gambling frequency
        if gamblingFrequency == "Daily" || gamblingFrequency == "Several times a week" {
            personalizationAreas.append("Intensive daily support")
        } else if gamblingFrequency == "Weekly" {
            personalizationAreas.append("Regular check-ins and strategies")
        } else {
            personalizationAreas.append("Preventive techniques and maintenance")
        }
        
        // Generate based on motivation
        if primaryMotivation == "Financial concerns" {
            personalizationAreas.append("Financial health restoration")
        } else if primaryMotivation == "Relationship impact" {
            personalizationAreas.append("Rebuilding relationship trust")
        } else if primaryMotivation == "Mental wellbeing" {
            personalizationAreas.append("Mental health and mindfulness")
        }
        
        // Generate based on challenge
        if biggestChallenge == "Dealing with cravings" {
            personalizationAreas.append("Craving management techniques")
        } else if biggestChallenge == "Finding alternative activities" {
            personalizationAreas.append("Healthy habit replacement")
        } else if biggestChallenge == "Stress management" {
            personalizationAreas.append("Stress reduction strategies")
        }
        
        // Ensure we have at least 3 areas
        if personalizationAreas.count < 3 {
            let defaultAreas = ["Mindfulness practice", "Progress tracking", "Community support"]
            for area in defaultAreas {
                if !personalizationAreas.contains(area) && personalizationAreas.count < 3 {
                    personalizationAreas.append(area)
                }
            }
        }
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
            // Teal background color from screenshot
            Color(hex: "#3DDFD3")
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
                    
                    // Skip button (only show for value proposition screen)
                    if viewModel.currentScreen == .combinedValueProposition {
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
        case .combinedValueProposition:
            CombinedValuePropositionView(viewModel: viewModel)
        case .assessmentIntro:
            AssessmentIntroView(viewModel: viewModel)
        case .assessmentQuiz:
            AssessmentQuizView(viewModel: viewModel)
        case .assessmentResults:
            AssessmentResultsView(viewModel: viewModel)
        case .triggerIdentificationIntro:
            TriggerIdentificationIntroView(viewModel: viewModel)
        case .triggerMapping:
            TriggerMappingView(viewModel: viewModel)
        case .triggerIntensity:
            TriggerIntensityView(viewModel: viewModel)
        case .triggerStrategies:
            TriggerStrategiesView(viewModel: viewModel)
        case .triggerSummary:
            TriggerSummaryView(viewModel: viewModel)
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

// New combined value proposition view with paging
struct CombinedValuePropositionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var currentPage = 0
    
    // Content for each page
    private let pages = [
        ValuePropPage(
            icon: "heart.fill",
            title: "Break Free From Gambling",
            description: "Take the first step toward a healthier relationship with gambling through evidence-based tools and support."
        ),
        ValuePropPage(
            icon: "chart.line.uptrend.xyaxis",
            title: "Track Your Progress",
            description: "Monitor your journey with personalized insights and celebrate your milestones along the way."
        ),
        ValuePropPage(
            icon: "brain.head.profile",
            title: "Find Your Calm",
            description: "Access mindfulness exercises and breathing techniques to help manage urges and reduce stress."
        )
    ]
    
    var body: some View {
        ZStack {
            // Teal background color from screenshot
            Color(hex: "#3DDFD3")
                .ignoresSafeArea()
            
            VStack {
                // Skip button at top right - we'll remove this to avoid duplication with the main Skip button
                Spacer().frame(height: 50) // Replace duplicate button with spacer
                
                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 10)
                
                // TabView for swiping between pages
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack {
                    Spacer()
                    
                            // Icon with circles
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 160, height: 160)
                                
                                Circle()
                                    .fill(Color.white.opacity(0.35))
                                    .frame(width: 120, height: 120)
                                
                                Circle()
                                    .fill(Color.white.opacity(0.5))
                                    .frame(width: 80, height: 80)
                                    .overlay(
                                        Image(systemName: pages[index].icon)
                                            .font(.system(size: 40, weight: .semibold))
                                            .foregroundColor(.white)
                                    )
                            }
                            
                            // Title and description
                            Text(pages[index].title)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.top, 40)
                                .padding(.horizontal, 20)
                            
                            Text(pages[index].description)
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.top, 10)
                                .padding(.horizontal, 40)
                    
                    Spacer()
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Replace custom button with BFPrimaryButton
                BFPrimaryButton(
                    text: currentPage == pages.count - 1 ? "Get Started" : "Next",
                    icon: "arrow.right",
                    action: {
                        if currentPage < pages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                                    viewModel.nextScreen()
                                }
                            }
                )
                .padding(.horizontal, BFSpacing.medium)
                .padding(.bottom, BFSpacing.xlarge)
            }
        }
    }
}

// Simple struct to hold page content
struct ValuePropPage {
    let icon: String
    let title: String
    let description: String
}

// MARK: - AssessmentIntroView
struct AssessmentIntroView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    
    var body: some View {
        ZStack {
            // Use standardized background
            BFScreenBackground()
            
            VStack(spacing: BFSpacing.medium) {
                Spacer()
                
                // Icon
                Image(systemName: "person.fill.questionmark")
                    .font(.system(size: 60))
                    .foregroundColor(BFColors.accent)
                    .padding(30)
                                .background(
                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .overlay(
                                Circle()
                                    .stroke(BFColors.accent.opacity(0.3), lineWidth: 2)
                                    .padding(2)
                            )
                    )
                    .scaleEffect(animateContent ? 1.0 : 0.8)
                    .opacity(animateContent ? 1.0 : 0.0)
                
                // Title
                Text("Let's Personalize Your Journey")
                    .heading2()
                    .multilineTextAlignment(.center)
                    .padding(.top, BFSpacing.large)
                    .padding(.horizontal, BFSpacing.medium)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 20)
                
                // Description
                Text("A few quick questions will help us create a plan that's perfect for your specific needs and challenges.")
                    .bodyLarge()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, BFSpacing.xlarge)
                    .padding(.top, BFSpacing.small)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 15)
                
                // Privacy note
                BFCard {
                    HStack(spacing: BFSpacing.small) {
                        Image(systemName: "lock.fill")
                            .foregroundColor(BFColors.accent)
                        
                        Text("Your answers are private and only used to personalize your experience")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#1B263B")) // Dark text color for better contrast
                    }
                    .padding(.horizontal, BFSpacing.small)
                    .padding(.vertical, BFSpacing.small)
                }
                .styledBody(opacity: 0.9) // Use high opacity white background
                .padding(.horizontal, BFSpacing.medium)
                .padding(.top, BFSpacing.small)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 10)
                
                        Spacer()
                
                // Primary button for begin assessment
                BFPrimaryButton(
                    text: "Begin Assessment",
                    icon: "arrow.right",
                    action: {
                        viewModel.nextScreen()
                    }
                )
                .opacity(animateContent ? 1.0 : 0.0)
                .scaleEffect(animateContent ? 1.0 : 0.9)
                .padding(.horizontal, BFSpacing.medium)
                
                // Text button for skipping
                BFTextButton(
                    text: "Skip Assessment",
                    action: {
                        viewModel.skipToSignIn()
                    }
                )
                .opacity(animateContent ? 1.0 : 0.0)
                
                Spacer().frame(height: BFSpacing.medium)
            }
        }
        .onAppear {
            withAnimation(BFAnimations.standardAppear) {
                animateContent = true
            }
        }
    }
}

// MARK: - AssessmentQuizView
struct AssessmentQuizView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var selectedOption = ""
    @State private var selectedOptions: [String] = []
    @State private var customText = ""
    @State private var showCustomField = false
    @State private var animateContent = false
    
    var body: some View {
        ZStack {
            // Use standardized background
            BFScreenBackground()
            
            VStack(spacing: 0) {
                // Progress bar
                BFProgressBar(progress: viewModel.quizProgress)
                    .frame(height: 4)
                    .padding(.horizontal, BFSpacing.medium)
                    .padding(.top, BFSpacing.medium)
                    .padding(.bottom, BFSpacing.medium)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: BFSpacing.large) {
                        // Question counter
                        Text("QUESTION \(viewModel.currentQuizQuestionIndex + 1) OF \(viewModel.assessmentQuestions.count)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(BFColors.accent)
                            .padding(.horizontal, BFSpacing.medium)
                            .opacity(animateContent ? 1.0 : 0.0)
                        
                        // Question
                        Text(viewModel.currentAssessmentQuestion)
                            .heading2()
                            .padding(.horizontal, BFSpacing.medium)
                            .padding(.bottom, BFSpacing.small)
                            .opacity(animateContent ? 1.0 : 0.0)
                        
                        // Options
                        VStack(spacing: BFSpacing.small) {
                            ForEach(getOptionsForCurrentQuestion(), id: \.self) { option in
                                BFOptionButton(
                                    text: option,
                                    isSelected: isOptionSelected(option),
                                    allowsMultiple: viewModel.currentQuizQuestionIndex == 1 || viewModel.currentQuizQuestionIndex == 4,
                                    action: {
                                        handleOptionSelection(option)
                                    }
                                )
                                .opacity(animateContent ? 1.0 : 0.0)
                            }
                        }
                        .padding(.horizontal, BFSpacing.medium)
                        
                        // Custom text field
                        if showCustomField {
                            VStack(alignment: .leading, spacing: BFSpacing.small) {
                                Text("Please specify:")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                
                                TextField("", text: $customText)
                                    .padding()
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(BFCornerRadius.medium)
                                    .foregroundColor(.white)
                                    .accentColor(BFColors.accent)
                            }
                            .padding(.horizontal, BFSpacing.medium)
                            .padding(.top, BFSpacing.small)
                            .transition(.opacity)
                        }
                        
                        Spacer().frame(height: BFSpacing.medium)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, BFSpacing.medium)
                }
                
                // Bottom buttons
                VStack(spacing: BFSpacing.medium) {
                    BFPrimaryButton(
                        text: viewModel.currentQuizQuestionIndex == viewModel.assessmentQuestions.count - 1 ? "Complete" : "Continue",
                        icon: "arrow.right",
                        action: {
                            nextQuestion()
                        },
                        isDisabled: !canContinue()
                    )
                    .padding(.horizontal, BFSpacing.medium)
                    .overlay(
                        RoundedRectangle(cornerRadius: BFCornerRadius.medium)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                    
                    BFTextButton(
                        text: "Skip Assessment",
                        action: {
                            viewModel.skipToSignIn()
                        }
                    )
                }
                .padding(.bottom, BFSpacing.medium)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            initializeStateForCurrentQuestion()
            withAnimation(BFAnimations.standardAppear) {
                animateContent = true
            }
        }
    }
    
    // Helper methods
    private func getOptionsForCurrentQuestion() -> [String] {
        switch viewModel.currentQuizQuestionIndex {
        case 0: return viewModel.frequencyOptions
        case 1: return viewModel.gamblingTypeOptions
        case 2: return viewModel.motivationOptions
        case 3: return viewModel.challengeOptions
        case 4: return viewModel.supportNetworkOptions
        default: return []
        }
    }
    
    private func isOptionSelected(_ option: String) -> Bool {
        if viewModel.currentQuizQuestionIndex == 1 || viewModel.currentQuizQuestionIndex == 4 {
            return selectedOptions.contains(option)
        } else {
            return selectedOption == option
        }
    }
    
    private func handleOptionSelection(_ option: String) {
        if viewModel.currentQuizQuestionIndex == 1 || viewModel.currentQuizQuestionIndex == 4 {
            // Multiple selection question
            if selectedOptions.contains(option) {
                selectedOptions.removeAll { $0 == option }
                if option == "Other" {
                    showCustomField = false
                }
            } else {
                selectedOptions.append(option)
                if option == "Other" {
                    showCustomField = true
                }
            }
        } else {
            // Single selection question
            selectedOption = option
            
            // Show custom field for "Other" option
            if option == "Other" {
                withAnimation {
                    showCustomField = true
                }
            } else {
                withAnimation {
                    showCustomField = false
                }
            }
        }
    }
    
    private func canContinue() -> Bool {
        if viewModel.currentQuizQuestionIndex == 1 || viewModel.currentQuizQuestionIndex == 4 {
            // For multiple selection questions
            if selectedOptions.isEmpty {
                return false
            }
            // If "Other" is selected, require custom text
            if selectedOptions.contains("Other") && customText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
            return true
        } else {
            // For single selection questions
            if selectedOption.isEmpty {
                return false
            }
            // If "Other" is selected, require custom text
            if selectedOption == "Other" && customText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
            return true
        }
    }
    
    private func saveAnswerForCurrentQuestion() {
        switch viewModel.currentQuizQuestionIndex {
        case 0:
            viewModel.gamblingFrequency = selectedOption
        case 1:
            viewModel.gamblingTypes = selectedOptions
        case 2:
            viewModel.primaryMotivation = selectedOption
            if selectedOption == "Other" {
                viewModel.customMotivation = customText
            }
        case 3:
            viewModel.biggestChallenge = selectedOption
            if selectedOption == "Other" {
                viewModel.customChallenge = customText
            }
        case 4:
            viewModel.supportNetwork = selectedOptions
        default:
            break
        }
    }
    
    private func nextQuestion() {
        saveAnswerForCurrentQuestion()
        
        if viewModel.currentQuizQuestionIndex < viewModel.assessmentQuestions.count - 1 {
            // Animate out
            withAnimation(BFAnimations.standardDisappear) {
                animateContent = false
            }
            
            // Move to next question after brief delay
            DispatchQueue.main.asyncAfter(deadline: .now() + BFAnimations.quickDuration) {
                viewModel.currentQuizQuestionIndex += 1
                initializeStateForCurrentQuestion()
                
                // Animate in
                withAnimation(BFAnimations.standardAppear) {
                    animateContent = true
                }
            }
        } else {
            // Completed the assessment quiz
            viewModel.generatePersonalizedAreas()
                            viewModel.nextScreen()
                        }
    }
    
    private func initializeStateForCurrentQuestion() {
        // Reset state
        selectedOption = ""
        selectedOptions = []
        customText = ""
        showCustomField = false
        
        // Set current state based on any existing answers
        switch viewModel.currentQuizQuestionIndex {
        case 0:
            selectedOption = viewModel.gamblingFrequency
        case 1:
            selectedOptions = viewModel.gamblingTypes
            showCustomField = selectedOptions.contains("Other")
        case 2:
            selectedOption = viewModel.primaryMotivation
            if selectedOption == "Other" {
                customText = viewModel.customMotivation
                showCustomField = true
            }
        case 3:
            selectedOption = viewModel.biggestChallenge
            if selectedOption == "Other" {
                customText = viewModel.customChallenge
                showCustomField = true
            }
        case 4:
            selectedOptions = viewModel.supportNetwork
            showCustomField = selectedOptions.contains("Other")
        default:
            break
        }
    }
}

// MARK: - OptionButton
struct OptionButton: View {
    var text: String
    var isSelected: Bool
    var allowsMultiple: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                // Selection indicator
                ZStack {
                    if allowsMultiple {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(isSelected ? BFColors.accent : Color.white.opacity(0.4), lineWidth: 2)
                            .frame(width: 20, height: 20)
                        
                        if isSelected {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(BFColors.accent)
                        }
                    } else {
                        Circle()
                            .stroke(isSelected ? BFColors.accent : Color.white.opacity(0.4), lineWidth: 2)
                            .frame(width: 20, height: 20)
                        
                        if isSelected {
                            Circle()
                                .fill(BFColors.accent)
                                .frame(width: 12, height: 12)
                        }
                    }
                }
                
                // Option text
                Text(text)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                            .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
                            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(isSelected ? 0.2 : 0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? BFColors.accent.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 1)
                    )
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - ProgressBar
struct ProgressBar: View {
    var progress: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .cornerRadius(2)
                
                Rectangle()
                    .fill(BFColors.accent)
                    .cornerRadius(2)
                    .frame(width: CGFloat(self.progress) * geometry.size.width)
                    .animation(.easeInOut, value: progress)
            }
        }
    }
}

// MARK: - AssessmentResultsView
struct AssessmentResultsView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    @State private var animateAreas = false
    
    var body: some View {
        ZStack {
            // Use standardized background
            BFScreenBackground()
            
            VStack(spacing: BFSpacing.medium) {
                Spacer()
                
                // Success icon
                ZStack {
                    Circle()
                        .fill(BFColors.accent.opacity(0.15))
                        .frame(width: 120, height: 120)
                        .scaleEffect(animateContent ? 1.0 : 0.6)
                        .opacity(animateContent ? 1.0 : 0.0)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(BFColors.accent)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .scaleEffect(animateContent ? 1.0 : 0.7)
                }
                
                // Title
                Text("Your Personalized Plan is Ready")
                    .heading2()
                    .multilineTextAlignment(.center)
                    .padding(.top, BFSpacing.large)
                    .padding(.horizontal, BFSpacing.medium)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 20)
                
                // Description
                Text("Based on your responses, we've customized your BetFree journey.")
                    .bodyLarge()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, BFSpacing.xlarge)
                    .padding(.top, BFSpacing.small)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 15)
                
                // Focus areas
                VStack(alignment: .leading, spacing: BFSpacing.medium) {
                    Text("Your primary focus areas:")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.bottom, BFSpacing.tiny)
                    
                    ForEach(Array(viewModel.personalizationAreas.enumerated()), id: \.offset) { index, area in
                        BFCard {
                            HStack(spacing: BFSpacing.medium) {
                                // Area icon
                                ZStack {
                                    Circle()
                                        .fill(BFColors.accent.opacity(0.2))
                                        .frame(width: 36, height: 36)
                                    
                                    Image(systemName: getIconForArea(area))
                                        .font(.system(size: 16))
                                        .foregroundColor(BFColors.accent)
                                }
                                
                                // Area content
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(area)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(Color(hex: "#1B263B"))
                                    
                                    Text(getDescriptionForArea(area))
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(hex: "#1B263B").opacity(0.7))
                                        .lineLimit(2)
                                }
                                
                                Spacer()
                            }
                        }
                        .styledBody(opacity: 0.95)
                        .opacity(animateAreas ? 1.0 : 0.0)
                        .offset(y: animateAreas ? 0 : 20)
                        .animation(
                            BFAnimations.standardAppear.delay(
                                BFAnimations.staggeredDelay(baseDelay: 0.2, itemIndex: index)
                            ), 
                            value: animateAreas
                        )
                    }
                }
                .padding(.horizontal, BFSpacing.medium)
                .padding(.top, BFSpacing.medium)
                .padding(.bottom, BFSpacing.medium)
                
                Spacer()
                
                // Primary action button
                BFPrimaryButton(
                    text: "Next: Identify Your Triggers",
                    icon: "arrow.right",
                    action: {
                        viewModel.nextScreen()
                    }
                )
                .opacity(animateContent ? 1.0 : 0.0)
                .scaleEffect(animateContent ? 1.0 : 0.9)
                .padding(.horizontal, BFSpacing.medium)
                
                // Skip button
                BFTextButton(
                    text: "Skip to Account Creation",
                    action: {
                        viewModel.skipToSignIn()
                    }
                )
                .opacity(animateContent ? 1.0 : 0.0)
                
                Spacer().frame(height: BFSpacing.medium)
            }
        }
        .onAppear {
            withAnimation(BFAnimations.standardAppear) {
                animateContent = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(BFAnimations.standardAppear) {
                    animateAreas = true
                }
            }
        }
    }
    
    private func getIconForArea(_ area: String) -> String {
        switch area {
        case _ where area.contains("daily"): return "clock.fill"
        case _ where area.contains("financial"): return "dollarsign.circle.fill"
        case _ where area.contains("relation"): return "person.2.fill"
        case _ where area.contains("mental"): return "brain.fill"
        case _ where area.contains("crav"): return "bolt.shield.fill"
        case _ where area.contains("habit"): return "arrow.triangle.swap"
        case _ where area.contains("stress"): return "wind"
        case _ where area.contains("mindful"): return "leaf.fill"
        case _ where area.contains("progress"): return "chart.line.uptrend.xyaxis"
        case _ where area.contains("community"): return "person.3.fill"
        default: return "star.fill"
        }
    }
    
    private func getDescriptionForArea(_ area: String) -> String {
        switch area {
        case "Intensive daily support": return "This area focuses on daily mindfulness practice and stress reduction techniques."
        case "Regular check-ins and strategies": return "This area includes regular check-ins with a trusted person and strategies for managing urges."
        case "Preventive techniques and maintenance": return "This area covers general techniques for preventing gambling urges and maintaining a healthy lifestyle."
        case "Financial health restoration": return "This area focuses on improving financial health and reducing stress related to money."
        case "Rebuilding relationship trust": return "This area focuses on rebuilding trust in relationships and social support."
        case "Mental health and mindfulness": return "This area covers mindfulness exercises and mental health strategies."
        case "Craving management techniques": return "This area focuses on managing cravings and urges related to gambling."
        case "Healthy habit replacement": return "This area focuses on finding healthy alternatives to gambling."
        case "Stress reduction strategies": return "This area covers strategies for managing stress and reducing gambling urges."
        default: return ""
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
                                .fontWeight(.medium)
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(isEmailFocused ? BFColors.accent : .white.opacity(0.7))
                                    .font(.system(size: 16))
                                
                                TextField("your@email.com", text: $viewModel.email)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .focused($isEmailFocused)
                                    .foregroundColor(Color(hex: "#1B263B")) // Darker text for better contrast
                                    .onChange(of: viewModel.email) { oldValue, newValue in
                                        // Clear error when typing
                                        emailErrorMessage = nil
                                    }
                                
                                if !viewModel.email.isEmpty {
                                    Button(action: {
                                        viewModel.email = ""
                                        emailErrorMessage = nil
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(Color(hex: "#718096")) // Darker gray for better contrast
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
                                    .stroke(emailErrorMessage != nil ? BFColors.error : (isEmailFocused ? BFColors.accent : Color.clear), lineWidth: 1.5)
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
                                .fontWeight(.medium)
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(isPasswordFocused ? BFColors.accent : .white.opacity(0.7))
                                    .font(.system(size: 16))
                                
                                if showingPassword {
                                    TextField("Your password", text: $viewModel.password)
                                        .focused($isPasswordFocused)
                                        .foregroundColor(Color(hex: "#1B263B"))
                                        .onChange(of: viewModel.password) { oldValue, newValue in
                                            // Clear error when typing
                                            passwordErrorMessage = nil
                                        }
                                } else {
                                    SecureField("Your password", text: $viewModel.password)
                                        .focused($isPasswordFocused)
                                        .foregroundColor(Color(hex: "#1B263B"))
                                        .onChange(of: viewModel.password) { oldValue, newValue in
                                            // Clear error when typing
                                            passwordErrorMessage = nil
                                        }
                                }
                                
                                Button(action: {
                                    showingPassword.toggle()
                                }) {
                                    Image(systemName: showingPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(Color(hex: "#718096"))
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
                                    .stroke(passwordErrorMessage != nil ? BFColors.error : (isPasswordFocused ? BFColors.accent : Color.clear), lineWidth: 1.5)
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
                                .shadow(color: Color.black.opacity(0.05), radius: 4)
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
        }
        .padding(.bottom, 32)
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

// MARK: - TriggerIdentificationIntroView
struct TriggerIdentificationIntroView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    
    var body: some View {
            VStack(spacing: 30) {
            Spacer().frame(height: 20)
            
            // Header image
            Image(systemName: "brain.head.profile")
                .font(.system(size: 80))
                .foregroundColor(.white)
                .padding(30)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [BFColors.primary.opacity(0.7), BFColors.primary.opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: BFColors.primary.opacity(0.5), radius: 15, x: 0, y: 5)
                .scaleEffect(animateContent ? 1.0 : 0.8)
                .opacity(animateContent ? 1.0 : 0.0)
            
            VStack(spacing: 16) {
                // Title
                Text("Understand Your Triggers")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                // Description
                Text("Identifying what triggers your gambling urges is a critical step in taking control. Let's map these triggers and develop strategies to manage them.")
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 10)
            
            Spacer()
            
            // Button
            Button(action: {
                viewModel.nextScreen()
            }) {
                HStack(spacing: 8) {
                    Text("Start Mapping")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                }
                        .foregroundColor(.white)
                .frame(height: 24)
                .padding(.vertical, 16)
                .padding(.horizontal, 30)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(12)
                .shadow(color: BFColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .scaleEffect(animateContent ? 1.0 : 0.9)
            
            Button(action: {
                viewModel.skipToSignIn()
            }) {
                Text("Skip This Step")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.vertical, 16)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            
            Spacer().frame(height: 20)
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                animateContent = true
            }
        }
    }
}

// MARK: - TriggerMappingView
struct TriggerMappingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var selectedCategoryIndex = 0
    @State private var animateContent = false
    @State private var customTrigger = ""
    
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
            .padding(.top, 20)
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
                                                .white : .white.opacity(0.9))  // Increased opacity from 0.8 to 0.9
                                .fontWeight(selectedCategoryIndex == index ? .semibold : .medium)  // Added font weight difference
                        }
                    }
                }
                        .padding(.horizontal, 20)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            
            // Triggers grid
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(viewModel.triggerCategories[selectedCategoryIndex].triggers, id: \.self) { trigger in
                        Button(action: {
                            toggleTrigger(trigger)
                        }) {
                    HStack {
                                Text(trigger)
                                    .font(.system(size: 16, weight: viewModel.selectedTriggers.contains(trigger) ? .semibold : .regular))  // Added weight difference
                                    .foregroundColor(viewModel.selectedTriggers.contains(trigger) ? .white : .white.opacity(0.9))
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                                
                                Image(systemName: viewModel.selectedTriggers.contains(trigger) ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 20))  // Increased size from default to 20
                                    .foregroundColor(viewModel.selectedTriggers.contains(trigger) ? BFColors.accent : .white.opacity(0.7))  // Increased opacity from 0.5 to 0.7
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(viewModel.selectedTriggers.contains(trigger) ? 
                                          BFColors.accent.opacity(0.3) : Color.white.opacity(0.15))  // Increased opacity values
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(viewModel.selectedTriggers.contains(trigger) ? BFColors.accent.opacity(0.5) : Color.white.opacity(0.3), lineWidth: 1)  // Added border
                                    )
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
                                RoundedRectangle(cornerRadius: 10)
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
                    .frame(height: 24)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [BFColors.primary, BFColors.primary.opacity(0.9)]),  // Changed from accent to primary color (deeper blue)
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .cornerRadius(12)
                        .opacity(viewModel.selectedTriggers.isEmpty ? 0.5 : 1.0)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)  // Added white border for better visibility
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)  // Added shadow for depth
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

// MARK: - TriggerIntensityView
struct TriggerIntensityView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var currentTriggerIndex = 0
    @State private var animateContent = false
    @State private var intensity = 5
    
    var currentTrigger: String {
        guard currentTriggerIndex < viewModel.selectedTriggers.count else { return "" }
        return viewModel.selectedTriggers[currentTriggerIndex]
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Rate Your Triggers")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("How strong is your urge to gamble when you experience this trigger?")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            .padding(.top, 20)
            .opacity(animateContent ? 1.0 : 0.0)
            
            // Progress indicator
            HStack {
                Text("\(currentTriggerIndex + 1) of \(viewModel.selectedTriggers.count)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 3)
                            .fill(BFColors.accent)
                            .frame(width: geometry.size.width * CGFloat(currentTriggerIndex + 1) / CGFloat(viewModel.selectedTriggers.count), height: 6)
                    }
                }
                .frame(height: 6)
                    .padding(.vertical, 8)
            }
            .padding(.horizontal, 20)
            .opacity(animateContent ? 1.0 : 0.0)
            
            // Current trigger
            VStack(spacing: 20) {
                Text(currentTrigger)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.1))
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                // Intensity slider
                VStack(spacing: 16) {
                    Slider(value: Binding<Double>(
                        get: { Double(intensity) },
                        set: { intensity = Int($0) }
                    ), in: 1...10, step: 1)
                    .accentColor(BFColors.accent)
                    
                    // Intensity labels
                    HStack {
                        Text("Mild")
                            .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                        
                        Text("Moderate")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                        
                        Text("Severe")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    // Selected intensity display
                    Text("\(intensity)/10")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(
                            intensity <= 3 ? .green :
                            intensity <= 6 ? .yellow :
                            .red
                        )
                        .padding(.top, 8)
                }
                .padding(.horizontal, 8)
                .padding(.top, 24)
            }
            .padding(.horizontal, 20)
            .opacity(animateContent ? 1.0 : 0.0)
            
            Spacer()
            
            // Navigation buttons
            HStack {
                // Skip button
                Button(action: {
                    saveCurrentIntensity()
                    moveToNextTrigger()
                }) {
                    Text("Skip")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.vertical, 16)
                }
                
                Spacer()
                
                // Continue button
                Button(action: {
                    saveCurrentIntensity()
                    moveToNextTrigger()
                }) {
                    Text(isLastTrigger ? "Complete" : "Next")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 120, height: 24)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .cornerRadius(12)
                        )
                }
                .shadow(color: BFColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .opacity(animateContent ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                animateContent = true
            }
            
            // Initialize intensity from stored value if available
            if let storedIntensity = viewModel.triggerIntensities[currentTrigger] {
                intensity = storedIntensity
            } else {
                intensity = 5 // Default value
            }
        }
    }
    
    private var isLastTrigger: Bool {
        return currentTriggerIndex == viewModel.selectedTriggers.count - 1
    }
    
    private func saveCurrentIntensity() {
        viewModel.triggerIntensities[currentTrigger] = intensity
    }
    
    private func moveToNextTrigger() {
        if isLastTrigger {
            viewModel.nextScreen()
        } else {
            withAnimation {
                currentTriggerIndex += 1
                
                // Set intensity to stored value if available
                if let storedIntensity = viewModel.triggerIntensities[viewModel.selectedTriggers[currentTriggerIndex]] {
                    intensity = storedIntensity
                } else {
                    intensity = 5 // Default value
                }
            }
        }
    }
}

// MARK: - TriggerStrategiesView
struct TriggerStrategiesView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    @State private var currentTriggerIndex = 0
    @State private var selectedStrategies: [String] = []
    
    // Sort triggers by intensity (highest first)
    var sortedTriggers: [String] {
        return viewModel.selectedTriggers.sorted { (a, b) -> Bool in
            return viewModel.triggerIntensities[a] ?? 0 > viewModel.triggerIntensities[b] ?? 0
        }
    }
    
    var currentTrigger: String {
        guard currentTriggerIndex < sortedTriggers.count else { return "" }
        return sortedTriggers[currentTriggerIndex]
    }
    
    var currentIntensity: Int {
        return viewModel.triggerIntensities[currentTrigger] ?? 5
    }
    
    // Get strategies for the current trigger's category
    var strategiesForCurrentTrigger: [String] {
        // Find which category the current trigger belongs to
        for category in viewModel.triggerCategories {
            if category.triggers.contains(currentTrigger) {
                return viewModel.strategyOptions[category.name] ?? []
            }
        }
        // Default strategies if category not found
        return ["Take a deep breath", "Call a support person", "Distract yourself with another activity", "Remember your motivation for quitting"]
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Develop Your Strategies")
                    .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Select strategies that will help you manage this trigger")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            .padding(.top, 20)
            .opacity(animateContent ? 1.0 : 0.0)
            
            // Progress indicator
            HStack {
                Text("\(currentTriggerIndex + 1) of \(sortedTriggers.count)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 3)
                            .fill(BFColors.accent)
                            .frame(width: geometry.size.width * CGFloat(currentTriggerIndex + 1) / CGFloat(sortedTriggers.count), height: 6)
                    }
                }
                .frame(height: 6)
                .padding(.vertical, 8)
            }
            .padding(.horizontal, 20)
            .opacity(animateContent ? 1.0 : 0.0)
            
            // Current trigger with intensity
            VStack(spacing: 8) {
                Text(currentTrigger)
                    .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                
                HStack {
                    Text("Intensity:")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("\(currentIntensity)/10")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(
                            currentIntensity <= 3 ? .green :
                            currentIntensity <= 6 ? .yellow :
                            .red
                        )
                }
            }
            .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.1))
            )
            .padding(.horizontal, 20)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            .opacity(animateContent ? 1.0 : 0.0)
            
            // Strategy options
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(strategiesForCurrentTrigger, id: \.self) { strategy in
                        Button(action: {
                            toggleStrategy(strategy)
                        }) {
                            HStack {
                                Text(strategy)
                                    .font(.system(size: 16))
                                    .foregroundColor(selectedStrategies.contains(strategy) ? .white : .white.opacity(0.9))
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                                
                                Image(systemName: selectedStrategies.contains(strategy) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedStrategies.contains(strategy) ? BFColors.accent : .white.opacity(0.5))
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selectedStrategies.contains(strategy) ? 
                                          BFColors.accent.opacity(0.2) : Color.white.opacity(0.1))
                            )
                        }
                    }
                    
                    // Custom strategy input
                    TextField("Add your own strategy...", text: Binding(
                        get: { viewModel.customTrigger },
                        set: { viewModel.customTrigger = $0 }
                    ))
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.1))
                    )
                    .submitLabel(.done)
                    .onSubmit {
                        if !viewModel.customTrigger.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            let newStrategy = viewModel.customTrigger.trimmingCharacters(in: .whitespacesAndNewlines)
                            selectedStrategies.append(newStrategy)
                            viewModel.customTrigger = ""
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            
            Spacer()
            
            // Navigation buttons
            HStack {
                // Skip button
                Button(action: {
                    saveCurrentStrategies()
                    moveToNextTrigger()
                }) {
                    Text("Skip")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.vertical, 16)
                }
                
                Spacer()
                
                // Continue button
                Button(action: {
                    saveCurrentStrategies()
                    moveToNextTrigger()
                }) {
                    Text(isLastTrigger ? "Complete" : "Next")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 120, height: 24)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .cornerRadius(12)
                            .opacity(selectedStrategies.isEmpty ? 0.5 : 1.0)
                        )
                }
                .shadow(color: selectedStrategies.isEmpty ? Color.clear : BFColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
                .disabled(selectedStrategies.isEmpty)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .opacity(animateContent ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                animateContent = true
            }
            
            // Initialize selected strategies from stored values if available
            if let storedStrategies = viewModel.triggerStrategies[currentTrigger] {
                selectedStrategies = storedStrategies
            } else {
                selectedStrategies = []
            }
        }
    }
    
    private var isLastTrigger: Bool {
        return currentTriggerIndex == sortedTriggers.count - 1
    }
    
    private func toggleStrategy(_ strategy: String) {
        if let index = selectedStrategies.firstIndex(of: strategy) {
            selectedStrategies.remove(at: index)
        } else {
            selectedStrategies.append(strategy)
        }
    }
    
    private func saveCurrentStrategies() {
        viewModel.triggerStrategies[currentTrigger] = selectedStrategies
    }
    
    private func moveToNextTrigger() {
        if isLastTrigger {
            viewModel.nextScreen()
        } else {
            withAnimation {
                currentTriggerIndex += 1
                
                // Set strategies to stored values if available
                if let storedStrategies = viewModel.triggerStrategies[sortedTriggers[currentTriggerIndex]] {
                    selectedStrategies = storedStrategies
                } else {
                    selectedStrategies = []
                }
            }
        }
    }
}

// MARK: - TriggerSummaryView
struct TriggerSummaryView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    
    // Get top triggers sorted by intensity
    var topTriggers: [String] {
        return viewModel.selectedTriggers
            .sorted { (a, b) -> Bool in
                return viewModel.triggerIntensities[a] ?? 0 > viewModel.triggerIntensities[b] ?? 0
            }
            .prefix(3)
            .map { $0 }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 60))
                        .foregroundColor(BFColors.accent)
                        .padding(.bottom, 8)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .scaleEffect(animateContent ? 1.0 : 0.7)
                    
                    Text("Your Trigger Plan")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Here's a summary of your personal trigger management plan.")
                        .font(.system(size: 17))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                
                // Top triggers section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Your Top Triggers")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    ForEach(topTriggers, id: \.self) { trigger in
                        HStack(alignment: .top, spacing: 16) {
                            // Intensity indicator
            ZStack {
                Circle()
                                    .fill(
                                        (viewModel.triggerIntensities[trigger] ?? 0) <= 3 ? Color.green :
                                        (viewModel.triggerIntensities[trigger] ?? 0) <= 6 ? Color.yellow :
                                        Color.red
                                    )
                    .frame(width: 40, height: 40)
                
                                Text("\(viewModel.triggerIntensities[trigger] ?? 0)")
                                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            
                            VStack(alignment: .leading, spacing: 8) {
                                // Trigger name
                                Text(trigger)
                                    .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
                                // Strategies
                                if let strategies = viewModel.triggerStrategies[trigger], !strategies.isEmpty {
                                    VStack(alignment: .leading, spacing: 4) {
                                        ForEach(strategies.prefix(2), id: \.self) { strategy in
                                            HStack(alignment: .top, spacing: 6) {
                                                Image(systemName: "arrow.right.circle.fill")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(BFColors.accent)
                                                
                                                Text(strategy)
                                                    .font(.system(size: 16))
                                                    .foregroundColor(.white.opacity(0.9))
                                                    .fixedSize(horizontal: false, vertical: true)
                                            }
                                        }
                                        
                                        if (viewModel.triggerStrategies[trigger]?.count ?? 0) > 2 {
                                            Text("+ \((viewModel.triggerStrategies[trigger]?.count ?? 0) - 2) more")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.white.opacity(0.7))
                                                .padding(.leading, 24)
                                        }
                                    }
                                } else {
                                    Text("No strategies defined")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.white.opacity(0.7))
                                        .italic()
                                }
                            }
                        }
                        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
                    }
                }
                .padding(.horizontal, 20)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                
                // Note about all triggers
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(BFColors.accent)
                    
                    Text("You've identified \(viewModel.selectedTriggers.count) triggers in total. All of these will be available in your personalized plan.")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(BFColors.accent.opacity(0.1))
                )
                .padding(.horizontal, 20)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 10)
                
                Spacer()
                
                // Continue button
                Button(action: {
                    viewModel.nextScreen()
                }) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .cornerRadius(12)
                        )
                }
                .shadow(color: BFColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .opacity(animateContent ? 1.0 : 0.0)
            }
            .padding(.vertical, 20)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                animateContent = true
            }
        }
    }
}
