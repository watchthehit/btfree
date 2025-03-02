import SwiftUI

// MARK: - OnboardingViewModel
@MainActor
class OnboardingViewModel: ObservableObject {
    // MARK: - Constants
    let screens: [OnboardingScreen] = [
        .valueProposition1,
        .valueProposition2,
        .valueProposition3,
        .personalSetup,
        .notificationPrivacy,
        .paywall,
        .completion
    ]
    
    // MARK: - Published Properties
    @Published var currentScreenIndex = 0
    @Published var username = ""
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
    
    // MARK: - Data Persistence
    func saveToAppState() {
        // In a real app, you would save this data to UserDefaults, CoreData, or a backend service
        print("Saving user data:")
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
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Icon/logo
            Image(systemName: "heart.fill")
                .font(.system(size: 70))
                .foregroundColor(BFColors.primary)
                .padding()
                .background(
                    Circle()
                        .fill(BFColors.cardBackground)
                        .shadow(color: Color.black.opacity(0.2), radius: 10)
                )
            
            // Welcome text
            Text("Break Free From Gambling")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(BFColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Take the first step toward a healthier relationship with gambling through evidence-based tools and support.")
                .font(.system(size: 18))
                .foregroundColor(BFColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            // Next button
            Button {
                withAnimation {
                    viewModel.nextScreen()
                }
            } label: {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        BFColors.primary
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    )
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
    }
}

struct ValuePropositionView2: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Icon/illustration
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 70))
                .foregroundColor(BFColors.primary)
                .padding()
                .background(
                    Circle()
                        .fill(BFColors.cardBackground)
                        .shadow(color: Color.black.opacity(0.2), radius: 10)
                )
            
            // Content text
            Text("Track Your Progress")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(BFColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Monitor your journey with personalized insights and celebrate your milestones along the way.")
                .font(.system(size: 18))
                .foregroundColor(BFColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            // Next button
            Button {
                withAnimation {
                    viewModel.nextScreen()
                }
            } label: {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        BFColors.primary
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    )
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
    }
}

struct ValuePropositionView3: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Icon/illustration
            Image(systemName: "brain.head.profile")
                .font(.system(size: 70))
                .foregroundColor(BFColors.primary)
                .padding()
                .background(
                    Circle()
                        .fill(BFColors.cardBackground)
                        .shadow(color: Color.black.opacity(0.2), radius: 10)
                )
            
            // Content text
            Text("Find Your Calm")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(BFColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Access mindfulness exercises and breathing techniques to help manage urges and reduce stress.")
                .font(.system(size: 18))
                .foregroundColor(BFColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            // Next button
            Button {
                withAnimation {
                    viewModel.nextScreen()
                }
            } label: {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        BFColors.primary
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    )
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
    }
}

struct PersonalSetupView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @FocusState private var isUsernameFocused: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Personalize Your Experience")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(BFColors.textPrimary)
                .padding(.top, 32)
                .multilineTextAlignment(.center)
            
            // Username field
            VStack(alignment: .leading, spacing: 8) {
                Text("What should we call you?")
                    .font(.headline)
                    .foregroundColor(BFColors.textSecondary)
                
                TextField("Your name", text: $viewModel.username)
                    .padding()
                    .background(BFColors.cardBackground)
                    .cornerRadius(12)
                    .focused($isUsernameFocused)
            }
            .padding(.horizontal, 32)
            .padding(.top, 16)
            
            // Daily goal selector
            VStack(alignment: .leading, spacing: 12) {
                Text("Minutes per day for mindfulness:")
                    .font(.headline)
                    .foregroundColor(BFColors.textSecondary)
                
                Slider(value: Binding(
                    get: { Double(viewModel.dailyGoal) },
                    set: { viewModel.dailyGoal = Int($0) }
                ), in: 5...60, step: 5)
                .accentColor(BFColors.primary)
                
                Text("\(viewModel.dailyGoal) minutes")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(BFColors.primary)
            }
            .padding(.horizontal, 32)
            .padding(.top, 16)
            
            Spacer()
            
            // Next button
            Button {
                withAnimation {
                    viewModel.nextScreen()
                }
            } label: {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        BFColors.primary
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    )
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
        .onTapGesture {
            isUsernameFocused = false
        }
    }
}

struct NotificationsView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Stay Connected")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(BFColors.textPrimary)
                .padding(.top, 32)
            
            Text("Enable notifications to get the most out of your recovery journey")
                .font(.headline)
                .foregroundColor(BFColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            // Notification image
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 50))
                .foregroundColor(BFColors.primary)
                .padding()
                .background(
                    Circle()
                        .fill(BFColors.cardBackground)
                        .shadow(color: Color.black.opacity(0.1), radius: 5)
                )
                .padding(.vertical, 16)
            
            // Notification toggles
            VStack(spacing: 16) {
                ForEach(0..<viewModel.notificationTypes.count, id: \.self) { index in
                    Toggle(isOn: Binding(
                        get: { viewModel.notificationTypes[index].isEnabled },
                        set: { viewModel.notificationTypes[index].isEnabled = $0 }
                    )) {
                        VStack(alignment: .leading) {
                            Text(viewModel.notificationTypes[index].name)
                                .font(.headline)
                                .foregroundColor(BFColors.textPrimary)
                            
                            if let detail = viewModel.notificationTypes[index].detail {
                                Text(detail)
                                    .font(.subheadline)
                                    .foregroundColor(BFColors.textSecondary)
                            }
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: BFColors.primary))
                    .padding(.horizontal, 32)
                }
            }
            
            Spacer()
            
            // Next button
            Button {
                withAnimation {
                    viewModel.nextScreen()
                }
            } label: {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        BFColors.primary
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    )
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
    }
}

