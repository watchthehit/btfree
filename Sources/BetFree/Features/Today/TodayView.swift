import SwiftUI

public struct TodayView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var savingsManager = SavingsManager()
    @State private var showingAddSaving = false
    @State private var showingAppBlocking = false
    
    public init() {}
    
    private var dailyProgress: Double {
        let todaySavings = savingsManager.savings(for: Date())
        return appState.dailyLimit > 0 ? min(1.0, todaySavings / appState.dailyLimit) : 0
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    StreakCounterView(currentStreak: appState.currentStreak)
                    MoneySavedView(savingsManager: savingsManager, showingAddSaving: $showingAddSaving)
                    DailyProgressView(dailyProgress: dailyProgress)
                    
                    if !appState.hasBlockedApps {
                        AppBlockingCardView(showingAppBlocking: $showingAppBlocking)
                    }
                    
                    if let achievement = todayAchievement {
                        AchievementCardView(achievement: achievement)
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
        if appState.currentStreak == 7 {
            return Achievement(
                title: "First Week Clean!",
                description: "You've completed your first week without betting. Keep up the great work!"
            )
        } else if appState.currentStreak == 30 {
            return Achievement(
                title: "One Month Milestone!",
                description: "A full month of being bet-free. You're making incredible progress!"
            )
        } else if appState.currentStreak == 90 {
            return Achievement(
                title: "90 Days Strong!",
                description: "Three months of commitment to your well-being. You're an inspiration!"
            )
        }
        return nil
    }
}

private struct Achievement {
    let title: String
    let description: String
}

private struct StreakCounterView: View {
    let currentStreak: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(currentStreak)")
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
    }
}

private struct MoneySavedView: View {
    let savingsManager: SavingsManager
    @Binding var showingAddSaving: Bool
    
    var body: some View {
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
    }
}

private struct DailyProgressView: View {
    let dailyProgress: Double
    
    var body: some View {
        BFCard(style: .elevated) {
            VStack(spacing: 16) {
                HStack {
                    Text("Daily Progress")
                        .font(BFDesignSystem.Typography.titleMedium)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    Spacer()
                    Text("\(Int(dailyProgress * 100))%")
                        .font(BFDesignSystem.Typography.labelLarge)
                        .foregroundColor(BFDesignSystem.Colors.primary)
                }
                
                SwiftUI.ProgressView(value: dailyProgress)
                    .tint(BFDesignSystem.Colors.primary)
            }
            .padding()
        }
    }
}

private struct AppBlockingCardView: View {
    @Binding var showingAppBlocking: Bool
    
    var body: some View {
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
}

private struct AchievementCardView: View {
    let achievement: Achievement
    
    var body: some View {
        BFCard(style: .elevated) {
            VStack(spacing: 8) {
                Text("🎉 Achievement Unlocked!")
                    .font(BFDesignSystem.Typography.titleMedium)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                
                Text(achievement.title)
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text(achievement.description)
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
}
