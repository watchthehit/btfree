import SwiftUI

// MARK: - Free Trial Teaser Screen
struct FreeTrialTeaserScreen: View {
    @EnvironmentObject private var viewModel: OnboardingViewModel
    
    var body: some View {
        BFCard {
            VStack(spacing: 25) {
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
                    .heading2()
                    .multilineTextAlignment(.center)
                
                Text("Continue to set up your personal recovery journey and unlock a 7-day free trial of BetFree Pro.")
                    .bodyMedium()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Feature preview
                VStack(spacing: 12) {
                    premiumFeatureRow(icon: "chart.bar.fill", title: "Advanced Analytics")
                    premiumFeatureRow(icon: "brain.head.profile", title: "All Mindfulness Exercises")
                    premiumFeatureRow(icon: "bell.badge.fill", title: "Smart Notifications")
                }
                .padding(.vertical, 10)
                
                Text("You'll have full access during your trial with no obligation to continue.")
                    .font(BFTypography.caption)
                    .foregroundColor(BFColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
            }
        }
        .padding(.vertical)
    }
    
    private func premiumFeatureRow(icon: String, title: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(BFColors.accent)
                .font(.system(size: 18))
                .frame(width: 24)
            
            Text(title)
                .font(BFTypography.bodyMedium)
                .foregroundColor(BFColors.textPrimary)
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(BFColors.success)
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