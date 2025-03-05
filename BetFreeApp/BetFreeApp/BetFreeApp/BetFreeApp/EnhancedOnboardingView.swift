import SwiftUI
#if os(iOS)
import UIKit
#endif

/**
 * EnhancedOnboardingView
 * A modern, personalized onboarding experience for BetFree utilizing best practices
 * from leading mental health and wellness apps.
 */

// MARK: - Color Extensions
extension Color {
    init(_ hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Note: BFTheme has been moved to its own file. 
// See BFTheme.swift for the implementation.

// MARK: - Haptic Feedback Manager
class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    func selectionFeedback() {
        #if canImport(UIKit)
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
        #endif
    }
    
    #if canImport(UIKit)
    func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func notificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    #else
    func impactFeedback(style: Int = 0) {
        // No haptics on non-UIKit platforms
    }
    
    func notificationFeedback(type: Int) {
        // No haptics on non-UIKit platforms
    }
    #endif
}

// MARK: - EnhancedOnboardingViewModel
@MainActor
class EnhancedOnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    @Published var userName = ""
    @Published var selectedGoal = "Reduce"
    @Published var selectedTriggers: [String] = []
    @Published var dailyMindfulnessGoal = 10
    @Published var notificationsEnabled = true
    @Published var reminderTime = Date()
    @Published var showBreatheAnimation = false
    @Published var breatheProgress: CGFloat = 0.0
    @Published var breatheIn = false
    @Published var isAnimating = false
    @Published var shouldShowPaywall = false
    @Published var isProUser = false
    @Published var showQuickStartOption = true
    
    enum OnboardingSection {
        case intro, personalization, paywall, breathing
    }
    @Published var currentSection: OnboardingSection = .intro
    
    let goals = ["Track & Reduce", "Quit", "Maintain control"]
    
    let commonTriggers = [
        "Stress", "Boredom", "Financial pressure",
        "Social situations", "Advertisements", "Alcohol",
        "Free time", "Negative emotions"
    ]
    
    static let valuePropositionPages = [
        OnboardingPage(
            title: "Track Your Gambling Habits",
            description: "Easily log urges and gambling sessions to understand and reduce your habits over time.",
            illustration: { size in BFAssets.BFOnboardingIllustrations.BreakingFree(size: size) }
        ),
        OnboardingPage(
            title: "Set Daily Goals",
            description: "Create a personalized plan with daily limits to gradually decrease your gambling behavior.",
            illustration: { size in BFAssets.BFOnboardingIllustrations.GrowthJourney(size: size) }
        ),
        OnboardingPage(
            title: "Compare With Friends",
            description: "Connect with Quit Buddies to track progress together and motivate each other to stay on track.",
            illustration: { size in BFAssets.BFOnboardingIllustrations.SupportNetwork(size: size) }
        )
    ]
    
    var totalPages: Int {
        return Self.valuePropositionPages.count + 1
    }
    
    var isNameInputValid: Bool {
        !userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isLastPage: Bool {
        currentPage == totalPages - 1
    }
    
    func nextPage() {
        if currentPage < totalPages - 1 {
            withAnimation {
                currentPage += 1
            }
            HapticManager.shared.selectionFeedback()
        }
    }
    
    func quickStart() {
        userName = "User"
        selectedGoal = "Track & Reduce"
        selectedTriggers = ["Stress", "Boredom"]
        dailyMindfulnessGoal = 5
        notificationsEnabled = true
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            shouldShowPaywall = true
        }
    }
    
    var onCompletionHandler: (() -> Void)? = nil
    
