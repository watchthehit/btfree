import SwiftUI
// We use placeholder extension from BFStandardComponents.swift

// Import components needed for onboarding

/**
 * EnhancedOnboardingView
 * A modern, personalized onboarding experience for BetFree utilizing best practices
 * from leading mental health and wellness apps.
 */

// MARK: - Helper Extensions
// The placeholder extension is defined in BFStandardComponents.swift
// DO NOT redefine it here to avoid the "Invalid redeclaration" error

// Using Color hex init from ColorExtensions.swift

// MARK: - Logo Component
struct BetFreeLogo: View {
    enum LogoStyle {
        case standard, compact
    }
    
    var style: LogoStyle = .standard
    var size: CGFloat = 80
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#1B263B"),
                            Color(hex: "#0D1B2A")
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: style == .compact ? size * 0.9 : size,
                       height: style == .compact ? size * 0.9 : size)
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
            
            // Text-based logo
            VStack(spacing: -2) {
                // "Bet" part with strikethrough effect
                ZStack(alignment: .center) {
                    Text("Bet")
                        .font(.system(size: style == .compact ? size * 0.30 : size * 0.35, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Strikethrough line
                    Rectangle()
                        .fill(Color(hex: "#64FFDA"))
                        .frame(width: style == .compact ? size * 0.48 : size * 0.55, height: style == .compact ? size * 0.05 : size * 0.06)
                        .rotationEffect(.degrees(-10))
                        .offset(y: style == .compact ? size * 0.03 : size * 0.04)
                }
                
                // "Free" part with emphasis
                Text("Free")
                    .font(.system(size: style == .compact ? size * 0.32 : size * 0.38, weight: .heavy))
                    .foregroundColor(Color(hex: "#64FFDA"))
            }
            .offset(y: -size * 0.02) // Slight adjustment to center visually
            
            // Highlight accent
            Circle()
                .trim(from: 0.7, to: 0.9)
                .stroke(
                    Color(hex: "#64FFDA"),
                    style: StrokeStyle(
                        lineWidth: style == .compact ? size * 0.06 : size * 0.08,
                        lineCap: .round
                    )
                )
                .frame(width: style == .compact ? size * 0.95 : size * 1.05)
                .rotationEffect(.degrees(45))
                .shadow(color: Color(hex: "#64FFDA").opacity(0.6), radius: 8, x: 0, y: 0)
        }
    }
}

// MARK: - Main Onboarding View
struct EnhancedOnboardingView: View {
    @State private var currentPage = 0
    @State private var isAnimating = false
    @State private var userName = ""
    @State private var selectedGoal = "Reduce"
    @State private var selectedTriggers: [String] = []
    @State private var dailyMindfulnessGoal = 10
    @State private var notificationsEnabled = true
    @State private var reminderTime = Date()
    @State private var showBreatheAnimation = false
    @State private var breatheProgress: CGFloat = 0.0
    @State private var breatheIn = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    // Available goals
    private let goals = ["Reduce", "Quit", "Maintain control"]
    
    // Common triggers
    private let commonTriggers = [
        "Stress", "Boredom", "Financial pressure", 
        "Social situations", "Advertisements", "Alcohol", 
        "Free time", "Negative emotions"
    ]
    
    // Completion handler
    var onCompleteOnboarding: () -> Void
    
    // Initialize with a default empty completion handler
    init(onCompleteOnboarding: @escaping () -> Void = {}) {
        self.onCompleteOnboarding = onCompleteOnboarding
    }
    
