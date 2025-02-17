import SwiftUI
import BetFreeUI
import BetFreeModels

@available(macOS 10.15, iOS 13.0, *)
public struct CravingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CravingViewModel()
    @State private var isAnimated = false
    @State private var currentStep = 0
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress Steps
                HStack(spacing: 4) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(getStepColor(for: index))
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentStep == index ? 1.2 : 1.0)
                    }
                }
                .padding(.top)
                .opacity(isAnimated ? 1 : 0)
                
                // Step Content
                TabView(selection: $currentStep) {
                    // Step 1: Intensity
                    IntensityView(
                        selectedIntensity: Binding(
                            get: { viewModel.selectedIntensity },
                            set: { viewModel.setIntensity($0) }
                        ),
                        description: intensityDescription,
                        onNext: { currentStep = 1 }
                    )
                    .tag(0)
                    
                    // Step 2: Triggers
                    TriggerView(
                        selectedTriggers: Binding(
                            get: { viewModel.selectedTriggers },
                            set: { _ in }
                        ),
                        toggleTrigger: viewModel.toggleTrigger,
                        onNext: { currentStep = 2 },
                        onBack: { currentStep = 0 }
                    )
                    .tag(1)
                    
                    // Step 3: Strategies
                    StrategyView(
                        selectedStrategies: Binding(
                            get: { viewModel.selectedStrategies },
                            set: { _ in }
                        ),
                        toggleStrategy: viewModel.toggleStrategy,
                        isLoading: viewModel.isLoading,
                        onSubmit: {
                            Task {
                                await viewModel.logCraving()
                            }
                        },
                        onBack: { currentStep = 1 }
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentStep)
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                withAnimation(.spring(response: 0.6)) {
                    isAnimated = true
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        if !viewModel.isLoading {
                            dismiss()
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .alert("Success", isPresented: $viewModel.showSuccess) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your craving has been logged! Keep going, you're doing great!")
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") { }
            } message: {
                Text(viewModel.error ?? "An unknown error occurred")
            }
        }
    }
    
    private var navigationTitle: String {
        switch currentStep {
        case 0: return "How Strong?"
        case 1: return "What Triggered It?"
        case 2: return "Coping Strategies"
        default: return "Log Urge"
        }
    }
    
    private func getStepColor(for index: Int) -> Color {
        if index < currentStep {
            return BFDesignSystem.Colors.success
        } else if index == currentStep {
            return BFDesignSystem.Colors.primary
        } else {
            return BFDesignSystem.Colors.primary.opacity(0.3)
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

// MARK: - Step Views
private struct IntensityView: View {
    @Binding var selectedIntensity: Int
    let description: String
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.xxLarge) {
            // Title and Description
            VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                Text("Rate Your Urge")
                    .font(BFDesignSystem.Typography.displayMedium)
                    .foregroundStyle(BFDesignSystem.Colors.warning)
                    .multilineTextAlignment(.center)
                
                Text("How strong is your urge to bet right now?")
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, BFDesignSystem.Layout.Spacing.xxLarge)
            
            // Intensity Scale
            VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
                // Intensity Buttons
                HStack(spacing: BFDesignSystem.Layout.Spacing.large) {
                    ForEach(1...5, id: \.self) { intensity in
                        IntensityButton(
                            intensity: intensity,
                            isSelected: selectedIntensity == intensity
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                selectedIntensity = intensity
                            }
                        }
                    }
                }
                
                // Description
                Text(description)
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, BFDesignSystem.Layout.Spacing.xxLarge)
                    .opacity(selectedIntensity >= 1 ? 1 : 0)
                    .animation(.easeInOut, value: selectedIntensity)
            }
            
            Spacer()
            
            // Next Button
            Button(action: onNext) {
                Text("Continue")
                    .font(BFDesignSystem.Typography.labelLarge)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedIntensity >= 1 ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.primary.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }
            .disabled(selectedIntensity < 1)
            .padding(.horizontal)
            .padding(.bottom, BFDesignSystem.Layout.Spacing.large)
        }
        .padding()
    }
}

private struct TriggerView: View {
    @Binding var selectedTriggers: Set<Trigger>
    let toggleTrigger: (Trigger) -> Void
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
            // Title and Description
            VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                Text("What Triggered It?")
                    .font(BFDesignSystem.Typography.displayMedium)
                    .foregroundStyle(BFDesignSystem.Colors.primary)
                    .multilineTextAlignment(.center)
                
