import SwiftUI

public struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @State private var showingAddTransaction = false
    @State private var showingTip = true
    @State private var previousStreak: Int = 0
    @State private var previousSavings: Double = 0
    @State private var dailySpentAmount: Double = 0
    
    private let hapticEngine = BFHapticEngine()
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Section with Welcome Message
                    welcomeSection
                    
                    // Stats Overview
                    statsSection
                        .withSuccessHaptics(when: appState.currentStreak > previousStreak)
                    
                    // Daily Progress
                    if appState.dailyLimit > 0 {
                        progressSection
                            .onChange(of: dailySpentAmount) { newAmount in
                                if newAmount >= appState.dailyLimit {
                                    BFHaptics.error()
                                } else if newAmount >= appState.dailyLimit * 0.8 {
                                    BFHaptics.warning()
                                }
                            }
                    }
                    
                    // Quick Actions
                    quickActionsSection
                    
                    // Tips & Insights
                    if showingTip {
                        tipSection
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView()
            }
            .onChange(of: appState.totalSavings) { newSavings in
                if newSavings >= previousSavings + 100 {  // Achievement for every $100 saved
                    hapticEngine.playAchievementPattern()
                    previousSavings = newSavings
                }
            }
            .onAppear {
                previousStreak = appState.currentStreak
                previousSavings = appState.totalSavings
                updateDailySpent()
            }
        }
    }
    
    private func updateDailySpent() {
        dailySpentAmount = appState.getTotalSpentToday()
    }
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome\(appState.username.isEmpty ? "" : ", \(appState.username)")")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Let's make today count!")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
    
    private var statsSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            BFStatCard(
                value: "\(appState.currentStreak)",
                label: "Day Streak",
                icon: "flame.fill",
                gradient: .orangeGradient
            )
            
            BFStatCard(
                value: "$\(Int(appState.totalSavings))",
                label: "Total Saved",
                icon: "dollarsign.circle.fill",
                gradient: .greenGradient
            )
        }
        .padding(.horizontal)
    }
    
    private var progressSection: some View {
        let progress = appState.dailyLimit > 0 ? dailySpentAmount / appState.dailyLimit : 0
        
        return VStack(alignment: .leading, spacing: 10) {
            Text("Daily Progress")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Text("$\(Int(dailySpentAmount))")
                    .font(.body)
                    .foregroundColor(.primary)
                
                Text("of")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("$\(Int(appState.dailyLimit))")
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            SwiftUI.ProgressView(value: progress)
                .tint(progress >= 1.0 ? .red : .blue)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quick Actions")
                .font(.headline)
                .padding(.horizontal)
            
            Button(action: { showingAddTransaction = true }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.green)
                    Text("Add Transaction")
                        .font(.body)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal)
        }
    }
    
    private var tipSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("💡 Tip of the Day")
                    .font(.headline)
                Spacer()
                Button(action: { withAnimation { showingTip = false } }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
            
            Text("Track your daily spending to stay within your budget. Small savings add up to big results!")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

#Preview {
    NavigationView {
        HomeView()
            .environmentObject(AppState.preview)
    }
}