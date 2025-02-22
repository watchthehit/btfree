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

private struct SavingsSparkline: View {
    let values: [Double]
    let height: CGFloat = 30
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                guard values.count > 1 else { return }
                
                let width = geometry.size.width
                let height = geometry.size.height
                let step = width / CGFloat(values.count - 1)
                
                let points = values.enumerated().map { index, value in
                    let x = CGFloat(index) * step
                    let y = (1 - (value / (values.max() ?? 1))) * height
                    return CGPoint(x: x, y: y)
                }
                
                path.move(to: points[0])
                for point in points.dropFirst() {
                    path.addLine(to: point)
                }
            }
            .stroke(BFDesignSystem.Colors.success, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
        .frame(height: height)
    }
}

private struct StreakCard: View {
    let streak: Int
    let savings: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Streak section
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Current Streak")
                        .font(.system(size: 28, weight: .regular))
                        .foregroundColor(.white)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("\(streak)")
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(BFDesignSystem.Colors.primary)
                        Text("Days Bet-Free")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Image(systemName: "flame")
                    .font(.system(size: 32))
                    .foregroundColor(.gray)
            }
            
            Divider()
                .background(Color.gray.opacity(0.3))
            
            // Savings section
            VStack(alignment: .leading, spacing: 12) {
                Text("Total Savings")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.gray)
                
                HStack {
                    Text("$\(String(format: "%.2f", savings))")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.green)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Add Saving")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding(20)
        .background(Color(white: 0.12))
        .cornerRadius(16)
    }
}

private struct QuickActionsGrid: View {
    enum QuickAction: String, CaseIterable {
        case trackSavings = "Track Savings"
        case viewProgress = "View Progress"
        case resources = "Resources"
        case getHelp = "Get Help"
        
        var icon: String {
            switch self {
            case .trackSavings: return "dollarsign"
            case .viewProgress: return "chart.line.uptrend.xyaxis"
            case .resources: return "book"
            case .getHelp: return "phone"
            }
        }
        
        var iconColor: Color {
            switch self {
            case .trackSavings: return .green
            case .viewProgress: return .purple
            case .resources: return .yellow
            case .getHelp: return .red
            }
        }
        
        var circleColor: Color {
            iconColor.opacity(0.3)
        }
    }
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            ForEach(QuickAction.allCases, id: \.self) { action in
                Button(action: {
                    handleAction(action)
                }) {
                    VStack(spacing: 12) {
                        Circle()
                            .fill(action.circleColor)
                            .frame(width: 64, height: 64)
                            .overlay(
                                Image(systemName: action.icon)
                                    .font(.system(size: 28))
                                    .foregroundColor(action.iconColor)
                            )
                        
                        Text(action.rawValue)
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(white: 0.15))
                    .cornerRadius(16)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 4)
    }
    
    private func handleAction(_ action: QuickAction) {
        switch action {
        case .trackSavings:
            print("Track savings tapped")
        case .viewProgress:
            print("View progress tapped")
        case .resources:
            print("Resources tapped")
        case .getHelp:
            print("Get help tapped")
        }
    }
}

private struct CheckInCard: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Daily Check-In")
                .font(.system(size: 28, weight: .regular))
                .foregroundColor(.white)
            
            Text("Stay accountable by checking in every day")
                .font(.system(size: 17))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Button(action: action) {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .medium))
                    Text("Check In Now")
                        .font(.system(size: 17, weight: .medium))
                }
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.white)
                .cornerRadius(8)
            }
            .padding(.top, 4)
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 24)
        .background(Color(white: 0.12))
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