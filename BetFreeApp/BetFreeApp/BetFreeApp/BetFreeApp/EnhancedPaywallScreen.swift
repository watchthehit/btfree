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
    @State private var isModal = false
    @Environment(\.presentationMode) private var presentationMode
    
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
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#0A1528"),
                    Color(hex: "#152A4F")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Main content
            BFScrollView(
                showsIndicators: true,
                bottomSpacing: 50,
                heightMultiplier: 1.1
            ) {
                VStack(spacing: 20) {
                    // App logo and name
                    VStack(spacing: 10) {
                        Image(systemName: "checkmark.seal.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(BFColorSystem.accent)
                        
                        Text("BetFree Premium")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 30)
                    
                    // Features list
                    featuresSection
                    
                    // Subscription options
                    subscriptionOptionsSection
                    
                    // Legal text
                    legalSection
                }
                .padding(.horizontal)
            }
            
            // Close button
            if isModal {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white.opacity(0.7))
                                .padding(16)
                        }
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    isAnimating = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation {
                    showFeatures = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    showPersonalizedOffer = true
                }
            }
        }
    }
    
    // MARK: - UI Components
    
    private var featuresSection: some View {
        VStack(spacing: 16) {
            // Feature list
            ForEach(features) { feature in
                featureRow(feature)
            }
        }
        .padding(.top, 10)
        .opacity(showFeatures ? 1 : 0)
        .animation(.easeOut(duration: 0.6).delay(0.2), value: showFeatures)
    }
    
    private func featureRow(_ feature: FeatureItem) -> some View {
        let isExpanded = expandedFeature == feature.id
        
        return HStack(spacing: 12) {
            Image(systemName: feature.icon)
                .foregroundColor(BFColorSystem.accent)
                .font(.system(size: 18))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(feature.title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                if isExpanded {
                    Text(feature.description)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                        .fixedSize(horizontal: false, vertical: true)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            
            Spacer()
            
            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                .foregroundColor(.white.opacity(0.6))
                .font(.system(size: 14, weight: .medium))
                .padding(8)
                .background(Color.white.opacity(0.1))
                .clipShape(Circle())
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .onTapGesture {
            withAnimation(.spring()) {
                expandedFeature = isExpanded ? nil : feature.id
            }
        }
    }
    
    private var subscriptionOptionsSection: some View {
        VStack(spacing: 16) {
            Text("Choose Your Plan")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.top, 10)
            
            // Plan options
            ForEach(plans) { plan in
                planOptionView(plan)
            }
        }
        .padding(.top, 10)
    }
    
    @ViewBuilder
    private func planOptionView(_ plan: PlanOption) -> some View {
        let isSelected = selectedPlanIndex == plan.id
        
        PlanCard(
            plan: plan,
            isSelected: isSelected,
            action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedPlanIndex = plan.id
                    HapticManager.shared.playLightFeedback()
                }
            }
        )
    }
    
    private var legalSection: some View {
        VStack(spacing: 10) {
            Button {
                // Open privacy policy
                if let url = URL(string: "https://betfreeapp.com/privacy") {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("Privacy Policy")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Button {
                // Open terms of service
                if let url = URL(string: "https://betfreeapp.com/terms") {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("Terms of Service")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(.top, 10)
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
                        .fill(isSelected ? BFColorSystem.accent : Color.white.opacity(0.05))
                        .frame(width: 32, height: 32)
                        .shadow(color: isSelected ? BFColorSystem.accent.opacity(0.6) : Color.clear, radius: 6)
                    
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
                                .foregroundColor(BFColorSystem.accent)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(BFColorSystem.accent.opacity(0.2))
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
                            .foregroundColor(BFColorSystem.accent)
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
                            gradient: Gradient(colors: [BFColorSystem.accent.opacity(0.3), Color.white.opacity(0.12)]),
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
                            .stroke(isSelected ? BFColorSystem.accent : Color.white.opacity(0.08), lineWidth: isSelected ? 2 : 1)
                    )
                    .shadow(color: isSelected ? BFColorSystem.accent.opacity(0.4) : Color.clear, radius: 8, x: 0, y: 2)
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