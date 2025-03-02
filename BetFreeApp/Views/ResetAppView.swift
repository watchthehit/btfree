import SwiftUI

/**
 * ResetAppView
 * A utility view that allows developers to reset app state for testing
 * Can be accessed from the Brand Assets demo tab
 */
struct ResetAppView: View {
    @AppStorage("hasShownSplash") private var hasShownSplash = true
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    @State private var showSplashConfirmation = false
    @State private var showOnboardingConfirmation = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Developer Tools")
                .font(.system(size: 24, weight: .bold))
            
            Divider()
            
            // Splash Screen Reset
            VStack(alignment: .leading, spacing: 10) {
                Text("Splash Screen Testing")
                    .font(.headline)
                
                Text("Current state: \(hasShownSplash ? "Splash has been shown" : "Splash will show on next launch")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                BFButton(
                    title: "Reset Splash Screen",
                    style: .secondary,
                    icon: "arrow.clockwise.circle",
                    action: {
                        showSplashConfirmation = true
                    },
                    isFullWidth: true
                )
                .alert(isPresented: $showSplashConfirmation) {
                    Alert(
                        title: Text("Reset Splash Screen"),
                        message: Text("This will show the splash screen again the next time you launch the app. Continue?"),
                        primaryButton: .destructive(Text("Reset")) {
                            hasShownSplash = false
                            UserDefaults.standard.set(false, forKey: "hasShownSplash")
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
            
            // Onboarding Reset
            VStack(alignment: .leading, spacing: 10) {
                Text("Onboarding Testing")
                    .font(.headline)
                
                Text("Current state: \(hasCompletedOnboarding ? "Onboarding has been completed" : "Onboarding will show on next launch")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                BFButton(
                    title: "Reset Onboarding",
                    style: .secondary,
                    icon: "arrow.clockwise.circle",
                    action: {
                        showOnboardingConfirmation = true
                    },
                    isFullWidth: true
                )
                .alert(isPresented: $showOnboardingConfirmation) {
                    Alert(
                        title: Text("Reset Onboarding"),
                        message: Text("This will show the onboarding screens again the next time you launch the app. Continue?"),
                        primaryButton: .destructive(Text("Reset")) {
                            hasCompletedOnboarding = false
                            UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
            
            // Reset Both Button
            BFButton(
                title: "Reset Both (Full App Restart)",
                style: .primary,
                icon: "arrow.triangle.2.circlepath",
                action: {
                    hasShownSplash = false
                    hasCompletedOnboarding = false
                    UserDefaults.standard.set(false, forKey: "hasShownSplash")
                    UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
                },
                isFullWidth: true
            )
            
            Text("Note: After resetting, you'll need to fully restart the app to see the changes")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Developer Tools")
    }
}

struct ResetAppView_Previews: PreviewProvider {
    static var previews: some View {
        ResetAppView()
    }
} 