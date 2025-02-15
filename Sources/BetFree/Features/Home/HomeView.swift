import SwiftUI

public struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var savingsManager = SavingsManager()
    @StateObject private var cravingManager = CravingManager()
    
    // State for navigation
    @State private var selectedTab: HomeTab = .progress
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    progressCard
                    
                    if let riskInfo = todayRiskInfo {
                        riskAlertCard(riskInfo: riskInfo)
                    }
                    
                    recentProgressCard
                }
                .padding()
            }
            .navigationTitle("BetFree")
        }
    }
    
    // MARK: - Card Views
    
    private var progressCard: some View {
        BFCard(style: .elevated) {
            VStack(spacing: 12) {
                cardHeader
                progressStats
                weeklyProgress
            }
            .padding()
        }
        .semanticMeaning("Progress Card")
        .semanticValue("\(appState.currentStreak) days bet-free")
    }
    
    private var cardHeader: some View {
        HStack {
            Text("Daily Progress")
                .font(BFDesignSystem.Typography.titleMedium)
            Spacer()
            Image(systemName: "star.fill")
                .foregroundColor(BFDesignSystem.Colors.warning)
        }
    }
    
    private var progressStats: some View {
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
                Text("$\(savingsManager.totalSaved)")
                    .font(BFDesignSystem.Typography.displaySmall)
                    .foregroundColor(BFDesignSystem.Colors.primary)
            }
        }
    }
    
    private var weeklyProgress: some View {
        SwiftUI.ProgressView(value: weeklyProgressValue)
            .progressViewStyle(.linear)
            .tint(BFDesignSystem.Colors.success)
    }
    
    private var weeklyProgressValue: Double {
        Double(appState.currentStreak % 7) / 7.0
    }
    
    // MARK: - Risk Alert
    
    private struct RiskInfo {
        let situation: String
        let riskLevel: Int
        let safetyPlan: [String]
    }
    
    private var todayRiskInfo: RiskInfo? {
        guard let situation = CravingManager.riskySituations.first(where: { _ in
            Calendar.current.isDateInToday(Date())
        }) else {
            return nil
        }
        
        let riskLevel = CravingManager.getRiskLevel(for: situation)
        let safetyPlan = cravingManager.getSafetyPlan(for: riskLevel)
        
        return RiskInfo(
            situation: situation,
            riskLevel: riskLevel,
            safetyPlan: safetyPlan
        )
    }
    
    private func riskAlertCard(riskInfo: RiskInfo) -> some View {
        BFCard(style: .elevated) {
            VStack(alignment: .leading, spacing: 12) {
                riskHeader(situation: riskInfo.situation)
                
                Text("Your Safety Plan:")
                    .font(BFDesignSystem.Typography.labelLarge)
                
                safetySteps(steps: riskInfo.safetyPlan)
                
                emergencyContactButton
            }
            .padding()
        }
        .semanticMeaning("Risk Alert")
        .semanticValue("High risk: \(riskInfo.situation)")
    }
    
    private func riskHeader(situation: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
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
        }
    }
    
    private func safetySteps(steps: [String]) -> some View {
        ForEach(steps, id: \.self) { step in
            HStack(alignment: .top) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(BFDesignSystem.Colors.success)
                Text(step)
                    .font(BFDesignSystem.Typography.bodyMedium)
            }
        }
    }
    
    private var emergencyContactButton: some View {
        Button {
            // Add emergency contact action
        } label: {
            Label("Contact Sponsor", systemImage: "phone.fill")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(BFDesignSystem.Colors.error)
    }
    
    // MARK: - Recent Progress
    
    private var recentProgressCard: some View {
        BFCard(style: .elevated) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Recent Progress")
                    .font(BFDesignSystem.Typography.titleMedium)
                
                progressInsights
                
                Divider()
                
                quickActions
            }
            .padding()
        }
    }
    
    private var progressInsights: some View {
        ForEach(cravingManager.getProgressInsights(), id: \.self) { insight in
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(BFDesignSystem.Colors.warning)
                Text(insight)
                    .font(BFDesignSystem.Typography.bodyMedium)
            }
        }
    }
    
    private var quickActions: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            QuickActionButton(
                title: "Log Urge",
                icon: "exclamationmark.triangle",
                color: BFDesignSystem.Colors.warning
            ) {
                selectedTab = .cravings
            }
            
            QuickActionButton(
                title: "Add Savings",
                icon: "dollarsign.circle",
                color: BFDesignSystem.Colors.success
            ) {
                selectedTab = .savings
            }
            
            QuickActionButton(
                title: "Get Support",
                icon: "person.2.fill",
                color: BFDesignSystem.Colors.primary
            ) {
                selectedTab = .resources
            }
            
            QuickActionButton(
                title: "View Stats",
                icon: "chart.bar.fill",
                color: BFDesignSystem.Colors.secondary
            ) {
                selectedTab = .stats
            }
        }
    }
}

// MARK: - Supporting Types

private enum HomeTab {
    case progress
    case cravings
    case savings
    case resources
    case stats
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