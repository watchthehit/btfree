import SwiftUI

/**
 * BetFree Logo - "Strength Circle" implementation in SwiftUI
 * 
 * This file provides reusable components for displaying the BetFree brand logo
 * in different configurations throughout the app.
 */
struct BetFreeLogo: View {
    enum Style {
        case full       // Circle with text below
        case compact    // Circle only
        case horizontal // Circle with text to the right
    }
    
    var style: Style = .full
    var size: CGFloat = 100
    
    var body: some View {
        switch style {
        case .full:
            VStack(spacing: size * 0.15) {
                strengthCircle
                logoText
            }
        case .compact:
            strengthCircle
        case .horizontal:
            HStack(spacing: size * 0.15) {
                strengthCircle
                    .frame(width: size)
                logoText
            }
        }
    }
    
    // The main circle with opening at the top
    private var strengthCircle: some View {
        ZStack {
            // Background circle for light mode
            Circle()
                .strokeBorder(Color(hex: "#1B263B"), lineWidth: size * 0.03)
                .frame(width: size, height: size)
                .opacity(colorScheme == .light ? 1.0 : 0.0)
            
            // Main circle with opening
            Circle()
                .trim(from: 0.1, to: 0.9) // Creates opening at the top
                .rotation(.degrees(90))  // Rotates so opening is at top
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#64FFDA"),
                            Color(hex: "#00B4D8")
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.9, height: size * 0.9)
                .shadow(color: Color(hex: "#64FFDA").opacity(0.3), radius: size * 0.05, x: 0, y: 0)
        }
        .frame(width: size, height: size)
    }
    
    // Text component of the logo
    private var logoText: some View {
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
            
            // The strength circle with a bit more spacing inside icon boundaries
            Circle()
                .trim(from: 0.1, to: 0.9)
                .rotation(.degrees(90))
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#64FFDA"),
                            Color(hex: "#00B4D8")
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.7, height: size * 0.7)
                .shadow(color: Color.black.opacity(0.1), radius: size * 0.05, x: 0, y: size * 0.02)
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