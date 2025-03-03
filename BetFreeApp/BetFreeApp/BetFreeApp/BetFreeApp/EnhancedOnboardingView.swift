import SwiftUI
import Foundation
import UIKit

// MARK: - Onboarding Types
enum OnboardingViewTypes {
    enum TrackingMethod: String, CaseIterable, Identifiable {
        case automatic = "Let the app monitor your activity and detect potential risks"
        case manual = "Log your activities and feelings manually at your own pace"
        case hybrid = "Combine automatic monitoring with manual check-ins"
        
        var id: String { rawValue }
        
        var icon: String {
            switch self {
            case .automatic: return "antenna.radiowaves.left.and.right"
            case .manual: return "pencil.and.list.clipboard"
            case .hybrid: return "arrow.triangle.2.circlepath"
            }
        }
        
        var description: String {
            return rawValue
        }
        
        var features: [String] {
            switch self {
            case .automatic:
                return ["Real-time trigger detection", "Behavioral pattern analysis", "Minimal manual input required"]
            case .manual:
                return ["Complete privacy control", "Detailed self-reflection prompts", "Customizable tracking fields"]
            case .hybrid:
                return ["Combined automated and manual tracking", "Comprehensive insights", "Balanced approach"]
            }
        }
    }
    
    enum Weekday: String, CaseIterable, Identifiable {
        case monday = "Mon"
        case tuesday = "Tue"
        case wednesday = "Wed" 
        case thursday = "Thu"
        case friday = "Fri"
        case saturday = "Sat"
        case sunday = "Sun"
        
        var id: String { rawValue }
    }
}

// MARK: - Animation Helper
func animateWithReducedMotion<Result>(_ animation: Animation? = .default, reduceMotion: Bool, _ body: () -> Result) -> Result {
    if reduceMotion {
        return withAnimation(nil) {
            body()
        }
    } else {
        return withAnimation(animation) {
            body()
        }
    }
}

// MARK: - Trigger Mapping Components
private struct TriggerHeader: View {
    let animateContent: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Identify Your Triggers")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : -10)
                .accessibilityAddTraits(.isHeader)
            
            Text("Select all that apply in each category")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .opacity(animateContent ? 1.0 : 0.0)
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
    }
}

private struct CategorySelector: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @Binding var selectedCategoryIndex: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.triggerCategories.indices, id: \.self) { index in
                    Button(action: {
                        selectedCategoryIndex = index
                    }) {
                        Text(viewModel.triggerCategories[index].name)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(selectedCategoryIndex == index ? .white : .white.opacity(0.6))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedCategoryIndex == index ? BFColors.accent : Color.clear)
                            )
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
        }
    }
}

private struct TriggerList: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let selectedCategoryIndex: Int
    @Binding var customTrigger: String
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.triggerCategories[selectedCategoryIndex].triggers, id: \.self) { trigger in
                Button(action: {
                    viewModel.toggleTrigger(trigger)
                }) {
                    HStack {
                        Text(trigger)
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: viewModel.selectedTriggers.contains(trigger) ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 22))
                            .foregroundColor(viewModel.selectedTriggers.contains(trigger) ? BFColors.accent : .white.opacity(0.3))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.05))
                    )
                }
            }
            
            // Custom trigger input
            HStack {
                TextField("Add custom trigger", text: $customTrigger)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 17))
                    .foregroundColor(.white)
                
                Button(action: {
                    if !customTrigger.isEmpty {
                        viewModel.addCustomTrigger(customTrigger)
        customTrigger = ""
    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(customTrigger.isEmpty ? .white.opacity(0.3) : BFColors.accent)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.05))
            )
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 32)
    }
}

private struct ContinueButton: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        Button(action: {
            viewModel.nextScreen()
        }) {
            Text("Continue")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(BFColors.accent)
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
        }
        .opacity(viewModel.selectedTriggers.isEmpty ? 0.5 : 1.0)
        .disabled(viewModel.selectedTriggers.isEmpty)
    }
}

