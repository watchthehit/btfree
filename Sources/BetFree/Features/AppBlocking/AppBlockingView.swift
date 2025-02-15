import SwiftUI
import StoreKit

public struct AppBlockingView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState
    @State private var showingScreenTimeSettings = false
    @State private var currentStep = 0
    
    private let steps = [
        BlockingStep(
            title: "Enable Screen Time",
            description: "First, we'll set up app limits using Screen Time",
            icon: "hourglass",
            action: .screenTime
        ),
        BlockingStep(
            title: "Block Betting Apps",
            description: "Set app limits for betting apps to 0 minutes",
            icon: "hand.raised.fill",
            action: .appLimits
        ),
        BlockingStep(
            title: "Block Safari Betting",
            description: "Add content restrictions for betting websites",
            icon: "globe.slash",
            action: .webRestrictions
        ),
        BlockingStep(
            title: "Set Up Password",
            description: "Create a Screen Time password to prevent changes",
            icon: "lock.fill",
            action: .password
        )
    ]
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Progress indicator
                ProgressCircle(progress: Double(currentStep) / Double(steps.count - 1))
                    .frame(width: 60, height: 60)
                
                // Current step
                if currentStep < steps.count {
                    let step = steps[currentStep]
                    
                    VStack(spacing: 16) {
                        Image(systemName: step.icon)
                            .font(.system(size: 48))
                            .foregroundColor(BFDesignSystem.Colors.primary)
                        
                        Text(step.title)
                            .font(BFDesignSystem.Typography.titleLarge)
                        
                        Text(step.description)
                            .font(BFDesignSystem.Typography.bodyMedium)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                    
                    Button {
                        handleStepAction(step.action)
                    } label: {
                        Text("Continue")
                            .font(BFDesignSystem.Typography.labelLarge)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(BFDesignSystem.Colors.primary)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                } else {
                    // Completion view
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 64))
                            .foregroundColor(BFDesignSystem.Colors.success)
                        
                        Text("All Set!")
                            .font(BFDesignSystem.Typography.titleLarge)
                        
                        Text("Betting apps have been blocked. Stay strong!")
                            .font(BFDesignSystem.Typography.bodyMedium)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Button {
                            appState.hasBlockedApps = true
                            dismiss()
                        } label: {
                            Text("Done")
                                .font(BFDesignSystem.Typography.labelLarge)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(BFDesignSystem.Colors.success)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Block Betting Apps")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingScreenTimeSettings) {
                ScreenTimeSettingsView()
            }
        }
    }
    
    private func handleStepAction(_ action: BlockingStepAction) {
        switch action {
        case .screenTime:
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        case .appLimits:
            showingScreenTimeSettings = true
        case .webRestrictions:
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        case .password:
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        
        // Advance to next step
        withAnimation {
            currentStep += 1
        }
    }
}

private struct BlockingStep {
    let title: String
    let description: String
    let icon: String
    let action: BlockingStepAction
}

private enum BlockingStepAction {
    case screenTime
    case appLimits
    case webRestrictions
    case password
}

private struct ProgressCircle: View {
    let progress: Double
    
    var body: some View {
        Circle()
            .stroke(BFDesignSystem.Colors.primary.opacity(0.2), lineWidth: 8)
            .overlay(
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(BFDesignSystem.Colors.primary, lineWidth: 8)
                    .rotationEffect(.degrees(-90))
            )
    }
}

private struct ScreenTimeSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(commonBettingApps, id: \.name) { app in
                        HStack {
                            Image(systemName: "app.fill")
                                .foregroundColor(app.color)
                            Text(app.name)
                            Spacer()
                            Text("Block")
                                .foregroundColor(BFDesignSystem.Colors.error)
                        }
                    }
                } header: {
                    Text("Common Betting Apps")
                }
                
                Section {
                    Button("Open Screen Time Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                        dismiss()
                    }
                } footer: {
                    Text("Set app limits to 0 minutes for betting apps")
                }
            }
            .navigationTitle("Block Apps")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private let commonBettingApps = [
        BettingApp(name: "DraftKings", color: .green),
        BettingApp(name: "FanDuel", color: .blue),
        BettingApp(name: "BetMGM", color: .orange),
        BettingApp(name: "Caesars", color: .purple),
        BettingApp(name: "PointsBet", color: .red)
    ]
}

private struct BettingApp {
    let name: String
    let color: Color
}
