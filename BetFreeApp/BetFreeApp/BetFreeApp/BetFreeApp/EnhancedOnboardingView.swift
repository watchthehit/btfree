import SwiftUI

// MARK: - OnboardingViewModel
@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    @Published var username: String = ""
    @Published var dailyGoal: Int = 30
    @Published var userTriggers: [String] = []
    @Published var customTrigger: String = ""
    @Published var notificationPreferences: [String: Bool] = [
        "Daily Check-in": true,
        "Weekly Summary": true,
        "Craving Alerts": false,
        "Achievement Notifications": true
    ]
    
    // Paywall related properties
    @Published var hasAgreedToFreeTrial: Bool = false
    @Published var isTrialActive: Bool = false
    @Published var trialEndDate: Date?
    @Published var selectedPricingTier: Int = 1 // Default to annual
    
    // Constants for screens
    let WELCOME_SCREEN = 0
    let NAME_INPUT_SCREEN = 1
    let GOAL_SETTING_SCREEN = 2
    let FREE_TRIAL_TEASER_SCREEN = 3
    let TRIGGER_SELECTION_SCREEN = 4
    let NOTIFICATION_SETUP_SCREEN = 5
    let FEATURE_OVERVIEW_SCREEN = 6
    let SOFT_GATE_SCREEN = 7
    let PRIVACY_SCREEN = 8
    let COMPLETION_SCREEN = 9
    
    let totalScreens = 10
    
    private let commonTriggers = [
        "Stress", "Boredom", "Social Pressure", "Celebration", 
        "After Meals", "While Drinking", "Financial Concerns"
    ]
    
    var availableTriggers: [String] {
        commonTriggers.filter { !userTriggers.contains($0) }
    }
    
    var daysRemainingInTrial: Int {
        guard let endDate = trialEndDate else { return 0 }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: endDate)
        return max(0, components.day ?? 0)
    }
    
    var trialProgress: Double {
        guard trialEndDate != nil else { return 1.0 }
        let totalDays = 7.0
        let daysRemaining = Double(daysRemainingInTrial)
        return (totalDays - daysRemaining) / totalDays
    }
    
    func nextPage() {
        if currentPage < totalScreens - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage += 1
            }
        }
    }
    
    func previousPage() {
        if currentPage > 0 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage -= 1
            }
        }
    }
    
    func goToPage(_ page: Int) {
        if page >= 0 && page < totalScreens {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage = page
            }
        }
    }
    
    func addTrigger(_ trigger: String) {
        if !trigger.isEmpty && !userTriggers.contains(trigger) {
            userTriggers.append(trigger)
            customTrigger = ""
        }
    }
    
    func removeTrigger(_ trigger: String) {
        if let index = userTriggers.firstIndex(of: trigger) {
            userTriggers.remove(at: index)
        }
    }
    
    func saveToAppState(_ appState: AppState) {
        appState.username = username
        appState.dailyGoal = dailyGoal
        appState.userTriggers = userTriggers
        appState.notificationPreferences = notificationPreferences
        
        // Set trial status if agreed to free trial
        if hasAgreedToFreeTrial {
            let sevenDaysLater = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
            appState.trialEndDate = sevenDaysLater
            appState.isTrialActive = true
            appState.hasProAccess = true
        }
        
        appState.completeOnboarding()
    }
    
    func startFreeTrial() {
        hasAgreedToFreeTrial = true
        isTrialActive = true
        trialEndDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
    }
}

// MARK: - Main Onboarding View
struct EnhancedOnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        ZStack {
            BFBackgroundView(style: .waves, gradient: BFColors.calmGradient())
            
