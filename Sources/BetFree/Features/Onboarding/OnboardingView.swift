import SwiftUI
import UIKit
import ComposableArchitecture

// MARK: - Models
public struct OnboardingStep: Identifiable {
    public let id = UUID()
    public let title: String
    public let subtitle: String
    public let image: String
    public let imageColor: Color
    public let background: Color
    public let type: StepType
    
    public enum StepType {
        case welcome
        case goalSelection(options: [String])
        case situationInput(fields: [InputField])
        case supportSelection(options: [String])
        case commitmentLevel(sliders: [SliderOption])
    }
    
    public struct InputField {
        public let title: String
        public let placeholder: String
        public let keyboardType: UIKeyboardType
        public let prefix: String?
        
        public init(title: String, placeholder: String, keyboardType: UIKeyboardType, prefix: String?) {
            self.title = title
            self.placeholder = placeholder
            self.keyboardType = keyboardType
            self.prefix = prefix
        }
    }
    
    public struct SliderOption {
        public let title: String
        public let range: ClosedRange<Double>
        public let step: Double
        public let format: String
        
        public init(title: String, range: ClosedRange<Double>, step: Double, format: String) {
            self.title = title
            self.range = range
            self.step = step
            self.format = format
        }
    }
    
    public init(title: String, subtitle: String, image: String, imageColor: Color, background: Color, type: StepType) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.imageColor = imageColor
        self.background = background
        self.type = type
    }
}

// MARK: - Main View
public struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject private var appState: AppState
    
    public var body: some View {
        ZStack {
            // Background
            BFDesignSystem.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
                // Progress Header
                OnboardingProgressHeader(
                    currentStep: viewModel.currentStep,
                    totalSteps: viewModel.steps.count
                )
                
                // Content
                TabView(selection: $viewModel.currentStep) {
                    ForEach(Array(viewModel.steps.enumerated()), id: \.element.id) { index, step in
                        OnboardingStepView(
                            step: step,
                            viewModel: viewModel
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: viewModel.currentStep)
                
                // Navigation
                OnboardingNavigation(
                    currentStep: viewModel.currentStep,
                    totalSteps: viewModel.steps.count,
                    isNextEnabled: viewModel.canProceed,
                    onNext: viewModel.nextStep,
                    onBack: viewModel.previousStep
                )
            }
            .padding(.vertical, BFDesignSystem.Layout.Spacing.large)
            
            // Paywall
            if viewModel.showPaywall {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                BetFree.PaywallView(
                    isPresented: $viewModel.showPaywall,
                    onSubscribe: {
                        viewModel.completeOnboarding()
                        appState.completeOnboarding()
                    }
                )
                .transition(.move(edge: .bottom))
            }
        }
    }
    
    public init() {}
}

// MARK: - Progress Header
struct OnboardingProgressHeader: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.small)
                        .fill(BFDesignSystem.Colors.cardBackground)
                        .frame(height: 4)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.small)
                        .fill(BFDesignSystem.Colors.primary)
                        .frame(width: geometry.size.width * CGFloat(currentStep + 1) / CGFloat(totalSteps), height: 4)
                        .animation(.spring(), value: currentStep)
                }
            }
            .frame(height: 4)
            .padding(.horizontal)
            
            // Step Counter
            Text("Step \(currentStep + 1) of \(totalSteps)")
                .font(BFDesignSystem.Typography.caption)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
        }
    }
}

// MARK: - Step View
struct OnboardingStepView: View {
    let step: OnboardingStep
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.xxLarge) {
            // Header Image
            ZStack {
                Circle()
                    .fill(step.background)
                    .frame(width: BFDesignSystem.Layout.Size.progressCircleLarge, height: BFDesignSystem.Layout.Size.progressCircleLarge)
                
                Image(systemName: step.image)
                    .font(.system(size: BFDesignSystem.Layout.Size.iconLarge, weight: .medium))
                    .foregroundColor(step.imageColor)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
            .onAppear {
                isAnimating = true
            }
            .onChange(of: viewModel.currentStep) { _ in
                isAnimating = true
            }
            
            // Title & Subtitle
            VStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                Text(step.title)
                    .font(BFDesignSystem.Typography.titleLarge)
                    .multilineTextAlignment(.center)
                
                Text(step.subtitle)
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, BFDesignSystem.Layout.Spacing.large)
            }
            
            // Dynamic Content
            switch step.type {
            case .welcome:
                WelcomeStepContent()
                
            case .goalSelection(let options):
                GoalSelectionContent(
                    options: options,
                    selectedGoal: $viewModel.selectedGoal
                )
                
            case .situationInput(let fields):
                SituationInputContent(
                    fields: fields,
                    inputs: $viewModel.situationInputs
                )
                
            case .supportSelection(let options):
                SupportSelectionContent(
                    options: options,
                    selectedSupports: $viewModel.selectedSupports
                )
                
            case .commitmentLevel(let sliders):
                CommitmentLevelContent(
                    sliders: sliders,
                    commitmentLevels: $viewModel.commitmentLevels
                )
            }
        }
        .padding()
    }
}