    // Onboarding pages
    private let valuePropositionPages = [
        OnboardingPage(
            title: "Break Free From Gambling",
            description: "Take the first step toward a healthier relationship with gambling through evidence-based tools and support.",
            illustration: AnyView(BFAssets.BFOnboardingIllustrations.BreakingFree(size: 200))
        ),
        OnboardingPage(
            title: "Track Your Progress",
            description: "Monitor your journey with personalized insights and celebrate your milestones along the way.",
            illustration: AnyView(BFAssets.BFOnboardingIllustrations.GrowthJourney(size: 200))
        ),
        OnboardingPage(
            title: "Find Your Calm",
            description: "Access mindfulness exercises and breathing techniques to help manage urges and reduce stress.",
            illustration: AnyView(BFAssets.BFOnboardingIllustrations.CalmMind(size: 200))
        ),
        OnboardingPage(
            title: "Connect With Support",
            description: "You're not alone. Join a community of people on similar journeys and access professional guidance.",
            illustration: AnyView(BFAssets.BFOnboardingIllustrations.SupportNetwork(size: 200))
        )
    ]
    
    // Calculate total pages including value propositions and additional screens
    private var totalPages: Int {
        return valuePropositionPages.count + 4 // +4 for personalization, goals, triggers, and notifications
    }
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#0D1B2A"),
                    Color(hex: "#1B263B")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // Main content
            VStack(spacing: 0) {
                // Logo (improved positioning)
                HStack {
                    BetFreeLogo(style: .compact, size: currentPage < valuePropositionPages.count ? 70 : 50)
                        .padding(.top, 20)
                        .padding(.leading, 20)
                    Spacer()
                }
                .opacity(isAnimating ? 1 : 0)
                .animation(.easeIn(duration: 0.5).delay(0.2), value: isAnimating)
                
                // Increased vertical spacing
                Spacer().frame(height: 30)
                
                if currentPage < valuePropositionPages.count {
                    // Value proposition pages
                    TabView(selection: $currentPage) {
                        ForEach(0..<valuePropositionPages.count, id: \.self) { index in
                            OnboardingPageView(page: valuePropositionPages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut, value: currentPage)
                    .transition(.slide)
                    .padding(.bottom, 40) // Increased bottom padding
                } else if currentPage == valuePropositionPages.count {
                    // Personalization screen
                    PersonalizationView(userName: $userName)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                } else if currentPage == valuePropositionPages.count + 1 {
                    // Goal setting screen
                    GoalSettingView(selectedGoal: $selectedGoal, availableGoals: goals, dailyMindfulnessGoal: $dailyMindfulnessGoal)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                } else if currentPage == valuePropositionPages.count + 2 {
                    // Trigger identification screen
                    TriggerIdentificationView(selectedTriggers: $selectedTriggers, availableTriggers: commonTriggers)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                } else if currentPage == valuePropositionPages.count + 3 {
                    // Notifications screen
                    NotificationsSetupView(notificationsEnabled: $notificationsEnabled, reminderTime: $reminderTime)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
                
                // Added spacing before bottom controls
                Spacer().frame(height: 20)
                
                // Bottom controls
                VStack(spacing: 25) { // Increased spacing from 20 to 25
                    // Progress bar
                    ProgressBar(currentStep: currentPage, totalSteps: totalPages)
                        .padding(.horizontal)
                        .padding(.bottom, 10) // Increased from 5 to 10
                    
                    // Navigation buttons
                    HStack {
                        // Back button (except on first page)
                        if currentPage > 0 {
                            Button(action: {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "arrow.left")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Back")
                                        .font(.system(size: 16, weight: .medium))
                                }
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                            }
                        } else {
                            Spacer()
                        }
                        
                        Spacer()
                        
                        // Next/Continue/Get Started button
                        Button(action: {
                            if currentPage < totalPages - 1 {
                                withAnimation {
                                    currentPage += 1
                                }
                            } else {
                                // Complete onboarding and save user preferences
                                completeOnboarding()
                            }
                        }) {
                            HStack(spacing: 8) {
                                Text(currentPage < totalPages - 1 ? "Continue" : "Get Started")
                                    .font(.system(size: 16, weight: .semibold))
                                
                                if currentPage < totalPages - 1 {
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 16, weight: .medium))
                                } else {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 16, weight: .medium))
                                }
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(hex: "#64FFDA"),
                                        Color(hex: "#00B4D8")
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
                        }
                        .disabled(currentPage == valuePropositionPages.count && userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .opacity(currentPage == valuePropositionPages.count && userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 50) // Increased from 40 to 50
                }
                .opacity(isAnimating ? 1 : 0)
                .animation(.easeIn(duration: 0.5).delay(0.4), value: isAnimating)
            }
            
            // Breathing exercise overlay when completing onboarding
            if showBreatheAnimation {
                ZStack {
                    Color.black.opacity(0.85)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 24) {
                        Text(breatheIn ? "Breathe In..." : "Breathe Out...")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
                        
                        ZStack {
                            Circle()
                                .fill(Color.clear)
                                .frame(width: 150, height: 150)
                                .overlay(
                                    Circle()
                                        .stroke(Color(hex: "#64FFDA").opacity(0.4), lineWidth: 8)
                                )
                            
                            Circle()
                                .trim(from: 0, to: breatheProgress)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(hex: "#64FFDA"),
                                            Color(hex: "#00B4D8")
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                )
                                .frame(width: 150, height: 150)
                                .rotationEffect(.degrees(-90))
                            
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(hex: "#64FFDA").opacity(0.6),
                                            Color(hex: "#00B4D8").opacity(0.6)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: breatheIn ? 100 : 50, height: breatheIn ? 100 : 50)
                                .animation(.easeInOut(duration: 4), value: breatheIn)
                        }
                        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
                        
                        Text("Starting your journey...")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.top, 20)
                    }
                }
                .transition(.opacity)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
    
    // Complete onboarding and save user preferences
    private func completeOnboarding() {
        // Show breathing exercise before completing
        withAnimation {
            showBreatheAnimation = true
        }
        
        // Start breathing animation cycle
        startBreathingCycle()
        
        // Set a timer to complete onboarding after breathing exercise
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            // Here you would save all the collected user preferences to your app's state
            print("Saving user preferences:")
            print("- User Name: \(userName)")
            print("- Selected Goal: \(selectedGoal)")
            print("- Daily Mindfulness Goal: \(dailyMindfulnessGoal) minutes")
            print("- Selected Triggers: \(selectedTriggers)")
            print("- Notifications Enabled: \(notificationsEnabled)")
            if notificationsEnabled {
                print("- Reminder Time: \(formatTime(reminderTime))")
            }
            
            // Set onboarding as completed
            hasCompletedOnboarding = true
            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
            UserDefaults.standard.synchronize()
            
            // Call completion handler
            onCompleteOnboarding()
        }
    }
    
    // Start the breathing cycle animation
    private func startBreathingCycle() {
        // Initial breath in
        breatheIn = true
        withAnimation(.easeInOut(duration: 4)) {
            breatheProgress = 0.5
        }
        
        // Schedule breath out after 4 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            breatheIn = false
            withAnimation(.easeInOut(duration: 4)) {
                breatheProgress = 1.0
            }
            
            // Schedule another breath in after 4 more seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                breatheIn = true
                withAnimation(.easeInOut(duration: 4)) {
                    breatheProgress = 0.5
                }
            }
        }
    }
    
    // Format time for display
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Personalization View
struct PersonalizationView: View {
    @Binding var userName: String
    @FocusState private var isNameFieldFocused: Bool
    @State private var hasAppeared = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Personalize Your Journey")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 20)
                .animation(.easeOut(duration: 0.5), value: hasAppeared)
            