private struct TriggerMappingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var selectedCategoryIndex = 0
    @State private var animateContent = false
    @State private var customTrigger = ""
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        NoTabSpaceWrapper {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        TriggerHeader(animateContent: animateContent)
                        CategorySelector(viewModel: viewModel, selectedCategoryIndex: $selectedCategoryIndex)
                        TriggerList(viewModel: viewModel, selectedCategoryIndex: selectedCategoryIndex, customTrigger: $customTrigger)
                    }
                }
                
                ContinueButton(viewModel: viewModel)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                animateWithReducedMotion(.easeOut(duration: 0.6), reduceMotion: reduceMotion) {
                    animateContent = true
                }
            }
        }
    }
}

// MARK: - Main Onboarding View
public struct EnhancedOnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State private var animateContent = false
    @EnvironmentObject var paywallManager: PaywallManager
    
    // Add completion handler property
    var onComplete: (() -> Void)?
    
    public init(onComplete: (() -> Void)? = nil) {
        self.onComplete = onComplete
        
        // Completely remove any bottom insets in the whole app
        UITabBar.appearance().isHidden = true
    }
    
    public var body: some View {
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
                    if viewModel.currentScreenIndex > 0 {
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
                    ProgressView(value: Double(viewModel.currentScreenIndex) / Double(viewModel.screens.count - 1))
                        .progressViewStyle(LinearProgressViewStyle(tint: .white))
                        .frame(width: 100)
                }
                    .padding(.horizontal, 24)
                .padding(.top, 16)
                
                // Current screen content
                switch viewModel.screens[viewModel.currentScreenIndex] {
                case .welcome:
                    WelcomeScreen(viewModel: viewModel)
                case .valueProposition1:
                    ValuePropositionScreen(
                        viewModel: viewModel,
                        title: "Track Your Progress",
                        subtitle: "Monitor your gambling habits and see how far you've come on your journey.",
                        iconName: "chart.line.uptrend.xyaxis",
                        showSkip: true
                    )
                case .valueProposition2:
                    ValuePropositionScreen(
                        viewModel: viewModel,
                        title: "Identify Triggers",
                        subtitle: "Learn what situations lead to gambling urges so you can develop healthier responses.",
                        iconName: "exclamationmark.triangle",
                        showSkip: true
                    )
                case .valueProposition3:
                    ValuePropositionScreen(
                        viewModel: viewModel,
                        title: "Find Your Calm",
                        subtitle: "Access proven mindfulness techniques to manage urges and reduce stress.",
                        iconName: "leaf",
                        showSkip: true
                    )
                case .goalSelection:
                    GoalSelectionScreen(viewModel: viewModel)
                case .combinedProfileSetup:
                    CombinedProfileSetupScreen(viewModel: viewModel)
                case .notificationSetup:
                    CombinedNotificationScreen(viewModel: viewModel)
                case .enhancedPaywall:
                    EnhancedPaywallScreen()
                        .environmentObject(viewModel)
                        .environmentObject(paywallManager)
                case .completion:
                    CompletionScreen(viewModel: viewModel)
                default:
                    Text("Screen not implemented yet")
                        .foregroundColor(.white)
                }
            }
        }
        .environmentObject(viewModel)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                animateContent = true
            }
        }
    }
}

// MARK: - Welcome Screen
private struct WelcomeScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    @State private var showResumeOption = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // App Logo/Icon
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .scaleEffect(animateContent ? 1.0 : 0.7)
                    .opacity(animateContent ? 1.0 : 0.0)
            }
            .padding(.bottom, 20)
            
            // Welcome Text
            VStack(spacing: 16) {
                Text("Welcome to BetFree")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Your personal companion for overcoming gambling addiction and building healthier habits.")
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            
            Spacer()
            
            // Buttons
            VStack(spacing: 16) {
                BFButton(title: "Get Started", isEnabled: true) {
                    withAnimation {
                        viewModel.nextScreen()
                    }
                }
                
                if showResumeOption {
                    Button {
                        // Restore and go to last completed screen + 1
                        viewModel.restorePartialProgress()
                        if viewModel.lastCompletedScreenIndex >= 0 && 
                           viewModel.lastCompletedScreenIndex < viewModel.screens.count - 1 {
                            withAnimation {
                                viewModel.skipToScreen(viewModel.lastCompletedScreenIndex + 1)
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Resume Where I Left Off")
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.vertical, 8)
                    }
                }
            }
            .padding(.bottom, 40)
            .opacity(animateContent ? 1.0 : 0.0)
        }
        .padding(.horizontal, 30)
        .onAppear {
            // Check if we have partial progress saved
            viewModel.restorePartialProgress()
            showResumeOption = viewModel.hasStartedOnboarding || viewModel.lastCompletedScreenIndex >= 0
            
            withAnimation(reduceMotion ? nil : .easeOut(duration: 0.6).delay(0.1)) {
                animateContent = true
            }
        }
    }
}