// MARK: - Step Content Views
struct WelcomeStepContent: View {
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
            // Success Stats
            HStack(spacing: BFDesignSystem.Layout.Spacing.large) {
                BFStatCard(value: "10K+", label: "Members")
                BFStatCard(value: "87%", label: "Success Rate")
            }
            
            // Testimonial
            BFTestimonialCard(
                quote: "This app changed my life. I'm 6 months free and counting!",
                author: "John D."
            )
        }
    }
}

struct GoalSelectionContent: View {
    let options: [String]
    @Binding var selectedGoal: String?
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            ForEach(options, id: \.self) { option in
                BFSelectableCard(
                    title: option,
                    isSelected: selectedGoal == option,
                    action: { selectedGoal = option }
                )
            }
        }
    }
}

struct SituationInputContent: View {
    let fields: [OnboardingStep.InputField]
    @Binding var inputs: [String: String]
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
            ForEach(fields, id: \.title) { field in
                BFInputField(
                    title: field.title,
                    text: Binding(
                        get: { inputs[field.title] ?? "" },
                        set: { inputs[field.title] = $0 }
                    ),
                    placeholder: field.placeholder,
                    prefix: field.prefix,
                    keyboardType: field.keyboardType
                )
            }
        }
    }
}

struct SupportSelectionContent: View {
    let options: [String]
    @Binding var selectedSupports: Set<String>
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            ForEach(options, id: \.self) { option in
                BFSelectableCard(
                    title: option,
                    isSelected: selectedSupports.contains(option),
                    action: {
                        if selectedSupports.contains(option) {
                            selectedSupports.remove(option)
                        } else {
                            selectedSupports.insert(option)
                        }
                    }
                )
            }
        }
    }
}

struct CommitmentLevelContent: View {
    let sliders: [OnboardingStep.SliderOption]
    @Binding var commitmentLevels: [String: Double]
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
            ForEach(sliders, id: \.title) { slider in
                VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.small) {
                    Text(slider.title)
                        .font(BFDesignSystem.Typography.bodyMedium)
                    
                    HStack {
                        Slider(
                            value: Binding(
                                get: { commitmentLevels[slider.title] ?? slider.range.lowerBound },
                                set: { commitmentLevels[slider.title] = $0 }
                            ),
                            in: slider.range,
                            step: slider.step
                        )
                        .tint(BFDesignSystem.Colors.primary)
                        
                        Text(String(format: slider.format, commitmentLevels[slider.title] ?? slider.range.lowerBound))
                            .font(BFDesignSystem.Typography.bodyMedium)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                            .frame(width: 60)
                    }
                }
            }
        }
    }
}

// MARK: - Navigation
struct OnboardingNavigation: View {
    let currentStep: Int
    let totalSteps: Int
    let isNextEnabled: Bool
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        HStack {
            if currentStep > 0 {
                Button(action: onBack) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
            }
            
            Spacer()
            
            Button(action: onNext) {
                HStack {
                    Text(currentStep == totalSteps - 1 ? "Get Started" : "Continue")
                    Image(systemName: "chevron.right")
                }
                .font(BFDesignSystem.Typography.headlineMedium)
                .foregroundColor(.white)
                .padding(.horizontal, BFDesignSystem.Layout.Spacing.large)
                .padding(.vertical, BFDesignSystem.Layout.Spacing.medium)
                .background(
                    isNextEnabled ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.primary.opacity(0.5)
                )
                .cornerRadius(BFDesignSystem.Layout.CornerRadius.button)
            }
            .disabled(!isNextEnabled)
        }
        .padding(.horizontal)
    }
}

// MARK: - Supporting Views
public struct BFStatCard: View {
    let value: String
    let label: String
    
    public init(value: String, label: String) {
        self.value = value
        self.label = label
    }
    
    public var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.xxSmall) {
            Text(value)
                .font(BFDesignSystem.Typography.titleLarge)
                .foregroundColor(BFDesignSystem.Colors.primary)
            
            Text(label)
                .font(BFDesignSystem.Typography.bodySmall)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
        }
        .padding()
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.medium)
    }
}

public struct BFTestimonialCard: View {
    let quote: String
    let author: String
    
    public init(quote: String, author: String) {
        self.quote = quote
        self.author = author
    }
    
    public var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            Text("\u{201C}") // Using Unicode for opening quote
                .font(.system(size: 48))
                .foregroundColor(BFDesignSystem.Colors.primary)
            
