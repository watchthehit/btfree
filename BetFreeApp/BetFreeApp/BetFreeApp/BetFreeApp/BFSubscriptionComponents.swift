import SwiftUI

struct BFTrialBadge: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
        if appState.isTrialActive {
            HStack(spacing: 4) {
                Text("PRO TRIAL")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                
                Text("\(appState.daysRemainingInTrial)d")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(BFColors.accent)
                    .padding(.horizontal, 4)
                    .background(
                        Capsule()
                            .fill(Color.white)
                    )
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(
                Capsule()
                    .fill(BFColors.accent)
            )
        } else if appState.hasProAccess {
            Text("PRO")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(BFColors.accent)
                )
        }
    }
}

struct BFTrialBanner: View {
    @ObservedObject var appState: AppState
    @Binding var showPaywall: Bool
    
    var body: some View {
        if appState.isTrialActive {
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundColor(BFColors.accent)
                    
                    Text("PRO Trial")
                        .font(BFTypography.bodyMedium)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {
                        showPaywall = true
                    }) {
                        Text("Upgrade")
                            .font(BFTypography.bodySmall)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(BFColors.accent)
                            )
                            .foregroundColor(.white)
                    }
                }
                
                BFTimedProgressBar(
                    progress: appState.trialProgress,
                    daysRemaining: appState.daysRemainingInTrial
                )
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
            .padding(.horizontal)
        } else if !appState.hasProAccess {
            VStack(spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Unlock Premium Features")
                            .font(BFTypography.bodyMedium)
                            .fontWeight(.semibold)
                        
                        Text("Get advanced analytics and more")
                            .font(BFTypography.caption)
                            .foregroundColor(BFColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showPaywall = true
                    }) {
                        Text("Upgrade")
                            .font(BFTypography.bodySmall)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(BFColors.accent)
                            )
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
            .padding(.horizontal)
        }
    }
}

struct BFFeatureLockOverlay: View {
    var featureName: String
    @Binding var showPaywall: Bool
    
    var body: some View {
        ZStack {
            // Blurred background
            BlurView(style: .systemThinMaterial)
                .opacity(0.7)
            
            // Lock content
            VStack(spacing: 16) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 32))
                    .foregroundColor(BFColors.textSecondary)
                
                Text("\(featureName) is a Pro feature")
                    .font(BFTypography.bodyMedium)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    showPaywall = true
                }) {
                    Text("Upgrade to Pro")
                        .font(BFTypography.bodyMedium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(BFColors.accent)
                        )
                }
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 10)
            )
            .padding()
        }
    }
}

// Helper blur view
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
} 