            VStack {
                // Header
                HStack {
                    if viewModel.currentPage > 0 {
                        Button(action: {
                            viewModel.previousPage()
                        }) {
                            HStack(spacing: 2) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Back")
                            }
                        }
                        .bfTextButton()
                        .padding()
                    } else {
                        Spacer()
                            .frame(width: 80)
                    }
                    
                    Spacer()
                    
                    Text("Step \(viewModel.currentPage + 1) of \(viewModel.totalScreens)")
                        .font(BFTypography.caption)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    if viewModel.currentPage < viewModel.totalScreens - 1 && 
                       viewModel.currentPage != viewModel.SOFT_GATE_SCREEN {
                        Button(action: {
                            // Skip logic changes based on screen
                            if viewModel.currentPage == viewModel.FREE_TRIAL_TEASER_SCREEN {
                                viewModel.goToPage(viewModel.TRIGGER_SELECTION_SCREEN)
                            } else if viewModel.currentPage == viewModel.FEATURE_OVERVIEW_SCREEN {
                                viewModel.goToPage(viewModel.PRIVACY_SCREEN)
                            } else {
                                viewModel.nextPage()
                            }
                        }) {
                            Text("Skip")
                        }
                        .foregroundColor(.white)
                        .padding()
                    } else {
                        Spacer()
                            .frame(width: 80)
                    }
                }
                .padding(.horizontal)
                
                // Content
                TabView(selection: $viewModel.currentPage) {
                    WelcomeScreen()
                        .tag(viewModel.WELCOME_SCREEN)
                    
                    NameInputScreen(username: $viewModel.username)
                        .tag(viewModel.NAME_INPUT_SCREEN)
                    
                    GoalSettingScreen(dailyGoal: $viewModel.dailyGoal)
                        .tag(viewModel.GOAL_SETTING_SCREEN)
                    
                    FreeTrialTeaserScreen()
                        .tag(viewModel.FREE_TRIAL_TEASER_SCREEN)
                    
                    TriggerSelectionScreen(
                        availableTriggers: viewModel.availableTriggers,
                        userTriggers: $viewModel.userTriggers,
                        customTrigger: $viewModel.customTrigger,
                        addTrigger: viewModel.addTrigger,
                        removeTrigger: viewModel.removeTrigger
                    )
                        .tag(viewModel.TRIGGER_SELECTION_SCREEN)
                    
                    NotificationSetupScreen(preferences: $viewModel.notificationPreferences)
                        .tag(viewModel.NOTIFICATION_SETUP_SCREEN)
                    
                    FeatureOverviewScreen()
                        .tag(viewModel.FEATURE_OVERVIEW_SCREEN)
                        
                    SoftGateScreen()
                        .tag(viewModel.SOFT_GATE_SCREEN)
                    
                    PrivacyScreen()
                        .tag(viewModel.PRIVACY_SCREEN)
                    
                    CompletionScreen {
                        viewModel.saveToAppState(appState)
                    }
                    .tag(viewModel.COMPLETION_SCREEN)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Progress indicator
                HStack(spacing: 8) {
                    ForEach(0..<10) { index in
                        if index < viewModel.totalScreens {
                            Circle()
                                .fill(viewModel.currentPage == index ? Color.white : Color.white.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .scaleEffect(viewModel.currentPage == index ? 1.2 : 1.0)
                                .animation(.spring(response: 0.4), value: viewModel.currentPage)
                        }
                    }
                }
                .padding(.bottom)
                
                // Continue button - hide on soft gate screen since it has its own buttons
                if viewModel.currentPage < viewModel.totalScreens - 1 && 
                   viewModel.currentPage != viewModel.SOFT_GATE_SCREEN {
                    Button(action: {
                        viewModel.nextPage()
                    }) {
                        HStack {
                            Text("Continue")
                            Image(systemName: "arrow.right")
                        }
                    }
                    .bfPrimaryButton(isWide: true)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .environmentObject(viewModel)
        }
    }
}

// MARK: - WelcomeScreen
struct WelcomeScreen: View {
    var body: some View {
        BFCard {
            VStack(spacing: 30) {
                BFAssets.appLogo(size: 120)
                    .padding(.top, 20)
                
                Text("Welcome to BetFree")
                    .heading1()
                
                Text("Your journey to a healthier relationship with gambling starts here.")
                    .bodyLarge()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                BFAssets.OnboardingIllustrations.welcome(size: 160)
                    .padding(.vertical, 10)
                
                Text("This app will help you track triggers, manage cravings, and build healthier habits.")
                    .bodyMedium()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
            }
        }
        .padding(.vertical)
    }
}

// MARK: - Individual Screens
struct NameInputScreen: View {
    @Binding var username: String
    @FocusState private var isNameFieldFocused: Bool
    
