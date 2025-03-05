import SwiftUI
// Import the files that contain our class definitions
import Foundation  // Make sure Foundation is imported
import Combine

// Define necessary type definitions that were previously removed
class OnboardingViewModel: ObservableObject {
    @Published var currentScreen = 0
    @Published var hasProAccess = false
    @Published var isTrialActive = false
    
    func nextScreen() {
        currentScreen += 1
    }
    
    func skipToPaywall() {
        // Logic to skip to paywall screen
        currentScreen = 3 // Assuming paywall is screen 3
    }
}

/**
 * BFPaywallManager
 * Manages subscription purchases and paywall presentation
 */

class BFPaywallManager: ObservableObject {
    @Published var isProUser: Bool = UserDefaults.standard.bool(forKey: "isProUser")
    @Published var showPaywall: Bool = false
    
    var onPurchaseCompleted: (() -> Void)?
    
    init() {
        // Initialize payment handling
        print("PaywallManager initialized")
    }
    
    func purchaseSubscription(planId: String, completion: @escaping (Bool) -> Void) {
        // In a real app, this would initiate App Store purchase flow
        print("Purchasing subscription plan: \(planId)")
        
        // Simulate successful purchase
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Set user as pro
            self.isProUser = true
            UserDefaults.standard.set(true, forKey: "isProUser")
            
            // Call completion handlers
            completion(true)
            self.onPurchaseCompleted?()
            
            print("Purchase completed successfully!")
        }
    }
    
    func restorePurchases(completion: @escaping (Bool) -> Void) {
        // In a real app, this would restore purchases from App Store
        print("Restoring purchases...")
        
        // Simulate successful restore
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(true)
            print("Purchases restored successfully!")
        }
    }
    
    func showPaywallScreen() {
        withAnimation {
            showPaywall = true
        }
    }
    
    func hidePaywallScreen() {
        withAnimation {
            showPaywall = false
        }
    }
    
    // Added missing methods
    func recordHardPaywallSeen() {
        // In a real app, this would log analytics
        print("Hard paywall screen was seen by user")
    }
    
    func recordPurchaseStarted(planType: String) {
        // In a real app, this would log analytics
        print("Purchase started for plan type: \(planType)")
    }
}

/// Color constants for the app
class BFColors {
    // Main Colors
    static let primary = Color(red: 0.0, green: 0.8, blue: 0.8) // Teal (same as accent for now)
    static let accent = Color(red: 0.0, green: 0.8, blue: 0.8) // Teal
    static let secondary = Color(red: 0.1, green: 0.6, blue: 0.9) // Blue
    static let background = Color(red: 0.06, green: 0.1, blue: 0.2) // Dark blue
    
    // Semantic Colors
    static let calm = Color(red: 0.4, green: 0.7, blue: 0.9) // Light blue for calm/peaceful UI elements
    static let focus = Color(red: 0.8, green: 0.4, blue: 0.9) // Purple for focus/concentration UI elements
    
    // Text Colors
    static let textPrimary = Color.white // White
    static let textSecondary = Color(red: 0.8, green: 0.8, blue: 0.9) // Light gray
    static let textTertiary = Color(red: 0.6, green: 0.6, blue: 0.7) // Medium gray
    
    // UI Element Colors
    static let cardBackground = Color(red: 0.1, green: 0.15, blue: 0.25) // Slightly lighter than background
    static let divider = Color(red: 0.2, green: 0.25, blue: 0.35) // Border color
    
    // Status Colors
    static let success = Color(red: 0.2, green: 0.8, blue: 0.4) // Green
    static let warning = Color(red: 0.95, green: 0.8, blue: 0.3) // Yellow
    static let error = Color(red: 0.9, green: 0.3, blue: 0.3) // Red
    static let info = Color(red: 0.3, green: 0.6, blue: 0.9) // Blue
    
    // Additional UI Colors
    static let secondaryBackground = Color(red: 0.15, green: 0.2, blue: 0.3) // Slightly lighter than background for contrast
}

// MARK: - Button Style
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(BFColors.background)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(BFColors.accent)
            .cornerRadius(16)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Free Trial Teaser Screen
