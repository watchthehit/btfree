import SwiftUI

public struct SavingsView: View {
    @EnvironmentObject private var appState: AppState
    @State private var showingAddSaving = false
    @State private var selectedTimeFrame: TimeFrame = .month
    
    private enum TimeFrame: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        case all = "All Time"
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Total Savings Card
                    BFCard(style: .elevated) {
                        VStack(spacing: 12) {
                            Text("Total Savings")
                                .font(BFDesignSystem.Typography.titleMedium)
                            
                            Text("$\(String(format: "%.2f", totalSavings))")
                                .font(BFDesignSystem.Typography.displayLarge)
                                .foregroundColor(BFDesignSystem.Colors.success)
                            
                            Text("from avoided sports bets")
                                .font(BFDesignSystem.Typography.bodyMedium)
                                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                            
                            // Time Frame Picker
                            Picker("Time Frame", selection: $selectedTimeFrame) {
                                ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
                                    Text(timeFrame.rawValue).tag(timeFrame)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding(.top, 8)
                        }
                        .padding()
                    }
                    
                    // Stats Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        StatBox(
                            title: "Bets Avoided",
                            value: "\(filteredSavings.count)",
                            icon: "hand.raised.fill",
                            color: BFDesignSystem.Colors.primary
                        )
                        
                        StatBox(
                            title: "Average Saved",
                            value: "$\(String(format: "%.0f", averageSaving))",
                            icon: "chart.bar.fill",
                            color: BFDesignSystem.Colors.warning
                        )
                    }
                    
                    // Recent Savings
                    BFCard(style: .elevated) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recent Savings")
                                .font(BFDesignSystem.Typography.titleMedium)
                            
                            if filteredSavings.isEmpty {
                                EmptyStateView()
                            } else {
                                ForEach(filteredSavings.prefix(5)) { saving in
                                    SavingRow(saving: saving)
                                    
                                    if saving.id != filteredSavings.prefix(5).last?.id {
                                        Divider()
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("Savings")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddSaving = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSaving) {
                AddSavingView()
            }
        }
    }
    
    private var filteredSavings: [Saving] {
        let calendar = Calendar.current
        let now = Date()
        
        return appState.savings.filter { saving in
            switch selectedTimeFrame {
            case .week:
                return calendar.isDate(saving.date, equalTo: now, toGranularity: .weekOfYear)
            case .month:
                return calendar.isDate(saving.date, equalTo: now, toGranularity: .month)
            case .year:
                return calendar.isDate(saving.date, equalTo: now, toGranularity: .year)
            case .all:
                return true
            }
        }
        .sorted { $0.date > $1.date }
    }
    
    private var totalSavings: Double {
        filteredSavings.reduce(0) { $0 + $1.amount }
    }
    
    private var averageSaving: Double {
        guard !filteredSavings.isEmpty else { return 0 }
        return totalSavings / Double(filteredSavings.count)
    }
}

private struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(BFDesignSystem.Typography.titleLarge)
                .foregroundColor(color)
            
            Text(title)
                .font(BFDesignSystem.Typography.labelMedium)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

private struct SavingRow: View {
    let saving: Saving
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(saving.description)
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(BFDesignSystem.Colors.textPrimary)
                
                Text(saving.date, style: .date)
                    .font(BFDesignSystem.Typography.bodySmall)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
            
            Spacer()
            
            Text("$\(String(format: "%.2f", saving.amount))")
                .font(BFDesignSystem.Typography.titleMedium)
                .foregroundColor(BFDesignSystem.Colors.success)
        }
    }
}

private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "piggybank.fill")
                .font(.system(size: 48))
                .foregroundColor(BFDesignSystem.Colors.primary)
            
            Text("No Savings Yet")
                .font(BFDesignSystem.Typography.titleMedium)
            
            Text("Start tracking your savings from avoided sports bets")
                .font(BFDesignSystem.Typography.bodyMedium)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    SavingsView()
        .environmentObject(AppState.preview)
}
