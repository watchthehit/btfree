import SwiftUI
import Foundation

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
                                .accessibilityAddTraits(.isHeader)
                            
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
                                // Limited library with locked overlay and improved contrast
                                ZStack {
                                    VStack(spacing: 12) {
                                        exerciseRow(name: "Deep Breathing", duration: "5 min", category: "Breathing")
                                        exerciseRow(name: "Body Scan", duration: "15 min", category: "Body Awareness")
                                        exerciseRow(name: "Urge Surfing", duration: "10 min", category: "Urge Management", isPremium: true)
                                        exerciseRow(name: "Gratitude Practice", duration: "7 min", category: "Gratitude", isPremium: true)
                                    }
                                    .opacity(0.7) // Increased from 0.4 for better contrast
                                    
                                    // Upgrade prompt with improved contrast
                                    ZStack {
                                        // Background for better text contrast
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.bfOverlay(opacity: 0.6))
                                            .frame(height: 80)
                                            .padding(.horizontal, 20)
                                        
                                        VStack(spacing: 8) {
                                            Text("Unlock 20+ Premium Exercises")
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.bfWhite)
                                            
                                            Button(action: {
                                                showPaywall = true
                                            }) {
                                                Text("Upgrade to Pro")
                                                    .font(BFTypography.button)
                                                    .foregroundColor(.bfWhite)
                                                    .padding(.horizontal, 16)
                                                    .padding(.vertical, 8)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .fill(BFColors.accent)
                                                    )
                                            }
                                        }
                                    }
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
                .font(BFTypography.heading3)
                .foregroundColor(BFColors.textPrimary)
            
            Text(label)
                .font(BFTypography.bodySmall)
                .foregroundColor(BFColors.textSecondary)
        }
    }
    
    private func exerciseRow(name: String, duration: String, category: String, isPremium: Bool = false) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(name)
                        .font(BFTypography.bodyMedium)
                        .foregroundColor(BFColors.textPrimary)
                    
                    if isPremium {
                        Image(systemName: "lock.fill")
                            .font(.caption2)
                            .foregroundColor(BFColors.accent)
                    }
                }
                
                Text(category)
                    .font(BFTypography.caption)
                    .foregroundColor(BFColors.textSecondary)
            }
            
            Spacer()
            
            Text(duration)
                .font(BFTypography.bodySmall)
                .foregroundColor(BFColors.textTertiary)
        }
        .padding()
        .standardCardBackground()
    }
} 