            Text(quote)
                .font(BFDesignSystem.Typography.bodyLarge)
                .multilineTextAlignment(.center)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            Text("- \(author)")
                .font(BFDesignSystem.Typography.bodyMedium)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
        }
        .padding()
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.large)
    }
}

public struct BFSelectableCard: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    public init(title: String, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(isSelected ? .white : BFDesignSystem.Colors.textPrimary)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .white : BFDesignSystem.Colors.textSecondary)
            }
            .padding()
            .background(isSelected ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.cardBackground)
            .cornerRadius(BFDesignSystem.Layout.CornerRadius.medium)
            .animation(.spring(), value: isSelected)
        }
    }
}

public struct BFInputField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let prefix: String?
    let keyboardType: UIKeyboardType
    
    public init(title: String, text: Binding<String>, placeholder: String, prefix: String?, keyboardType: UIKeyboardType) {
        self.title = title
        self._text = text
        self.placeholder = placeholder
        self.prefix = prefix
        self.keyboardType = keyboardType
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: BFDesignSystem.Layout.Spacing.small) {
            Text(title)
                .font(BFDesignSystem.Typography.bodyMedium)
            
            HStack {
                if let prefix = prefix {
                    Text(prefix)
                        .font(BFDesignSystem.Typography.bodyLarge)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
                
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(BFDesignSystem.Typography.bodyLarge)
            }
        }
    }
}

// MARK: - ViewModel
class OnboardingViewModel: ObservableObject {
    @Published var currentStep = 0
    @Published var selectedGoal: String?
    @Published var situationInputs: [String: String] = [:]
    @Published var selectedSupports: Set<String> = []
    @Published var commitmentLevels: [String: Double] = [:]
    @Published var showPaywall = false
    
    let steps = [
        OnboardingStep(
            title: "Your Journey Starts Here",
            subtitle: "Join thousands of others taking control of their lives",
            image: "heart.fill",
            imageColor: BFDesignSystem.Colors.accent,
            background: BFDesignSystem.Colors.accent.opacity(0.1),
            type: .welcome
        ),
        OnboardingStep(
            title: "What's Your Goal?",
            subtitle: "Choose what matters most to you",
            image: "target",
            imageColor: BFDesignSystem.Colors.primary,
            background: BFDesignSystem.Colors.primary.opacity(0.1),
            type: .goalSelection(options: [
                "Save Money",
                "Build Better Habits",
                "Support Family",
                "Reduce Stress"
            ])
        ),
        OnboardingStep(
            title: "Your Starting Point",
            subtitle: "Understanding where you are helps us personalize your journey",
            image: "figure.walk",
            imageColor: BFDesignSystem.Colors.secondary,
            background: BFDesignSystem.Colors.secondary.opacity(0.1),
            type: .situationInput(fields: [
                .init(title: "Weekly Spend", placeholder: "Enter amount", keyboardType: .decimalPad, prefix: "$"),
                .init(title: "Main Trigger", placeholder: "e.g., Stress, Boredom", keyboardType: .default, prefix: nil)
            ])
        ),
        OnboardingStep(
            title: "You're Not Alone",
            subtitle: "Choose your support preferences",
            image: "hands.sparkles",
            imageColor: BFDesignSystem.Colors.success,
            background: BFDesignSystem.Colors.success.opacity(0.1),
            type: .supportSelection(options: [
                "Daily Check-ins",
                "Progress Tracking",
                "Community Support",
                "Expert Guidance"
            ])
        ),
        OnboardingStep(
            title: "Set Your Pace",
            subtitle: "Start with achievable goals",
            image: "chart.line.uptrend.xyaxis",
            imageColor: BFDesignSystem.Colors.info,
            background: BFDesignSystem.Colors.info.opacity(0.1),
            type: .commitmentLevel(sliders: [
                .init(title: "Daily Time Commitment (minutes)", range: 5...60, step: 5, format: "%.0f min"),
                .init(title: "Weekly Savings Goal", range: 10...500, step: 10, format: "$%.0f")
            ])
        )
    ]
    
    var canProceed: Bool {
        switch steps[currentStep].type {
        case .welcome:
            return true
        case .goalSelection:
            return selectedGoal != nil
        case .situationInput:
            return !situationInputs.isEmpty && situationInputs.values.allSatisfy { !$0.isEmpty }
        case .supportSelection:
            return !selectedSupports.isEmpty
        case .commitmentLevel:
            return !commitmentLevels.isEmpty
        }
    }
    
    func nextStep() {
        if currentStep < steps.count - 1 {
            currentStep += 1
        } else {
            showPaywall = true
        }
    }
    
    func previousStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }
    
    func completeOnboarding() {
        // Save all collected data
        // Update app state
        showPaywall = false
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState.shared)
} 