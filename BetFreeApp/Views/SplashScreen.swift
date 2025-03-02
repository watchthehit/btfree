import SwiftUI

/**
 * SplashScreen
 * The initial screen users see when launching the app, featuring
 * the BetFree logo with an animated entrance.
 */
struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var textOpacity = 0.0
    
    var body: some View {
        ZStack {
            // Background gradient using Serene Strength colors
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#0D1B2A"),
                    Color(hex: "#1B263B")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Logo with animation
                BetFreeLogo(style: .compact, size: 120)
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
                    .opacity(isAnimating ? 1.0 : 0.0)
                
                // Tagline with fade-in animation
                Text("Break free. Live better.")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .opacity(textOpacity)
            }
        }
        .onAppear {
            // Start animations in sequence
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
                isAnimating = true
            }
            
            // Delay the text appearance
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeIn(duration: 0.6)) {
                    textOpacity = 1.0
                }
            }
        }
    }
}

/**
 * SplashScreenController
 * Manages the display of the splash screen and transition to the main app
 */
struct SplashScreenController: View {
    @State private var isActive = false
    @State private var animationComplete = false
    
    var body: some View {
        Group {
            if isActive {
                // Replace with your app's main content view
                Text("Main App") // This would be your app's main content
            } else {
                SplashScreen()
            }
        }
        .onAppear {
            // Simulate splash screen duration - typically 2-3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
} 