    func completeOnboarding(completion: @escaping () -> Void) {
        // Show breathing exercise
        withAnimation {
            showBreatheAnimation = true
        }
        
        // Start breathing animation cycle
        startBreathingCycle()
        
        // Set a timer to complete onboarding after breathing exercise
        Task {
            try? await Task.sleep(for: .seconds(12))
            
            await MainActor.run {
                // Here you would save all the collected user preferences
            print("Saving user preferences:")
            print("- User Name: \(userName)")
            print("- Selected Goal: \(selectedGoal)")
            print("- Daily Mindfulness Goal: \(dailyMindfulnessGoal) minutes")
            print("- Selected Triggers: \(selectedTriggers)")
            print("- Notifications Enabled: \(notificationsEnabled)")
            if notificationsEnabled {
                print("- Reminder Time: \(formatTime(reminderTime))")
            }
                print("- Pro User: \(isProUser)")
            
                // Set onboarding as completed and call completion handler
            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                UserDefaults.standard.set(isProUser, forKey: "isProUser")
            UserDefaults.standard.synchronize()
            
                // Call the completion handler passed in
                completion()
                
                // Call the view's completion handler if set
                onCompletionHandler?()
            }
        }
    }
    
    private func startBreathingCycle() {
        Task {
        // Initial breath in
            await MainActor.run {
        breatheIn = true
        withAnimation(.easeInOut(duration: 4)) {
            breatheProgress = 0.5
                }
            }
            
            try? await Task.sleep(for: .seconds(4))
            
            // Breath out
            await MainActor.run {
            breatheIn = false
            withAnimation(.easeInOut(duration: 4)) {
                breatheProgress = 1.0
                }
            }
            
            try? await Task.sleep(for: .seconds(4))
            
            // Another breath in
            await MainActor.run {
                breatheIn = true
                withAnimation(.easeInOut(duration: 4)) {
                    breatheProgress = 0.5
                }
            }
        }
    }
    
    // Format time for display
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Onboarding Page Model
struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let illustration: (CGFloat) -> any View
    
    var illustrationView: (CGFloat) -> AnyView {
        { size in
            AnyView(illustration(size))
        }
    }
    
    // For backward compatibility
    var anyViewIllustration: AnyView {
        AnyView(illustration(200))
    }
}

// MARK: - Main Onboarding View
struct EnhancedOnboardingView: View {
    @StateObject private var viewModel = EnhancedOnboardingViewModel()
    @EnvironmentObject private var paywallManager: BFPaywallManager
    @Binding var hasCompletedOnboarding: Bool
    
    private let pages = EnhancedOnboardingViewModel.valuePropositionPages
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    BFTheme.background,
                    BFTheme.cardBackground
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if viewModel.shouldShowPaywall {
                // Show paywall view
                OnboardingPaywallView(viewModel: viewModel)
                    .transition(.opacity)
            } else {
                VStack(spacing: 0) {
                    // Header with skip and quick start buttons
                    HStack {
                        if viewModel.showQuickStartOption {
                            Button(action: {
                                viewModel.quickStart()
                            }) {
                                Text("Quick Start")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundStyle(BFTheme.accentColor)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule()
                                            .stroke(BFTheme.accentColor.opacity(0.5), lineWidth: 1.5)
                                    )
                            }
                            .padding(.leading, 20)
                            .padding(.top, 16)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                // Show paywall before skipping
                                viewModel.shouldShowPaywall = true
                            }
                        }) {
                            Text("Skip")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundStyle(BFTheme.neutralLight.opacity(0.8))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(BFTheme.neutralDark.opacity(0.15))
                                )
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 16)
                        .opacity(viewModel.currentPage < pages.count - 1 ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.currentPage)
                    }
                    
                    // Pager
                    TabView(selection: $viewModel.currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            OnboardingPageView(page: pages[index])
                                .tag(index)
                        }
                        
                        // Quick setup page
                        BasicSetupView(viewModel: viewModel)
                            .tag(pages.count)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut, value: viewModel.currentPage)
                    
                    // Progress and button controls
                    VStack(spacing: 24) {
                        // Progress indicators
                        ProgressIndicators(currentPage: viewModel.currentPage, totalPages: pages.count + 1)
                        
                        // Continue button
                        Button(action: {
                            if viewModel.currentPage < pages.count {
                                withAnimation {
                                    viewModel.currentPage += 1
                                }
                            } else {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                    // Show paywall before completing
                                    viewModel.shouldShowPaywall = true
                                }
                            }
                        }) {
                            HStack(spacing: 12) {
                                Text(viewModel.currentPage < pages.count ? "Continue" : "Get Started")
                                    .font(BFTheme.Typography.button())
                                    .foregroundStyle(.white)
                                
                                if viewModel.currentPage < pages.count {
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: viewModel.currentPage < pages.count ? 
                                        [BFTheme.primaryColor, BFTheme.primaryColor.opacity(0.8)] : 
                                        [BFTheme.accentColor, BFTheme.accentColor.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: (viewModel.currentPage < pages.count ? BFTheme.primaryColor : BFTheme.accentColor).opacity(0.3), 
                                        radius: 10, x: 0, y: 5)
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)
                    }
                    .padding(.bottom, 40)
                    .padding(.top, 20)
                }
            }
        }
        .onAppear {
            // Setup completion handler
            viewModel.onCompletionHandler = {
                hasCompletedOnboarding = true
            }
        }
    }
}

