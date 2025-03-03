import SwiftUI

// MARK: - Free Trial Teaser Screen
struct FreeTrialTeaserScreen: View {
    @EnvironmentObject private var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            // Premium badge with shine effect
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.7)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .shadow(color: BFColors.accent.opacity(0.3), radius: 10, x: 0, y: 5)
                
                Image(systemName: "crown.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                
                // Shine effect
                Circle()
                    .trim(from: 0, to: 0.2)
                    .stroke(Color.white.opacity(0.8), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .frame(width: 90, height: 90)
                    .rotationEffect(.degrees(-45))
            }
            .padding(.top, 20)
            
            Text("Unlock Premium Features")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("Continue to set up your personal recovery journey and unlock a 7-day free trial of BetFree Pro.")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Feature preview
            VStack(spacing: 20) {
                premiumFeatureRowWithCircle(icon: "chart.bar.fill", title: "Advanced Analytics")
                premiumFeatureRowWithCircle(icon: "brain", title: "All Mindfulness Exercises")
                premiumFeatureRowWithCircle(icon: "bell", title: "Smart Notifications")
            }
            .padding(.vertical, 10)
            
            Text("You'll have full access during your trial with no obligation to continue.")
                .font(.system(size: 14))
                .foregroundColor(Color.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                // Use the standard navigation pattern from viewModel
                viewModel.nextScreen()
            }) {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(BFColors.accent)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(BFColors.primary)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
        )
        .padding(.horizontal)
    }
    
    private func premiumFeatureRowWithCircle(icon: String, title: String) -> some View {
        HStack(spacing: 15) {
            // Icon with circular background
            ZStack {
                Circle()
                    .fill(Color(red: 1.0, green: 0.9, blue: 0.85))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .foregroundColor(BFColors.accent)
                    .font(.system(size: 20))
            }
            
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
            
            // Bright green checkmark
            ZStack {
                Circle()
                    .fill(Color(red: 0.2, green: 0.85, blue: 0.4))
                    .frame(width: 26, height: 26)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Soft Gate Screen (After Features Overview)
struct SoftGateScreen: View {
    @EnvironmentObject private var viewModel: OnboardingViewModel
    @State private var selectedPlan = 1 // Default to annual plan
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    Text("Enhance Your Recovery Journey")
                        .heading2()
                        .multilineTextAlignment(.center)
                    
                    Text("Choose the plan that works best for you")
                        .bodyMedium()
                        .foregroundColor(BFColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                // Plan selection cards
                VStack(spacing: 16) {
                    BFPlanSelectionCard(
                        title: "Monthly",
                        price: "$9.99",
                        billingPeriod: "/month",
                        isPopular: false,
                        savings: nil,
                        selectedPlan: $selectedPlan,
                        planIndex: 0
                    )
                    
                    BFPlanSelectionCard(
                        title: "Annual",
                        price: "$79.99",
                        billingPeriod: "/year",
                        isPopular: true,
                        savings: "Save 33% ($39.89)",
                        selectedPlan: $selectedPlan,
                        planIndex: 1
                    )
                    
                    BFPlanSelectionCard(
                        title: "Lifetime",
                        price: "$199.99",
                        billingPeriod: "one-time",
                        isPopular: false,
                        savings: "Best long-term value",
                        selectedPlan: $selectedPlan,
                        planIndex: 2
                    )
                }
                .padding(.horizontal)
                
                // Free trial emphasis
                VStack(spacing: 8) {
                    Text("7-Day Free Trial")
                        .heading3()
                        .foregroundColor(BFColors.accent)
                    
                    Text("Try all premium features free for 7 days")
                        .bodyMedium()
                        .foregroundColor(BFColors.textSecondary)
                    
                    Text("Cancel anytime before your trial ends and you won't be charged")
                        .font(BFTypography.caption)
                        .foregroundColor(BFColors.textSecondary)
                        .padding(.top, 2)
                }
                .padding(.vertical, 10)
                
                // Feature comparison
                VStack(alignment: .leading, spacing: 20) {
                    // Basic features
                    BFFeatureListSection(
                        title: "Free Features",
                        features: [
                            ("Basic progress tracking", false, true),
                            ("Limited mindfulness exercises", false, true),
                            ("Daily check-ins", false, true),
                            ("Basic trigger tracking (5 max)", false, true)
                        ]
                    )
                    
                    // Premium features
                    BFFeatureListSection(
                        title: "Premium Features",
                        features: [
                            ("Advanced analytics and insights", true, true),
                            ("Complete mindfulness library", true, true),
                            ("Personalized recommendations", true, true),
                            ("Unlimited trigger tracking", true, true),
                            ("Advanced notification settings", true, true),
                            ("Data export and portability", true, true)
                        ]
                    )
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        // Start free trial and continue
                        viewModel.isTrialActive = true
                        viewModel.nextScreen()
                    }) {
                        HStack {
                            Text("Start Free Trial")
                            Image(systemName: "chevron.right")
                        }
                    }
                    .bfPrimaryButton(isWide: true)
                    
                    Button(action: {
                        // Skip subscription and continue to next step
                        viewModel.isTrialActive = false
                        viewModel.nextScreen()
                    }) {
                        Text("Continue with Basic Version")
                    }
                    .bfTextButton()
                }
                .padding()
                
                // Legal text
                Text("Payment will be charged to your Apple ID account at the confirmation of purchase. Subscription automatically renews unless it is canceled at least 24 hours before the end of the current period. Your account will be charged for renewal within 24 hours prior to the end of the current period. You can manage and cancel your subscriptions by going to your account settings on the App Store after purchase.")
                    .font(.system(size: 10))
                    .foregroundColor(BFColors.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        }
        .background(BFColors.secondaryBackground)
    }
}

// MARK: - Hard Paywall Screen (For after trial expiration)
struct HardPaywallScreen: View {
    @Binding var isPresented: Bool
    @State private var selectedPlan = 1 // Default to annual
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Close button
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(BFColors.textSecondary)
                    }
                    .padding([.top, .trailing], 16)
                }
                
                // Header
                VStack(spacing: 12) {
                    Text("Your Free Trial Has Ended")
                        .heading1()
                        .multilineTextAlignment(.center)
                    
                    Text("Upgrade to continue your progress with full access to premium features")
                        .bodyMedium()
                        .foregroundColor(BFColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // Progress loss warning
                HStack(spacing: 15) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(BFColors.warning)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Your progress is at risk")
                            .font(BFTypography.bodyMedium)
                            .fontWeight(.semibold)
                        
                        Text("You'll lose access to your detailed analytics and advanced features")
                            .font(BFTypography.bodySmall)
                            .foregroundColor(BFColors.textSecondary)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(BFColors.warning.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(BFColors.warning.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal)
                
                // Plan selection
                VStack(spacing: 16) {
                    BFPlanSelectionCard(
                        title: "Monthly",
                        price: "$9.99",
                        billingPeriod: "/month",
                        isPopular: false,
                        savings: nil,
                        selectedPlan: $selectedPlan,
                        planIndex: 0
                    )
                    
                    BFPlanSelectionCard(
                        title: "Annual",
                        price: "$79.99",
                        billingPeriod: "/year",
                        isPopular: true,
                        savings: "Save 33% ($39.89)",
                        selectedPlan: $selectedPlan,
                        planIndex: 1
                    )
                    
                    BFPlanSelectionCard(
                        title: "Lifetime",
                        price: "$199.99",
                        billingPeriod: "one-time",
                        isPopular: false,
                        savings: "Best long-term value",
                        selectedPlan: $selectedPlan,
                        planIndex: 2
                    )
                }
                .padding(.horizontal)
                
                // Testimonials
                VStack(spacing: 12) {
                    Text("What Our Users Say")
                        .heading3()
                        .padding(.bottom, 5)
                    
                    testimonialView(text: "BetFree Pro helped me stay accountable and finally break free from my gambling habit. Worth every penny!", author: "Michael T.")
                    
                    testimonialView(text: "The premium exercises made all the difference in my recovery journey.", author: "Sarah L.")
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                // CTA button
                Button(action: {
                    // Subscribe flow would go here
                    isPresented = false
                }) {
                    Text("Upgrade Now")
                }
                .bfPrimaryButton(isWide: true, size: .large)
                .padding(.horizontal)
                
                // Continue with basic
                Button(action: {
                    isPresented = false
                }) {
                    Text("Continue with Basic Version")
                }
                .bfTextButton()
                .padding(.vertical, 5)
                
                // Legal text
                Text("Payment will be charged to your Apple ID account at the confirmation of purchase. Subscription automatically renews unless it is canceled at least 24 hours before the end of the current period. Your account will be charged for renewal within 24 hours prior to the end of the current period.")
                    .font(.system(size: 10))
                    .foregroundColor(BFColors.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        }
        .background(BFColors.secondaryBackground)
    }
    
    private func testimonialView(text: String, author: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\"" + text + "\"")
                .font(BFTypography.bodyMedium)
                .italic()
                .foregroundColor(BFColors.textPrimary)
            
            HStack {
                // Stars
                HStack(spacing: 2) {
                    ForEach(0..<5) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(BFColors.accent)
                            .font(.system(size: 12))
                    }
                }
                
                Spacer()
                
                // Author
                Text("— " + author)
                    .font(BFTypography.caption)
                    .foregroundColor(BFColors.textSecondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

// MARK: - Enhanced Paywall Screen
struct EnhancedPaywallScreen: View {
    @EnvironmentObject private var viewModel: OnboardingViewModel
    @EnvironmentObject private var paywallManager: PaywallManager
    @State private var selectedPlan = 1 // Default to annual
    @State private var animateGradient = false
    @State private var showPromo = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Premium crown logo with animated glow
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [BFColors.accent, BFColors.accent]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .shadow(color: BFColors.accent.opacity(0.5), radius: 15, x: 0, y: 5)
                    
                    // Pulsing animation
                    Circle()
                        .stroke(BFColors.accent.opacity(0.5), lineWidth: 8)
                        .frame(width: 120, height: 120)
                        .scaleEffect(animateGradient ? 1.1 : 0.9)
                        .opacity(animateGradient ? 0.2 : 0.6)
                        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateGradient)
                    
                    Image(systemName: "crown.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .shadow(color: .white.opacity(0.5), radius: 5, x: 0, y: 0)
                    
                    // Shine effect
                    Circle()
                        .trim(from: 0, to: 0.2)
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                        .frame(width: 90, height: 90)
                        .rotationEffect(.degrees(-45))
                        .rotationEffect(Angle(degrees: animateGradient ? 360 : 0))
                        .animation(Animation.linear(duration: 8).repeatForever(autoreverses: false), value: animateGradient)
                }
                .padding(.top, 30)
                .onAppear {
                    // Record that user has seen the hard paywall
                    paywallManager.recordHardPaywallSeen()
                    
                    animateGradient = true
                    
                    // Show special promo after a delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.easeIn(duration: 0.5)) {
                            showPromo = true
                        }
                    }
                }
                
                // Title and subtitle
                VStack(spacing: 12) {
                    Text("Unlock Your Full Potential")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .accessibilityAddTraits(.isHeader)
                    
                    ZStack {
                        // Semi-transparent background for better contrast
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.3))
                            .frame(height: 28)
                            .padding(.horizontal, -8)
                        
                        Text("Join thousands who have transformed their lives with BetFree Pro")
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                }
                
                // Limited time offer
                if showPromo {
                    VStack {
                        Text("🔥 SPECIAL OFFER 🔥")
                            .font(.system(size: 14, weight: .heavy))
                            .foregroundColor(BFColors.accent)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 12)
                            .background(
                                Capsule()
                                    .fill(BFColors.accent.opacity(0.15))
                            )
                        
                        Text("Get 7 days FREE, then 50% off your first month")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.top, 5)
                    }
                    .padding(.vertical, 10)
                    .transition(.scale.combined(with: .opacity))
                }
                
                // Plan selection
                VStack(spacing: 18) {
                    Text("Choose Your Plan")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // Plan selection cards
                    subscriptionOption(
                        title: "Monthly",
                        price: "$9.99",
                        period: "per month",
                        benefits: ["Billed monthly", "Cancel anytime"],
                        isPopular: false,
                        index: 0
                    )
                    
                    subscriptionOption(
                        title: "Annual",
                        price: "$79.99",
                        period: "per year",
                        benefits: ["Save 33% ($39.89)", "Best value"],
                        isPopular: true,
                        index: 1
                    )
                    
                    subscriptionOption(
                        title: "Lifetime",
                        price: "$199.99",
                        period: "one-time payment",
                        benefits: ["Pay once, own forever", "No recurring charges"],
                        isPopular: false,
                        index: 2
                    )
                }
                .padding(.vertical, 10)
                
                // Premium features
                VStack(spacing: 5) {
                    Text("Everything You Get:")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        premiumFeatureRow(
                            icon: "chart.bar.fill",
                            title: "Advanced Analytics",
                            description: "Gain deeper insights into your recovery journey"
                        )
                        
                        premiumFeatureRow(
                            icon: "brain.head.profile",
                            title: "Complete Mindfulness Library",
                            description: "Access all 50+ specialized exercises"
                        )
                        
                        premiumFeatureRow(
                            icon: "bell.badge.fill",
                            title: "Intelligent Notifications",
                            description: "Personalized alerts when you need support most"
                        )
                        
                        premiumFeatureRow(
                            icon: "person.fill.checkmark",
                            title: "Unlimited Progress Tracking",
                            description: "No limits on data or history"
                        )
                    }
                    .padding(.top, 8)
                }
                .padding(.vertical, 15)
                
                // Testimonial
                VStack(spacing: 15) {
                    HStack {
                        ForEach(0..<5) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(BFColors.accent)
                        }
                    }
                    
                    Text("\"BetFree Pro changed my life. I've been gambling-free for 9 months now - the longest I've ever gone. The personalized insights and mindfulness tools made all the difference.\"")
                        .font(.system(size: 16, weight: .regular))
                        .italic()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("— Michael T., Member since 2022")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.white.opacity(0.7))
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.05))
                )
                .padding(.horizontal)
                
                // CTA Button
                Button(action: {
                    // Start subscription
                    viewModel.isTrialActive = true
                    viewModel.nextScreen()
                }) {
                    HStack {
                        Text("Start My 7-Day Free Trial")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(color: BFColors.accent.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal)
                
                // Secondary CTA - Changed to 'Limited Trial' instead of skipping
                Button(action: {
                    // Offer a limited experience but still activate a trial
                    viewModel.isTrialActive = true // Still activate trial but with limited features
                    // Add a user default to indicate limited trial mode
                    UserDefaults.standard.set(true, forKey: "limitedTrialMode")
                    viewModel.nextScreen()
                }) {
                    HStack {
                        Image(systemName: "hourglass")
                            .font(.system(size: 14))
                        Text("Try Limited Features")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(Color.white.opacity(0.9))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                    )
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Terms and privacy links
                HStack(spacing: 8) {
                    Link("Terms of Service", destination: URL(string: "https://betfree.com/terms")!)
                    Text("•")
                    Link("Privacy Policy", destination: URL(string: "https://betfree.com/privacy")!)
                }
                .font(.system(size: 12))
                .foregroundColor(Color.white.opacity(0.7))
                .padding(.top, 12)
                .padding(.bottom, 15)
                
                // Legal text
                Text("Payment will be charged to your Apple ID account at the confirmation of purchase. Subscription automatically renews unless it is canceled at least 24 hours before the end of the current period. Your account will be charged for renewal within 24 hours prior to the end of the current period. You can manage and cancel your subscriptions by going to your account settings on the App Store after purchase.")
                    .font(.system(size: 10))
                    .foregroundColor(Color.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(BFColors.primary)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
        )
        .padding(.horizontal)
    }
    
    // Subscription option card
    private func subscriptionOption(title: String, price: String, period: String, benefits: [String], isPopular: Bool, index: Int) -> some View {
        VStack(spacing: 0) {
            // Popular tag if applicable
            if isPopular {
                Text("MOST POPULAR")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 12)
                    .background(BFColors.accent)
                    .cornerRadius(12)
                    .offset(y: -12)
                    .zIndex(1)
            }
            
            // Card content
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    // Title
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Selection circle
                    ZStack {
                        Circle()
                            .strokeBorder(selectedPlan == index ? BFColors.accent : Color.white.opacity(0.4), lineWidth: 2)
                            .frame(width: 24, height: 24)
                        
                        if selectedPlan == index {
                            Circle()
                                .fill(BFColors.accent)
                                .frame(width: 16, height: 16)
                        }
                    }
                }
                
                // Price
                HStack(alignment: .firstTextBaseline) {
                    Text(price)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(period)
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.7))
                        .padding(.leading, 2)
                }
                
                // Benefits
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(benefits, id: \.self) { benefit in
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(BFColors.accent)
                            
                            Text(benefit)
                                .font(.system(size: 14))
                                .foregroundColor(Color.white.opacity(0.9))
                        }
                    }
                }
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(selectedPlan == index ? BFColors.accent.opacity(0.15) : Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(
                                selectedPlan == index ? BFColors.accent : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
        }
        .padding(.horizontal)
        .onTapGesture {
            withAnimation(.spring()) {
                selectedPlan = index
            }
        }
    }
    
    // Premium feature row
    private func premiumFeatureRow(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 16) {
            // Icon with circular background
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(BFColors.accent)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(Color.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
} 