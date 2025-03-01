import SwiftUI

// MARK: - OnboardingViewModel
@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    @Published var username: String = ""
    @Published var dailyGoal: Int = 30
    @Published var averageDailySpend: Double = 0
    @Published var userTriggers: [String] = []
    @Published var customTrigger: String = ""
    @Published var supportContact = SupportContact(name: "", relationship: "")
    @Published var addingSupportContact: Bool = false
    @Published var commitmentStatement: String = "I commit to building a gambling-free life, one day at a time."
    @Published var notificationPreferences: [String: Bool] = [
        "Daily Check-in": true,
        "Weekly Summary": true,
        "Craving Alerts": true,
        "Achievement Notifications": true,
        "Mindfulness Reminders": true
    ]
    
    private let commonTriggers = [
        "Stress", "Boredom", "Social Pressure", "Celebration", 
        "Financial Worries", "Alcohol Use", "Sports Events",
        "Advertisements", "Gambling Apps", "Casino Environment"
    ]
    
    var availableTriggers: [String] {
        commonTriggers.filter { !userTriggers.contains($0) }
    }
    
    func nextPage() {
        if currentPage < 7 {
            currentPage += 1
        }
    }
    
    func previousPage() {
        if currentPage > 0 {
            currentPage -= 1
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
        appState.averageDailySpend = averageDailySpend
        
        // Only add the support contact if there's a name
        if !supportContact.name.isEmpty {
            appState.addSupportContact(supportContact)
        }
        
        appState.completeOnboarding()
    }
}