// Modern progress indicators
struct ProgressIndicators: View {
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        VStack(spacing: 16) {
            // Modern progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background bar
                    Capsule()
                        .fill(BFTheme.neutralLight.opacity(0.2))
                        .frame(height: 6)
                    
                    // Progress bar
                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [BFTheme.primaryColor, BFTheme.primaryColor.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat((currentPage + 1)) / CGFloat(totalPages), height: 6)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentPage)
                }
            }
            .frame(height: 6)
            .padding(.horizontal, 20)
            
            // Step text
            Text("\(currentPage + 1)/\(totalPages)")
                .font(BFTheme.Typography.caption())
                .foregroundStyle(BFTheme.neutralLight.opacity(0.8))
                .padding(.top, 4)
        }
    }
}

// MARK: - Onboarding Page View
struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 32) {
            // Illustration
            ZStack {
                // Background effect
                Circle()
                    .fill(BFTheme.primaryColor.opacity(0.1))
                    .frame(width: 200, height: 200)
                
                // Illustration view
                page.illustrationView(160)
                    .scaleEffect(1.0)
                    .opacity(1)
                    .brightness(0.05)
                    .shadow(color: BFTheme.primaryColor.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.bottom, 20)
            
            // Text content
            VStack(alignment: .center, spacing: 16) {
                Text(page.title)
                    .font(BFTheme.Typography.title())
                    .foregroundColor(BFTheme.neutralLight)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 10)
                
                Text(page.description)
                    .font(BFTheme.Typography.body())
                    .foregroundColor(BFTheme.neutralLight)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 24)
                    .lineSpacing(4)
                    .padding(.bottom, 8)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(BFTheme.cardBackground.description).opacity(0.9))
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            )
            .padding(.horizontal, 20)
        }
        .padding(.top, 40)
        .padding(.bottom, 20)
    }
}

// MARK: - Paywall View
struct OnboardingPaywallView: View {
    @ObservedObject var viewModel: EnhancedOnboardingViewModel
    @EnvironmentObject private var paywallManager: BFPaywallManager
    @Environment(\.dismiss) private var dismiss
    @State private var hasAppeared = false
    @State private var selectedPlanIndex = 1 // Default to middle plan
    @State private var showAllPlans = false
    
    // Define a struct for subscription plans
    struct SubscriptionPlan {
        let title: String
        let price: String
        let subtitle: String
        let originalPrice: String?
        let id: String
        let isBestValue: Bool
        let isPromoted: Bool
    }
    
    let plans: [SubscriptionPlan] = [
        SubscriptionPlan(
            title: "Monthly",
            price: "$3.99",
            subtitle: "per month",
            originalPrice: nil,
            id: "monthly_intro_sub",
            isBestValue: false,
            isPromoted: false
        ),
        SubscriptionPlan(
            title: "Quarterly",
            price: "$9.99",
            subtitle: "$3.33/mo",
            originalPrice: "$11.97",
            id: "quarterly_sub",
            isBestValue: true,
            isPromoted: true
        ),
        SubscriptionPlan(
            title: "Yearly",
            price: "$29.99",
            subtitle: "$2.50/mo",
            originalPrice: "$47.88",
            id: "yearly_sub",
            isBestValue: false,
            isPromoted: false
        ),
        SubscriptionPlan(
            title: "Lifetime",
            price: "$79.99",
            subtitle: "one-time payment",
            originalPrice: "$99.99",
            id: "lifetime_sub",
            isBestValue: false,
            isPromoted: false
        )
    ]
    
