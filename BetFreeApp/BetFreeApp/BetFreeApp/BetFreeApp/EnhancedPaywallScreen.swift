import SwiftUI

/**
 * EnhancedPaywallScreen
 * An engaging, visually-rich paywall interface for the BetFree app.
 * Uses design patterns from the successful urge tracking screen implementation.
 * Provides clear value proposition with interactive elements and personalized messaging.
 * Features highly visible subscription plan selection with checkmark indicators and gradient backgrounds.
 */

struct EnhancedPaywallScreen: View {
    @ObservedObject var viewModel: EnhancedOnboardingViewModel
    @EnvironmentObject private var paywallManager: BFPaywallManager
    @State private var selectedPlanIndex = 1 // Default to yearly plan
    @State private var isAnimating = false
    @State private var showFeatures = false
    @State private var expandedFeature: Int? = nil
    @State private var showPersonalizedOffer = false
    
    // Plan options
    private let plans = [
        PlanOption(id: 0, name: "Monthly", price: "$9.99", period: "month", billingText: "Billed monthly", savings: "", popularTag: false, planId: "monthly_intro_sub"),
        PlanOption(id: 1, name: "Yearly", price: "$59.99", period: "year", billingText: "Billed annually", savings: "Save 50%", popularTag: true, planId: "yearly_sub"),
        PlanOption(id: 2, name: "Lifetime", price: "$149.99", period: "once", billingText: "One-time payment", savings: "Best value", popularTag: false, planId: "lifetime_sub")
    ]
    
    // Features with animations
    private let features = [
        FeatureItem(
            id: 0,
            icon: "chart.bar.fill",
            title: "Advanced Analytics",
            description: "Track your progress with detailed insights. Understand patterns and triggers to better manage your urges.",
            colorAccent: Color.blue
        ),
        FeatureItem(
            id: 1,
            icon: "bell.badge.fill",
            title: "Smart Reminders",
            description: "Get personalized notifications at critical moments. Our AI predicts when you're most vulnerable to urges.",
            colorAccent: Color.purple
        ),
        FeatureItem(
            id: 2,
            icon: "person.2.fill",
            title: "Community Support",
            description: "Connect with others on the same journey. Share experiences and strategies in our moderated community.",
            colorAccent: Color.orange
        ),
        FeatureItem(
            id: 3,
            icon: "brain.head.profile",
            title: "Mindfulness Exercises",
            description: "Access 50+ guided meditations designed specifically for urge management and stress reduction.",
            colorAccent: Color.green
        )
    ]
    
    // Personalized message based on user's name and goal
    private var personalizedMessage: String {
        let name = viewModel.userName.isEmpty ? "there" : viewModel.userName
        let goalText = viewModel.dailyMindfulnessGoal > 0 ? "reaching your daily goal of \(viewModel.dailyMindfulnessGoal) check-ins" : "reaching your daily goals"
        
        return "Hey \(name), unlock the full potential of BetFree to maximize your chances of \(goalText) and building lasting positive habits."
    }
    