            Text("Let's personalize your experience to help you reach your goals.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.1), value: hasAppeared)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("What should we call you?")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                TextField("", text: $userName)
                    .placeholder(when: userName.isEmpty) {
                        Text("Your name").foregroundColor(.white.opacity(0.6))
                    }
                    .padding()
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .focused($isNameFieldFocused)
                    .submitLabel(.done)
                    .onSubmit {
                        isNameFieldFocused = false
                    }
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            .opacity(hasAppeared ? 1 : 0)
            .offset(y: hasAppeared ? 0 : 20)
            .animation(.easeOut(duration: 0.5).delay(0.2), value: hasAppeared)
            
            Spacer()
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                hasAppeared = true
                isNameFieldFocused = true
            }
        }
        .onDisappear {
            hasAppeared = false
        }
    }
}

// MARK: - Goal Setting View
struct GoalSettingView: View {
    @Binding var selectedGoal: String
    let availableGoals: [String]
    @Binding var dailyMindfulnessGoal: Int
    @State private var hasAppeared = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Set Your Goals")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 20)
                .animation(.easeOut(duration: 0.5), value: hasAppeared)
            
            Text("Choose your primary goal and set a daily mindfulness target.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.1), value: hasAppeared)
            
            // Goal selection
            VStack(alignment: .leading, spacing: 12) {
                Text("I want to:")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.leading, 5)
                
                VStack(spacing: 12) {
                    ForEach(availableGoals, id: \.self) { goal in
                        GoalButton(
                            title: goal,
                            isSelected: selectedGoal == goal,
                            action: {
                                selectedGoal = goal
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, 30)
            .opacity(hasAppeared ? 1 : 0)
            .offset(y: hasAppeared ? 0 : 20)
            .animation(.easeOut(duration: 0.5).delay(0.2), value: hasAppeared)
            
            // Daily mindfulness goal
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Daily mindfulness goal:")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(dailyMindfulnessGoal) min")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "#64FFDA"))
                }
                .padding(.leading, 5)
                