                Text("Select all that apply")
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, BFDesignSystem.Layout.Spacing.large)
            
            // Triggers Grid
            ScrollView(showsIndicators: false) {
                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: BFDesignSystem.Layout.Spacing.medium
                ) {
                    ForEach(Trigger.allCases) { trigger in
                        TriggerButton(
                            trigger: trigger,
                            isSelected: selectedTriggers.contains(trigger)
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                toggleTrigger(trigger)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // Navigation Buttons
            HStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                Button(action: onBack) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(BFDesignSystem.Typography.labelLarge)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(BFDesignSystem.Colors.textPrimary)
                    .cornerRadius(16)
                }
                
                Button(action: onNext) {
                    HStack {
                        Text("Continue")
                        Image(systemName: "chevron.right")
                    }
                    .font(BFDesignSystem.Typography.labelLarge)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(!selectedTriggers.isEmpty ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.primary.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
                .disabled(selectedTriggers.isEmpty)
            }
            .padding(.horizontal)
            .padding(.bottom, BFDesignSystem.Layout.Spacing.large)
        }
    }
}

private struct StrategyView: View {
    @Binding var selectedStrategies: Set<CopingStrategy>
    let toggleStrategy: (CopingStrategy) -> Void
    let isLoading: Bool
    let onSubmit: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
            // Title and Description
            VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                Text("Coping Strategies")
                    .font(BFDesignSystem.Typography.displayMedium)
                    .foregroundStyle(BFDesignSystem.Colors.success)
                    .multilineTextAlignment(.center)
                
                Text("Choose strategies that can help you resist")
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, BFDesignSystem.Layout.Spacing.large)
            
            // Strategies List
            ScrollView(showsIndicators: false) {
                VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                    ForEach(CopingStrategy.allCases) { strategy in
                        StrategyButton(
                            strategy: strategy,
                            isSelected: selectedStrategies.contains(strategy)
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                toggleStrategy(strategy)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // Navigation Buttons
            HStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                Button(action: onBack) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(BFDesignSystem.Typography.labelLarge)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(BFDesignSystem.Colors.textPrimary)
                    .cornerRadius(16)
                }
                
                Button(action: onSubmit) {
                    HStack {
                        if isLoading {
                            SwiftUI.ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Submit")
                            Image(systemName: "checkmark")
                        }
                    }
                    .font(BFDesignSystem.Typography.labelLarge)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(!selectedStrategies.isEmpty ? BFDesignSystem.Colors.success : BFDesignSystem.Colors.success.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
                .disabled(selectedStrategies.isEmpty || isLoading)
            }
            .padding(.horizontal)
            .padding(.bottom, BFDesignSystem.Layout.Spacing.large)
        }
    }
}

// MARK: - Subviews
private struct IntensityButton: View {
    let intensity: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text("\(intensity)")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(isSelected ? BFDesignSystem.Colors.warning : .white)
            }
            .frame(width: 60, height: 60)
            .background(isSelected ? .white : .white.opacity(0.2))
            .cornerRadius(30)
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .animation(.spring(response: 0.3), value: isSelected)
        }
    }
}

private struct TriggerButton: View {
    let trigger: Trigger
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                Image(systemName: trigger.iconName)
                    .font(.system(size: 24))
                Text(trigger.name)
                    .font(BFDesignSystem.Typography.bodyMedium)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSelected ? BFDesignSystem.Colors.primary.opacity(0.1) : Color.gray.opacity(0.05))
            .foregroundColor(isSelected ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.textPrimary)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? BFDesignSystem.Colors.primary : Color.clear, lineWidth: 2)
            )
        }
    }
}

private struct StrategyButton: View {
    let strategy: CopingStrategy
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                Image(systemName: strategy.iconName)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? BFDesignSystem.Colors.success : BFDesignSystem.Colors.textSecondary)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(strategy.rawValue)
                        .font(BFDesignSystem.Typography.bodyLarge)
                        .foregroundColor(BFDesignSystem.Colors.textPrimary)
                    
                    Text(strategy.description)
                        .font(BFDesignSystem.Typography.bodySmall)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? BFDesignSystem.Colors.success : BFDesignSystem.Colors.textSecondary)
            }
            .padding()
            .background(isSelected ? BFDesignSystem.Colors.success.opacity(0.1) : Color.gray.opacity(0.05))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? BFDesignSystem.Colors.success : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

@available(macOS 10.15, iOS 13.0, *)
struct CravingView_Previews: PreviewProvider {
    static var previews: some View {
        CravingView()
    }
}
