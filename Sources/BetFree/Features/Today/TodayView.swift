import SwiftUI

public struct TodayView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var savingsManager = SavingsManager()
    @State private var showingAddSaving = false
    @State private var showingAppBlocking = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Streak Counter
                    VStack(spacing: 8) {
                        Text("\(appState.currentStreak)")
                            .font(.system(size: 72, weight: .bold))
                            .foregroundColor(BFDesignSystem.Colors.primary)
                        
                        Text("Days Bet-Free")
                            .font(BFDesignSystem.Typography.titleMedium)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .background(BFDesignSystem.Colors.background)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                    
                    // Money Saved
                    BFCard(style: .elevated) {
                        VStack(spacing: 8) {
                            Text("Money Saved")
                                .font(BFDesignSystem.Typography.titleMedium)
                                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                            
                            Text(savingsManager.formatAmount(savingsManager.totalSaved))
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(BFDesignSystem.Colors.success)
                            
                            Button {
                                showingAddSaving = true
                            } label: {
                                Text("Add Saving")
                                    .font(BFDesignSystem.Typography.labelLarge)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(BFDesignSystem.Colors.primary)
                                    .cornerRadius(12)
                            }
                            .padding(.top, 8)
                        }
                        .padding()
                    }
                    
                    // Block Apps (if not done)
                    if !appState.hasBlockedApps {
                        BFCard(style: .elevated) {
                            Button {
                                showingAppBlocking = true
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Block Betting Apps")
                                            .font(BFDesignSystem.Typography.titleMedium)
                                            .foregroundColor(BFDesignSystem.Colors.textPrimary)
                                        
                                        Text("Protect your recovery")
                                            .font(BFDesignSystem.Typography.bodyMedium)
                                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "hand.raised.fill")
                                        .font(.title2)
                                        .foregroundColor(BFDesignSystem.Colors.primary)
                                }
                                .padding()
                            }
                        }
                    }
                    
                    // Achievement Card (if any)
                    if let achievement = todayAchievement {
                        achievementCard(achievement)
                    }
                }
                .padding()
            }
            .navigationTitle("Today")
            .sheet(isPresented: $showingAddSaving) {
                AddSavingView()
            }
            .sheet(isPresented: $showingAppBlocking) {
                AppBlockingView()
            }
        }
    }
    
    private var todayAchievement: Achievement? {
        // Return achievement if milestone reached today
        if appState.currentStreak == 7 {
            return Achievement(
                title: "First Week Clean!",
                description: "You've completed your first week bet-free",
                icon: "star.fill",
                color: BFDesignSystem.Colors.success
            )
        }
        return nil
    }
    
    private func achievementCard(_ achievement: Achievement) -> some View {
        BFCard(style: .elevated) {
            VStack(spacing: 12) {
                Image(systemName: achievement.icon)
                    .font(.system(size: 36))
                    .foregroundColor(achievement.color)
                
                Text(achievement.title)
                    .font(BFDesignSystem.Typography.titleMedium)
                
                Text(achievement.description)
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
}

private struct Achievement {
    let title: String
    let description: String
    let icon: String
    let color: Color
}
