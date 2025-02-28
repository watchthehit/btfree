import SwiftUI

struct BFEnhancedDashboardView: View {
    @EnvironmentObject private var appState: AppState
    @State private var showPaywall = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome header with subscription badge
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome, \(appState.username.isEmpty ? "Friend" : appState.username)")
                                .font(BFTypography.heading2)
                                .foregroundColor(BFColors.textPrimary)
                            
                            Text("Today is a great day to stay on track")
                                .font(BFTypography.bodyMedium)
                                .foregroundColor(BFColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        BFTrialBadge(appState: appState)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    
                    // Trial banner (if applicable)
                    BFTrialBanner(appState: appState, showPaywall: $showPaywall)
                    
                    // Progress summary
                    BFCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Your Progress")
                                .font(BFTypography.heading3)
                            
                            HStack(spacing: 20) {
                                statView(value: "\(appState.streakCount)", label: "Day Streak")
                                
                                Divider()
                                    .frame(height: 40)
                                
                                statView(value: "\(appState.dailyGoal)", label: "Daily Goal")
                                
                                Divider()
                                    .frame(height: 40)
                                
                                statView(value: "5", label: "Tracked Triggers")
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    
                    // Mindfulness exercises (locked for free tier)
                    BFCard {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Mindfulness Exercises")
                                    .font(BFTypography.heading3)
                                
                                Spacer()
                                
                                if !appState.canAccessFullMindfulnessLibrary {
                                    Image(systemName: "lock.fill")
                                        .foregroundColor(BFColors.textSecondary)
                                }
                            }
                            
                            // Preview of exercises
                            if appState.canAccessFullMindfulnessLibrary {
                                // Full library
                                VStack(spacing: 12) {
                                    exerciseRow(name: "Deep Breathing", duration: "5 min", category: "Breathing")
                                    exerciseRow(name: "Urge Surfing", duration: "10 min", category: "Urge Management")
                                    exerciseRow(name: "Body Scan", duration: "15 min", category: "Body Awareness")
                                    exerciseRow(name: "Gratitude Practice", duration: "7 min", category: "Gratitude")
                                }
                            } else {
                                // Limited library with locked overlay
                                ZStack {
                                    VStack(spacing: 12) {
                                        exerciseRow(name: "Deep Breathing", duration: "5 min", category: "Breathing")
                                        exerciseRow(name: "Body Scan", duration: "15 min", category: "Body Awareness")
                                        exerciseRow(name: "Urge Surfing", duration: "10 min", category: "Urge Management", isPremium: true)
                                        exerciseRow(name: "Gratitude Practice", duration: "7 min", category: "Gratitude", isPremium: true)
                                    }
                                    .opacity(0.4)
                                    
                                    // Upgrade prompt
                                    VStack(spacing: 8) {
                                        Text("Unlock 20+ Premium Exercises")
                                            .font(BFTypography.bodyMedium)
                                            .fontWeight(.semibold)
                                        
                                        Button(action: {
                                            showPaywall = true
                                        }) {
                                            Text("Upgrade to Pro")
                                                .font(BFTypography.button)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(BFColors.accent)
                                                )
                                        }
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.9))
                                            .shadow(color: Color.black.opacity(0.05), radius: 8)
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .background(BFColors.secondaryBackground.ignoresSafeArea())
            .navigationTitle("Dashboard")
            .sheet(isPresented: $showPaywall) {
                HardPaywallScreen(isPresented: $showPaywall)
            }
        }
    }
    
    private func statView(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(BFColors.primary)
            
            Text(label)
                .font(BFTypography.caption)
                .foregroundColor(BFColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func exerciseRow(name: String, duration: String, category: String, isPremium: Bool = false) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(BFTypography.bodyMedium)
                    .foregroundColor(BFColors.textPrimary)
                
                Text(category)
                    .font(BFTypography.caption)
                    .foregroundColor(BFColors.textSecondary)
            }
            
            Spacer()
            
            if isPremium {
                Image(systemName: "crown.fill")
                    .foregroundColor(BFColors.accent)
                    .padding(.trailing, 4)
            }
            
            Text(duration)
                .font(BFTypography.bodySmall)
                .foregroundColor(BFColors.textSecondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(BFColors.secondaryBackground)
                )
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.03), radius: 2)
        )
    }
} 