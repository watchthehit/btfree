import SwiftUI

// MARK: - OnboardingViewModel
@MainActor
class OnboardingViewModel: ObservableObject {
    // MARK: - Constants
    let screens: [OnboardingScreen] = [
        .welcome,
        .personalSetup,
        .paywall,
        .notificationPrivacy,
        .completion
    ]
    
    // MARK: - Published Properties
    @Published var currentScreenIndex = 0
    @Published var username = ""
    @Published var dailyGoal = 20  // Default to 20 minutes
    @Published var userTriggers: [String] = []
    @Published var customTrigger = ""
    @Published var notificationTypes: [NotificationType] = [
        NotificationType(name: "Daily Check-ins", icon: "bell.badge", isEnabled: true),
        NotificationType(name: "Mindfulness Reminders", icon: "brain", isEnabled: true),
        NotificationType(name: "Weekly Reports", icon: "chart.bar", isEnabled: true),
        NotificationType(name: "Support Messages", icon: "hand.thumbsup", isEnabled: false)
    ]
    
    // Paywall and trial related properties
    @Published var hasAgreedToFreeTrial = false
    @Published var isTrialActive = false
    @Published var trialEndDate = Date().addingTimeInterval(7 * 24 * 60 * 60) // 7 days from now
    @Published var selectedPlan: PricingPlan = .yearly
    
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
    
    var progressValue: Float {
        Float(currentScreenIndex + 1) / Float(screens.count)
    }
    
    var daysRemainingInTrial: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: trialEndDate)
        return components.day ?? 0
    }
    
    // MARK: - Trigger Management
    let availableTriggers = [
        "Stress", "Boredom", "Social Pressure", 
        "Payday", "Loneliness", "Sports Events",
        "Alcohol", "Online Ads"
    ]
    
    func addTrigger(_ trigger: String) {
        let trimmedTrigger = trigger.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTrigger.isEmpty else { return }
        guard !userTriggers.contains(trimmedTrigger) else { return }
        
        userTriggers.append(trimmedTrigger)
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
    
    // MARK: - Data Persistence
    func saveToAppState() {
        // In a real app, you would save this data to UserDefaults, CoreData, or a backend service
        print("Saving user data:")
        print("Username: \(username)")
        print("Daily goal: \(dailyGoal) minutes")
        print("Triggers: \(userTriggers.joined(separator: ", "))")
        print("Notifications enabled: \(notificationTypes.filter { $0.isEnabled }.map { $0.name }.joined(separator: ", "))")
        print("Trial status: \(isTrialActive ? "Active" : "Inactive"), Expires: \(trialEndDate)")
        
        // Here you would typically call a completion handler or use a delegate to inform
        // the parent view that onboarding is complete
    }
}

