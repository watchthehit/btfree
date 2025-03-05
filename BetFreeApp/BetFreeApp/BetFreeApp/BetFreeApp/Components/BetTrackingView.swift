import SwiftUI

/**
 * BetTrackingView
 * A PuffCount-inspired tracking interface for gambling urges and sessions
 */

struct BetTrackingView: View {
    @StateObject private var viewModel = BetTrackingViewModel()
    
    var body: some View {
        ZStack {
            // Background
            BFColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Stats summary
                HStack(spacing: 30) {
                    StatCard(
                        title: "Streak",
                        value: "\(viewModel.currentStreak)",
                        unit: "DAYS",
                        icon: "flame.fill",
                        color: .orange,
                        trend: .neutral,
                        trendValue: nil
                    )
                    
                    StatCard(
                        title: "Urges",
                        value: "\(viewModel.urgesTracked)",
                        unit: "TOTAL",
                        icon: "hand.raised.fill",
                        color: BFColors.accent,
                        trend: .neutral,
                        trendValue: nil
                    )
                    
                    StatCard(
                        title: "Money Saved",
                        value: "$\(viewModel.moneySaved)",
                        unit: "EST.",
                        icon: "dollarsign.circle.fill",
                        color: .green,
                        trend: .positive,
                        trendValue: viewModel.moneySaved > 0 ? "+$\(viewModel.moneySaved)" : nil
                    )
                }
                .padding(.top, 20)
                
                // Main tracker
                VStack(spacing: 25) {
                    // Today's urges
                    Text("TODAY'S URGES")
                        .font(BFTypography.caption(14))
                        .foregroundColor(BFColors.textSecondary)
                        .tracking(1.5)
                    
                    // Counter display
                    Text("\(viewModel.todayUrges)")
                        .font(.system(size: 70, weight: .bold, design: .rounded))
                        .foregroundColor(BFColors.textPrimary)
                        .padding()
                        .frame(width: 180, height: 180)
                        .background(
                            Circle()
                                .stroke(BFColors.accent.opacity(0.3), lineWidth: 8)
                                .background(Circle().fill(BFColors.cardBackground))
                        )
                    
                    // Action buttons
                    HStack(spacing: 16) {
                        // Track urge button
                        Button {
                            viewModel.trackUrge()
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .bold))
                                Text("Track Urge")
                                    .font(BFTypography.button(18))
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                            .background(
                                Capsule()
                                    .fill(BFColors.primary)
                            )
                        }
                        
                        // Track bet button (if user gambled)
                        Button {
                            viewModel.showTrackBetSheet = true
                        } label: {
                            HStack {
                                Image(systemName: "dollarsign")
                                    .font(.system(size: 18, weight: .bold))
                                Text("Log Bet")
                                    .font(BFTypography.button(18))
                            }
                            .foregroundColor(BFColors.textDark)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                            .background(
                                Capsule()
                                    .fill(BFColors.textSecondary)
                            )
                        }
                    }
                }
                .padding(.vertical, 40)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(BFColors.cardBackground)
                )
                .padding(.horizontal, 16)
                
                // Daily Goal Progress
                VStack(spacing: 10) {
                    Text("DAILY GOAL")
                        .font(BFTypography.caption(14))
                        .foregroundColor(BFColors.textSecondary)
                        .tracking(1.5)
                    
                    HStack {
                        Text("\(viewModel.todayUrgesGoal - viewModel.todayUrges) urges left to reach goal")
                            .font(BFTypography.body(16))
                            .foregroundColor(BFColors.textPrimary)
                        
                        Spacer()
                        
                        Button {
                            viewModel.showGoalSettings = true
                        } label: {
                            Image(systemName: "gear")
                                .font(.system(size: 18))
                                .foregroundColor(BFColors.textSecondary)
                        }
                    }
                    
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background
                            Capsule()
                                .fill(BFColors.textTertiary)
                                .frame(height: 12)
                            
                            // Progress
                            let progress = min(1.0, Double(viewModel.todayUrges) / Double(viewModel.todayUrgesGoal))
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [BFColors.accent, BFColors.accent.opacity(0.7)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * CGFloat(progress), height: 12)
                        }
                    }
                    .frame(height: 12)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(BFColors.cardBackground)
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.showTrackBetSheet) {
            TrackBetSheet(onComplete: { amount in
                viewModel.trackBet(amount: amount)
            })
        }
        .sheet(isPresented: $viewModel.showGoalSettings) {
            GoalSettingsSheet(currentGoal: viewModel.todayUrgesGoal) { newGoal in
                viewModel.todayUrgesGoal = newGoal
            }
        }
    }
}