                Slider(value: Binding(
                    get: { Double(dailyMindfulnessGoal) },
                    set: { dailyMindfulnessGoal = Int($0) }
                ), in: 5...30, step: 5)
                .accentColor(Color(hex: "#64FFDA"))
                
                HStack {
                    Text("5 min")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                    Spacer()
                    Text("30 min")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal, 5)
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            .opacity(hasAppeared ? 1 : 0)
            .offset(y: hasAppeared ? 0 : 20)
            .animation(.easeOut(duration: 0.5).delay(0.3), value: hasAppeared)
            
            Spacer()
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                hasAppeared = true
            }
        }
        .onDisappear {
            hasAppeared = false
        }
    }
}

// MARK: - Trigger Identification View
struct TriggerIdentificationView: View {
    @Binding var selectedTriggers: [String]
    let availableTriggers: [String]
    @State private var hasAppeared = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Identify Your Triggers")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 20)
                .animation(.easeOut(duration: 0.5), value: hasAppeared)
            
            Text("Select situations that typically trigger gambling urges for you.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.1), value: hasAppeared)
            
            // Trigger selection
            VStack(alignment: .leading, spacing: 12) {
                Text("Common triggers:")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.leading, 5)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(availableTriggers, id: \.self) { trigger in
                        TriggerButton(
                            title: trigger,
                            isSelected: selectedTriggers.contains(trigger),
                            action: {
                                if selectedTriggers.contains(trigger) {
                                    selectedTriggers.removeAll { $0 == trigger }
                                } else {
                                    selectedTriggers.append(trigger)
                                }
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, 30)
            .opacity(hasAppeared ? 1 : 0)
            .offset(y: hasAppeared ? 0 : 20)
            .animation(.easeOut(duration: 0.5).delay(0.2), value: hasAppeared)
            
            Spacer()
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                hasAppeared = true
            }
        }
        .onDisappear {
            hasAppeared = false
        }
    }
}

// MARK: - Notifications Setup View
struct NotificationsSetupView: View {
    @Binding var notificationsEnabled: Bool
    @Binding var reminderTime: Date
    @State private var hasAppeared = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Stay on Track")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 20)
                .animation(.easeOut(duration: 0.5), value: hasAppeared)
            
