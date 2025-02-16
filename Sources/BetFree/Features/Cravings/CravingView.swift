import SwiftUI
import BetFreeUI
import BetFreeModels

@available(macOS 10.15, iOS 13.0, *)
public struct CravingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CravingViewModel()
    @State private var isAnimated = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    IntensityCardView(
                        selectedIntensity: $viewModel.selectedIntensity,
                        description: intensityDescription
                    )
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 20)
                    
                    TriggerCardView(
                        selectedTriggers: $viewModel.selectedTriggers,
                        toggleTrigger: viewModel.toggleTrigger
                    )
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 20)
                    
                    CopingStrategiesCardView(
                        selectedStrategies: $viewModel.selectedStrategies,
                        toggleStrategy: viewModel.toggleStrategy
                    )
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 20)
                    
                    // Submit Button
                    Button {
                        viewModel.logCraving()
                    } label: {
                        HStack {
                            if viewModel.isLoading {
                                SwiftUI.ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Log This Urge")
                                    .font(BFDesignSystem.Typography.labelLarge)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(BFDesignSystem.Colors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                    .disabled(viewModel.isLoading)
                    .padding(.horizontal)
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 20)
                }
                .padding(.vertical)
            }
            .navigationTitle("Log Urge")
            .onAppear {
                withAnimation(.spring(response: 0.6)) {
                    isAnimated = true
                }
            }
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                #else
                ToolbarItem(placement: .automatic) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                #endif
            }
            .alert("Success", isPresented: $viewModel.showSuccess) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your craving has been logged!")
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") { }
            } message: {
                Text(viewModel.error ?? "An unknown error occurred")
            }
        }
    }
    
    private var intensityDescription: String {
        switch viewModel.selectedIntensity {
        case 1: return "Mild - Barely noticeable"
        case 2: return "Light - Can easily resist"
        case 3: return "Moderate - Takes effort to resist"
        case 4: return "Strong - Very challenging"
        case 5: return "Severe - Need immediate help"
        default: return "Select intensity level"
        }
    }
}

// MARK: - Subviews
private struct IntensityCardView: View {
    @Binding var selectedIntensity: Int
    let description: String
    
    var body: some View {
        BFCard(style: .elevated, gradient: LinearGradient(
            colors: [BFDesignSystem.Colors.warning, BFDesignSystem.Colors.warning.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )) {
            VStack(spacing: 16) {
                Text("How strong is your urge?")
                    .font(BFDesignSystem.Typography.titleMedium)
                    .foregroundColor(.white)
                
                HStack(spacing: 16) {
                    ForEach(1...5, id: \.self) { intensity in
                        IntensityButton(
                            intensity: intensity,
                            isSelected: selectedIntensity == intensity
                        ) {
                            selectedIntensity = intensity
                        }
                    }
                }
                
                Text(description)
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
            }
            .padding()
        }
    }
}

private struct TriggerCardView: View {
    @Binding var selectedTriggers: Set<Trigger>
    let toggleTrigger: (Trigger) -> Void
    