// MARK: - Feature Row Component
private struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(BFColors.accent)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
    }
}

// MARK: - Goal Selection Screen
private struct GoalSelectionScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    @State private var selectedGoal: Goal = .quitCompletely
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    private enum Goal: String, CaseIterable {
        case quitCompletely = "Quit Completely"
        case reduceGradually = "Reduce Gradually"
        case notSure = "I'm Not Sure Yet"
        
        var description: String {
            switch self {
            case .quitCompletely:
                return "Stop gambling entirely and build a gambling-free life"
            case .reduceGradually:
                return "Gradually decrease gambling activity over time"
            case .notSure:
                return "I'd like guidance to help determine my best path"
            }
        }
        
        var icon: String {
            switch self {
            case .quitCompletely:
                return "hand.raised.slash"
            case .reduceGradually:
                return "chart.line.downtrend.xyaxis"
            case .notSure:
                return "questionmark.circle"
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HeaderView(
                    title: "What's Your Goal?",
                    subtitle: "Having a clear goal helps us personalize your journey."
                )
                .padding(.top, 20)
                .padding(.bottom, 12)
                
                VStack(spacing: 16) {
                    ForEach(Goal.allCases, id: \.self) { goal in
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedGoal = goal
                            }
                        } label: {
                            HStack(spacing: 16) {
                                Image(systemName: goal.icon)
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .frame(width: 32, height: 32)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(goal.rawValue)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Text(goal.description)
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                
                                Spacer()
                                
                                Image(systemName: selectedGoal == goal ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedGoal == goal ? .white : .white.opacity(0.5))
                                    .font(.system(size: 22))
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(selectedGoal == goal ? 0.25 : 0.1))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(selectedGoal == goal ? 0.5 : 0.2), lineWidth: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .opacity(animateContent ? 1 : 0)
                .offset(y: animateContent ? 0 : 20)
                
                Spacer(minLength: 30)
                
                // Info text
                Text("You can always change this later in your profile settings.")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.bottom, 8)
                    .opacity(animateContent ? 1 : 0)
                
                // Continue button
                BFButton(title: "Continue", isEnabled: true) {
                    // Map selected goal to viewModel
                    switch selectedGoal {
                    case .quitCompletely:
                        viewModel.selectedGoal = "Quit"
                    case .reduceGradually:
                        viewModel.selectedGoal = "Reduce"
                    case .notSure:
                        viewModel.selectedGoal = "Maintain control"
                    }
                    
                    withAnimation {
                        viewModel.nextScreen()
                    }
                }
                .opacity(animateContent ? 1 : 0)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .onAppear {
            // Set initial goal based on viewModel if available
            switch viewModel.selectedGoal {
            case "Quit":
                selectedGoal = .quitCompletely
            case "Reduce":
                selectedGoal = .reduceGradually
            case "Maintain control":
                selectedGoal = .notSure
            default:
                selectedGoal = .reduceGradually
            }
            
            withAnimation(.easeOut(duration: 0.5)) {
                animateContent = true
            }
        }
    }
}

// MARK: - Profile Completion Screen
private struct ProfileCompletionScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    @State private var name = ""
    @State private var email = ""
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    private var isFormValid: Bool {
        // Make email validation optional - either empty or valid
        if email.isEmpty {
            return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        } else {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
            return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && 
                   emailPredicate.evaluate(with: email)
        }
    }
    
    // Function to skip the sign-in screen and go directly to the next meaningful screen
    private func proceedToNextScreen() {
        // Skip the Sign In screen by advancing twice
        viewModel.nextScreen()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            viewModel.nextScreen()
        }
    }
    
    var body: some View {
        NoTabSpaceWrapper {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 16) {
                            Text("Complete Your Profile")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .opacity(animateContent ? 1 : 0)
                                .offset(y: animateContent ? 0 : 10)
                            
                            Text("Help us personalize your recovery journey. This information is kept private and secure.")
                                .font(.system(size: 17))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                                .opacity(animateContent ? 1 : 0)
                                .offset(y: animateContent ? 0 : 10)
                        }
                        .padding(.top, 40)
                        
                        // Form fields
                        VStack(spacing: 24) {
                            // Name field
                            CustomTextField(
                                title: "Name",
                                placeholder: "Enter your name",
                                text: $name
                            )
                            
                            // Email field
                            CustomTextField(
                                title: "Email",
                                placeholder: "Enter your email",
                                text: $email,
                                keyboardType: .emailAddress
                            )
                            
                            // Separator
                            HStack {
                                Rectangle()
                                    .fill(Color.white.opacity(0.3))
                                    .frame(height: 1)
                                
                                Text("OR")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Rectangle()
                                    .fill(Color.white.opacity(0.3))
                                    .frame(height: 1)
                            }
                            .padding(.vertical, 16)
                            
                            // Sign in with Apple Button
                            Button(action: {
                                // Handle Apple sign in and skip to the screen after sign in
                                proceedToNextScreen()
                            }) {
                                HStack {
                                    Image(systemName: "apple.logo")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                    
                                    Text("Sign in with Apple")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.black)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 20)
                    }
                }
                
                // Continue Button - always enabled if name is not empty
                Button(action: {
                    // Skip the sign in screen
                    proceedToNextScreen()
                }) {
                    Text("Continue")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(name.isEmpty ? BFColors.accent.opacity(0.5) : BFColors.accent)
                        )
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                }
                .opacity(animateContent ? 1 : 0)
                .disabled(name.isEmpty)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                animateWithReducedMotion(.easeOut(duration: 0.6), reduceMotion: reduceMotion) {
                    animateContent = true
                }
            }
        }
    }
}