    var body: some View {
        BFCard {
            VStack(spacing: 30) {
                BFAssets.OnboardingIllustrations.nameInput(size: 140)
                    .padding(.top, 20)
                
                Text("Let's Get to Know You")
                    .heading2()
                
                Text("How should we call you?")
                    .bodyLarge()
                    .multilineTextAlignment(.center)
                
                BFTextField(
                    title: "Your Name",
                    placeholder: "Enter your name",
                    text: $username,
                    icon: "person"
                )
                .focused($isNameFieldFocused)
                .onAppear {
                    // Auto-focus the name field after a brief delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isNameFieldFocused = true
                    }
                }
                
                Text("We'll use this to personalize your experience and make your journey more meaningful.")
                    .font(BFTypography.caption)
                    .foregroundColor(BFColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
            }
        }
        .padding(.vertical)
    }
}

// MARK: - GoalSettingScreen
struct GoalSettingScreen: View {
    @Binding var dailyGoal: Int
    @State private var sliderAnimation = false
    
    var body: some View {
        BFCard {
            VStack(spacing: 25) {
                BFAssets.OnboardingIllustrations.goalSetting(size: 140)
                    .padding(.top, 10)
                
                Text("Set Your Daily Goal")
                    .heading2()
                
                Text("How many minutes each day do you want to commit to mindfulness exercises?")
                    .bodyMedium()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Goal display with animation
                ZStack {
                    Circle()
                        .fill(BFColors.secondary.opacity(0.15))
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(dailyGoal) / 60.0)
                        .stroke(BFColors.secondary, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 0.6), value: dailyGoal)
                    
                    VStack(spacing: 0) {
                        Text("\(dailyGoal)")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(BFColors.secondary)
                        
                        Text("minutes")
                            .font(BFTypography.caption)
                            .foregroundColor(BFColors.textSecondary)
                    }
                }
                .padding(.vertical, 10)
                
                // Slider
                VStack(spacing: 10) {
                    Slider(value: Binding(
                        get: { Double(dailyGoal) },
                        set: { dailyGoal = Int($0) }
                    ), in: 5...60, step: 5)
                    .tint(BFColors.secondary)
                    .padding(.horizontal)
                    
                    HStack {
                        Text("5 min")
                            .font(BFTypography.caption)
                            .foregroundColor(BFColors.textSecondary)
                        
                        Spacer()
                        
                        Text("60 min")
                            .font(BFTypography.caption)
                            .foregroundColor(BFColors.textSecondary)
                    }
                    .padding(.horizontal, 25)
                }
                
                Text("Research shows that even short mindfulness sessions can reduce cravings and improve mental clarity.")
                    .font(BFTypography.caption)
                    .foregroundColor(BFColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
            }
            .padding(.bottom, 20)
        }
        .padding(.vertical)
        .onAppear {
            // Animate the slider slightly on appear for visual appeal
            withAnimation(.easeInOut(duration: 0.6).delay(0.3)) {
                sliderAnimation = true
            }
        }
    }
}

struct TriggerSelectionScreen: View {
    let availableTriggers: [String]
    @Binding var userTriggers: [String]
    @Binding var customTrigger: String
    let addTrigger: (String) -> Void
    let removeTrigger: (String) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Identify Your Triggers")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("What situations typically trigger gambling cravings for you?")
                .font(.title3)
                .multilineTextAlignment(.center)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your selected triggers:")
                        .font(.headline)
                        .padding(.top)
                    