    var body: some View {
        // Break up the complex expression into smaller parts
        let backgroundGradient = LinearGradient(
            gradient: Gradient(colors: [Color(hex: "#10172A"), Color(hex: "#1c2b4b")]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        return ZStack {
            // Background with gradient
            backgroundGradient
                .ignoresSafeArea()
            
            // Floating shapes (subtle background elements)
            ForEach(0..<6) { index in
                FloatingShape(index: index)
                    .opacity(0.15) // More subtle in this view
            }
            
            // Main content
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    VStack(spacing: 12) {
                        Text("Unlock Premium")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.top, 50)
                            .opacity(isAnimating ? 1 : 0)
                            .offset(y: isAnimating ? 0 : -20)
                            .animation(.easeOut(duration: 0.6), value: isAnimating)
                        
                        // Animated illustration of premium features
                        ZStack {
                            // Background glow
                            Circle()
                                .fill(BFColors.accent.opacity(0.2))
                                .frame(width: 120, height: 120)
                                .blur(radius: 15)
                                .opacity(isAnimating ? 1 : 0)
                                .scaleEffect(isAnimating ? 1 : 0.8)
                                .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
                            
                            // Premium badge
                            ZStack {
                                // Outer circle
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.7)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 100, height: 100)
                                    .shadow(color: BFColors.accent.opacity(0.6), radius: 10, x: 0, y: 5)
                                
                                // Sparkle effects
                                ForEach(0..<8) { i in
                                    let angle = Double(i) * .pi / 4
                                    let distance: CGFloat = 60
                                    
                                    Image(systemName: "sparkle")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .offset(
                                            x: cos(angle) * distance,
                                            y: sin(angle) * distance
                                        )
                                        .opacity(isAnimating ? 1 : 0)
                                        .scaleEffect(isAnimating ? 1 : 0)
                                        .animation(
                                            Animation.easeOut(duration: 0.8)
                                                .delay(0.4 + Double(i) * 0.05),
                                            value: isAnimating
                                        )
                                }
                                
                                // Premium icon
                                Image(systemName: "star.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            }
                            .opacity(isAnimating ? 1 : 0)
                            .scaleEffect(isAnimating ? 1 : 0.5)
                            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3), value: isAnimating)
                        }
                        .frame(height: 150)
                        
                        // Personalized message
                        if showPersonalizedOffer {
                            Text(personalizedMessage)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                                .padding(.top, 10)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }
                    }
                    
                    // Plan selection cards
                    VStack(spacing: 16) {
                        Text("Choose Your Plan")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.easeOut(duration: 0.5).delay(0.5), value: isAnimating)
                        
                        // Plan options
                        ForEach(plans) { plan in
                            PlanCard(
                                plan: plan,
                                isSelected: selectedPlanIndex == plan.id,
                                action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedPlanIndex = plan.id
                                    }
                                    HapticManager.shared.impactFeedback(style: .light)
                                }
                            )
                            .opacity(isAnimating ? 1 : 0)
                            .offset(y: isAnimating ? 0 : 20)
                            .animation(
                                .easeOut(duration: 0.5)
                                    .delay(0.6 + Double(plan.id) * 0.1),
                                value: isAnimating
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Features section
                    if showFeatures {
                        VStack(spacing: 16) {
                            Text("Premium Features")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.top, 10)
                            
                            // Feature list
                            VStack(spacing: 12) {
                                ForEach(features) { feature in
                                    FeatureCard(
                                        feature: feature,
                                        isExpanded: expandedFeature == feature.id,
                                        onTap: {
                                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                                if expandedFeature == feature.id {
                                                    expandedFeature = nil
                                                } else {
                                                    expandedFeature = feature.id
                                                }
                                            }
                                            HapticManager.shared.impactFeedback(style: .light)
                                        }
                                    )
                                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                                    .animation(
                                        .easeOut(duration: 0.4)
                                            .delay(Double(feature.id) * 0.1),
                                        value: showFeatures
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                    
                    // Money-back guarantee
                    VStack {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.shield.fill")
                                .foregroundColor(BFColors.accent)
                                .font(.system(size: 18))
                            
                            Text("7-Day Money-Back Guarantee")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 20)
                        .background(Color.white.opacity(0.07))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(1.0), value: isAnimating)
                    
                    // Action buttons
                    VStack(spacing: 15) {
                        // Subscribe button
                        Button(action: {
                            // Process subscription with paywallManager
                            let selectedPlan = plans[selectedPlanIndex]
                            HapticManager.shared.notificationFeedback(type: .success)
                            
                            paywallManager.purchaseSubscription(planId: selectedPlan.planId) { success in
                                if success {
                                    viewModel.isProUser = true
                                    viewModel.completeOnboarding {}
                                } else {
                                    // In a real app, you would show an error message here
                                    print("Purchase failed")
                                }
                            }
                        }) {
                            Text("Subscribe Now")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
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
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(1.1), value: isAnimating)
                        
                        // Skip for now (continue with limited version)
                        Button(action: {
                            // Skip subscription
                            HapticManager.shared.impactFeedback(style: .medium)
                            withAnimation {
                                viewModel.skipSubscription()
                            }
                        }) {
                            Text("Continue with Limited Version")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.vertical, 10)
                        }
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(1.2), value: isAnimating)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                    
                    // Terms and privacy
                    Text("By subscribing, you agree to our Terms of Service and Privacy Policy. Subscription automatically renews unless auto-renew is turned off.")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(1.3), value: isAnimating)
                }
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    // Helper methods
    private func startAnimations() {
        // Start entrance animations
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                isAnimating = true
            }
            