// MARK: - Custom TextField Component
private struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
            
            TextField(placeholder, text: $text)
                .font(.system(size: 17))
                .foregroundColor(.white)
                .keyboardType(keyboardType)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                )
        }
    }
}

// MARK: - Combined Personal Setup Screen
private struct CombinedPersonalSetupScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    @State private var selectedPreferences: Set<Preference> = []
    @State private var selectedSupport: Set<SupportType> = []
    @State private var selectedMethod: OnboardingViewTypes.TrackingMethod = .automatic
    @State private var selectedCategoryIndex = 0
    @State private var customTrigger = ""
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    // Personal setup types
    private enum Preference: String, CaseIterable, Identifiable {
        case dailyMotivation = "Daily Motivation"
        case progressTracking = "Progress Tracking"
        case mindfulnessExercises = "Mindfulness Exercises"
        case communitySupport = "Community Support"
        
        var id: String { rawValue }
        
        var icon: String {
            switch self {
            case .dailyMotivation: return "quote.bubble"
            case .progressTracking: return "chart.bar"
            case .mindfulnessExercises: return "leaf"
            case .communitySupport: return "person.3"
            }
        }
    }
    
    private enum SupportType: String, CaseIterable, Identifiable {
        case family = "Family"
        case friends = "Friends"
        case therapist = "Therapist"
        case supportGroup = "Support Group"
        case none = "Prefer not to say"
        
        var id: String { rawValue }
        
        var icon: String {
            switch self {
            case .family: return "house"
            case .friends: return "person.2"
            case .therapist: return "brain.head.profile"
            case .supportGroup: return "person.3"
            case .none: return "hand.raised"
            }
        }
    }
    
    var body: some View {
        NoTabSpaceWrapper {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 16) {
                            Text("Personalize Your Journey")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .opacity(animateContent ? 1 : 0)
                                .offset(y: animateContent ? 0 : 10)
                            
                            Text("Let's customize your recovery experience")
                                .font(.system(size: 17))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                                .opacity(animateContent ? 1 : 0)
                                .offset(y: animateContent ? 0 : 10)
                        }
                        .padding(.top, 16)
                        
                        // Tracking method section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recovery Tracking")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(OnboardingViewTypes.TrackingMethod.allCases, id: \.self) { method in
                                        Button(action: {
                                            selectedMethod = method
                                        }) {
                                            VStack(spacing: 12) {
                                                Image(systemName: method.icon)
                                                    .font(.system(size: 24))
                                                    .foregroundColor(selectedMethod == method ? .white : BFColors.accent)
                                                    .frame(width: 48, height: 48)
                                                    .background(
                                                        Circle()
                                                            .fill(selectedMethod == method ? BFColors.accent : Color.white.opacity(0.05))
                                                    )
                                                
                                                Text(method.rawValue.components(separatedBy: " ").first ?? "")
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(.white)
                                                    .multilineTextAlignment(.center)
                                            }
                                            .frame(width: 100)
                                            .padding(.vertical, 12)
                                        }
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 20)
                        
                        // Support system section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Your Support System")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(SupportType.allCases, id: \.self) { support in
                                        Button(action: {
                                            if support == .none {
                                                selectedSupport = [support]
                                            } else {
                                                selectedSupport.remove(.none)
                                                if selectedSupport.contains(support) {
                                                    selectedSupport.remove(support)
                                                } else {
                                                    selectedSupport.insert(support)
                                                }
                                            }
                                        }) {
                                            VStack(spacing: 12) {
                                                Image(systemName: support.icon)
                                                    .font(.system(size: 24))
                                                    .foregroundColor(selectedSupport.contains(support) ? .white : BFColors.accent)
                                                    .frame(width: 48, height: 48)
                                                    .background(
                                                        Circle()
                                                            .fill(selectedSupport.contains(support) ? BFColors.accent : Color.white.opacity(0.05))
                                                    )
                                                
                                                Text(support.rawValue)
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(.white)
                                                    .multilineTextAlignment(.center)
                                            }
                                            .frame(width: 100)
                                            .padding(.vertical, 12)
                                        }
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 20)
                        
                        // Common triggers section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Common Triggers")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                            
                            // Category selector
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.triggerCategories.indices, id: \.self) { index in
                                        Button(action: {
                                            selectedCategoryIndex = index
                                        }) {
                                            Text(viewModel.triggerCategories[index].name)
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(selectedCategoryIndex == index ? .white : .white.opacity(0.6))
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(selectedCategoryIndex == index ? BFColors.accent : Color.white.opacity(0.05))
                                                )
                                        }
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                            
                            // Trigger selection
                            VStack(spacing: 12) {
                                ForEach(viewModel.triggerCategories[selectedCategoryIndex].triggers.prefix(3), id: \.self) { trigger in
                                    Button(action: {
                                        viewModel.toggleTrigger(trigger)
                                    }) {
                                        HStack {
                                            Text(trigger)
                                                .font(.system(size: 17))
                                                .foregroundColor(.white)
                                            
                                            Spacer()
                                            
                                            Image(systemName: viewModel.selectedTriggers.contains(trigger) ? "checkmark.circle.fill" : "circle")
                                                .font(.system(size: 22))
                                                .foregroundColor(viewModel.selectedTriggers.contains(trigger) ? BFColors.accent : .white.opacity(0.3))
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.white.opacity(0.05))
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 20)
                    }
                    .padding(.bottom, 24)
                }
                
                // Continue Button
                Button(action: {
                    viewModel.nextScreen()
                }) {
                    Text("Continue")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(BFColors.accent)
                        )
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                }
                .opacity(animateContent ? 1 : 0)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                animateWithReducedMotion(.easeOut(duration: 0.6), reduceMotion: reduceMotion) {
                    animateContent = true
                }
            }
        }
    }
}

