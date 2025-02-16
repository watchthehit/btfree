import SwiftUI
import BetFreeUI
import BetFreeModels

private enum TimeFrame: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
    case all = "All Time"
}

@available(macOS 10.15, iOS 13.0, *)
public struct SavingsView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var savingsManager = SavingsManager()
    @State private var showingAddSaving = false
    @State private var selectedTimeFrame: TimeFrame = .month
    @State private var isAnimated = false
    
    public var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    TotalSavingsCardView(
                        totalSaved: savingsManager.totalSaved,
                        showingAddSaving: $showingAddSaving
                    )
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 20)
                    
                    TimeFramePickerView(selectedTimeFrame: $selectedTimeFrame)
                        .opacity(isAnimated ? 1 : 0)
                        .offset(y: isAnimated ? 0 : 20)
                    
                    StatisticsGridView(
                        savingsManager: savingsManager,
                        appState: appState
                    )
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 20)
                    
                    SavingsHistoryView(recentSavings: savingsManager.recentSavings)
                        .opacity(isAnimated ? 1 : 0)
                        .offset(y: isAnimated ? 0 : 20)
                }
                .padding(.horizontal)
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Savings")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddSaving = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(BFDesignSystem.Colors.primary)
                    }
                }
            }
            .sheet(isPresented: $showingAddSaving) {
                AddSavingView()
            }
            .onAppear {
                withAnimation(.spring(response: 0.6)) {
                    isAnimated = true
                }
            }
        }
    }
}

// MARK: - Subviews
private struct TotalSavingsCardView: View {
    let totalSaved: Double
    @Binding var showingAddSaving: Bool
    
    var body: some View {
        BFCard(style: .elevated, gradient: LinearGradient(
            colors: [BFDesignSystem.Colors.success, BFDesignSystem.Colors.success.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )) {
            VStack(spacing: 16) {
                Text("Total Savings")
                    .font(BFDesignSystem.Typography.titleMedium)
                    .foregroundColor(.white)
                
                Text("$\(String(format: "%.2f", totalSaved))")
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
    }
}

private struct TimeFramePickerView: View {
    @Binding var selectedTimeFrame: TimeFrame
    
    var body: some View {
        Picker("Time Frame", selection: $selectedTimeFrame) {
            ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
                Text(timeFrame.rawValue).tag(timeFrame)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
}

private struct StatisticsGridView: View {
    let savingsManager: SavingsManager
    let appState: AppState
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            SavingsStatCard(
                title: "Average Daily",
                value: savingsManager.formatAmount(savingsManager.dailyAverage),
                icon: "chart.bar.fill",
                color: BFDesignSystem.Colors.primary
            )
            
            SavingsStatCard(
                title: "Highest Day",
                value: savingsManager.formatAmount(savingsManager.savings(for: Date())),
                icon: "arrow.up.circle.fill",
                color: BFDesignSystem.Colors.success
            )
            
            SavingsStatCard(
                title: "Total Days",
                value: "\(savingsManager.streakDays)",
                icon: "calendar.circle.fill",
                color: BFDesignSystem.Colors.warning
            )
            
            SavingsStatCard(
                title: "Streak",
                value: "\(appState.currentStreak)",
                icon: "flame.fill",
                color: BFDesignSystem.Colors.error
            )
        }
        .padding(.horizontal)
    }
}

private struct SavingsHistoryView: View {
    let recentSavings: [Saving]
    
    var body: some View {
        BFCard(style: .elevated) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Recent Savings")
                    .font(BFDesignSystem.Typography.titleMedium)
                
                ForEach(recentSavings) { saving in
                    SavingRowView(saving: saving)
                    
                    if saving.id != recentSavings.last?.id {
                        Divider()
                    }
                }
            }
            .padding()
        }
    }
}

private struct SavingRowView: View {
    let saving: Saving
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(saving.date.formatted(date: .abbreviated, time: .omitted))
                    .font(BFDesignSystem.Typography.bodyMedium)
                if let notes = saving.notes {
                    Text(notes)
                        .font(BFDesignSystem.Typography.bodySmall)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
            }
            
            Spacer()
            
            Text("$\(String(format: "%.2f", saving.amount))")
                .font(BFDesignSystem.Typography.titleMedium)
                .foregroundColor(BFDesignSystem.Colors.success)
        }
        .padding(.vertical, 8)
    }
}

private struct SavingsStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        BFCard(style: .elevated) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(color)
                
                Text(value)
                    .font(BFDesignSystem.Typography.titleLarge)
                    .foregroundColor(color)
                
                Text(title)
                    .font(BFDesignSystem.Typography.labelMedium)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}

#Preview {
    SavingsView()
        .environmentObject(AppState.preview)
}