struct FreeTrialTeaserScreen: View {
    @EnvironmentObject private var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            // Logo
            Image(systemName: "arrow.up.forward.circle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(BFColors.accent)
                .frame(width: 80, height: 80)
                .padding(.top, 30)
                .shadow(color: BFColors.accent.opacity(0.5), radius: 15, x: 0, y: 0)
                .shadow(color: BFColors.accent.opacity(0.3), radius: 7, x: 0, y: 0)
            
            Text("Break Free From Gambling")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(BFColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Take the first step toward a healthier relationship with gambling through evidence-based tools and support.")
                .font(.body)
                .foregroundColor(BFColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .fixedSize(horizontal: false, vertical: true)
            
            // Features
            VStack(spacing: 18) {
                featureRow(icon: "chart.bar.fill", text: "Track Your Progress")
                featureRow(icon: "brain", text: "Mindfulness Techniques")
                featureRow(icon: "bell", text: "Recovery Support")
            }
            .padding(.vertical, 10)
            
            Spacer()
            
            Button("Continue") {
                viewModel.nextScreen()
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            BFColors.background
                .ignoresSafeArea()
        )
    }
    
    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(BFColors.accent)
                .frame(width: 28)
            
            Text(text)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(BFColors.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Soft Gate Screen (After Features Overview)
struct SoftGateScreen: View {
    @EnvironmentObject private var viewModel: OnboardingViewModel
    @State private var selectedPlan = 1 // Default to annual plan
    
    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // Header
                Text("Enhance Your Recovery")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(BFColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)
                
                // Plan selection
                VStack(spacing: 16) {
                    planOption("Monthly", price: "$9.99", perPeriod: "/month", isPopular: false, index: 0)
                    planOption("Annual", price: "$79.99", perPeriod: "/year", isPopular: true, index: 1)
                    planOption("Lifetime", price: "$199.99", perPeriod: "one-time", isPopular: false, index: 2)
                }
                .padding(.horizontal, 24)
                
                // Free trial info
                HStack(spacing: 12) {
                    Image(systemName: "gift.fill")
                        .font(.system(size: 22))
                        .foregroundColor(BFColors.accent)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("7-Day Free Trial")
                            .font(.headline)
                            .foregroundColor(BFColors.textPrimary)
                        
                        Text("Try all premium features risk-free")
                            .font(.subheadline)
                            .foregroundColor(BFColors.textSecondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 16) {
                    Button {
                        viewModel.isTrialActive = true
                        viewModel.hasProAccess = true
                        viewModel.nextScreen()
                    } label: {
                        HStack {
                            Text("Start Free Trial")
                            Image(systemName: "arrow.right")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button("Continue with Basic") {
                        viewModel.isTrialActive = false
                        viewModel.hasProAccess = false
                        viewModel.nextScreen()
                    }
                    .foregroundColor(BFColors.textSecondary)
                    .padding(.bottom, 8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
                
                // Legal
                Text(legalText)
                    .font(.system(size: 11))
                    .foregroundColor(BFColors.textTertiary.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
            }
        }
        .background(
            BFColors.background
                .ignoresSafeArea()
        )
    }
    
    private func planOption(_ title: String, price: String, perPeriod: String, isPopular: Bool, index: Int) -> some View {
        VStack(spacing: 0) {
            if isPopular {
                Text("BEST VALUE")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(BFColors.background)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(BFColors.accent)
                    .cornerRadius(12)
                    .offset(y: -12)
                    .zIndex(1)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(BFColors.textPrimary)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text(price)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(BFColors.textPrimary)
                        
                        Text(perPeriod)
                            .font(.caption)
                            .foregroundColor(BFColors.textSecondary)
                    }
                }
                
                Spacer()
                
                // Selection circle
                ZStack {
                    Circle()
                        .stroke(selectedPlan == index ? BFColors.accent : BFColors.divider, lineWidth: 2)
                        .frame(width: 22, height: 22)
                    
                    if selectedPlan == index {
                        Circle()
                            .fill(BFColors.accent)
                            .frame(width: 14, height: 14)
                    }
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(BFColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(selectedPlan == index ? BFColors.accent : BFColors.cardBackground, lineWidth: 2)
                    )
            )
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedPlan = index
            }
        }
    }
    
    private var legalText: String {
        "Payment will be charged to your Apple ID account at confirmation of purchase. Subscription automatically renews unless canceled at least 24 hours before the end of the current period."
    }
}

// MARK: - Enhanced Paywall Screen
struct EnhancedPaywallScreen: View {
    @EnvironmentObject private var viewModel: OnboardingViewModel
    @EnvironmentObject private var paywallManager: BFPaywallManager
    @State private var selectedPlan = 1 // Default to annual
    @State private var showPromo = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Logo
                Image(systemName: "arrow.up.forward.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(BFColors.accent)
                    .frame(width: 80, height: 80)
                    .padding(.top, 40)
                    .shadow(color: BFColors.accent.opacity(0.5), radius: 15, x: 0, y: 0)
                    .shadow(color: BFColors.accent.opacity(0.3), radius: 7, x: 0, y: 0)
                    .onAppear {
                        paywallManager.recordHardPaywallSeen()
                        
                        // Show special promo after a delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation(.easeOut) {
                                showPromo = true
                            }
                        }
                    }
                
                // Title
                VStack(spacing: 12) {
                    Text("Break Free From Gambling")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(BFColors.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Take the first step toward recovery with premium tools")
                        .font(.body)
                        .foregroundColor(BFColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 20)
                
                // Promo
                if showPromo {
                    Text("🔥 Get 7 days FREE, then 50% off 🔥")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(BFColors.accent)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(BFColors.accent.opacity(0.15))
                        )
                        .transition(.scale.combined(with: .opacity))
                }
                
                // Features
                VStack(alignment: .leading, spacing: 20) {
                    featureRow(icon: "chart.bar.fill", title: "Progress Tracking", description: "Monitor your recovery journey")
                    featureRow(icon: "brain.head.profile", title: "Mindfulness Exercises", description: "Evidence-based techniques")
                    featureRow(icon: "bell.badge.fill", title: "24/7 Support", description: "Help when you need it most")
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                // Plan selection
                Text("Choose Your Plan:")
                    .font(.headline)
                    .foregroundColor(BFColors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                
                // Plan Options
                VStack(spacing: 16) {
                    planOption("Annual", price: "$79.99", perPeriod: "/year", description: "Most popular, save 33%", isPopular: true, index: 1)
                    
                    HStack {
                        planOptionCompact("Monthly", price: "$9.99", perPeriod: "/mo", index: 0)
                        planOptionCompact("Lifetime", price: "$199.99", perPeriod: "once", index: 2)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer(minLength: 30)
                
                // CTA buttons
                VStack(spacing: 16) {
                    Button("Start My 7-Day Free Trial") {
                        viewModel.isTrialActive = true
                        viewModel.hasProAccess = true
                        viewModel.nextScreen()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button {
                        viewModel.isTrialActive = true
                        viewModel.hasProAccess = true
                        UserDefaults.standard.set(true, forKey: "limitedTrialMode")
                        viewModel.nextScreen()
                    } label: {
                        Text("Try Limited Features")
                            .foregroundColor(BFColors.textSecondary)
                    }
                }
                .padding(.horizontal, 24)
                
                // Legal
                HStack(spacing: 8) {
                    Link("Terms", destination: URL(string: "https://betfree.com/terms")!)
                    Text("•")
                    Link("Privacy", destination: URL(string: "https://betfree.com/privacy")!)
                }
                .font(.caption2)
                .foregroundColor(BFColors.textTertiary.opacity(0.7))
                .padding(.top, 20)
                
                Text(legalText)
                    .font(.system(size: 11))
                    .foregroundColor(BFColors.textTertiary.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
            }
        }
        .background(
            BFColors.background
                .ignoresSafeArea()
        )
    }
    
    private func featureRow(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(BFColors.accent)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(BFColors.textPrimary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(BFColors.textSecondary)
            }
            
            Spacer()
        }
    }
    
    private func planOption(_ title: String, price: String, perPeriod: String, description: String, isPopular: Bool, index: Int) -> some View {
        VStack(spacing: 0) {
            if isPopular {
                Text("BEST VALUE")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(BFColors.background)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(BFColors.accent)
                    .cornerRadius(12)
                    .offset(y: -12)
                    .zIndex(1)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(BFColors.textPrimary)
                        
                        Text(description)
                            .font(.caption)
                            .foregroundColor(BFColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Selection circle
                    ZStack {
                        Circle()
                            .stroke(selectedPlan == index ? BFColors.accent : BFColors.divider, lineWidth: 2)
                            .frame(width: 22, height: 22)
                        
                        if selectedPlan == index {
                            Circle()
                                .fill(BFColors.accent)
                                .frame(width: 14, height: 14)
                        }
                    }
                }
                
                // Price
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(price)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(BFColors.textPrimary)
                    
                    Text(perPeriod)
                        .font(.caption)
                        .foregroundColor(BFColors.textSecondary)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(BFColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(selectedPlan == index ? BFColors.accent : BFColors.cardBackground, lineWidth: 2)
                    )
            )
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedPlan = index
            }
        }
    }
    
    private func planOptionCompact(_ title: String, price: String, perPeriod: String, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(BFColors.textPrimary)
                
                Spacer()
                
                // Selection circle
                ZStack {
                    Circle()
                        .stroke(selectedPlan == index ? BFColors.accent : BFColors.divider, lineWidth: 2)
                        .frame(width: 18, height: 18)
                    
                    if selectedPlan == index {
                        Circle()
                            .fill(BFColors.accent)
                            .frame(width: 12, height: 12)
                    }
                }
            }
            
            // Price
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(price)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(BFColors.textPrimary)
                
                Text(perPeriod)
                    .font(.caption2)
                    .foregroundColor(BFColors.textSecondary)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(BFColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(selectedPlan == index ? BFColors.accent : BFColors.cardBackground, lineWidth: 2)
                )
        )
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedPlan = index
            }
        }
    }
    
    private var legalText: String {
        "Payment will be charged to your Apple ID account at confirmation of purchase. Subscription automatically renews unless canceled at least 24 hours before the end of the current period."
    }
}

// MARK: - Hard Paywall Screen
struct HardPaywallScreen: View {
    @EnvironmentObject private var paywallManager: BFPaywallManager
    @Binding var isPresented: Bool
    @State private var selectedPlan = 1 // Default to annual
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    // Logo
                    Image(systemName: "arrow.up.forward.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(BFColors.accent)
                    
                    // Title
                    Text("Upgrade to BetFree Pro")
                        .font(BFTypography.heading1)
                        .foregroundColor(BFColors.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    // Subtitle
                    Text("Unlock all premium features and take control of your betting habits")
                        .font(BFTypography.body)
                        .foregroundColor(BFColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
                
                // Features
                VStack(spacing: 16) {
                    featureRow(icon: "chart.bar.fill", title: "Advanced Analytics", description: "Get detailed insights into your betting patterns")
                    featureRow(icon: "bell.fill", title: "Custom Alerts", description: "Set personalized triggers and reminders")
                    featureRow(icon: "lock.shield.fill", title: "Ad-Free Experience", description: "Enjoy the app without interruptions")
                }
                .padding(.horizontal)
                
                // Pricing Plans
                VStack(spacing: 16) {
                    // Monthly Plan
                    planButton(index: 0, title: "Monthly", price: "$9.99", period: "month")
                    
                    // Annual Plan
                    planButton(index: 1, title: "Annual", price: "$59.99", period: "year", savings: "Save 50%")
                }
                .padding(.horizontal)
                
                // Purchase Button
                Button {
                    paywallManager.recordPurchaseStarted(planType: selectedPlan == 0 ? "monthly" : "annual")
                    // In a real app, this would initiate the purchase flow
                    isPresented = false
                } label: {
                    Text("Start Free Trial")
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(BFColors.accent)
                        .foregroundColor(BFColors.background)
                        .cornerRadius(16)
                        .font(BFTypography.buttonLabel)
                }
                .padding(.horizontal)
                
                // Close Button
                Button {
                    isPresented = false
                } label: {
                    Text("Maybe Later")
                        .foregroundColor(BFColors.textSecondary)
                        .font(BFTypography.buttonLabel)
                }
                
                // Legal Text
                Text("Payment will be charged to your Apple ID account at confirmation of purchase. Subscription automatically renews unless canceled at least 24 hours before the end of the current period.")
                    .font(BFTypography.caption)
                    .foregroundColor(BFColors.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
            }
        }
        .background(BFColors.background.ignoresSafeArea())
        .onAppear {
            paywallManager.recordHardPaywallSeen()
        }
    }
    
    private func featureRow(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(BFColors.accent)
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(BFTypography.heading3)
                    .foregroundColor(BFColors.textPrimary)
                
                Text(description)
                    .font(BFTypography.body)
                    .foregroundColor(BFColors.textSecondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(BFColors.cardBackground)
        .cornerRadius(12)
    }
    
    private func planButton(index: Int, title: String, price: String, period: String, savings: String = "") -> some View {
        Button {
            selectedPlan = index
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(BFTypography.heading3)
                        .foregroundColor(BFColors.textPrimary)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(price)
                            .font(BFTypography.heading2)
                            .foregroundColor(BFColors.textPrimary)
                        
                        Text("per \(period)")
                            .font(BFTypography.body)
                            .foregroundColor(BFColors.textSecondary)
                    }
                }
                
                Spacer()
                
                if !savings.isEmpty {
                    Text(savings)
                        .font(BFTypography.caption)
                        .foregroundColor(BFColors.accent)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(BFColors.accent.opacity(0.2))
                        .cornerRadius(8)
                }
                
                ZStack {
                    Circle()
                        .stroke(selectedPlan == index ? BFColors.accent : BFColors.divider, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if selectedPlan == index {
                        Circle()
                            .fill(BFColors.accent)
                            .frame(width: 16, height: 16)
                    }
                }
            }
            .padding(16)
            .background(BFColors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedPlan == index ? BFColors.accent : Color.clear, lineWidth: 2)
            )
        }
    }
}

// MARK: - View Extensions
extension View {
    func glow(color: Color, radius: CGFloat) -> some View {
        self
            .shadow(color: color.opacity(0.5), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(0.3), radius: radius/2, x: 0, y: 0)
    }
    