    var body: some View {
        BFCard(style: .elevated) {
            VStack(alignment: .leading, spacing: 16) {
                Text("What triggered this urge?")
                    .font(BFDesignSystem.Typography.titleMedium)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(Trigger.allCases) { trigger in
                        TriggerButton(
                            trigger: trigger,
                            isSelected: selectedTriggers.contains(trigger)
                        ) {
                            toggleTrigger(trigger)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

private struct CopingStrategiesCardView: View {
    @Binding var selectedStrategies: Set<CopingStrategy>
    let toggleStrategy: (CopingStrategy) -> Void
    
    var body: some View {
        BFCard(style: .elevated, gradient: LinearGradient(
            colors: [BFDesignSystem.Colors.primary, BFDesignSystem.Colors.primary.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Try these strategies")
                    .font(BFDesignSystem.Typography.titleMedium)
                    .foregroundColor(.white)
                
                Text("Select what works for you")
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .foregroundColor(.white.opacity(0.8))
                
                VStack(spacing: 12) {
                    ForEach(CopingStrategy.allCases) { strategy in
                        StrategyButton(
                            strategy: strategy,
                            isSelected: selectedStrategies.contains(strategy)
                        ) {
                            toggleStrategy(strategy)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

private struct IntensityButton: View {
    let intensity: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text("\(intensity)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(isSelected ? BFDesignSystem.Colors.warning : .white)
            }
            .frame(width: 48, height: 48)
            .background(isSelected ? .white : .white.opacity(0.2))
            .cornerRadius(24)
        }
    }
}

private struct TriggerButton: View {
    let trigger: Trigger
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: trigger.iconName)
                Text(trigger.name)
                    .font(BFDesignSystem.Typography.labelMedium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? BFDesignSystem.Colors.primary.opacity(0.1) : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.textPrimary)
            .cornerRadius(12)
        }
    }
}

private struct StrategyButton: View {
    let strategy: CopingStrategy
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: strategy.iconName)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(strategy.rawValue)
                        .font(BFDesignSystem.Typography.bodyMedium)
                        .foregroundColor(.white)
                    
                    Text(strategy.description)
                        .font(BFDesignSystem.Typography.bodySmall)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .white : .white.opacity(0.5))
            }
            .padding()
            .background(isSelected ? Color.white.opacity(0.2) : Color.clear)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

@available(macOS 10.15, iOS 13.0, *)
@MainActor
fileprivate final class CravingViewModel: ObservableObject {
    @Published fileprivate var selectedIntensity: Int = 1
    @Published fileprivate var selectedTriggers: Set<Trigger> = []
    @Published fileprivate var selectedStrategies: Set<CopingStrategy> = []
    @Published fileprivate var isLoading = false
    @Published fileprivate var error: String?
    @Published fileprivate var showError = false
    @Published fileprivate var showSuccess = false
    
    fileprivate func toggleTrigger(_ trigger: Trigger) {
        if selectedTriggers.contains(trigger) {
            selectedTriggers.remove(trigger)
        } else {
            selectedTriggers.insert(trigger)
        }
    }
    
    fileprivate func toggleStrategy(_ strategy: CopingStrategy) {
        if selectedStrategies.contains(strategy) {
            selectedStrategies.remove(strategy)
        } else {
            selectedStrategies.insert(strategy)
        }
    }
    
    fileprivate func logCraving() {
        isLoading = true
        
        // TODO: Save craving data
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            if Int.random(in: 0...10) > 8 {
                self.error = "Failed to log craving. Please try again."
                self.showError = true
            } else {
                self.showSuccess = true
            }
        }
    }
}

private enum CopingStrategy: String, CaseIterable, Identifiable {
    case deepBreathing = "Deep Breathing"
    case physicalActivity = "Physical Activity"
    case mindfulness = "Mindfulness"
    case journaling = "Journaling"
    case talkingToAFriend = "Talking to a Friend"
    case seekingProfessionalHelp = "Seeking Professional Help"
    
    var id: String { rawValue }
    var title: String { rawValue }
    var description: String {
        switch self {
        case .deepBreathing:
            return "Take slow, deep breaths to calm your mind and body."
        case .physicalActivity:
            return "Engage in physical activity to distract yourself and release endorphins."
        case .mindfulness:
            return "Focus on the present moment and let go of cravings."
        case .journaling:
            return "Write down your thoughts and feelings to process and release them."
        case .talkingToAFriend:
            return "Reach out to a friend or loved one for support and connection."
        case .seekingProfessionalHelp:
            return "Seek help from a professional counselor or therapist."
        }
    }
    var iconName: String {
        switch self {
        case .deepBreathing:
            return "heart"
        case .physicalActivity:
            return "figure.walk"
        case .mindfulness:
            return "mindfulness"
        case .journaling:
            return "pencil.tip"
        case .talkingToAFriend:
            return "person.2"
        case .seekingProfessionalHelp:
            return "briefcase"
        }
    }
}

private enum Trigger: String, CaseIterable, Identifiable {
    case boredom = "Boredom"
    case stress = "Stress"
    case social = "Social Pressure"
    case ads = "Betting Ads"
    case money = "Money Problems"
    case wins = "Past Wins"
    case losses = "Past Losses"
    case excitement = "Need Excitement"
    
    var id: String { rawValue }
    var name: String { rawValue }
    
    var iconName: String {
        switch self {
        case .boredom: return "hourglass"
        case .stress: return "bolt.fill"
        case .social: return "person.2.fill"
        case .ads: return "megaphone.fill"
        case .money: return "dollarsign.circle.fill"
        case .wins: return "trophy.fill"
        case .losses: return "arrow.down.circle.fill"
        case .excitement: return "star.fill"
        }
    }
}

@available(macOS 10.15, iOS 13.0, *)
struct CravingView_Previews: PreviewProvider {
    static var previews: some View {
        CravingView()
    }
}
