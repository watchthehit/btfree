import SwiftUI
import BetFreeUI
import BetFreeModels

public struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = HomeViewModel()
    @State private var showCravingSheet = false
    
    public init() {
        print("🏠 HomeView initialized")
    }
    
    public var body: some View {
        let _ = print("🏠 HomeView body evaluated")
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    VStack {
                        let _ = print("🏠 HomeView showing loading state")
                        Spacer()
                        ProgressView()
                            .progressViewStyle(.circular)
                        Spacer()
                    }
                } else {
                    let _ = print("🏠 HomeView showing content")
                    ScrollView {
                        VStack(spacing: 24) {
                            // Streak Card
                            StreakCard(
                                streak: appState.streak,
                                savings: appState.savingsAmount
                            )
                            
                            // Quick Actions
                            QuickActionsGrid()
                            
                            // Daily Check-in
                            if !viewModel.hasCheckedInToday {
                                CheckInCard {
                                    Task {
                                        do {
                                            try await viewModel.performDailyCheckIn()
                                        } catch {
                                            print("Error performing daily check-in: \(error)")
                                        }
                                    }
                                }
                            }
                            
                            // Recent Activity
                            RecentActivityList(activities: viewModel.recentActivities)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(appState.username.isEmpty ? "Welcome" : "Welcome, \(appState.username)")
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showCravingSheet = true }) {
                        Label("Report Craving", systemImage: "exclamationmark.triangle.fill")
                    }
                }
                #else
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showCravingSheet = true }) {
                        Label("Report Craving", systemImage: "exclamationmark.triangle.fill")
                    }
                }
                #endif
            }
        }
        .sheet(isPresented: $showCravingSheet) {
            CravingReportView()
        }
        .onAppear {
            print("🏠 HomeView appeared")
            print("🏠 AppState username: \(appState.username)")
            print("🏠 AppState streak: \(appState.streak)")
            print("🏠 AppState savings: \(appState.savingsAmount)")
        }
        .onDisappear {
            print("🏠 HomeView disappeared")
        }
    }
}

private struct StreakCard: View {
    let streak: Int
    let savings: Double
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Current Streak")
                        .font(BFDesignSystem.Typography.titleMedium)
                        .foregroundColor(BFDesignSystem.Colors.textPrimary)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(max(0, streak))")
                            .font(BFDesignSystem.Typography.displayMedium)
                            .foregroundColor(BFDesignSystem.Colors.primary)
                        Text("Days Bet-Free")
                            .font(BFDesignSystem.Typography.bodyMedium)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "flame.fill")
                    .font(.system(size: 40))
                    .foregroundColor(streak > 0 ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.textSecondary)
                    .opacity(streak > 0 ? 1.0 : 0.5)
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Savings")
                        .font(BFDesignSystem.Typography.titleSmall)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    
                    Text(formatCurrency(savings))
                        .font(BFDesignSystem.Typography.titleLarge)
                        .foregroundColor(BFDesignSystem.Colors.success)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Label("Add Saving", systemImage: "plus.circle.fill")
                        .font(BFDesignSystem.Typography.labelLarge)
                }
                .buttonStyle(BFButtonStyle())
            }
        }
        .padding()
        .background(BFDesignSystem.Colors.secondaryBackground)
        .cornerRadius(16)
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: max(0, value))) ?? "$0.00"
    }
}

private struct QuickActionsGrid: View {
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            QuickActionButton(
                title: "Track Savings",
                icon: "dollarsign.circle.fill",
                color: BFDesignSystem.Colors.success
            ) {
                // Navigate to savings tracking
            }
            
            QuickActionButton(
                title: "View Progress",
                icon: "chart.line.uptrend.xyaxis",
                color: BFDesignSystem.Colors.primary
            ) {
                // Navigate to progress view
            }
            
            QuickActionButton(
                title: "Resources",
                icon: "book.fill",
                color: BFDesignSystem.Colors.warning
            ) {
                // Navigate to resources
            }
            
            QuickActionButton(
                title: "Get Help",
                icon: "phone.fill",
                color: .red
            ) {
                // Show emergency contacts
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
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                Text(title)
                    .font(BFDesignSystem.Typography.labelMedium)
                    .foregroundColor(BFDesignSystem.Colors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(BFDesignSystem.Colors.secondaryBackground)
            .cornerRadius(12)
        }
    }
}

private struct CheckInCard: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Daily Check-In")
                .font(BFDesignSystem.Typography.titleMedium)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            Text("Stay accountable by checking in every day")
                .font(BFDesignSystem.Typography.bodyMedium)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
            
            Button(action: action) {
                Label("Check In Now", systemImage: "checkmark.circle.fill")
                    .font(BFDesignSystem.Typography.labelLarge)
            }
            .buttonStyle(BFButtonStyle())
        }
        .padding()
        .background(BFDesignSystem.Colors.secondaryBackground)
        .cornerRadius(16)
    }
}

private struct RecentActivityList: View {
    let activities: [Activity]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(BFDesignSystem.Typography.titleMedium)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            ForEach(activities) { activity in
                ActivityRow(activity: activity)
            }
        }
    }
}

private struct ActivityRow: View {
    let activity: Activity
    
    var body: some View {
        HStack {
            Image(systemName: activity.icon)
                .font(.system(size: 20))
                .foregroundColor(activity.color)
                .frame(width: 40, height: 40)
                .background(activity.color.opacity(0.1))
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title)
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(BFDesignSystem.Colors.textPrimary)
                
                Text(activity.timestamp.formatted())
                    .font(BFDesignSystem.Typography.bodySmall)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
            
            Spacer()
            
            if let amount = activity.amount {
                Text("$\(amount, specifier: "%.2f")")
                    .font(BFDesignSystem.Typography.titleMedium)
                    .foregroundColor(BFDesignSystem.Colors.success)
            }
        }
        .padding()
        .background(BFDesignSystem.Colors.secondaryBackground)
        .cornerRadius(12)
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState.preview)
}