    // Returns the visible plans based on the showAllPlans state
    var visiblePlans: [SubscriptionPlan] {
        if showAllPlans {
            return plans
        } else {
            // When not showing all plans, just show the first 3
            return Array(plans.prefix(3))
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                VStack(spacing: 8) {
                    Text("Unlock Full Access")
                        .font(BFTheme.Typography.title())
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.white, .white.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                .multilineTextAlignment(.center)
                        .padding(.top, 12)
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 20)
                        .animation(.easeOut(duration: 0.5), value: hasAppeared)
            
                    Text("Get the most out of your journey to bet-free living with premium features")
                        .font(BFTheme.Typography.body())
                        .foregroundStyle(.white.opacity(0.95))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.1), value: hasAppeared)
                }
                
                // Free Trial Banner
                Text("7-DAY FREE TRIAL")
                    .font(BFTheme.Typography.caption(14))
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .background(
                        Capsule()
                            .fill(BFTheme.accentColor)
                    )
                    .opacity(hasAppeared ? 1 : 0)
                    .animation(Animation.easeOut(duration: 0.5).delay(0.15), value: hasAppeared)
                
                // Features list
                VStack(alignment: .leading, spacing: 12) {
                    FeatureRow(icon: "chart.bar", title: "Bet Tracking", description: "Easily track every urge and gambling session to visualize and reduce over time")
            .opacity(hasAppeared ? 1 : 0)
            .offset(y: hasAppeared ? 0 : 20)
            .animation(.easeOut(duration: 0.5).delay(0.2), value: hasAppeared)
            
                    FeatureRow(icon: "calendar", title: "Set Custom Goals", description: "Create daily limits and a personalized quit plan with target dates")
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 20)
                        .animation(.easeOut(duration: 0.5).delay(0.3), value: hasAppeared)
                    
                    FeatureRow(icon: "person.2", title: "Quit Buddies", description: "Connect with friends also trying to quit and compare progress together")
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 20)
                        .animation(.easeOut(duration: 0.5).delay(0.4), value: hasAppeared)
                    
                    FeatureRow(icon: "exclamationmark.triangle", title: "Trigger Detection", description: "Identify patterns that lead to gambling through detailed tracking")
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 20)
                        .animation(.easeOut(duration: 0.5).delay(0.5), value: hasAppeared)
                }
                .padding(18)
                .background(
                    ZStack {
                        // New background with a subtle gradient that complements the accent color
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "#0F1923"), // Very dark background for contrast
                                Color(hex: "#121A24")  // Slightly different dark shade
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        
                        // Very subtle accent color influence
                        BFTheme.accentColor.opacity(0.03)
                    }
                )
                .overlay(
                    // Add subtle border for definition
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(BFTheme.accentColor.opacity(0.2), lineWidth: 1)
                )
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                .padding(.horizontal)
                
                // Limited Time Offer
                if hasAppeared {
                    Text("30% OFF - LIMITED TIME OFFER")
                        .font(BFTheme.Typography.caption(12))
                        .fontWeight(.bold)
                        .foregroundColor(BFTheme.accentColor)
                        .padding(.vertical, 8)
                        .padding(.top, 4)
                        .transition(.opacity)
                }
                
                // Pricing section - grid layout for all plans
                VStack(spacing: 16) {
                    // Plans in a grid layout
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(0..<visiblePlans.count, id: \.self) { index in
                            PricingOption(
                                title: visiblePlans[index].title,
                                price: visiblePlans[index].price,
                                subtitle: visiblePlans[index].subtitle,
                                originalPrice: visiblePlans[index].originalPrice,
                                isBestValue: visiblePlans[index].isBestValue,
                                isPromoted: visiblePlans[index].isPromoted,
                                isSelected: selectedPlanIndex == index,
                                action: { selectedPlanIndex = index }
                            )
            .opacity(hasAppeared ? 1 : 0)
            .offset(y: hasAppeared ? 0 : 20)
                            .animation(.easeOut(duration: 0.5).delay(0.6 + Double(index) * 0.1), value: hasAppeared)
                        }
                    }
                    .padding(.horizontal)
                    
                    // See all plans toggle
                    if plans.count > 3 {
                        Button {
                            withAnimation {
                                showAllPlans.toggle()
                            }
                        } label: {
                            Text(showAllPlans ? "Show Fewer Options" : "See All Plans")
                                .font(BFTheme.Typography.caption())
                                .foregroundColor(BFTheme.primaryColor)
                        }
                        .padding(.top, 4)
                        .opacity(hasAppeared ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.8), value: hasAppeared)
                    }
                    
                    // Start Trial button
                    Button {
                        // Handle subscription using paywallManager
                        let selectedPlan = visiblePlans[selectedPlanIndex]
                        paywallManager.purchaseSubscription(planId: selectedPlan.id) { success in
                            if success {
                                viewModel.isProUser = true
                                viewModel.completeOnboarding {
                                    // Completion handler
                                }
                            } else {
                                // Handle purchase failure
                                // In a real app, show an error message
                            }
                        }
                    } label: {
                        HStack(spacing: 12) {
                            Text("Start 7-Day Free Trial")
                                .font(BFTheme.Typography.button())
                                .foregroundStyle(.white)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [BFTheme.accentColor, BFTheme.accentColor.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: BFTheme.accentColor.opacity(0.3), radius: 10, x: 0, y: 5)
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .opacity(hasAppeared ? 1 : 0)
                    .offset(y: hasAppeared ? 0 : 20)
                    .animation(.easeOut(duration: 0.5).delay(0.9), value: hasAppeared)
                    
                    // Continue with free
                    Button {
                        // Continue with free version
                        viewModel.completeOnboarding {
                            // Completion handler
                        }
                    } label: {
                        Text("Continue with limited access")
                            .font(BFTheme.Typography.body(16))
                            .foregroundStyle(BFTheme.neutralLight.opacity(0.8))
                            .padding(.vertical, 8)
                    }
                    .opacity(hasAppeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(1.0), value: hasAppeared)
                    
                    // Privacy and terms
                    Text("Trial auto-converts to subscription. Cancel anytime.")
                        .font(BFTheme.Typography.caption(12))
                        .foregroundStyle(BFTheme.neutralLight.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                        .padding(.horizontal, 20)
                        .opacity(hasAppeared ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(1.1), value: hasAppeared)
                }
                .padding(.top, 6)
            }
            .padding(.bottom, 16)
        }
        .onAppear {
            Task {
                try? await Task.sleep(for: .seconds(0.1))
                await MainActor.run {
                    hasAppeared = true
                }
            }
        }
    }
}

