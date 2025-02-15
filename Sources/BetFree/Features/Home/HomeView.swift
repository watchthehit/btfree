import SwiftUI

public struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @State private var showingAddTransaction = false
    @State private var showingTip = true
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Section with Welcome Message
                    welcomeSection
                    
                    // Stats Overview
                    statsSection
                    
                    // Daily Progress
                    if appState.dailyLimit > 0 {
                        dailyProgressSection
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
        }
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
            ForEach(Array(zip([BFStatCard(
                value: "\(appState.streak)",
                label: "Day Streak",
                icon: "flame.fill",
                gradient: .orangeGradient
            ), BFStatCard(
                value: "$\(Int(appState.savings))",
                label: "Total Saved",
                icon: "dollarsign.circle.fill",
                gradient: .greenGradient
            )].indices, [BFStatCard(
                value: "\(appState.streak)",
                label: "Day Streak",
                icon: "flame.fill",
                gradient: .orangeGradient
            ), BFStatCard(
                value: "$\(Int(appState.savings))",
                label: "Total Saved",
                icon: "dollarsign.circle.fill",
                gradient: .greenGradient
            )])), id: \.0) { index, stat in
                stat
                .slideUpOnAppear()
            }
        }
        .padding(.horizontal)
    }
    
    private var dailyProgressSection: some View {
        let spentToday = appState.getTotalSpentToday()
        let dailyLimit = appState.dailyLimit
        let progress = dailyLimit > 0 ? spentToday / dailyLimit : 0
        
        return VStack(alignment: .leading, spacing: 12) {
            Text("Daily Progress")
                .font(BFDesignSystem.Typography.titleMedium)
                .foregroundColor(.primary)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Daily Limit:")
                        .foregroundColor(.secondary)
                    Text("$\(Int(dailyLimit))")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("Spent: $\(Int(spentToday))")
                        .foregroundColor(.secondary)
                }
                
                let progressValue: Double = min(progress, 1.0)
                SwiftUI.ProgressView(value: progressValue)
                
                HStack {
                    Text("$\(Int(spentToday))")
                        .font(BFDesignSystem.Typography.displayLarge)
                        .foregroundColor(.primary)
                    Text("/ $\(Int(dailyLimit))")
                        .font(BFDesignSystem.Typography.titleSmall)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            .padding(.horizontal)
        }
    }
    
    private func progressColor(_ progress: Double) -> Color {
        switch progress {
        case ..<0.5:
            return .green
        case 0.5..<0.8:
            return .orange
        default:
            return .red
        }
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