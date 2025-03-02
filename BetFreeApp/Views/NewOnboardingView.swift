import SwiftUI

/**
 * NewOnboardingView
 * A modern onboarding experience for BetFree utilizing the new design system
 */
struct NewOnboardingView: View {
    @State private var currentPage = 0
    @State private var isAnimating = false
    @State private var forceComplete = false  // New state to force completion
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    // Completion handler
    var onCompleteOnboarding: () -> Void
    
    // Initialize with a default empty completion handler
    init(onCompleteOnboarding: @escaping () -> Void = {}) {
        self.onCompleteOnboarding = onCompleteOnboarding
    }
    
    // Sample onboarding data
    private let pages = [
        OnboardingPage(
            title: "Break Free From Gambling",
            description: "Take the first step toward a healthier relationship with gambling through evidence-based tools and support.",
            illustration: AnyView(BFOnboardingIllustrations.BreakingFree(size: 200))
        ),
        OnboardingPage(
            title: "Track Your Progress",
            description: "Monitor your journey with personalized insights and celebrate your milestones along the way.",
            illustration: AnyView(BFOnboardingIllustrations.GrowthJourney(size: 200))
        ),
        OnboardingPage(
            title: "Find Your Calm",
            description: "Access mindfulness exercises and breathing techniques to help manage urges and reduce stress.",
            illustration: AnyView(BFOnboardingIllustrations.CalmMind(size: 200))
        ),
        OnboardingPage(
            title: "Connect With Support",
            description: "You're not alone. Join a community of people on similar journeys and access professional guidance.",
            illustration: AnyView(BFOnboardingIllustrations.SupportNetwork(size: 200))
        )
    ]
    
    var body: some View {
        ZStack {
            // Background
            BFColors.darkGradient()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Logo
                BetFreeLogo(style: .compact, size: 60)
                    .padding(.top, 40)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeIn(duration: 0.5).delay(0.2), value: isAnimating)
                
                // Pager
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                .transition(.slide)
                
                // Bottom controls
                VStack(spacing: 20) {
                    // Page indicators
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? BFColors.vibrantTeal : Color.white.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1)
                                .animation(.spring(), value: currentPage)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    // Navigation buttons
                    HStack {
                        // Skip button (except on last page)
                        if currentPage < pages.count - 1 {
                            BFButton(
                                title: "Skip",
                                style: .text,
                                action: {
                                    currentPage = pages.count - 1
                                }
                            )
                        } else {
                            Spacer()
                        }
                        
                        Spacer()
                        
                        // Next/Get Started button
                        BFButton(
                            title: currentPage < pages.count - 1 ? "Next" : "Get Started",
                            style: .primary,
                            icon: currentPage < pages.count - 1 ? "arrow.right" : "checkmark",
                            action: {
                                if currentPage < pages.count - 1 {
                                    withAnimation {
                                        currentPage += 1
                                    }
                                } else {
                                    // Ultra-forceful completion with multiple approaches
                                    print("FORCE COMPLETING ONBOARDING")
                                    
                                    // 1. Set local AppStorage
                                    hasCompletedOnboarding = true
                                    
                                    // 2. Write directly to UserDefaults 
                                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                                    UserDefaults.standard.synchronize()
                                    
                                    // 3. Call the completion handler
                                    onCompleteOnboarding()
                                    
                                    // 4. Set state to force UI update
                                    forceComplete = true
                                    
                                    // 5. Notify the developer what's happening
                                    print("Onboarding settings have been forcefully completed")
                                    print("UserDefaults hasCompletedOnboarding: \(UserDefaults.standard.bool(forKey: "hasCompletedOnboarding"))")
                                    print("AppStorage hasCompletedOnboarding: \(hasCompletedOnboarding)")
                                }
                            }
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 40)
                .padding(.horizontal)
                .opacity(isAnimating ? 1 : 0)
                .animation(.easeIn(duration: 0.5).delay(0.4), value: isAnimating)
            }
        }
        .onChange(of: forceComplete) { newValue in
            if newValue {
                // One more attempt - use a delayed force update
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    print("Delayed force completion")
                    hasCompletedOnboarding = true
                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                    UserDefaults.standard.synchronize()
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Onboarding Page
struct OnboardingPage {
    let title: String
    let description: String
    let illustration: AnyView
}

// MARK: - Onboarding Page View
struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var hasAppeared = false
    
    var body: some View {
        VStack(spacing: 40) {
            // Illustration
            page.illustration
                .padding(.top, 20)
                .scaleEffect(hasAppeared ? 1.0 : 0.8)
                .opacity(hasAppeared ? 1.0 : 0.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: hasAppeared)
            
            // Text content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .opacity(hasAppeared ? 1.0 : 0.0)
                    .offset(y: hasAppeared ? 0 : 20)
                    .animation(.easeOut(duration: 0.5).delay(0.2), value: hasAppeared)
                
                Text(page.description)
                    .font(.system(size: 16))
                    .foregroundColor(BFColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 24)
                    .opacity(hasAppeared ? 1.0 : 0.0)
                    .offset(y: hasAppeared ? 0 : 20)
                    .animation(.easeOut(duration: 0.5).delay(0.3), value: hasAppeared)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                hasAppeared = true
            }
        }
        .onDisappear {
            hasAppeared = false
        }
    }
}

// MARK: - Preview
struct NewOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        NewOnboardingView()
            .preferredColorScheme(.dark)
    }
} 