// MARK: - Main Onboarding View
struct EnhancedOnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        ZStack {
            // STATIC BACKGROUND - NO ANIMATIONS
            Color(hex: "#2C3550")
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
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.2))
                                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.leading, 16)
                        .transition(.opacity)
                    } else {
                        Spacer()
                            .frame(width: 70)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        // Progress bar
                        ProgressView(value: viewModel.progressValue)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color.white))
                            .frame(width: 120, height: 4)
                        
                        Text("Step \(viewModel.currentScreenIndex + 1) of \(viewModel.screens.count)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.vertical, 10)
                    
                    Spacer()
                    
                    // Skip button - not available on paywall screen
                    let paywallIndex = viewModel.screens.firstIndex(where: { $0 == .paywall }) ?? 0
                    if !viewModel.isLastScreen && viewModel.currentScreenIndex != paywallIndex {
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                // Skip to the next screen, but never skip the paywall
                                if viewModel.currentScreenIndex < paywallIndex {
                                    viewModel.currentScreenIndex = paywallIndex
                                } else if viewModel.currentScreenIndex > paywallIndex {
                                    viewModel.nextScreen()
                                }
                            }
                        } label: {
                            Text("Skip")
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.trailing, 16)
                        .transition(.opacity)
                    } else {
                        Spacer()
                            .frame(width: 70)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 16)
                .animation(.easeInOut(duration: 0.3), value: viewModel.currentScreenIndex)
                
                // Main content
                TabView(selection: $viewModel.currentScreenIndex) {
                    WelcomeScreen()
                        .environmentObject(viewModel)
                        .tag(0)
                    
                    PersonalSetupScreen(username: $viewModel.username)
                        .environmentObject(viewModel)
                        .tag(1)
                    
                    PaywallScreen()
                        .environmentObject(viewModel)
                        .tag(2)
                    
                    NotificationPrivacyScreen()
                        .environmentObject(viewModel)
                        .tag(3)
                    
                    CompletionScreen()
                        .environmentObject(viewModel)
                        .tag(4)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.currentScreenIndex)
                
                // Dots indicator
                HStack(spacing: 8) {
                    ForEach(0..<viewModel.screens.count, id: \.self) { index in
                        Circle()
                            .fill(viewModel.currentScreenIndex == index ? 
                                  Color.white : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(viewModel.currentScreenIndex == index ? 1.3 : 1.0)
                            .shadow(color: viewModel.currentScreenIndex == index ? 
                                    Color.white.opacity(0.5) : Color.clear, radius: 4)
                    }
                }
                .padding(.vertical, 16)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.currentScreenIndex)
                
                // Continue button
                let paywallIndex = viewModel.screens.firstIndex(where: { $0 == .paywall }) ?? 0
                if !viewModel.isLastScreen && viewModel.currentScreenIndex != paywallIndex {
                    Button {
                        print("🔴 Continue button tapped, moving from screen \(viewModel.currentScreenIndex) to \(viewModel.currentScreenIndex + 1)")
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            // Skip validation for simplicity in this example
                            viewModel.nextScreen()
                        }
                    } label: {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                Color(hex: "#4CAF50")
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - WelcomeScreen
struct WelcomeScreen: View {
    @State private var showContent = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header section
                VStack(spacing: 16) {
                    Text("Welcome to BetFree")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : -20)
                    
                    Text("Your journey to gambling-free living starts here")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : -10)
                }
                .padding(.top, 30)
                
                // Main illustration - SIMPLIFIED, NO ANIMATIONS
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 220, height: 220)
                    
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 260, height: 260)
                    
                    Image(systemName: "heart.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color(hex: "#4CAF50"))
                        .frame(width: 140, height: 140)
                        .scaleEffect(showContent ? 1 : 0.8)
                        .opacity(showContent ? 1 : 0)
                }
                .padding(.top, 20)
                .padding(.bottom, 30)
                
                // Key benefits section
                VStack(spacing: 20) {
                    Text("How BetFree Helps You")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 25)
                        .opacity(showContent ? 1 : 0)
                    
                    ForEach(Array(zip(benefits.indices, benefits)), id: \.0) { index, benefit in
                        BenefitRow(icon: benefit.icon, title: benefit.title, description: benefit.description, delay: Double(index) * 0.1)
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                    }
                }
                .padding(.bottom, 20)
                
                // Premium highlight
                VStack(spacing: 15) {
                    Text("Premium Features Included")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 25)
                        .opacity(showContent ? 1 : 0)
                    
                    HStack(spacing: 20) {
                        ForEach(premiumFeatures, id: \.icon) { feature in
                            VStack(spacing: 8) {
                                Image(systemName: feature.icon)
                                    .font(.system(size: 28))
                                    .foregroundColor(.white)
                                
                                Text(feature.title)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.15))
                            )
                        }
                    }
                    .padding(.horizontal, 25)
                    .opacity(showContent ? 1 : 0)
                }
                
                Spacer(minLength: 40)
            }
            .padding(.bottom, 20)
        }
        .background(Color(hex: "#2C3550"))
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                showContent = true
            }
        }
    }
    
    private var benefits: [(icon: String, title: String, description: String)] = [
        ("brain.head.profile", "Understand Your Triggers", "Identify and manage situations that lead to gambling urges"),
        ("chart.line.uptrend.xyaxis", "Track Your Progress", "See how far you've come with detailed insights"),
        ("figure.mind.and.body", "Daily Mindfulness", "Guided exercises to build mental resilience"),
        ("person.2.fill", "Community Support", "Connect with others on the same journey")
    ]
    
    private var premiumFeatures: [(icon: String, title: String)] = [
        ("lock.shield", "Advanced Protection"),
        ("chart.bar.fill", "Detailed Analytics"),
        ("bubble.left.and.bubble.right.fill", "1:1 Support")
    ]
}

