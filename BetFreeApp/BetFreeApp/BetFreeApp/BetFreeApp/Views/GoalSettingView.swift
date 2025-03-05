import SwiftUI

/// Screen for setting up tracking goals and urge limits
struct GoalSettingView: View {
    @StateObject private var viewModel = GoalSettingViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Quick Start Button
            QuickStartButton(action: viewModel.quickStart)
                .padding(.top, 20)
            
            ScrollView {
                VStack(spacing: 40) {
                    // Header
                    HeaderComponent()
                    
                    // Goal Selection
                    GoalSelectionComponent(
                        selectedGoal: $viewModel.selectedGoal,
                        onChange: viewModel.goalSelected
                    )
                    
                    // Goal Description - appears after selection
                    if let selectedGoal = viewModel.selectedGoal {
                        GoalDescriptionComponent(goalType: selectedGoal)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    // Urge Limit Selector
                    UrgeLimitComponent(count: $viewModel.urgeLimit)
                    
                    // Spacer to push content up
                    Spacer()
                        .frame(height: 40)
                }
                .padding(.horizontal)
                .padding(.bottom, 100) // Space for bottom buttons
            }
            
            // Fixed bottom section
            BottomActionComponent(
                currentStep: 4,
                totalSteps: 4,
                buttonEnabled: viewModel.isConfigurationValid,
                buttonAction: viewModel.completeSetup
            )
        }
        .background(BFColors.background.ignoresSafeArea())
        .animation(.easeInOut(duration: 0.3), value: viewModel.selectedGoal)
    }
}

// MARK: - Quick Start Button Component
struct QuickStartButton: View {
    let action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: action) {
                HStack(spacing: 8) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 14))
                    
                    Text("Quick Start")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                }
                .foregroundColor(BFColors.primary)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(
                    Capsule()
                        .stroke(BFColors.primary, lineWidth: 2)
                )
            }
            .accessibilityHint("Skip detailed setup and start with recommended settings")
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Header Component
struct HeaderComponent: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Ready to start tracking?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(BFColors.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.top, 10)
                .accessibilityAddTraits(.isHeader)
            
            Text("Set your goal and limits to begin your journey")
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(BFColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
    }
}

// MARK: - Goal Selection Component
struct GoalSelectionComponent: View {
    @Binding var selectedGoal: GoalType?
    let onChange: (GoalType) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What's your goal?")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(BFColors.textPrimary)
                .padding(.leading, 4)
                .accessibilityAddTraits(.isHeader)
            
            GoalOptionButton(
                title: "Track & Reduce",
                icon: "chart.line.downtrend.xyaxis",
                isSelected: selectedGoal == .trackAndReduce,
                action: { 
                    selectedGoal = .trackAndReduce
                    onChange(.trackAndReduce)
                }
            )
            
            GoalOptionButton(
                title: "Quit",
                icon: "hand.raised.fill",
                isSelected: selectedGoal == .quit,
                action: { 
                    selectedGoal = .quit 
                    onChange(.quit)
                }
            )
            
            GoalOptionButton(
                title: "Maintain control",
                icon: "gauge.with.dots.needle.33percent",
                isSelected: selectedGoal == .maintainControl,
                action: { 
                    selectedGoal = .maintainControl
                    onChange(.maintainControl)
                }
            )
        }
    }
}

// MARK: - Goal Option Button
struct GoalOptionButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: isSelected ? .bold : .semibold))
                    .foregroundColor(isSelected ? .white : BFColors.textPrimary)
                
                Text(title)
                    .font(.system(size: 16, weight: isSelected ? .bold : .semibold, design: .rounded))
                    .foregroundColor(isSelected ? .white : BFColors.textPrimary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? BFColors.primary : BFColors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? BFColors.primary : BFColors.cardBackground.opacity(0.5), 
                           lineWidth: isSelected ? 0 : 1)
            )
            .shadow(color: isSelected ? BFColors.primary.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
        }
        .accessibility(label: Text("Goal option: \(title)"))
        .accessibility(hint: Text("Tap to select this goal"))
        .accessibility(addTraits: isSelected ? .isSelected : [])
    }
}

