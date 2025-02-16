import SwiftUI
import BetFreeUI
import BetFreeModels

public struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var showPaywall = false
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Progress indicator
                SwiftUI.ProgressView(value: viewModel.progress)
                    .tint(.blue)
                    .padding(.horizontal)
                
                // Content
                ScrollView {
                    VStack(spacing: 16) {
                        switch viewModel.currentStep {
                        case .welcome:
                            welcomeStep
                        case .sports:
                            sportsStep
                        case .goals:
                            goalsStep
                        case .paywall:
                            paywallStep
                        }
                    }
                    .padding()
                }
                
                // Navigation buttons
                VStack(spacing: 16) {
                    if viewModel.currentStep != .welcome {
                        Button("Back") {
                            viewModel.previousStep()
                        }
                        .buttonStyle(.bordered)
                        .padding([.horizontal, .bottom])
                    }
                    
                    Button(viewModel.currentStep == .paywall ? "Complete" : "Continue") {
                        if viewModel.currentStep == .paywall {
                            viewModel.completeOnboarding()
                        } else {
                            viewModel.nextStep()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
        }
        #if os(iOS)
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView()
        }
        #else
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        #endif
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text("Error"), message: Text(viewModel.error ?? ""), dismissButton: .default(Text("OK")))
        }
    }
    
    private var welcomeStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Welcome to BetFree!")
                .font(.title)
                .foregroundColor(.primary)
            
            Text("Let's get started by learning a bit about you.")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    private var sportsStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Which sports do you bet on?")
                .font(.title)
                .foregroundColor(.primary)
            
            Text("Select all that apply.")
                .font(.body)
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(Sport.allCases) { sport in
                    SportButton(
                        sport: sport,
                        isSelected: viewModel.selectedSports.contains(sport),
                        action: { viewModel.toggleSport(sport) }
                    )
                }
            }
        }
    }
    
    private var goalsStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What are your betting goals?")
                .font(.title)
                .foregroundColor(.primary)
            
            Text("Add your goals below")
                .font(.body)
                .foregroundColor(.secondary)
            
            ForEach(viewModel.goals.indices, id: \.self) { index in
                HStack {
                    TextField("Goal \(index + 1)", text: .init(get: { viewModel.goals[index] }, set: { viewModel.goals[index] = $0 }))
                        .textFieldStyle(.roundedBorder)
                    Button(action: { viewModel.removeGoal(at: index) }) {
                        Image(systemName: "minus.circle")
                    }
                }
            }
            
            Button(action: { viewModel.addGoal("") }) {
                Image(systemName: "plus.circle")
                Text("Add goal")
            }
        }
    }
    
    private var paywallStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Get Full Access")
                .font(.title)
                .foregroundColor(.primary)
            
            Text("Unlock premium features to help you achieve your goals.")
                .font(.body)
                .foregroundColor(.secondary)
            
            // Feature list
            VStack(alignment: .leading, spacing: 12) {
                FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Track your progress")
                FeatureRow(icon: "brain.head.profile", text: "Access coping strategies")
                FeatureRow(icon: "bell.badge.fill", text: "Get personalized reminders")
                FeatureRow(icon: "lock.shield.fill", text: "Block gambling apps")
            }
            
            Spacer()
            
            Button(action: {
                // Handle subscription
            }) {
                Text("Subscribe Now")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)
            
            Button(action: {
                // Handle restore purchase
            }) {
                Text("Restore Purchase")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
            .padding(.vertical)
        }
    }
}

private struct SportButton: View {
    let sport: Sport
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: sport.iconName)
                Text(sport.name)
                    .font(.body)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? .blue.opacity(0.1) : .white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                isSelected ? .blue : .gray.opacity(0.2),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

private struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .welcome
    @Published var selectedSports: Set<Sport> = []
    @Published var goals: [String] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var showError = false
    
    var progress: Double {
        Double(currentStep.rawValue) / Double(OnboardingStep.allCases.count - 1)
    }
    
    func nextStep() {
        if let nextIndex = OnboardingStep(rawValue: currentStep.rawValue + 1) {
            currentStep = nextIndex
        }
    }
    
    func previousStep() {
        if let prevIndex = OnboardingStep(rawValue: currentStep.rawValue - 1) {
            currentStep = prevIndex
        }
    }
    
    func toggleSport(_ sport: Sport) {
        if selectedSports.contains(sport) {
            selectedSports.remove(sport)
        } else {
            selectedSports.insert(sport)
        }
    }
    
    func addGoal(_ goal: String) {
        goals.append(goal)
    }
    
    func removeGoal(at index: Int) {
        goals.remove(at: index)
    }
    
    func completeOnboarding() {
        isLoading = true
        
        // TODO: Save onboarding data
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            if Int.random(in: 0...10) > 8 {
                self.error = "Failed to save onboarding data. Please try again."
                self.showError = true
            }
        }
    }
}
