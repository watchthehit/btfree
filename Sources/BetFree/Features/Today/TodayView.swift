import SwiftUI
import BetFreeUI

public struct TodayView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var savingsManager = SavingsManager()
    @StateObject private var cravingManager = CravingManager()
    @State private var showingAddSaving = false
    @State private var showingAppBlocking = false
    @State private var isAnimated = false
    
    public init() {}
    
    private var dailyProgress: Double {
        let todaySavings = savingsManager.savings(for: Date())
        return appState.dailyLimit > 0 ? min(1.0, todaySavings / appState.dailyLimit) : 0
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Streak Card
                    BFCard(style: .elevated, gradient: LinearGradient(
                        colors: [BFDesignSystem.Colors.primary, BFDesignSystem.Colors.primary.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )) {
                        VStack(spacing: 16) {
                            Text("🎯 Current Streak")
                                .font(BFDesignSystem.Typography.titleMedium)
                                .foregroundColor(.white)
                            
                            Text("\(appState.currentStreak)")
                                .font(BFDesignSystem.Typography.displayLarge)
                                .foregroundColor(.white)
                            
                            Text("Days Bet-Free")
                                .font(BFDesignSystem.Typography.bodyMedium)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                    }
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 20)
                    
                    // Savings Card
                    BFCard(style: .elevated, gradient: LinearGradient(
                        colors: [BFDesignSystem.Colors.success, BFDesignSystem.Colors.success.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )) {
                        VStack(spacing: 16) {
                            Text("Total Savings")
                                .font(BFDesignSystem.Typography.titleMedium)
                                .foregroundColor(.white)
                            
                            Text("$\(String(format: "%.2f", savingsManager.totalSaved))")
                                .font(BFDesignSystem.Typography.displayLarge)
                                .foregroundColor(.white)
                            
                            Text("from avoided sports bets")
                                .font(BFDesignSystem.Typography.bodyMedium)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Button {
                                showingAddSaving = true
                            } label: {
                                Text("Add Savings")
                                    .font(BFDesignSystem.Typography.labelLarge)
                                    .foregroundColor(BFDesignSystem.Colors.success)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(Color.white)
                                    .cornerRadius(20)
                            }
                        }
                        .padding()
                    }
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 20)
                    
                    // Daily Progress Card
                    BFCard(style: .elevated) {
                        VStack(spacing: 16) {
                            HStack {
                                Text("📊 Daily Progress")
                                    .font(BFDesignSystem.Typography.titleMedium)
                                Spacer()
                                Text("\(Int(dailyProgress * 100))%")
                                    .font(BFDesignSystem.Typography.titleMedium)
                                    .foregroundColor(BFDesignSystem.Colors.primary)
                            }
                            
                            SwiftUI.ProgressView(value: dailyProgress)
                                .tint(BFDesignSystem.Colors.primary)
                                .background(Color.gray.opacity(0.2))
                                .scaleEffect(x: 1, y: 2, anchor: .center)
                            
                            Text("$\(String(format: "%.2f", savingsManager.savings(for: Date()))) saved today")
                                .font(BFDesignSystem.Typography.bodyMedium)
                                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                        }
                        .padding()
                    }
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 20)
                    
                    // Quick Actions Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        QuickActionButton(
                            title: "Log Craving",
                            icon: "exclamationmark.triangle.fill",
                            color: BFDesignSystem.Colors.warning
                        ) {
                            appState.selectedTab = 2
                        }
                        
                        QuickActionButton(
                            title: "View Progress",
                            icon: "chart.line.uptrend.xyaxis.circle.fill",
                            color: BFDesignSystem.Colors.primary
                        ) {
                            appState.selectedTab = 3
                        }
                        
                        QuickActionButton(
                            title: "Get Support",
                            icon: "heart.circle.fill",
                            color: BFDesignSystem.Colors.success
                        ) {
                            appState.selectedTab = 4
                        }
                        
                        if !appState.hasBlockedApps {
                            QuickActionButton(
                                title: "Block Apps",
                                icon: "hand.raised.fill",
                                color: BFDesignSystem.Colors.error
                            ) {
                                showingAppBlocking = true
                            }
                        }
                    }
                    .padding(.horizontal)
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 20)
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
            .onAppear {
                withAnimation(.spring(response: 0.6)) {
                    isAnimated = true
                }
            }
        }
    }
}

private struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                Text(title)
                    .font(BFDesignSystem.Typography.labelMedium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
}