// MARK: - Goal Description Component
struct GoalDescriptionComponent: View {
    let goalType: GoalType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: iconForGoal)
                    .font(.system(size: 20))
                    .foregroundColor(BFColors.primary)
                
                Text("About this goal")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(BFColors.textPrimary)
            }
            
            Text(descriptionForGoal)
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundColor(BFColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            
            if let tip = tipForGoal {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 14))
                        .foregroundColor(BFColors.accent)
                    
                    Text(tip)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(BFColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 4)
            }
        }
        .padding(16)
        .background(BFColors.cardBackground.opacity(0.1))
        .cornerRadius(16)
    }
    
    private var iconForGoal: String {
        switch goalType {
        case .trackAndReduce: return "chart.line.downtrend.xyaxis"
        case .quit: return "hand.raised.fill"
        case .maintainControl: return "gauge.with.dots.needle.33percent"
        }
    }
    
    private var descriptionForGoal: String {
        switch goalType {
        case .trackAndReduce:
            return "Track your gambling urges and gradually reduce them over time. This approach helps you understand your triggers and build healthier habits."
        case .quit:
            return "Complete abstinence from gambling activities. This goal is focused on stopping gambling entirely to prevent potential harm."
        case .maintainControl:
            return "Keep gambling within your set limits. This approach is about maintaining control over your gambling behavior without necessarily stopping completely."
        }
    }
    
    private var tipForGoal: String? {
        switch goalType {
        case .trackAndReduce:
            return "Setting a realistic urge limit and gradually decreasing it works well for most people."
        case .quit:
            return "Having a support system significantly increases your chances of success with this goal."
        case .maintainControl:
            return "Regular check-ins and honest self-assessment are key to maintaining control."
        }
    }
}

// MARK: - Urge Limit Component
struct UrgeLimitComponent: View {
    @Binding var count: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Set a daily urge limit")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(BFColors.textPrimary)
                .padding(.leading, 4)
                .accessibilityAddTraits(.isHeader)
            
            VStack(spacing: 20) {
                // Counter display
                Text("\(count) urges per day")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(BFColors.textPrimary)
                
                // Counter controls
                HStack(spacing: 20) {
                    // Minus button
                    CircleControlButton(
                        icon: "minus",
                        action: { if count > 1 { count -= 1 } },
                        isEnabled: count > 1
                    )
                    
                    // Progress indicator
                    ZStack(alignment: .leading) {
                        // Background track
                        RoundedRectangle(cornerRadius: 2)
                            .fill(BFColors.cardBackground)
                            .frame(height: 4)
                        
                        // Fill
                        RoundedRectangle(cornerRadius: 2)
                            .fill(
                                LinearGradient(
                                    colors: [BFColors.primary, BFColors.accent],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: limitProgressWidth(count: count), height: 4)
                    }
                    .frame(height: 24)
                    
                    // Plus button
                    CircleControlButton(
                        icon: "plus",
                        action: { if count < 20 { count += 1 } },
                        isEnabled: count < 20
                    )
                }
                
                // Description based on count
                HStack {
                    Image(systemName: "info.circle")
                        .font(.system(size: 14))
                        .foregroundColor(BFColors.textSecondary)
                    
                    Text(limitDescription(for: count))
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(BFColors.textSecondary)
                }
                .padding(.top, 4)
            }
            .padding(20)
            .background(BFColors.cardBackground.opacity(0.1))
            .cornerRadius(16)
        }
    }
    
    // Calculate progress width based on count (1-20)
    private func limitProgressWidth(count: Int) -> CGFloat {
        let percentage = CGFloat(count - 1) / 19.0  // 0-1 range
        return percentage * 220  // Approximating a reasonable width
    }
    
    private func limitDescription(for count: Int) -> String {
        if count <= 5 {
            return "A low limit - great for those focused on quitting"
        } else if count <= 12 {
            return "A moderate limit - good for tracking and reduction"
        } else {
            return "A higher limit - suitable if you have frequent urges"
        }
    }
}