// MARK: - Main Onboarding View
struct EnhancedOnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @State private var currentPage = 0
    @State private var name = ""
    @State private var selectedGoal = 30
    @State private var averageDailySpend = ""
    @State private var selectedTriggers: [String] = []
    @State private var customTrigger = ""
    @State private var showGoalComplete = false
    
    // Common triggers for gambling
    private let commonTriggers = [
        "Feeling stressed or anxious",
        "Boredom",
        "After getting paid",
        "When drinking alcohol",
        "Social pressure",
        "After watching sports",
        "When feeling lonely",
        "Financial problems"
    ]
    
    var body: some View {
        ZStack {
            // Animated background
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        BFColors.primary.opacity(0.8), 
                        BFColors.accent.opacity(0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Animated background elements
                BFBackgroundView(style: .waves,
                                gradient: BFColors.themeGradient(for: .standard))
                .opacity(animateBackground ? 0.2 : 0)
                .animation(.easeIn(duration: 0.8).delay(0.3), value: animateBackground)
            }
            
            VStack(spacing: 0) {
                // Progress indicator
                HStack(spacing: 8) {
                    ForEach(0..<5) { page in
                        Capsule()
                            .fill(page <= currentPage ? Color.white : Color.white.opacity(0.3))
                            .frame(height: 4)
                            .frame(width: page == currentPage ? 24 : 12)
                            .animation(.spring(response: 0.4), value: currentPage)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 10)
                .opacity(animateContent ? 1 : 0)
                .offset(y: animateContent ? 0 : -20)
                .animation(.easeOut(duration: 0.6).delay(0.1), value: animateContent)
                
                // Page content with slide transitions
                TabView(selection: $currentPage) {
                    // Welcome page
                    welcomeView
                        .tag(0)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .leading)),
                            removal: .opacity.combined(with: .move(edge: .trailing))
                        ))
                    
                    // Name page
                    nameView
                        .tag(1)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale),
                            removal: .opacity.combined(with: .scale)
                        ))
                    
                    // Goal setting page
                    goalSettingView
                        .tag(2)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .trailing)),
                            removal: .opacity.combined(with: .move(edge: .leading))
                        ))
                    
                    // Trigger identification page
                    triggerView
                        .tag(3)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .trailing)),
                            removal: .opacity.combined(with: .move(edge: .leading))
                        ))
                    
                    // Completion page
                    completionView
                        .tag(4)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale),
                            removal: .opacity
                        ))
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                .frame(maxHeight: .infinity)
                
                // Navigation buttons
                HStack {
                    // Back button (hidden on first page)
                    if currentPage > 0 && currentPage < 4 {
                        Button(action: {
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                        }
                        .textButtonStyle(color: .white)
                        .transition(.opacity)
                    }
                    
                    Spacer()
                    
                    // Next button (hidden on last page)
                    if currentPage < 4 {
                        Button(action: {
                            nextButtonTapped()
                        }) {
                            HStack {
                                Text(currentPage == 3 ? "Finish" : "Next")
                                Image(systemName: "chevron.right")
                            }
                        }
                        .primaryButtonStyle()
                        .disabled(isNextButtonDisabled)
                        .opacity(isNextButtonDisabled ? 0.6 : 1.0)
                        .transition(.opacity)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    Rectangle()
                        .fill(Color.black.opacity(0.1))
                        .ignoresSafeArea(edges: .bottom)
                )
                .opacity(showNavButtons ? 1 : 0)
                .animation(.easeIn.delay(0.3), value: showNavButtons)
            }
        }
        .onAppear {
            // Sequence the animations for better visual experience
            withAnimation {
                animateBackground = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    animateContent = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showNavButtons = true
                }
            }
        }
    }
    
    // MARK: - Individual page views
    
    private var welcomeView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 70))
                    .foregroundColor(Color.white)
                    .padding()
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 150, height: 150)
                    )
                    .drawingGroup()
                    .scaleEffect(animateContent ? 1.0 : 0.7)
                    .opacity(animateContent ? 1.0 : 0)
                    .animation(.spring(response: 0.6).delay(0.2), value: animateContent)
                
                Text("Welcome to BetFree")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(animateContent ? 1.0 : 0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.3), value: animateContent)
                
                Text("Your journey to gambling-free living starts here")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(animateContent ? 1.0 : 0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.4), value: animateContent)
            }
            
            VStack(spacing: 25) {
                FeatureRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Track Your Progress",
                    description: "Monitor your gambling-free days and see your progress visualized"
                )
                
                FeatureRow(
                    icon: "brain.head.profile",
                    title: "Mindfulness Tools",
                    description: "Access proven techniques to manage urges and triggers"
                )
                
                FeatureRow(
                    icon: "lightbulb.fill",
                    title: "Personalized Insights",
                    description: "Understand your patterns and behaviors better"
                )
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.15))
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 20)
            .opacity(animateContent ? 1.0 : 0)
            .offset(y: animateContent ? 0 : 40)
            .animation(.easeOut(duration: 0.7).delay(0.5), value: animateContent)
            
            Spacer()
        }
    }
    
    private var nameView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }
                
                Text("What should we call you?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("We'll use this to personalize your experience")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .opacity(animateContent ? 1.0 : 0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.5).delay(0.2), value: animateContent)
            
            VStack(spacing: 15) {
                // Name input field with animation
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Name")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                    
                    ZStack(alignment: .leading) {
                        if name.isEmpty {
                            Text("Enter your name")
                                .foregroundColor(.white.opacity(0.5))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                        }
                        
                        TextField("", text: $name)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .accentColor(.white)
                            .font(.system(size: 18))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.1))
                )
                .padding(.horizontal, 20)
                .opacity(animateContent ? 1.0 : 0)
                .offset(y: animateContent ? 0 : 30)
                .animation(.easeOut(duration: 0.6).delay(0.4), value: animateContent)
            }
            
            Spacer()
            Spacer()
        }
    }
    
    private var goalSettingView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "flag.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }
                
                Text("Set Your Goal")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("How many gambling-free days are you aiming for?")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .opacity(animateContent ? 1.0 : 0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.5).delay(0.2), value: animateContent)
            
            // Goal selection buttons with animation
            VStack(spacing: 20) {
                HStack(spacing: 10) {
                    ForEach([7, 14, 30], id: \.self) { days in
                        Button(action: {
                            withAnimation(.spring(response: 0.4)) {
                                selectedGoal = days
                            }
                        }) {
                            Text("\(days)")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(selectedGoal == days ? BFColors.primary : .white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(selectedGoal == days ? Color.white : Color.white.opacity(0.2))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedGoal == days ? BFColors.primary : Color.clear, lineWidth: 2)
                                )
                        }
                    }
                }
                
                HStack(spacing: 10) {
                    ForEach([60, 90, 180], id: \.self) { days in
                        Button(action: {
                            withAnimation(.spring(response: 0.4)) {
                                selectedGoal = days
                            }
                        }) {
                            Text("\(days)")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(selectedGoal == days ? BFColors.primary : .white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(selectedGoal == days ? Color.white : Color.white.opacity(0.2))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedGoal == days ? BFColors.primary : Color.clear, lineWidth: 2)
                                )
                        }
                    }
                }
                
                Text("Days")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(.vertical, 10)
            .opacity(animateContent ? 1.0 : 0)
            .offset(y: animateContent ? 0 : 30)
            .animation(.easeOut(duration: 0.6).delay(0.4), value: animateContent)
            
            // Daily spend input
            VStack(alignment: .leading, spacing: 10) {
                Text("How much do you spend on gambling per day on average?")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                HStack {
                    Text("$")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                    
                    TextField("Amount", text: $averageDailySpend)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.2))
                        )
                        .foregroundColor(.white)
                        .accentColor(.white)
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 15)
            .opacity(animateContent ? 1.0 : 0)
            .offset(y: animateContent ? 0 : 40)
            .animation(.easeOut(duration: 0.6).delay(0.6), value: animateContent)
            
            VStack {
                // Calculate potential savings
                if let spend = Double(averageDailySpend), selectedGoal > 0 {
                    let savings = spend * Double(selectedGoal)
                    VStack(spacing: 5) {
                        Text("You could save approximately")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text("$\(String(format: "%.2f", savings))")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.15))
                    )
                    .padding(.top, 10)
                }
            }
            .animation(.easeIn, value: averageDailySpend)
            .opacity(animateContent ? 1.0 : 0)
            .animation(.easeOut(duration: 0.6).delay(0.8), value: animateContent)
            
            Spacer()
        }
    }
    
    private var triggerView: some View {
        VStack(spacing: 20) {
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(BFColors.warning)
                }
                .opacity(animateContent ? 1.0 : 0)
                .scaleEffect(animateContent ? 1.0 : 0.8)
                .animation(.spring(response: 0.6).delay(0.2), value: animateContent)
                
                Text("Identify Your Triggers")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Select situations that typically trigger your gambling urges")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .opacity(animateContent ? 1.0 : 0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.5).delay(0.2), value: animateContent)
            
            ScrollView {
                VStack(spacing: 12) {
                    // Common triggers with staggered animation
                    ForEach(Array(commonTriggers.enumerated()), id: \.element) { index, trigger in
                        Button(action: {
                            toggleTrigger(trigger)
                        }) {
                            HStack {
                                Text(trigger)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                if selectedTriggers.contains(trigger) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .transition(.scale.combined(with: .opacity))
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedTriggers.contains(trigger) 
                                        ? BFColors.primary.opacity(0.3) 
                                        : Color.white.opacity(0.15))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedTriggers.contains(trigger) 
                                            ? Color.white 
                                            : Color.clear, 
                                            lineWidth: 1)
                            )
                        }
                        .opacity(animateContent ? 1.0 : 0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.4).delay(0.3 + Double(index) * 0.05), value: animateContent)
                    }
                    
                    // Custom trigger entry
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Add your own trigger:")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                        
                        HStack {
                            TextField("Describe your trigger", text: $customTrigger)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white.opacity(0.2))
                                )
                                .foregroundColor(.white)
                                .accentColor(.white)
                            
                            Button(action: {
                                addCustomTrigger()
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                            .disabled(customTrigger.isEmpty)
                            .opacity(customTrigger.isEmpty ? 0.6 : 1.0)
                        }
                    }
                    .padding(.top, 10)
                    .opacity(animateContent ? 1.0 : 0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.5).delay(0.6), value: animateContent)
                    
                    // Display selected custom triggers
                    if !selectedTriggers.filter({ !commonTriggers.contains($0) }).isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Your custom triggers:")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                            
                            ForEach(selectedTriggers.filter({ !commonTriggers.contains($0) }), id: \.self) { trigger in
                                HStack {
                                    Text(trigger)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        withAnimation {
                                            toggleTrigger(trigger)
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.white.opacity(0.8))
                                            .font(.system(size: 20))
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(BFColors.primary.opacity(0.3))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                                .transition(.opacity.combined(with: .move(edge: .trailing)))
                            }
                        }
                        .padding(.top, 10)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .padding(.vertical, 10)
            }
            .frame(maxHeight: 300)
            .padding(.horizontal, 20)
        }
    }
    
    private var completionView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            if showGoalComplete {
                BFAnimatedCheckmark()
                    .scaleEffect(1.5)
                    .padding(.bottom, 20)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 70))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
            }
            
            Text("You're All Set!")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .opacity(animateContent ? 1 : 0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.4), value: animateContent)
            
            Text("Thank you for completing the setup, \(name). Your journey starts now.")
                .font(.system(size: 18))
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.9))
                .padding(.horizontal)
                .opacity(animateContent ? 1 : 0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.5), value: animateContent)
            
            VStack(alignment: .leading, spacing: 20) {
                InfoRow(title: "Your Goal", value: "\(selectedGoal) days")
                
                InfoRow(title: "Money to Save", value: calculateSavings())
                
                InfoRow(title: "Triggers", value: "\(selectedTriggers.count) identified")
            }
            .padding(.vertical, 30)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.15))
            )
            .padding(.horizontal, 25)
            .opacity(animateContent ? 1 : 0)
            .offset(y: animateContent ? 0 : 40)
            .animation(.easeOut(duration: 0.7).delay(0.6), value: animateContent)
            
            Spacer()
            
            Button(action: {
                completeOnboarding()
            }) {
                Text("Begin Your Journey")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(BFColors.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 25)
            .opacity(animateContent ? 1 : 0)
            .animation(.easeOut(duration: 0.6).delay(0.8), value: animateContent)
        }
        .onAppear {
            withAnimation(.spring().delay(0.3)) {
                showGoalComplete = true
            }
        }
    }
    
    // MARK: - Helper components
    
    private struct FeatureRow: View {
        let icon: String
        let title: String
        let description: String
        
        var body: some View {
            HStack(alignment: .top, spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(description)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.9))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
    
    private struct InfoRow: View {
        let title: String
        let value: String
        
        var body: some View {
            HStack {
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Helper methods
    
    private var isNextButtonDisabled: Bool {
        switch currentPage {
        case 1:
            return name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 2:
            return selectedGoal <= 0 || averageDailySpend.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        default:
            return false
        }
    }
    
    private func nextButtonTapped() {
        switch currentPage {
        case 1:
            appState.username = name.trimmingCharacters(in: .whitespacesAndNewlines)
        case 2:
            appState.dailyGoal = selectedGoal
            if let spend = Double(averageDailySpend) {
                appState.averageDailySpend = spend
            }
        case 3:
            appState.userTriggers = selectedTriggers
        default:
            break
        }
        
        withAnimation {
            currentPage += 1
        }
    }
    
    private func toggleTrigger(_ trigger: String) {
        withAnimation(.spring(response: 0.3)) {
            if selectedTriggers.contains(trigger) {
                selectedTriggers.removeAll(where: { $0 == trigger })
            } else {
                selectedTriggers.append(trigger)
            }
        }
    }
    
    private func addCustomTrigger() {
        let trimmed = customTrigger.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        withAnimation {
            if !selectedTriggers.contains(trimmed) {
                selectedTriggers.append(trimmed)
            }
            
            customTrigger = ""
        }
    }
    
    private func calculateSavings() -> String {
        guard let spend = Double(averageDailySpend) else {
            return "$0"
        }
        
        let potentialSavings = spend * Double(selectedGoal)
        return String(format: "$%.2f", potentialSavings)
    }
    
    private func completeOnboarding() {
        // Save all settings to AppState
        appState.username = name.trimmingCharacters(in: .whitespacesAndNewlines)
        appState.dailyGoal = selectedGoal
        if let spend = Double(averageDailySpend) {
            appState.averageDailySpend = spend
            appState.moneySaved = 0 // Reset to zero, will be calculated as days pass
        }
        appState.userTriggers = selectedTriggers
        
        // Mark onboarding as completed
        appState.hasCompletedOnboarding = true
        
        // Set start date
        appState.markDayAsCompleted()
    }
}

struct EnhancedOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedOnboardingView()
            .environmentObject(AppState())
    }
} 