struct BenefitRow: View {
    let icon: String
    let title: String
    let description: String
    let delay: Double
    
    @State private var appear = false
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 46, height: 46)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
        .padding(.horizontal, 25)
        .opacity(appear ? 1 : 0)
        .onAppear {
            appear = true
        }
    }
}

// MARK: - PersonalSetupScreen
struct PersonalSetupScreen: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    @Binding var username: String
    @FocusState private var isUsernameFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Text("What's your name?")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                Text("This helps us personalize your journey to quit.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                // SIMPLIFIED TEXT FIELD - NO ANIMATIONS
                VStack(spacing: 8) {
                    TextField("Enter your name", text: $username)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .focused($isUsernameFocused)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)
                    
                    Text("Enter your name above to continue")
                        .font(.caption)
                        .foregroundColor(Color.white.opacity(0.7))
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                Text("What triggers your urges?")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Text("Select all that apply to you.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                // SIMPLIFIED TRIGGER BUTTONS - NO ANIMATIONS
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(viewModel.availableTriggers, id: \.self) { trigger in
                        Button {
                            if viewModel.userTriggers.contains(trigger) {
                                viewModel.removeTrigger(trigger)
                            } else {
                                viewModel.addTrigger(trigger)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "tag.fill")
                                    .font(.system(size: 20))
                                Text(trigger)
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .background(
                                viewModel.userTriggers.contains(trigger) ? 
                                Color(hex: "#4CAF50").opacity(0.8) : 
                                Color.white.opacity(0.1)
                            )
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 15)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .background(Color(hex: "#2C3550"))
        .onTapGesture {
            isUsernameFocused = false
        }
    }
}

// MARK: - PaywallScreen
struct PaywallScreen: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                VStack(spacing: 16) {
                    Image(systemName: "crown.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.yellow)
                        .padding(.top, 30)
                    
                    Text("Unlock Full Access")
                        .font(.system(size: 28, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                    Text("Get unlimited access to all BetFree features to help you quit for good.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.horizontal)
                }
                
                Spacer().frame(height: 30)
                
                // FIXED PRICING PLAN BUTTONS
                VStack(spacing: 15) {
                    Button {
                        print("Selected plan: Annual")
                        withAnimation {
                            viewModel.selectedPlan = .yearly
                        }
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Annual Plan")
                                    .font(.headline)
                                Text("Save 50% compared to monthly")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            Spacer()
                            
                            // PRICING DISPLAY IN YELLOW
                            VStack(alignment: .trailing) {
                                Text("$49.99")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.yellow)
                                Text("per year")
                                    .font(.caption)
                                    .foregroundColor(.yellow.opacity(0.8))
                            }
                            
                            if viewModel.selectedPlan == .yearly {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(hex: "#4CAF50"))
                                    .padding(.leading, 8)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.selectedPlan == .yearly ? Color(hex: "#4CAF50").opacity(0.2) : Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button {
                        print("Selected plan: Monthly")
                        withAnimation {
                            viewModel.selectedPlan = .monthly
                        }
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Monthly Plan")
                                    .font(.headline)
                                Text("Pay month-to-month")
                                    .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            }
                            Spacer()
                            
                            // PRICING DISPLAY IN YELLOW
                            VStack(alignment: .trailing) {
                                Text("$9.99")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.yellow)
                                Text("per month")
                                    .font(.caption)
                                    .foregroundColor(.yellow.opacity(0.8))
                            }
                            
                            if viewModel.selectedPlan == .monthly {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(hex: "#4CAF50"))
                                    .padding(.leading, 8)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.selectedPlan == .monthly ? Color(hex: "#4CAF50").opacity(0.2) : Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
                
                Spacer().frame(height: 20)
                
                Button {
                    print("Starting free trial with plan: \(viewModel.selectedPlan)")
                    viewModel.hasAgreedToFreeTrial = true
                    viewModel.isTrialActive = true
                    viewModel.nextScreen()
                } label: {
                    Text("Start 7-Day Free Trial")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#4CAF50"))
                        .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
                
                Button {
                    print("Restoring purchases")
                    // Implement restore functionality
                } label: {
                    Text("Restore Purchases")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 8)
                
                Text("Auto-renews. Cancel anytime. Terms & Privacy Policy apply.")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .padding(.top, 8)
                
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color(hex: "#2C3550"))
    }
}

// MARK: - Notification & Privacy Screen
struct NotificationPrivacyScreen: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Notifications & Privacy")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
                .opacity(animateContent ? 1 : 0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.1), value: animateContent)
            
            Text("Choose how you want to be notified and learn about our privacy practices.")
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.bottom)
                .opacity(animateContent ? 1 : 0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.2), value: animateContent)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Notification Preferences")
                    .font(.headline)
                    .padding(.top)
                    .opacity(animateContent ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.3), value: animateContent)
                
                ForEach(Array(viewModel.notificationTypes.enumerated()), id: \.element.id) { index, notification in
                    NotificationToggleRow(notification: binding(for: index), delay: 0.4 + Double(index) * 0.1)
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.4 + Double(index) * 0.1), value: animateContent)
                }
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Privacy Information")
                    .font(.headline)
                    .opacity(animateContent ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.8), value: animateContent)
                
                Text("Your data is stored locally on your device. We collect anonymous usage statistics to improve the app, but never personal information.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.9), value: animateContent)
                
                Link("Privacy Policy", destination: URL(string: "https://www.example.com/privacy")!)
                    .font(.subheadline)
                    .padding(.top, 5)
                    .opacity(animateContent ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(1.0), value: animateContent)
            }
            .padding(.bottom)
        }
        .padding(.horizontal)
        .background(Color(hex: "#2C3550"))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animateContent = true
            }
        }
    }
    
    private func binding(for index: Int) -> Binding<NotificationType> {
        return Binding(
            get: { viewModel.notificationTypes[index] },
            set: { viewModel.notificationTypes[index] = $0 }
        )
    }
}