// MARK: - Feature Row Component
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .symbolRenderingMode(.palette)
                .foregroundStyle(BFTheme.accentColor, BFTheme.neutralLight.opacity(0.3))
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(BFTheme.accentColor.opacity(0.15))
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(BFTheme.Typography.headline(17))
                    .foregroundStyle(.white)
                
                Text(description)
                    .font(BFTheme.Typography.body(14))
                    .foregroundStyle(.white.opacity(0.9))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(6)
    }
}

// MARK: - Updated Pricing Option Component
struct PricingOption: View {
    let title: String
    let price: String
    let subtitle: String
    let originalPrice: String?
    let isBestValue: Bool
    let isPromoted: Bool
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 6) {
            if isBestValue {
                Text("Best Value")
                    .font(BFTheme.Typography.caption(11))
                    .fontWeight(.bold)
                    .foregroundStyle(BFTheme.accentColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(BFTheme.accentColor.opacity(0.15))
                    )
                    .padding(.bottom, 2)
            } else if isPromoted {
                Text("Popular")
                    .font(BFTheme.Typography.caption(11))
                    .fontWeight(.bold)
                    .foregroundStyle(BFTheme.primaryColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(BFTheme.primaryColor.opacity(0.15))
                    )
                    .padding(.bottom, 2)
            } else {
                Spacer()
                    .frame(height: 19)
            }
            
                Text(title)
                .font(BFTheme.Typography.headline(16))
                .foregroundStyle(BFTheme.neutralLight)
            
            Text(price)
                .font(BFTheme.Typography.title(22))
                .foregroundStyle(BFTheme.neutralLight)
            
            if let original = originalPrice {
                Text(original)
                    .font(BFTheme.Typography.caption(12))
                    .foregroundStyle(BFTheme.neutralLight.opacity(0.6))
                    .strikethrough(true, color: BFTheme.neutralLight.opacity(0.6))
                    .padding(.top, -6)
            }
            
            Text(subtitle)
                .font(BFTheme.Typography.body(14))
                .foregroundStyle(BFTheme.neutralLight)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? BFTheme.accentColor : BFTheme.neutralLight.opacity(0.3), lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? BFTheme.cardBackground.opacity(0.8) : BFTheme.cardBackground.opacity(0.5))
                )
        )
        .onTapGesture {
            action()
        }
    }
}

