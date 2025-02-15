import SwiftUI

public struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var savingsManager = SavingsManager()
    @StateObject private var cravingManager = CravingManager()
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Daily Progress
                    BFCard(style: .elevated) {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Daily Progress")
                                    .font(BFDesignSystem.Typography.titleMedium)
                                Spacer()
                                Image(systemName: "star.fill")
                                    .foregroundColor(BFDesignSystem.Colors.warning)
                            }
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Bet-Free Day")
                                        .font(BFDesignSystem.Typography.labelLarge)
                                    Text("\(appState.currentStreak)")
                                        .font(BFDesignSystem.Typography.displaySmall)
                                        .foregroundColor(BFDesignSystem.Colors.success)
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("Money Saved")
                                        .font(BFDesignSystem.Typography.labelLarge)
                                    Text("$\(Int(savingsManager.totalSavings))")
                                        .font(BFDesignSystem.Typography.displaySmall)
                                        .foregroundColor(BFDesignSystem.Colors.primary)
                                }
                            }
                            
                            SwiftUI.ProgressView(value: Double(appState.currentStreak.remainder(dividingBy: 7)) / 7.0)
                                .progressViewStyle(.linear)
                                .tint(BFDesignSystem.Colors.success)
                        }
                        .padding()
                    }
                    .semanticMeaning("Progress Card")
                    .semanticValue("\(appState.currentStreak) days bet-free")
                    
                    // Today's Games Alert
                    if let situation = CravingManager.riskySituations.first(where: { Calendar.current.isDateInToday(Date()) }) {
                        BFCard(style: .elevated) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(BFDesignSystem.Colors.error)
                                    Text("High Risk Games Today")
                                        .font(BFDesignSystem.Typography.titleMedium)
                                }
                                
                                Text(situation)
                                    .font(BFDesignSystem.Typography.bodyLarge)
                                    .foregroundColor(BFDesignSystem.Colors.textPrimary)
                                
                                Divider()
                                
                                Text("Your Safety Plan:")
                                    .font(BFDesignSystem.Typography.labelLarge)
                                
                                ForEach(cravingManager.getSafetyPlan(for: CravingManager.getRiskLevel(for: situation)), id: \.self) { step in
                                    HStack(alignment: .top) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(BFDesignSystem.Colors.success)
                                        Text(step)
                                            .font(BFDesignSystem.Typography.bodyMedium)
                                    }
                                }
                                
                                Button {
                                    // Add emergency contact action
                                } label: {
                                    Label("Contact Sponsor", systemImage: "phone.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(BFDesignSystem.Colors.error)
                            }
                            .padding()
                        }
                        .semanticMeaning("Risk Alert")
                        .semanticValue("High risk: \(situation)")
                    }
                    
                    // Recent Progress
                    BFCard(style: .elevated) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Progress")
                                .font(BFDesignSystem.Typography.titleMedium)
                            
                            // Recent Insights
                            ForEach(cravingManager.getProgressInsights(), id: \.self) { insight in
                                HStack {
                                    Image(systemName: "lightbulb.fill")
                                        .foregroundColor(BFDesignSystem.Colors.warning)
                                    Text(insight)
                                        .font(BFDesignSystem.Typography.bodyMedium)
                                }
                            }
                            
                            Divider()
                            
                            // Quick Actions
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                QuickActionButton(
                                    title: "Log Urge",
                                    icon: "exclamationmark.triangle",
                                    color: BFDesignSystem.Colors.warning
                                ) {
                                    // Navigate to CravingView
                                }
                                
                                QuickActionButton(
                                    title: "Add Savings",
                                    icon: "dollarsign.circle",
                                    color: BFDesignSystem.Colors.success
                                ) {
                                    // Navigate to SavingsView
                                }
                                
                                QuickActionButton(
                                    title: "Get Support",
                                    icon: "person.2.fill",
                                    color: BFDesignSystem.Colors.primary
                                ) {
                                    // Navigate to ResourcesView
                                }
                                
                                QuickActionButton(
                                    title: "View Stats",
                                    icon: "chart.bar.fill",
                                    color: BFDesignSystem.Colors.secondary
                                ) {
                                    // Navigate to StatsView
                                }
                            }
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("BetFree")
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
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(BFDesignSystem.Typography.labelMedium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(12)
        }
        .semanticMeaning("\(title) Button")
        .semanticHint("Double tap to \(title.lowercased())")
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState.preview)
}