    func withPaywall(manager: BFPaywallManager) -> some View {
        // This modifier would normally apply paywall-related functionality
        // For now, it just returns the view itself without modification
        return self
    }
}

// MARK: - Standalone Paywall Screen
struct BFPaywallScreen: View {
    @EnvironmentObject private var paywallManager: BFPaywallManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlanIndex = 0
    @State private var hasAppeared = false
    
    // Define a struct for subscription plans
    struct SubscriptionPlan {
        let title: String
        let price: String
        let subtitle: String
        let id: String
        let isBestValue: Bool
    }
    
    let plans: [SubscriptionPlan] = [
        SubscriptionPlan(title: "Monthly", price: "$4.99", subtitle: "per month", id: "monthly_sub", isBestValue: false),
        SubscriptionPlan(title: "Yearly", price: "$29.99", subtitle: "per year", id: "yearly_sub", isBestValue: true)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        BFColors.background,
                        BFColors.cardBackground
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 12) {
                            Text("Upgrade to BetFree Pro")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    .linearGradient(
                                        colors: [.white, .white.opacity(0.8)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .multilineTextAlignment(.center)
                                .padding(.top, 20)
                                .opacity(hasAppeared ? 1 : 0)
                                .offset(y: hasAppeared ? 0 : 20)
                                .animation(.easeOut(duration: 0.5), value: hasAppeared)
                            
                            Text("Unlock all premium features to support your gambling-free journey")
                                .font(.callout.weight(.medium))
                                .foregroundStyle(.white.opacity(0.95))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                                .opacity(hasAppeared ? 1 : 0)
                                .offset(y: hasAppeared ? 0 : 20)
                                .animation(.easeOut(duration: 0.5).delay(0.1), value: hasAppeared)
                        }
                        
                        // Features list
                        VStack(alignment: .leading, spacing: 16) {
                            FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Advanced Analytics", description: "Track patterns and identify triggers with detailed insights")
                                .opacity(hasAppeared ? 1 : 0)
                                .offset(y: hasAppeared ? 0 : 20)
                                .animation(.easeOut(duration: 0.5).delay(0.2), value: hasAppeared)
                            
                            FeatureRow(icon: "brain.head.profile", title: "Expert-Led Exercises", description: "Access specialized mindfulness techniques for gambling urges")
                                .opacity(hasAppeared ? 1 : 0)
                                .offset(y: hasAppeared ? 0 : 20)
                                .animation(.easeOut(duration: 0.5).delay(0.3), value: hasAppeared)
                            
                            FeatureRow(icon: "person.3", title: "Community Support", description: "Connect with others on similar journeys in our moderated forums")
                                .opacity(hasAppeared ? 1 : 0)
                                .offset(y: hasAppeared ? 0 : 20)
                                .animation(.easeOut(duration: 0.5).delay(0.4), value: hasAppeared)
                            
                            FeatureRow(icon: "bell.badge", title: "Custom Reminders", description: "Set personalized reminders for high-risk times and situations")
                                .opacity(hasAppeared ? 1 : 0)
                                .offset(y: hasAppeared ? 0 : 20)
                                .animation(.easeOut(duration: 0.5).delay(0.5), value: hasAppeared)
                        }
                        .padding(24)
                        .background(.ultraThinMaterial.opacity(0.5))
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        // Pricing section
                        VStack(spacing: 20) {
                            HStack(spacing: 16) {
                                PricingOption(
                                    title: plans[0].title,
                                    price: plans[0].price,
                                    subtitle: plans[0].subtitle,
                                    originalPrice: nil,
                                    isBestValue: plans[0].isBestValue,
                                    isPromoted: false,
                                    isSelected: selectedPlanIndex == 0,
                                    action: { selectedPlanIndex = 0 }
                                )
                                
                                PricingOption(
                                    title: plans[1].title,
                                    price: plans[1].price,
                                    subtitle: plans[1].subtitle,
                                    originalPrice: nil,
                                    isBestValue: plans[1].isBestValue,
                                    isPromoted: false,
                                    isSelected: selectedPlanIndex == 1,
                                    action: { selectedPlanIndex = 1 }
                                )
                            }
                            .padding(.horizontal)
                            .opacity(hasAppeared ? 1 : 0)
                            .offset(y: hasAppeared ? 0 : 20)
                            .animation(.easeOut(duration: 0.5).delay(0.6), value: hasAppeared)
                            
                            // Subscribe button
                            Button {
                                // Handle subscription using paywallManager
                                let selectedPlan = plans[selectedPlanIndex]
                                paywallManager.purchaseSubscription(planId: selectedPlan.id) { success in
                                    if success {
                                        dismiss()
                                    }
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    Text("Subscribe Now")
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                        .foregroundStyle(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .shadow(color: BFColors.accent.opacity(0.3), radius: 10, x: 0, y: 5)
                                )
                            }
                            .padding(.horizontal, 20)
                            .opacity(hasAppeared ? 1 : 0)
                            .offset(y: hasAppeared ? 0 : 20)
                            .animation(.easeOut(duration: 0.5).delay(0.7), value: hasAppeared)
                            
                            // Restore purchases button
                            Button {
                                paywallManager.restorePurchases { success in
                                    if success {
                                        dismiss()
                                    }
                                }
                            } label: {
                                Text("Restore Purchases")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundStyle(BFColors.textPrimary.opacity(0.8))
                                    .padding(.vertical, 12)
                            }
                            .opacity(hasAppeared ? 1 : 0)
                            .animation(.easeOut(duration: 0.5).delay(0.8), value: hasAppeared)
                            
                            // Privacy and terms
                            Text("Subscription auto-renews. Cancel anytime in App Store settings.")
                                .font(.caption)
                                .foregroundStyle(BFColors.textPrimary.opacity(0.6))
                                .multilineTextAlignment(.center)
                                .padding(.top, 8)
                                .padding(.horizontal, 20)
                                .opacity(hasAppeared ? 1 : 0)
                                .animation(.easeOut(duration: 0.5).delay(0.9), value: hasAppeared)
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 40)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationBarItems(
                trailing: Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(BFColors.textPrimary.opacity(0.7))
                        .padding(8)
                }
            )
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
}

// MARK: - Preview
struct BFPaywallScreens_Previews: PreviewProvider {
    static var previews: some View {
        BFPaywallScreen()
            .environmentObject(BFPaywallManager())
            .preferredColorScheme(.dark)
    }
} 