// MARK: - New simple setup page in PuffCount style
struct BasicSetupView: View {
    @ObservedObject var viewModel: EnhancedOnboardingViewModel
    
    var body: some View {
        VStack(spacing: 25) {
            // Title
            Text("Ready to start tracking?")
                .font(BFTheme.Typography.title(28))
                .foregroundColor(BFTheme.neutralLight)
                    .multilineTextAlignment(.center)
                .padding(.top, 40)
            
            // Main controls - Just the essential questions
            VStack(spacing: 30) {
                // Goal selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("What's your goal?")
                        .font(BFTheme.Typography.headline())
                        .foregroundColor(BFTheme.neutralLight)
                    
                    HStack(spacing: 12) {
                        ForEach(viewModel.goals, id: \.self) { goal in
                            GoalButton(
                                title: goal,
                                isSelected: viewModel.selectedGoal == goal,
                                action: {
                                    viewModel.selectedGoal = goal
                                    HapticManager.shared.selectionFeedback()
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Divider()
                    .background(BFTheme.neutralLight.opacity(0.2))
                    .padding(.horizontal, 40)
                
                // Daily urge goal
                VStack(alignment: .leading, spacing: 12) {
                    Text("Set a daily urge limit")
                        .font(BFTheme.Typography.headline())
                        .foregroundColor(BFTheme.neutralLight)
                    
                    HStack {
                        Text("\(viewModel.dailyMindfulnessGoal) urges per day")
                            .font(BFTheme.Typography.body(18))
                            .foregroundColor(BFTheme.neutralLight)
                            .frame(width: 180)
            
            Spacer()
                        
                        // Stepper
                        HStack(spacing: 20) {
                            Button(action: {
                                if viewModel.dailyMindfulnessGoal > 1 {
                                    viewModel.dailyMindfulnessGoal -= 1
                                    HapticManager.shared.selectionFeedback()
                                }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(BFTheme.primaryColor)
                            }
                            
                            Button(action: {
                                if viewModel.dailyMindfulnessGoal < 50 {
                                    viewModel.dailyMindfulnessGoal += 1
                                    HapticManager.shared.selectionFeedback()
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(BFTheme.primaryColor)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(BFTheme.cardBackground)
                    )
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, 20)
            .padding(.bottom, 40)
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

struct GoalButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(BFTheme.Typography.body())
                .foregroundColor(isSelected ? .white : BFTheme.neutralLight)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? BFTheme.accentColor : BFTheme.cardBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(BFTheme.accentColor.opacity(isSelected ? 0 : 0.5), lineWidth: 1.5)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
struct EnhancedOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedOnboardingView(hasCompletedOnboarding: .constant(false))
            .preferredColorScheme(.dark)
    }
} 