// MARK: - Circle Control Button
struct CircleControlButton: View {
    let icon: String
    let action: () -> Void
    let isEnabled: Bool
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(BFColors.primary)
                    .frame(width: 48, height: 48)
                    .opacity(isEnabled ? 1.0 : 0.3)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .disabled(!isEnabled)
        .accessibilityLabel(Text(icon == "plus" ? "Increase limit" : "Decrease limit"))
    }
}

// MARK: - Bottom Action Component
struct BottomActionComponent: View {
    let currentStep: Int
    let totalSteps: Int
    let buttonEnabled: Bool
    let buttonAction: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Progress indicator
            ProgressIndicator(current: currentStep, total: totalSteps)
            
            // Get Started button
            Button(action: buttonAction) {
                Text("Get Started")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            colors: buttonEnabled ? 
                                    [BFColors.primary, BFColors.primary.opacity(0.8)] : 
                                    [BFColors.textTertiary, BFColors.textTertiary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .cornerRadius(18)
                    )
                    .shadow(
                        color: buttonEnabled ? BFColors.primary.opacity(0.3) : Color.clear, 
                        radius: 8, x: 0, y: 4
                    )
            }
            .disabled(!buttonEnabled)
            .accessibilityHint("Complete setup and start tracking")
        }
        .padding(.horizontal)
        .padding(.bottom, 50)  // Extra bottom padding for safe area
        .padding(.top, 24)
        .background(
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            BFColors.background.opacity(0.0),
                            BFColors.background
                        ],
                        startPoint: .top,
                        endPoint: .center
                    )
                )
                .edgesIgnoringSafeArea(.bottom)
        )
    }
}

// MARK: - Progress Indicator
struct ProgressIndicator: View {
    let current: Int
    let total: Int
    
    var body: some View {
        VStack(spacing: 8) {
            // Progress bar
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 2)
                    .fill(BFColors.cardBackground)
                    .frame(height: 4)
                
                // Progress
                RoundedRectangle(cornerRadius: 2)
                    .fill(BFColors.primary)
                    .frame(width: progressWidth, height: 4)
            }
            
            // Step counter
            HStack {
                Spacer()
                
                Text("\(current)/\(total)")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(BFColors.textSecondary)
            }
        }
        .accessibilityLabel(Text("Step \(current) of \(total)"))
    }
    
    private var progressWidth: CGFloat {
        return UIScreen.main.bounds.width * 0.9 * (CGFloat(current) / CGFloat(total))
    }
}

// MARK: - View Model
class GoalSettingViewModel: ObservableObject {
    @Published var selectedGoal: GoalType?
    @Published var urgeLimit: Int = 10
    @Published var hasUserInteracted: Bool = false
    
    var isConfigurationValid: Bool {
        selectedGoal != nil
    }
    
    func goalSelected(_ goal: GoalType) {
        hasUserInteracted = true
        
        // Adjust urge limit based on goal type for better user experience
        switch goal {
        case .trackAndReduce:
            if urgeLimit > 15 || urgeLimit < 5 {
                urgeLimit = 10
            }
        case .quit:
            if urgeLimit > 10 {
                urgeLimit = 5
            }
        case .maintainControl:
            if urgeLimit < 5 {
                urgeLimit = 10
            }
        }
    }
    
    func quickStart() {
        // Set default configuration
        selectedGoal = .trackAndReduce
        urgeLimit = 10
        completeSetup()
    }
    
    func completeSetup() {
        // Save settings
        UserDefaults.standard.set(selectedGoal?.rawValue, forKey: "goalType")
        UserDefaults.standard.set(urgeLimit, forKey: "dailyUrgeLimit")
        
        // In a real app, we might navigate or trigger app state changes
        NotificationCenter.default.post(name: .setupCompleted, object: nil)
    }
}

// MARK: - Supporting Types
enum GoalType: String, CaseIterable {
    case trackAndReduce = "track_and_reduce"
    case quit = "quit"
    case maintainControl = "maintain_control"
}

extension Notification.Name {
    static let setupCompleted = Notification.Name("setupCompleted")
}

// Preview
#Preview {
    GoalSettingView()
} 