struct PaywallView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Unlock Full Access")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(BFColors.textPrimary)
                .padding(.top, 32)
            
            // Premium features
            VStack(alignment: .leading, spacing: 16) {
                Text("Premium Features:")
                    .font(.headline)
                    .foregroundColor(BFColors.textPrimary)
                    .padding(.bottom, 4)
                
                FeatureRow(icon: "chart.line.uptrend.xyaxis.circle.fill", 
                           text: "Advanced progress tracking",
                           color: BFColors.accent)
                
                FeatureRow(icon: "brain.head.profile", 
                           text: "Unlimited mindfulness exercises",
                           color: BFColors.secondary)
                
                FeatureRow(icon: "person.2.fill", 
                           text: "Community support access",
                           color: BFColors.secondary)
                
                FeatureRow(icon: "lock.shield.fill", 
                           text: "No ads or interruptions",
                           color: BFColors.secondary)
            }
            .padding(.horizontal, 32)
            
            // Subscription plan selector
            VStack(spacing: 16) {
                Text("Choose Your Plan:")
                    .font(.headline)
                    .foregroundColor(BFColors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 32)
                
                HStack(spacing: 12) {
                    ForEach(0..<viewModel.plans.count, id: \.self) { index in
                        let plan = viewModel.plans[index]
                        
                        VStack(spacing: 8) {
                            Text(plan.name)
                                .font(.headline)
                                .foregroundColor(viewModel.selectedPlan == index ? .white : BFColors.textPrimary)
                            
                            Text(plan.price)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(viewModel.selectedPlan == index ? .white : BFColors.textPrimary)
                            
                            Text("per \(plan.period)")
                                .font(.subheadline)
                                .foregroundColor(viewModel.selectedPlan == index ? .white.opacity(0.8) : BFColors.textSecondary)
                            
                            if !plan.savings.isEmpty {
                                Text(plan.savings)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(viewModel.selectedPlan == index ? .white : BFColors.accent)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(viewModel.selectedPlan == index ? Color.white.opacity(0.2) : BFColors.accent.opacity(0.1))
                                    )
                            }
                        }
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(viewModel.selectedPlan == index ? BFColors.primary : BFColors.cardBackground)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.selectedPlan == index ? BFColors.primary : Color.gray.opacity(0.2), lineWidth: 2)
                        )
                        .onTapGesture {
                            withAnimation {
                                viewModel.selectedPlan = index
                            }
                        }
                    }
                }
                .padding(.horizontal, 32)
            }
            
            Spacer()
            
            // Trial info
            Text("7-day free trial, then \(viewModel.selectedPlanDetails.price)/\(viewModel.selectedPlanDetails.period)")
                .font(.subheadline)
                .foregroundColor(BFColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            // Start trial button
            Button {
                // Set trial as active
                viewModel.isTrialActive = true
                
                withAnimation {
                    viewModel.nextScreen()
                }
            } label: {
                Text("Start Free Trial")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        BFColors.primary
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    )
            }
            .padding(.horizontal, 32)
            
            // Terms text
            Text("Cancel anytime. Terms apply.")
                .font(.caption)
                .foregroundColor(BFColors.textSecondary)
                .padding(.bottom, 32)
        }
    }
}

struct FeatureRow: View {
    var icon: String
    var text: String
    var color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 20))
            
            Text(text)
                .foregroundColor(BFColors.textPrimary)
                .font(.body)
        }
    }
}

struct CompletionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Success icon
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 70))
                .foregroundColor(BFColors.success)
                .padding()
            
            // Completion text
            Text("You're All Set!")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(BFColors.textPrimary)
                .multilineTextAlignment(.center)
            
            if viewModel.isTrialActive {
                Text("Your 7-day free trial has started. Your journey to mindful recovery begins now.")
                    .font(.system(size: 18))
                    .foregroundColor(BFColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            } else {
                Text("Your journey to mindful recovery begins now.")
                    .font(.system(size: 18))
                    .foregroundColor(BFColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            // Finish button
            Button {
                // Save user settings and complete onboarding
                viewModel.saveToAppState()
            } label: {
                Text("Start My Journey")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        BFColors.primary
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    )
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
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

enum OnboardingScreen: Equatable {
    case valueProposition1
    case valueProposition2
    case valueProposition3
    case personalSetup
    case notificationPrivacy
    case paywall
    case completion
}

// MARK: - Preview
struct EnhancedOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedOnboardingView()
    }
}