            Text("Set up reminders to help you maintain your mindfulness practice.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.1), value: hasAppeared)
            
            // Notifications toggle
            VStack(alignment: .leading, spacing: 20) {
                Toggle(isOn: $notificationsEnabled) {
                    Text("Enable daily reminders")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
                .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#64FFDA")))
                
                if notificationsEnabled {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Reminder time:")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .accentColor(Color(hex: "#64FFDA"))
                            .colorScheme(.dark)
                    }
                    .padding(.top, 5)
                    .transition(.opacity)
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            .animation(.easeOut(duration: 0.3), value: notificationsEnabled)
            .opacity(hasAppeared ? 1 : 0)
            .offset(y: hasAppeared ? 0 : 20)
            .animation(.easeOut(duration: 0.5).delay(0.2), value: hasAppeared)
            
            // Privacy info
            VStack(alignment: .leading, spacing: 12) {
                Text("Your privacy is important")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "#64FFDA"))
                
                Text("Notifications are optional and will only be used to remind you of your mindfulness practice. You can change notification settings anytime.")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(20)
            .background(Color.white.opacity(0.08))
            .cornerRadius(10)
            .padding(.horizontal, 30)
            .padding(.top, 10)
            .opacity(hasAppeared ? 1 : 0)
            .offset(y: hasAppeared ? 0 : 20)
            .animation(.easeOut(duration: 0.5).delay(0.3), value: hasAppeared)
            
            Spacer()
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                hasAppeared = true
            }
        }
        .onDisappear {
            hasAppeared = false
        }
    }
}

// MARK: - Progress Bar
struct ProgressBar: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        VStack(spacing: 8) {
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    // Progress
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(hex: "#64FFDA"),
                                    Color(hex: "#00B4D8")
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(currentStep + 1) / CGFloat(totalSteps), height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
            
            // Step count text
            HStack {
                Spacer()
                Text("Step \(currentStep + 1) of \(totalSteps)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
}

// MARK: - Goal Button
struct GoalButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? Color(hex: "#0D1B2A") : .white)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(hex: "#0D1B2A"))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                Group {
                    if isSelected {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "#64FFDA"),
                                Color(hex: "#00B4D8")
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        Color.white.opacity(0.15)
                    }
                }
            )
            .cornerRadius(10)
        }
        .shadow(color: isSelected ? Color.black.opacity(0.15) : Color.clear, radius: 2, x: 0, y: 1)
    }
}

// MARK: - Trigger Button
struct TriggerButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? Color(hex: "#0D1B2A") : .white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(hex: "#0D1B2A"))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                Group {
                    if isSelected {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "#64FFDA"),
                                Color(hex: "#00B4D8")
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        Color.white.opacity(0.15)
                    }
                }
            )
            .cornerRadius(10)
        }
        .shadow(color: isSelected ? Color.black.opacity(0.15) : Color.clear, radius: 2, x: 0, y: 1)
    }
}

// MARK: - Onboarding Page View (from existing implementation)
struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var hasAppeared = false
    
    var body: some View {
        VStack(spacing: 40) {
            // Illustration
            page.illustration
                .padding(.top, 20)
                .scaleEffect(hasAppeared ? 1.0 : 0.8)
                .opacity(hasAppeared ? 1.0 : 0.0)
                .brightness(0.1) // Add slight brightness
                .shadow(color: Color(hex: "#64FFDA").opacity(0.5), radius: 15, x: 0, y: 0) // Add glow effect
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: hasAppeared)
            
            // Text content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .opacity(hasAppeared ? 1.0 : 0.0)
                    .offset(y: hasAppeared ? 0 : 20)
                    .animation(.easeOut(duration: 0.5).delay(0.2), value: hasAppeared)
                
                Text(page.description)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 24)
                    .opacity(hasAppeared ? 1.0 : 0.0)
                    .offset(y: hasAppeared ? 0 : 20)
                    .animation(.easeOut(duration: 0.5).delay(0.3), value: hasAppeared)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                hasAppeared = true
            }
        }
        .onDisappear {
            hasAppeared = false
        }
    }
}

// MARK: - Onboarding Page (from existing implementation)
struct OnboardingPage {
    let title: String
    let description: String
    let illustration: AnyView
}

// MARK: - Preview
struct EnhancedOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedOnboardingView()
            .preferredColorScheme(.dark)
    }
} 