            // Show features after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    showFeatures = true
                }
                
                // Show personalized offer
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        showPersonalizedOffer = true
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Views and Models

/**
 * PlanOption 
 * Data structure for subscription plan options displayed in the paywall.
 * Contains pricing information, savings details, and selection state.
 */
struct PlanOption: Identifiable {
    let id: Int
    let name: String
    let price: String
    let period: String
    let billingText: String
    let savings: String
    let popularTag: Bool
    let planId: String
}

/**
 * FeatureItem
 * Data structure for premium features displayed in the features section.
 * Includes visual and descriptive elements for each premium capability.
 */
struct FeatureItem: Identifiable {
    let id: Int
    let icon: String
    let title: String
    let description: String
    let colorAccent: Color
}

/**
 * PlanCard
 * A visually distinct subscription plan option card with prominent selection indicators.
 * Features checkmark icon, gradient background, and scale effects to make selection state unmistakable.
 * Provides strong visual feedback through color, opacity, and shadow changes when a plan is selected.
 */
struct PlanCard: View {
    let plan: PlanOption
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                // Completely redesigned selection indicator
                ZStack {
                    Circle()
                        .fill(isSelected ? BFColors.accent : Color.white.opacity(0.05))
                        .frame(width: 32, height: 32)
                        .shadow(color: isSelected ? BFColors.accent.opacity(0.6) : Color.clear, radius: 6)
                    
                    if isSelected {
                        // Checkmark icon for selected plans
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                // Plan details
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(plan.name)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(isSelected ? .white : .white.opacity(0.8))
                        
                        if plan.popularTag {
                            Text("POPULAR")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(BFColors.accent)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(BFColors.accent.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(plan.billingText)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(isSelected ? .white.opacity(0.9) : .white.opacity(0.6))
                }
                
                Spacer()
                
                // Price
                VStack(alignment: .trailing, spacing: 2) {
                    Text(plan.price)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(isSelected ? .white : .white.opacity(0.8))
                    
                    Text("per \(plan.period)")
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(isSelected ? .white.opacity(0.9) : .white.opacity(0.6))
                    
                    if !plan.savings.isEmpty {
                        Text(plan.savings)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(BFColors.accent)
                            .padding(.top, 2)
                    }
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? 
                          LinearGradient(
                            gradient: Gradient(colors: [BFColors.accent.opacity(0.3), Color.white.opacity(0.12)]),
                            startPoint: .leading,
                            endPoint: .trailing
                          ) : 
                          LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.05), Color.white.opacity(0.05)]),
                            startPoint: .leading,
                            endPoint: .trailing
                          ))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? BFColors.accent : Color.white.opacity(0.08), lineWidth: isSelected ? 2 : 1)
                    )
                    .shadow(color: isSelected ? BFColors.accent.opacity(0.4) : Color.clear, radius: 8, x: 0, y: 2)
            )
            .scaleEffect(isSelected ? 1.03 : (isPressed ? 0.98 : 1.0))
            .opacity(isSelected ? 1 : 0.8)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

struct FeatureCard: View {
    let feature: FeatureItem
    let isExpanded: Bool
    let onTap: () -> Void
    
    // Animation states
    @State private var iconRotation = 0.0
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                // Feature header (always visible)
                HStack(spacing: 15) {
                    // Icon with colored background
                    ZStack {
                        Circle()
                            .fill(feature.colorAccent.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: feature.icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(feature.colorAccent)
                            .rotationEffect(.degrees(iconRotation))
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                                    iconRotation = isExpanded ? 20 : 10
                                }
                            }
                            .onChange(of: isExpanded) { oldValue, newValue in
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                    iconRotation = newValue ? 20 : 10
                                }
                            }
                    }
                    
                    Text(feature.title)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Expansion indicator
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isExpanded)
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                
                // Expanded description
                if isExpanded {
                    Text(feature.description)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(isExpanded ? 0.1 : 0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(feature.colorAccent.opacity(isExpanded ? 0.3 : 0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
struct EnhancedPaywallScreen_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = EnhancedOnboardingViewModel()
        viewModel.userName = "Alex"
        viewModel.dailyMindfulnessGoal = 8
        
        return EnhancedPaywallScreen(viewModel: viewModel)
            .preferredColorScheme(.dark)
    }
} 