// MARK: - Combined Notification Screen
private struct BFNotificationType {
    let id = UUID()
    let name: String
    let icon: String
    let detail: String?
    var isEnabled: Bool
}

private let availableNotificationTypes: [BFNotificationType] = [
    BFNotificationType(name: "Daily Check-ins", icon: "checkmark.circle", detail: "Get daily reminders to track your progress", isEnabled: false),
    BFNotificationType(name: "Urge Alerts", icon: "exclamationmark.triangle", detail: "Receive alerts when you might be at risk", isEnabled: false),
    BFNotificationType(name: "Progress Milestones", icon: "chart.line.uptrend.xyaxis", detail: "Celebrate your recovery milestones", isEnabled: false),
    BFNotificationType(name: "Mindfulness Reminders", icon: "leaf", detail: "Get reminded to practice mindfulness", isEnabled: false),
    BFNotificationType(name: "Support Messages", icon: "heart.text.square", detail: "Receive encouraging messages from your support network", isEnabled: false),
    BFNotificationType(name: "Weekly Reports", icon: "doc.text.below.ecg", detail: "Get weekly summaries of your progress", isEnabled: false)
]

private struct CombinedNotificationScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var selectedTypes: [UUID] = []
    @State private var quietHoursEnabled = false
    @State private var quietHoursStart = Calendar.current.date(from: DateComponents(hour: 22, minute: 0)) ?? Date()
    @State private var quietHoursEnd = Calendar.current.date(from: DateComponents(hour: 7, minute: 0)) ?? Date()
    @State private var selectedDays: Set<OnboardingViewTypes.Weekday> = Set(OnboardingViewTypes.Weekday.allCases)
    @State private var reminderTime = Date()
    @State private var animateContent = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Set up header (shorter to match screenshot)
                Text("journey.")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // Day selection
                VStack(alignment: .leading, spacing: 16) {
                    Text("Check-in Days")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    HStack(spacing: 8) {
                        ForEach(OnboardingViewTypes.Weekday.allCases) { day in
                            DayButton(
                                day: day,
                                isSelected: selectedDays.contains(day)
                            ) {
                                if selectedDays.contains(day) {
                                    selectedDays.remove(day)
                                } else {
                                    selectedDays.insert(day)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .opacity(animateContent ? 1 : 0)
                .offset(y: animateContent ? 0 : 10)
                
                // Time picker
                VStack(alignment: .leading, spacing: 12) {
                    Text("Preferred Time")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    DatePicker(
                        "Reminder Time",
                        selection: $reminderTime,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
                    .colorScheme(.dark)
                    .padding(.horizontal)
                }
                .opacity(animateContent ? 1 : 0)
                .offset(y: animateContent ? 0 : 10)
                
                // Notification types
                VStack(alignment: .leading, spacing: 16) {
                    Text("Notification Types")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    ForEach(availableNotificationTypes.prefix(4), id: \.id) { type in
                        BFNotificationTypeButton(
                            type: type,
                            isSelected: selectedTypes.contains(type.id),
                            action: {
                                if selectedTypes.contains(type.id) {
                                    selectedTypes.removeAll { $0 == type.id }
                                } else {
                                    selectedTypes.append(type.id)
                                }
                            }
                        )
                    }
                    .padding(.horizontal)
                }
                .opacity(animateContent ? 1 : 0)
                .offset(y: animateContent ? 0 : 10)
                
                // Quiet hours
                VStack(alignment: .leading, spacing: 16) {
                    Toggle(isOn: $quietHoursEnabled) {
                        Text("Enable Quiet Hours")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: BFColors.accent))
                    .padding(.horizontal)
                    
                    if quietHoursEnabled {
                        VStack(spacing: 12) {
                            DatePicker("Start Time", selection: $quietHoursStart, displayedComponents: .hourAndMinute)
                                .foregroundColor(.white)
                                .accentColor(BFColors.accent)
                            DatePicker("End Time", selection: $quietHoursEnd, displayedComponents: .hourAndMinute)
                                .foregroundColor(.white)
                                .accentColor(BFColors.accent)
                        }
                        .padding(.horizontal)
                    }
                }
                .opacity(animateContent ? 1 : 0)
                .offset(y: animateContent ? 0 : 10)
                
                Spacer(minLength: 24)
                
                BFButton(title: "Continue", isEnabled: !selectedTypes.isEmpty && !selectedDays.isEmpty) {
                    viewModel.nextScreen()
                }
                .padding(.horizontal)
                .opacity(animateContent ? 1 : 0)
            }
            .padding(.vertical, 24)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                animateWithReducedMotion(.easeOut(duration: 0.6), reduceMotion: reduceMotion) {
                    animateContent = true
                }
            }
        }
    }
}