// ViewModel for BetTrackingView
class BetTrackingViewModel: ObservableObject {
    @Published var todayUrges = 0
    @Published var todayUrgesGoal = 5 // Default goal
    @Published var urgesTracked = 0
    @Published var currentStreak = 0
    @Published var moneySaved = 0
    @Published var showTrackBetSheet = false
    @Published var showGoalSettings = false
    
    init() {
        // In a real app, you would load these values from persistent storage
        todayUrges = UserDefaults.standard.integer(forKey: "todayUrges")
        urgesTracked = UserDefaults.standard.integer(forKey: "totalUrges")
        currentStreak = UserDefaults.standard.integer(forKey: "currentStreak")
        moneySaved = UserDefaults.standard.integer(forKey: "moneySaved")
        todayUrgesGoal = UserDefaults.standard.integer(forKey: "urgesGoal")
        
        // Set default if not previously set
        if todayUrgesGoal == 0 {
            todayUrgesGoal = 5
            UserDefaults.standard.set(todayUrgesGoal, forKey: "urgesGoal")
        }
    }
    
    func trackUrge() {
        // Increment today's urges
        todayUrges += 1
        urgesTracked += 1
        
        // Save to UserDefaults (in a real app, use more robust persistence)
        UserDefaults.standard.set(todayUrges, forKey: "todayUrges")
        UserDefaults.standard.set(urgesTracked, forKey: "totalUrges")
        
        // Play haptic feedback
        HapticManager.shared.impactFeedback(style: .medium)
    }
    
    func trackBet(amount: Int) {
        // Reset streak
        currentStreak = 0
        
        // Decrease money saved
        moneySaved -= amount
        
        // Save to UserDefaults
        UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
        UserDefaults.standard.set(moneySaved, forKey: "moneySaved")
        
        // Play haptic feedback
        HapticManager.shared.notificationFeedback(type: .warning)
    }
}

// Track bet sheet
struct TrackBetSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var betAmount = ""
    let onComplete: (Int) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Log a Bet")
                    .font(BFTypography.title(24))
                    .foregroundColor(BFColors.textPrimary)
                    .padding(.top, 20)
                
                Text("We'll reset your streak, but you can start again!")
                    .font(BFTypography.body())
                    .foregroundColor(BFColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Amount spent ($)")
                        .font(BFTypography.caption())
                        .foregroundColor(BFColors.textSecondary)
                    
                    TextField("Enter amount", text: $betAmount)
                        .font(.system(size: 18, weight: .medium))
                        .keyboardType(.numberPad)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(BFColors.cardBackground)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
                
                Button {
                    if let amount = Int(betAmount), amount > 0 {
                        onComplete(amount)
                        dismiss()
                    }
                } label: {
                    Text("Log Bet")
                        .font(BFTypography.button())
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            isButtonEnabled ?
                            LinearGradient(
                                colors: [BFColors.primary, BFColors.primary.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ).cornerRadius(16) :
                            LinearGradient(
                                colors: [BFColors.textTertiary, BFColors.textTertiary.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ).cornerRadius(16)
                        )
                }
                .disabled(!isButtonEnabled)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    var isButtonEnabled: Bool {
        guard let amount = Int(betAmount) else { return false }
        return amount > 0
    }
}

// Note: Using the shared GoalSettingsSheet component defined elsewhere in the app

#Preview {
    BetTrackingView()
        .preferredColorScheme(.dark)
} 