                    if userTriggers.isEmpty {
                        Text("None selected yet")
                            .italic()
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(userTriggers, id: \.self) { trigger in
                            HStack {
                                Text(trigger)
                                Spacer()
                                Button(action: {
                                    removeTrigger(trigger)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    
                    Divider()
                    
                    Text("Common triggers:")
                        .font(.headline)
                        .padding(.top)
                    
                    ForEach(availableTriggers, id: \.self) { trigger in
                        HStack {
                            Text(trigger)
                            Spacer()
                            Button(action: {
                                addTrigger(trigger)
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    
                    Divider()
                    
                    Text("Add a custom trigger:")
                        .font(.headline)
                        .padding(.top)
                    
                    HStack {
                        TextField("Custom trigger", text: $customTrigger)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            addTrigger(customTrigger)
                        }) {
                            Text("Add")
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(customTrigger.isEmpty ? Color.gray : Color.blue)
                                .cornerRadius(5)
                        }
                        .disabled(customTrigger.isEmpty)
                    }
                }
                .padding()
            }
        }
        .padding()
    }
}

struct NotificationSetupScreen: View {
    @Binding var preferences: [String: Bool]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Notification Preferences")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("How would you like to receive support from the app?")
                .font(.title3)
                .multilineTextAlignment(.center)
            
            Form {
                ForEach(Array(preferences.keys.sorted()), id: \.self) { key in
                    if let isEnabled = preferences[key] {
                        Toggle(key, isOn: Binding(
                            get: { isEnabled },
                            set: { preferences[key] = $0 }
                        ))
                    }
                }
            }
            .frame(height: 250)
            
            Text("You can always change these later in Settings.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct FeatureOverviewScreen: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("App Features")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Everything you need to stay on track")
                .font(.title3)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 15) {
                FeatureRow(icon: "chart.bar.fill", title: "Track Progress", description: "Monitor your daily and weekly achievements")
                
                FeatureRow(icon: "bell.fill", title: "Smart Alerts", description: "Get notified when you're near known triggers")
                
                FeatureRow(icon: "brain.head.profile", title: "Mindfulness Exercises", description: "Quick activities to help manage cravings")
                
                FeatureRow(icon: "person.3.fill", title: "Community Support", description: "Connect with others on similar journeys")
                
                FeatureRow(icon: "lock.shield.fill", title: "Private & Secure", description: "Your data never leaves your device")
            }
            .padding()
        }
        .padding()
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.system(size: 30))
                .frame(width: 40)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 5)
    }
}

struct PrivacyScreen: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Your Privacy Matters")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("We take your privacy seriously")
                .font(.title3)
                .multilineTextAlignment(.center)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    PrivacySection(
                        title: "Local Storage Only",
                        description: "All your personal data is stored locally on your device. We don't upload or share your information with any third parties."
                    )
                    
                    PrivacySection(
                        title: "No Tracking",
                        description: "We don't track your location or online activities. The app only uses the information you explicitly provide."
                    )
                    
                    PrivacySection(
                        title: "Notifications",
                        description: "Notifications are generated on your device based on your settings and are not monitored externally."
                    )
                    
                    PrivacySection(
                        title: "Data Control",
                        description: "You can export or delete your data at any time from the Settings menu."
                    )
                }
                .padding()
            }
            
            Text("By continuing, you agree to our Privacy Policy and Terms of Service.")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding()
        }
        .padding()
    }
}

struct PrivacySection: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 5)
    }
}

struct CompletionScreen: View {
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
            
            Text("You're All Set!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Your BetFree journey begins now")
                .font(.title3)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("• Track your progress daily")
                Text("• Complete mindfulness exercises")
                Text("• Report cravings when they happen")
                Text("• Review your insights weekly")
            }
            .padding()
            
            Spacer()
            
            Button(action: onComplete) {
                Text("Get Started")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}

// MARK: - Preview
struct EnhancedOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedOnboardingView()
            .environmentObject(AppState())
    }
} 