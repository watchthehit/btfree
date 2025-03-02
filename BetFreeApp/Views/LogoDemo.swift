import SwiftUI

/**
 * LogoDemo
 * A demonstration view that showcases the BetFree logo and app icon
 * in various configurations for design review.
 */
struct LogoDemo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                // Header
                Text("BetFree Brand Assets")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.top, 20)
                
                // Full logo section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Primary Logo")
                        .font(.headline)
                    
                    HStack {
                        Spacer()
                        BetFreeLogo(style: .full, size: 120)
                        Spacer()
                    }
                    .frame(height: 180)
                    .background(Color(hex: "#F5F5F5"))
                    .cornerRadius(12)
                    
                    Text("The full logo should be used in welcome screens, about pages, and marketing materials.")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Compact and horizontal logos
                VStack(alignment: .leading, spacing: 15) {
                    Text("Logo Variants")
                        .font(.headline)
                    
                    HStack(spacing: 20) {
                        VStack {
                            BetFreeLogo(style: .compact, size: 60)
                            Text("Compact")
                                .font(.caption)
                        }
                        .frame(width: 150, height: 100)
                        .background(Color(hex: "#F5F5F5"))
                        .cornerRadius(12)
                        
                        VStack {
                            BetFreeLogo(style: .horizontal, size: 40)
                            Text("Horizontal")
                                .font(.caption)
                        }
                        .frame(width: 150, height: 100)
                        .background(Color(hex: "#F5F5F5"))
                        .cornerRadius(12)
                    }
                    
                    Text("Compact logo is for small spaces. Horizontal is for navigation bars.")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // App icon
                VStack(alignment: .leading, spacing: 15) {
                    Text("App Icon")
                        .font(.headline)
                    
                    HStack {
                        Spacer()
                        BetFreeAppIcon(size: 120)
                            .frame(width: 120, height: 120)
                        Spacer()
                    }
                    .padding(.vertical, 30)
                    .background(Color(hex: "#F5F5F5"))
                    .cornerRadius(12)
                    
                    Text("The app icon uses the same circle motif with a darker background for better visibility on home screens.")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Dark mode examples
                VStack(alignment: .leading, spacing: 15) {
                    Text("Dark Mode Variants")
                        .font(.headline)
                    
                    HStack(spacing: 20) {
                        VStack {
                            BetFreeLogo(style: .full, size: 80)
                            Text("Full")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .frame(width: 150, height: 130)
                        .background(Color(hex: "#0D1B2A"))
                        .cornerRadius(12)
                        
                        VStack {
                            BetFreeLogo(style: .horizontal, size: 40)
                            Text("Horizontal")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .frame(width: 150, height: 130)
                        .background(Color(hex: "#0D1B2A"))
                        .cornerRadius(12)
                    }
                    
                    Text("Dark mode variants automatically adjust text color for visibility.")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Guidance
                VStack(alignment: .leading, spacing: 15) {
                    Text("Usage Guidelines")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        guideline(text: "Maintain clear space around the logo equal to 20% of its size")
                        guideline(text: "Do not stretch or distort the proportions of the logo")
                        guideline(text: "Do not change the colors outside of approved palette")
                        guideline(text: "Minimum size for the full logo: 40px height")
                    }
                    .padding()
                    .background(Color(hex: "#E9F5F9"))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Developer Tools Section
                NavigationLink(destination: ResetAppView()) {
                    HStack {
                        Image(systemName: "hammer.fill")
                        Text("Developer Tools")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: "#64FFDA").opacity(0.1))
                    )
                    .foregroundColor(Color(hex: "#00B4D8"))
                }
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
        }
        .navigationTitle("Brand Assets")
    }
    
    private func guideline(text: String) -> some View {
        HStack(alignment: .top) {
            Text("•")
                .foregroundColor(Color(hex: "#00B4D8"))
            Text(text)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct LogoDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LogoDemo()
        }
    }
} 