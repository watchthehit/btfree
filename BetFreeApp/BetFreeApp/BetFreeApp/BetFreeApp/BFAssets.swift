import SwiftUI

struct BFAssets {
    // App Logo
    static func appLogo(size: CGFloat = 100) -> some View {
        ZStack {
            Circle()
                .fill(BFColors.primary)
                .frame(width: size, height: size)
                .shadow(color: BFColors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
            
            Circle()
                .strokeBorder(Color.white.opacity(0.7), lineWidth: 2)
                .frame(width: size * 0.85, height: size * 0.85)
            
            Image(systemName: "heart.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: size * 0.5, height: size * 0.5)
                .offset(y: -size * 0.03)
        }
    }
    
    // Onboarding Illustrations
    struct OnboardingIllustrations {
        static func welcome(size: CGFloat = 200) -> some View {
            ZStack {
                Circle()
                    .fill(BFColors.calm.opacity(0.3))
                    .frame(width: size, height: size)
                
                Image(systemName: "hand.wave.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(BFColors.primary)
                    .frame(width: size * 0.6, height: size * 0.6)
            }
        }
        
        static func nameInput(size: CGFloat = 200) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(BFColors.calm.opacity(0.3))
                    .frame(width: size, height: size * 0.75)
                
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(BFColors.primary)
                    .frame(width: size * 0.4, height: size * 0.4)
            }
        }
        
        static func goalSetting(size: CGFloat = 200) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(BFColors.healing.opacity(0.3))
                    .frame(width: size, height: size * 0.75)
                
                Image(systemName: "target")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(BFColors.secondary)
                    .frame(width: size * 0.4, height: size * 0.4)
            }
        }
        
        static func triggers(size: CGFloat = 200) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(BFColors.warning.opacity(0.2))
                    .frame(width: size, height: size * 0.75)
                
                Image(systemName: "bolt.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(BFColors.warning)
                    .frame(width: size * 0.4, height: size * 0.4)
            }
        }
        
        static func notifications(size: CGFloat = 200) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(BFColors.accent.opacity(0.2))
                    .frame(width: size, height: size * 0.75)
                
                Image(systemName: "bell.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(BFColors.accent)
                    .frame(width: size * 0.4, height: size * 0.4)
            }
        }
        
        static func features(size: CGFloat = 200) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(BFColors.info.opacity(0.2))
                    .frame(width: size, height: size * 0.75)
                
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(BFColors.info)
                    .frame(width: size * 0.4, height: size * 0.4)
            }
        }
        
        static func privacy(size: CGFloat = 200) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(BFColors.focus.opacity(0.2))
                    .frame(width: size, height: size * 0.75)
                
                Image(systemName: "lock.shield.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(BFColors.focus)
                    .frame(width: size * 0.4, height: size * 0.4)
            }
        }
        
        static func completion(size: CGFloat = 200) -> some View {
            ZStack {
                Circle()
                    .fill(BFColors.success.opacity(0.2))
                    .frame(width: size, height: size)
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(BFColors.success)
                    .frame(width: size * 0.6, height: size * 0.6)
            }
        }
    }
} 