struct NotificationToggleRow: View {
    @Binding var notification: NotificationType
    var delay: Double
    
    @State private var isAnimated = false
    
    var body: some View {
        HStack {
            Image(systemName: notification.icon)
                .font(.system(size: 24))
                .foregroundColor(Color(hex: "#4CAF50"))
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color(hex: "#4CAF50").opacity(0.2))
                )
                .padding(.trailing, 5)
            
            Text(notification.name)
                .font(.body)
            
            Spacer()
            
            Toggle("", isOn: $notification.isEnabled)
                .labelsHidden()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .scaleEffect(isAnimated ? 1 : 0.95)
        .opacity(isAnimated ? 1 : 0.7)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(delay)) {
                isAnimated = true
            }
        }
    }
}

struct CompletionScreen: View {
    @EnvironmentObject private var viewModel: OnboardingViewModel
    @State private var showContent = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Success animation - SIMPLIFIED, NO ANIMATIONS
                ZStack {
                    // Outer circle
                    Circle()
                        .stroke(Color(hex: "#4CAF50").opacity(0.7), lineWidth: 2)
                        .frame(width: 160, height: 160)
                    
                    // Middle circle
                    Circle()
                        .fill(Color(hex: "#4CAF50").opacity(0.15))
                        .frame(width: 130, height: 130)
                    
                    // Inner circle
                    Circle()
                        .fill(Color(hex: "#4CAF50").opacity(0.25))
                        .frame(width: 110, height: 110)
                    
                    // Checkmark
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color(hex: "#4CAF50"))
                        .frame(width: 80, height: 80)
                }
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.8)
                .padding(.top, 20)
                
                // Title and subtitle
                VStack(spacing: 12) {
                    Text("You're All Set!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : -10)
                    
                    Text("Your 7-day free trial has started")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : -5)
                }
                
                // Trial information
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                            .font(.title3)
                            .foregroundColor(.white)
                        
                        Text("Trial ends on \(formattedTrialEndDate)")
                            .font(.callout.weight(.medium))
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.15))
                    )
                    .opacity(showContent ? 1 : 0)
                    
                    Text("Cancel anytime in Settings → Subscription")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.7))
                        .opacity(showContent ? 1 : 0)
                }
                .padding(.horizontal, 25)
                .padding(.top, 10)
                
                // Feature bullets with staggered animations
                VStack(spacing: 20) {
                    Text("What's Next?")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 25)
                        .opacity(showContent ? 1 : 0)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(Array(zip(nextSteps.indices, nextSteps)), id: \.0) { index, step in
                            NextStepRow(
                                text: step.text,
                                icon: step.icon,
                                delay: Double(index) * 0.1
                            )
                        }
                    }
                    .padding(.horizontal, 25)
                }
                .padding(.top, 10)
                
                Spacer(minLength: 30)
                
                // Get started button
                Button {
                    // Save onboarding data and complete
                    viewModel.saveToAppState()
                } label: {
                    HStack {
                        Text("Start My Journey")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.right")
                            .font(.body.weight(.semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        Color(hex: "#4CAF50")
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 25)
                .padding(.bottom, 20)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
            }
            .padding(.bottom, 30)
        }
        .background(Color(hex: "#2C3550"))
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                showContent = true
            }
        }
    }
    
    private var formattedTrialEndDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: viewModel.trialEndDate)
    }
    
    private var nextSteps: [(icon: String, text: String)] = [
        ("calendar", "Set up your daily check-ins"),
        ("figure.walk", "Track your first gambling-free day"),
        ("brain.head.profile", "Complete a mindfulness exercise"),
        ("chart.bar.fill", "Review your progress dashboard")
    ]
}

struct NextStepRow: View {
    let text: String
    let icon: String
    let delay: Double
    
    @State private var appear = false
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#4CAF50").opacity(0.4))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
            }
            
            Text(text)
                .font(.callout)
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
        .opacity(appear ? 1 : 0)
        .onAppear {
            appear = true
        }
    }
}

// MARK: - Preview
struct EnhancedOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedOnboardingView()
            .environmentObject(AppState())
    }
}

enum OnboardingScreen: Identifiable {
    case welcome
    case personalSetup
    case paywall
    case notificationPrivacy
    case completion
    
    var id: Self { self }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .welcome:
            WelcomeScreen()
        case .personalSetup:
            PersonalSetupScreen(username: .constant(""))
        case .paywall:
            PaywallScreen()
        case .notificationPrivacy:
            NotificationPrivacyScreen()
        case .completion:
            CompletionScreen()
        }
    }
    
    var title: String {
        switch self {
        case .welcome:
            return "Welcome"
        case .personalSetup:
            return "Personal Setup"
        case .paywall:
            return "Premium Features"
        case .notificationPrivacy:
            return "Notifications & Privacy"
        case .completion:
            return "All Set"
        }
    }
} 