// MARK: - Day Button Component
private struct DayButton: View {
    let day: OnboardingViewTypes.Weekday
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(day.rawValue)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(isSelected ? BFColors.accent : Color.white.opacity(0.05))
                )
        }
    }
}

// MARK: - Completion Screen
private struct CompletionScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isLimitedTrial = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Success icon
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 120, height: 120)
                
                Image(systemName: isLimitedTrial ? "checkmark.circle" : "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .scaleEffect(animateContent ? 1.0 : 0.7)
                    .opacity(animateContent ? 1.0 : 0.0)
            }
            .padding(.bottom, 10)
            
            // Celebration text
            VStack(spacing: 16) {
                Text(isLimitedTrial ? "You're Ready to Start!" : "You're All Set!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                if !viewModel.username.isEmpty {
                    Text("Welcome \(viewModel.username), your personal recovery journey is ready to begin.")
                        .font(.system(size: 17))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                } else {
                    Text("Your personal recovery journey is ready to begin.")
                        .font(.system(size: 17))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                // Show additional text for limited trial users
                if isLimitedTrial {
                    Text("You've chosen the limited feature set. You can upgrade anytime to access all premium features.")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                }
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            
            // Features overview
            VStack(spacing: 12) {
                FeatureItem(
                    iconName: "calendar",
                    title: "Daily Check-Ins",
                    description: "Regular check-ins help track your progress",
                    isLocked: false
                )
                
                FeatureItem(
                    iconName: "brain.head.profile",
                    title: "Mindfulness Tools",
                    description: "Proven techniques to manage urges", 
                    isLocked: isLimitedTrial
                )
                
                FeatureItem(
                    iconName: "chart.bar.fill",
                    title: "Progress Tracking",
                    description: "Visual insights to track your journey",
                    isLocked: isLimitedTrial
                )
            }
            .padding(.horizontal, 20)
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 30)
            
            Spacer()
            
            // Start button with upgrade option for limited trial
            VStack(spacing: 12) {
                BFButton(title: "Start My Journey", isEnabled: true) {
                    if let onComplete = viewModel.onComplete {
                        onComplete()
                    }
                }
                
                if isLimitedTrial {
                    Button(action: {
                        // Return to paywall to upgrade
                        if let paywallIndex = viewModel.screens.firstIndex(of: .enhancedPaywall) {
                            viewModel.skipToScreen(paywallIndex)
                        }
                    }) {
                        Text("Upgrade to Premium")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(BFColors.accent)
                            .padding(.vertical, 8)
                    }
                }
            }
            .padding(.bottom, 40)
            .opacity(animateContent ? 1.0 : 0.0)
        }
        .padding(.horizontal, 20)
        .onAppear {
            // Check if user is on limited trial
            isLimitedTrial = UserDefaults.standard.bool(forKey: "limitedTrialMode")
            
            withAnimation(reduceMotion ? nil : .easeOut(duration: 0.6).delay(0.1)) {
                animateContent = true
            }
        }
    }
}

