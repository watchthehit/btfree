import SwiftUI
import BetFreeUI
import BetFreeModels

@available(macOS 10.15, iOS 13.0, *)
public struct CravingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CravingViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    intensitySection
                    triggersSection
                    copingStrategiesSection
                    submitButton
                }
                .padding()
            }
            .navigationTitle("Log Craving")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
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
    
    private var intensitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How strong is your craving?")
                .font(.title)
            
            Text("Rate the intensity from 1-10")
                .font(.body)
                .foregroundColor(.secondary)
            
            Slider(value: $viewModel.intensity, in: 1...10, step: 1)
                .tint(viewModel.intensityColor)
            
            HStack {
                Text("1")
                Spacer()
                Text(String(format: "%.0f", viewModel.intensity))
                    .foregroundColor(viewModel.intensityColor)
                Spacer()
                Text("10")
            }
            .font(.callout)
            
            Text(viewModel.intensityDescription)
                .font(.body)
                .foregroundColor(viewModel.intensityColor)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var triggersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What triggered this craving?")
                .font(.title)
                .foregroundColor(.primary)
            
            Text("Select all that apply")
                .font(.body)
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(CravingTrigger.allCases) { trigger in
                    TriggerButton(
                        trigger: trigger,
                        isSelected: viewModel.selectedTriggers.contains(trigger)
                    ) {
                        viewModel.toggleTrigger(trigger)
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var copingStrategiesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Try these coping strategies")
                .font(.title)
                .foregroundColor(.primary)
            
            Text("Select what works for you")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                ForEach(CopingStrategy.allCases) { strategy in
                    StrategyButton(
                        strategy: strategy,
                        isSelected: viewModel.selectedStrategies.contains(strategy)
                    ) {
                        viewModel.toggleStrategy(strategy)
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var submitButton: some View {
        Button(action: {
            viewModel.logCraving()
        }) {
            if viewModel.isLoading {
                SwiftUI.ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                Text("Submit")
            }
        }
        .buttonStyle(.borderedProminent)
        .disabled(viewModel.isLoading)
        .padding(.horizontal)
    }
}

@available(macOS 10.15, iOS 13.0, *)
fileprivate struct TriggerButton: View {
    let trigger: CravingTrigger
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: trigger.iconName)
                Text(trigger.name)
                    .font(.body)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? Color.primary : Color.gray.opacity(0.5),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

@available(macOS 10.15, iOS 13.0, *)
fileprivate struct StrategyButton: View {
    let strategy: CopingStrategy
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: strategy.iconName)
                    .foregroundColor(isSelected ? Color.green : Color.blue)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(strategy.rawValue)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    Text(strategy.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? Color.green : Color.gray.opacity(0.5))
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

@available(macOS 10.15, iOS 13.0, *)
@MainActor
fileprivate final class CravingViewModel: ObservableObject {
    @Published fileprivate var intensity: Double = 5
    @Published fileprivate var selectedTriggers: Set<CravingTrigger> = []
    @Published fileprivate var selectedStrategies: Set<CopingStrategy> = []
    @Published fileprivate var isLoading = false
    @Published fileprivate var error: String?
    @Published fileprivate var showError = false
    @Published fileprivate var showSuccess = false
    
    fileprivate var intensityColor: Color {
        switch intensity {
        case 1...3:
            return Color.green
        case 4...7:
            return Color.blue
        default:
            return Color.red
        }
    }
    
    fileprivate var intensityDescription: String {
        switch intensity {
        case 1...3:
            return "Mild craving - You've got this!"
        case 4...7:
            return "Moderate craving - Try some coping strategies"
        default:
            return "Strong craving - Use multiple strategies"
        }
    }
    
    fileprivate func toggleTrigger(_ trigger: CravingTrigger) {
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

private enum CravingTrigger: String, CaseIterable, Identifiable {
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
