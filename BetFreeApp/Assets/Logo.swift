import SwiftUI

/**
 * BetFree Logo - Text-based logo implementation in SwiftUI
 * 
 * This file provides reusable components for displaying the BetFree brand logo
 * in different configurations throughout the app.
 */
struct BetFreeLogo: View {
    enum Style {
        case full       // Text logo in circular container
        case compact    // Text only version
        case horizontal // Text logo with optional text to the right
    }
    
    var style: Style = .full
    var size: CGFloat = 100
    
    var body: some View {
        switch style {
        case .full:
            VStack(spacing: size * 0.15) {
                textLogo
                appName
            }
        case .compact:
            textLogo
        case .horizontal:
            HStack(spacing: size * 0.15) {
                textLogo
                    .frame(width: size)
                appName
            }
        }
    }
    
    // The main text-based logo in a circular container
    private var textLogo: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(Color(hex: "#0D1B2A"))
                .frame(width: size, height: size)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            
            // Partial circular accent
            Circle()
                .trim(from: 0.55, to: 0.85)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#64FFDA"),
                            Color(hex: "#00B4D8")
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: size * 0.08, lineCap: .round)
                )
                .frame(width: size * 0.85, height: size * 0.85)
                .rotationEffect(Angle(degrees: 45))
            
            // Text logo
            VStack(spacing: -size * 0.07) {
                // "Bet" with strikethrough
                Text("Bet")
                    .font(.system(size: size * 0.24, weight: .bold))
                    .foregroundColor(.white)
                    .overlay(
                        Rectangle()
                            .frame(height: size * 0.05)
                            .offset(y: size * 0.0)
                            .foregroundColor(.white)
                    )
                
                // "Free" in teal
                Text("Free")
                    .font(.system(size: size * 0.27, weight: .heavy))
                    .foregroundColor(Color(hex: "#64FFDA"))
            }
        }
        .frame(width: size, height: size)
    }
    
    // Text component of the logo for full and horizontal styles
    private var appName: some View {
        Text("BetFree")
            .font(.system(size: min(size * 0.3, 34), weight: .bold, design: .default))
            .foregroundColor(colorScheme == .dark ? .white : Color(hex: "#0D1B2A"))
    }
    
    @Environment(\.colorScheme) private var colorScheme
}

// App icon version with slightly different proportions for iOS icon grid
struct BetFreeAppIcon: View {
    var size: CGFloat = 1024 // Standard size for App Store
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "#0D1B2A")
            
            // Partial circular accent
            Circle()
                .trim(from: 0.55, to: 0.85)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#64FFDA"),
                            Color(hex: "#00B4D8")
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: size * 0.08, lineCap: .round)
                )
                .frame(width: size * 0.6, height: size * 0.6)
                .rotationEffect(Angle(degrees: 45))
            
            // Text logo
            VStack(spacing: -size * 0.05) {
                // "Bet" with strikethrough
                Text("Bet")
                    .font(.system(size: size * 0.2, weight: .bold))
                    .foregroundColor(.white)
                    .overlay(
                        Rectangle()
                            .frame(height: size * 0.04)
                            .offset(y: size * 0.0)
                            .foregroundColor(.white)
                    )
                
                // "Free" in teal
                Text("Free")
                    .font(.system(size: size * 0.22, weight: .heavy))
                    .foregroundColor(Color(hex: "#64FFDA"))
            }
        }
        .frame(width: size, height: size)
        .cornerRadius(size * 0.2235) // iOS rounded corner standard
    }
}

// Preview provider for development
struct BetFreeLogo_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            BetFreeLogo(style: .full, size: 100)
            BetFreeLogo(style: .compact, size: 60)
            BetFreeLogo(style: .horizontal, size: 50)
            
            BetFreeAppIcon(size: 200)
                .frame(width: 200, height: 200)
                .cornerRadius(40)
        }
        .padding()
        .background(Color(hex: "#E0E1DD"))
        .previewDisplayName("Light Mode")
        .preferredColorScheme(.light)
        
        VStack(spacing: 40) {
            BetFreeLogo(style: .full, size: 100)
            BetFreeLogo(style: .compact, size: 60)
            BetFreeLogo(style: .horizontal, size: 50)
            
            BetFreeAppIcon(size: 200)
                .frame(width: 200, height: 200)
                .cornerRadius(40)
        }
        .padding()
        .background(Color(hex: "#0D1B2A"))
        .previewDisplayName("Dark Mode")
        .preferredColorScheme(.dark)
    }
} 