// Update FeatureItem to support locked state
private struct FeatureItem: View {
    var iconName: String
    var title: String
    var description: String
    var isLocked: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 48, height: 48)
                
                Image(systemName: iconName)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    if isLocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 12))
                            .foregroundColor(BFColors.accent)
                    }
                }
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.08))
        )
    }
}

// MARK: - Support Views
struct NoTabSpaceWrapper<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

// MARK: - Using components from BFStandardComponents
// Using HeaderView and BFButton from BFStandardComponents.swift

fileprivate struct BFNotificationTypeButton: View {
    let type: BFNotificationType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: type.icon)
                    .font(.system(size: 22))
                    .foregroundColor(Color.gray)
                    .frame(width: 36, height: 36)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(type.name)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.black)
                    if let detail = type.detail {
                        Text(detail)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color.gray)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // Right side selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? BFColors.accent : Color.gray.opacity(0.3))
                    .font(.system(size: 22))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
            )
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Combined Profile and Personal Setup Screen
private struct CombinedProfileSetupScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    @State private var selectedPreferences: Set<Preference> = []
    @State private var username = ""
    @FocusState private var isUsernameFocused: Bool
    @State private var dailyMindfulnessGoal = 10
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    // Personal preferences types
    private enum Preference: String, CaseIterable, Identifiable {
        case dailyMotivation = "Daily Motivation"
        case progressTracking = "Progress Tracking"
        case mindfulnessExercises = "Mindfulness Exercises"
        case communitySupport = "Community Support"
        
        var id: String { rawValue }
        
        var icon: String {
            switch self {
            case .dailyMotivation: return "quote.bubble"
            case .progressTracking: return "chart.bar"
            case .mindfulnessExercises: return "leaf"
            case .communitySupport: return "person.3"
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HeaderView(
                    title: "Set Up Your Profile",
                    subtitle: "Let's personalize your experience to help you achieve your goals."
                )
                .padding(.bottom, 8)
                
                // First Name Input
                VStack(alignment: .leading, spacing: 12) {
                    Text("What would you like to be called?")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    TextField("Your name", text: $username)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .focused($isUsernameFocused)
                        .submitLabel(.done)
                        .onSubmit {
                            isUsernameFocused = false
                        }
                }
                .padding(.bottom, 8)
                
                // Daily Mindfulness Goal
                VStack(alignment: .leading, spacing: 12) {
                    Text("Daily mindfulness goal")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("Set a daily goal for mindfulness exercises")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    HStack {
                        ForEach([5, 10, 15, 20], id: \.self) { minutes in
                            Button {
                                dailyMindfulnessGoal = minutes
                            } label: {
                                Text("\(minutes) min")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(dailyMindfulnessGoal == minutes ? Color.white : Color.white.opacity(0.2))
                                    .foregroundColor(dailyMindfulnessGoal == minutes ? Color(UIColor.systemBlue) : .white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding(.bottom, 12)
                
                // Preferences Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("What are you interested in?")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("Select all that apply")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    VStack(spacing: 12) {
                        ForEach(Preference.allCases) { preference in
                            Button {
                                if selectedPreferences.contains(preference) {
                                    selectedPreferences.remove(preference)
                                } else {
                                    selectedPreferences.insert(preference)
                                }
                            } label: {
                                HStack {
                                    Image(systemName: selectedPreferences.contains(preference) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(selectedPreferences.contains(preference) ? .white : .white.opacity(0.6))
                                    
                                    Image(systemName: preference.icon)
                                        .padding(.horizontal, 8)
                                    
                                    Text(preference.rawValue)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                
                Spacer(minLength: 20)
                
                // Continue Button
                BFButton(title: "Continue", isEnabled: !username.isEmpty) {
                    // Save the data to view model
                    viewModel.username = username
                    viewModel.dailyGoal = dailyMindfulnessGoal
                    
                    // Continue to next screen
                    withAnimation {
                        viewModel.nextScreen()
                    }
                }
                .padding(.vertical, 10)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .opacity(animateContent ? 1 : 0)
            .offset(y: animateContent ? 0 : 20)
        }
        .onAppear {
            // Populate fields with existing data if available
            username = viewModel.username
            dailyMindfulnessGoal = viewModel.dailyGoal
            
            withAnimation(.easeOut(duration: 0.5)) {
                animateContent = true
            }
        }
    }
}

// MARK: - Value Proposition Screen
private struct ValuePropositionScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var animateContent = false
    
    var title: String
    var subtitle: String
    var iconName: String
    var showSkip: Bool = false
    
    var body: some View {
        ZStack {
            // Improved background for better contrast
            LinearGradient(
                gradient: Gradient(colors: [BFColors.primary, BFColors.primary.darker(by: 15)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Spacer()
                
                // Icon with motion
                ZStack {
                    Circle()
                        .fill(BFColors.secondary)
                        .frame(width: 100, height: 100)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    
                    Image(systemName: iconName)
                        .font(.system(size: 40))
                        .foregroundColor(BFColors.primary)
                }
                .scaleEffect(animateContent ? 1.0 : 0.8)
                .opacity(animateContent ? 1.0 : 0.0)
                
                // Title and subtitle with better contrast
                VStack(spacing: 16) {
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .accessibilityAddTraits(.isHeader)
                    
                    // Adding background for better contrast
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.3))
                            .padding(.horizontal, -12)
                        
                        Text(subtitle)
                            .font(.title3)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal, 20)
                }
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : 20)
                
                Spacer()
                Spacer()
                
                // Navigation buttons
                VStack(spacing: 16) {
                    Button(action: {
                        viewModel.nextScreen()
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(BFColors.accent)
                            )
                    }
                    
                    if showSkip {
                        Button(action: {
                            // Skip directly to the last value proposition screen
                            if let index = viewModel.screens.firstIndex(of: .valueProposition3) {
                                viewModel.skipToScreen(index)
                            } else {
                                viewModel.nextScreen()
                            }
                        }) {
                            Text("Skip")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                        }
                        .padding(.bottom, 8)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
                .opacity(animateContent ? 1.0 : 0.0)
            }
        }
        .onAppear {
            // Use reduced motion preference if enabled
            let animation = reduceMotion ? nil : Animation.spring(response: 0.6, dampingFraction: 0.8)
            
            withAnimation(animation) {
                animateContent = true
            }
        }
    }
} 