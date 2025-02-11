import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif
import ComposableArchitecture

extension Animation {
    static let defaultSpring = Animation.spring(response: 0.5, dampingFraction: 0.7)
    static func defaultSpringWithDelay(_ delay: Double) -> Animation {
        return defaultSpring.delay(delay)
    }
}

// MARK: - Main View
public struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState
    
    public var body: some View {
        ZStack {
            // Background
            BFDesignSystem.Colors.cardBackground
                .ignoresSafeArea()
            
            // Content
            if viewModel.showPaywall {
                PaywallView(isPresented: $viewModel.showPaywall) {
                    viewModel.completeOnboarding()
                }
            } else {
                OnboardingStepView(
                    step: viewModel.steps[viewModel.currentStep],
                    viewModel: viewModel
                )
            }
        }
        .onAppear {
            viewModel.appState = appState
        }
    }
    
    public init() {}
}

// MARK: - Progress Header
private struct OnboardingProgressHeader: View {
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
                        .withShadow(BFDesignSystem.Layout.Shadow.small)
                        .frame(height: 4)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.small)
                        .fill(BFDesignSystem.Colors.primaryGradient)
                        .frame(width: geometry.size.width * CGFloat(currentStep + 1) / CGFloat(totalSteps), height: 4)
                        .animation(.defaultSpring, value: currentStep)
                }
            }
            .frame(height: 4)
            .padding(.horizontal)
            
            // Step Counter
            HStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                Text("Step \(currentStep + 1)")
                    .font(BFDesignSystem.Typography.button)
                    .foregroundStyle(BFDesignSystem.Colors.primaryGradient)
                
                Text("of \(totalSteps)")
                    .font(BFDesignSystem.Typography.caption)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
            .animation(.defaultSpring, value: currentStep)
        }
    }
}

// MARK: - Step View
private struct OnboardingStepView: View {
    let step: OnboardingStep
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var isAnimating = false
    @State private var showContent = false
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.xxLarge) {
            // Progress Header
            OnboardingProgressHeader(
                currentStep: viewModel.currentStep,
                totalSteps: viewModel.steps.count
            )
            
            // Header Image
            ZStack {
                Circle()
                    .fill(step.background)
                    .frame(width: BFDesignSystem.Layout.Size.progressCircleLarge, height: BFDesignSystem.Layout.Size.progressCircleLarge)
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(isAnimating ? 1 : 0.8)
                
                Image(systemName: step.image)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [step.imageColor, step.imageColor.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(isAnimating ? 1.1 : 0.9)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(Animation.defaultSpring, value: isAnimating)
            }
            .animation(.defaultSpring, value: isAnimating)
            
            // Title & Subtitle
            VStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                Text(step.title)
                    .font(BFDesignSystem.Typography.titleLarge)
                    .foregroundStyle(BFDesignSystem.Colors.primaryGradient)
                    .multilineTextAlignment(.center)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                
                Text(step.subtitle)
                    .font(BFDesignSystem.Typography.bodyLarge)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, BFDesignSystem.Layout.Spacing.large)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
            }
            .animation(Animation.defaultSpringWithDelay(0.2), value: showContent)
            
            // Dynamic Content
            VStack {
                switch step.type {
                case .welcome:
                    WelcomeStepContent()
                
                case let .goalSelection(options):
                    GoalSelectionContent(
                        options,
                        selectedGoal: $viewModel.selectedGoal
                    )
                
                case let .situationInput(fields):
                    SituationInputContent(
                        fields,
                        inputs: $viewModel.situationInputs
                    )
                
                case let .supportSelection(options):
                    SupportSelectionContent(
                        options,
                        selectedSupports: $viewModel.selectedSupports
                    )
                
                case let .commitmentLevel(sliders):
                    CommitmentLevelContent(
                        sliders,
                        commitmentLevels: $viewModel.commitmentLevels
                    )
                }
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 30)
            .animation(Animation.defaultSpringWithDelay(0.4), value: showContent)
            
            // Navigation Buttons
            HStack {
                if viewModel.currentStep > 0 {
                    Button(action: viewModel.previousStep) {
                        HStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: BFDesignSystem.Layout.Size.iconMedium))
                            Text("Back")
                                .font(BFDesignSystem.Typography.button)
                        }
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
                
                Button(action: viewModel.nextStep) {
                    HStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                        Text(viewModel.currentStep == viewModel.steps.count - 1 ? "Get Started" : "Continue")
                            .font(BFDesignSystem.Typography.button)
                        Image(systemName: "chevron.right")
                            .font(.system(size: BFDesignSystem.Layout.Size.iconMedium))
                    }
                    .foregroundColor(.white)
                    .frame(height: BFDesignSystem.Layout.Size.buttonHeight)
                    .padding(.horizontal, BFDesignSystem.Layout.Spacing.large)
                    .background(
                        viewModel.canProceed ? 
                            BFDesignSystem.Colors.primaryGradient :
                            LinearGradient(
                                colors: [BFDesignSystem.Colors.textSecondary, BFDesignSystem.Colors.textSecondary.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                    )
                    .cornerRadius(BFDesignSystem.Layout.CornerRadius.button)
                }
                .buttonStyle(.plain)
                .disabled(!viewModel.canProceed)
            }
            .padding(.horizontal)
            .opacity(showContent ? 1 : 0)
            .animation(Animation.defaultSpringWithDelay(0.6), value: showContent)
        }
        .padding()
        .onAppear {
            isAnimating = true
            withAnimation(.defaultSpring) {
                showContent = true
            }
        }
        .onChange(of: viewModel.currentStep) { _ in
            isAnimating = true
            withAnimation(.defaultSpring) {
                showContent = true
            }
        }
    }
}

// MARK: - Step Content Views
private struct WelcomeStepContent: View {
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

private struct GoalSelectionContent: View {
    let options: [String]
    @Binding var selectedGoal: String?
    
    init(_ options: [String], selectedGoal: Binding<String?>) {
        self.options = options
        self._selectedGoal = selectedGoal
    }
    
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

private struct SituationInputContent: View {
    let fields: [OnboardingStep.InputField]
    @Binding var inputs: [String: String]
    
    init(_ fields: [OnboardingStep.InputField], inputs: Binding<[String: String]>) {
        self.fields = fields
        self._inputs = inputs
    }
    
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

private struct SupportSelectionContent: View {
    let options: [String]
    @Binding var selectedSupports: Set<String>
    
    init(_ options: [String], selectedSupports: Binding<Set<String>>) {
        self.options = options
        self._selectedSupports = selectedSupports
    }
    
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

private struct CommitmentLevelContent: View {
    let sliders: [OnboardingStep.SliderOption]
    @Binding var commitmentLevels: [String: Double]
    
    init(_ sliders: [OnboardingStep.SliderOption], commitmentLevels: Binding<[String: Double]>) {
        self.sliders = sliders
        self._commitmentLevels = commitmentLevels
    }
    
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
                            .font(BFDesignSystem.Typography.bodyLargeMedium)
                            .foregroundColor(BFDesignSystem.Colors.textSecondary)
                            .frame(width: 60)
                    }
                }
            }
        }
    }
}

// MARK: - Navigation
private struct OnboardingNavigation: View {
    let currentStep: Int
    let totalSteps: Int
    let isNextEnabled: Bool
    let onNext: () -> Void
    let onBack: () -> Void
    @State private var isNextHovered = false
    @State private var isBackHovered = false
    
    var body: some View {
        HStack {
            if currentStep > 0 {
                Button(action: onBack) {
                    HStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: BFDesignSystem.Layout.Size.iconMedium))
                        Text("Back")
                            .font(BFDesignSystem.Typography.button)
                    }
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    .scaleEffect(isBackHovered ? 1.05 : 1.0)
                }
                .buttonStyle(.plain)
                .onHover { hovering in
                    withAnimation(.defaultSpring) {
                        isBackHovered = hovering
                    }
                }
            }
            
            Spacer()
            
            Button(action: onNext) {
                HStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                    Text(currentStep == totalSteps - 1 ? "Get Started" : "Continue")
                        .font(BFDesignSystem.Typography.button)
                    Image(systemName: "chevron.right")
                        .font(.system(size: BFDesignSystem.Layout.Size.iconMedium))
                }
                .foregroundColor(.white)
                .frame(height: BFDesignSystem.Layout.Size.buttonHeight)
                .padding(.horizontal, BFDesignSystem.Layout.Spacing.large)
                .background(
                    isNextEnabled ? 
                        LinearGradient(
                            colors: [BFDesignSystem.Colors.primary, BFDesignSystem.Colors.primary.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [BFDesignSystem.Colors.textSecondary, BFDesignSystem.Colors.textSecondary.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                )
                .cornerRadius(BFDesignSystem.Layout.CornerRadius.button)
                .withShadow(isNextEnabled ? BFDesignSystem.Layout.Shadow.button : BFDesignSystem.Layout.Shadow.small)
                .scaleEffect(isNextHovered && isNextEnabled ? 1.05 : 1.0)
            }
            .buttonStyle(.plain)
            .disabled(!isNextEnabled)
            .onHover { hovering in
                withAnimation(.defaultSpring) {
                    isNextHovered = hovering
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Paywall Components
private struct OnboardingPaywallView: View {
    @Binding var isPresented: Bool
    let onSubscribe: () -> Void
    @State private var isAnimating = false
    @State private var showFeatures = false
    @State private var showButtons = false
    @State private var selectedPlan = 1 // 0: Monthly, 1: Annual
    
    let plans = [
        (name: "Monthly", price: "$9.99", period: "month", savings: ""),
        (name: "Annual", price: "$79.99", period: "year", savings: "Save 33%")
    ]
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.large) {
            PaywallHeaderView(isAnimating: isAnimating)
            PaywallSocialProofView(showFeatures: showFeatures)
            
            // Features
            VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                ForEach(Array(["chart.line.uptrend.xyaxis", "target", "bell", "sparkles"].enumerated()), id: \.0) { index, icon in
                    FeatureRow(
                        icon: icon,
                        text: [
                            "Personalized Progress Tracking",
                            "Custom Goal Setting",
                            "Smart Reminders",
                            "Premium Resources"
                        ][index]
                    )
                    .offset(x: showFeatures ? 0 : -50)
                    .opacity(showFeatures ? 1 : 0)
                    .animation(
                        Animation.spring(response: 0.5, dampingFraction: 0.7)
                            .delay(Double(index) * 0.1),
                        value: showFeatures
                    )
                }
            }
            .padding(.vertical, BFDesignSystem.Layout.Spacing.large)
            
            // Plan Selection
            HStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                ForEach(0..<2) { index in
                    PaywallPlanView(
                        plan: plans[index],
                        isSelected: selectedPlan == index
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedPlan = index
                        }
                    }
                }
            }
            .opacity(showButtons ? 1 : 0)
            
            // Action Buttons
            VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        onSubscribe()
                    }
                }) {
                    Text("Start Free Trial")
                        .font(BFDesignSystem.Typography.button)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: BFDesignSystem.Layout.Size.buttonHeight)
                        .background(BFDesignSystem.Colors.calmingGradient)
                        .cornerRadius(BFDesignSystem.Layout.CornerRadius.button)
                        .withShadow(BFDesignSystem.Layout.Shadow.button)
                }
                .scaleEffect(showButtons ? 1 : 0.8)
                .opacity(showButtons ? 1 : 0)
                
                // Money Back Guarantee
                HStack(spacing: BFDesignSystem.Layout.Spacing.small) {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundColor(BFDesignSystem.Colors.success)
                    Text("30-day money-back guarantee")
                        .font(BFDesignSystem.Typography.caption)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
                .opacity(showButtons ? 1 : 0)
                
                // Terms
                Text("7-day free trial, then \(plans[selectedPlan].price)/\(plans[selectedPlan].period). Cancel anytime.")
                    .font(BFDesignSystem.Typography.caption)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .opacity(showButtons ? 1 : 0)
                
                // Dismiss Button
                Button("Maybe Later") {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        isPresented = false
                    }
                }
                .font(BFDesignSystem.Typography.button)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .opacity(showButtons ? 1 : 0)
                .padding(.top, BFDesignSystem.Layout.Spacing.medium)
            }
        }
        .padding(BFDesignSystem.Layout.Spacing.xxLarge)
        .background(BFDesignSystem.Colors.cardBackground)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.xLarge)
        .withShadow(BFDesignSystem.Layout.Shadow.large)
        .padding(.horizontal, BFDesignSystem.Layout.Spacing.large)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isAnimating = true
            }
            
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.3)) {
                showFeatures = true
            }
            
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.6)) {
                showButtons = true
            }
        }
    }
}

private struct PaywallHeaderView: View {
    let isAnimating: Bool
    
    var body: some View {
        VStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            Text("Transform Your Life")
                .font(BFDesignSystem.Typography.display)
                .foregroundStyle(BFDesignSystem.Colors.calmingGradient)
                .multilineTextAlignment(.center)
                .scaleEffect(isAnimating ? 1 : 0.8)
                .opacity(isAnimating ? 1 : 0)
            
            Text("Join thousands who have reclaimed control")
                .font(BFDesignSystem.Typography.titleSmall)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .scaleEffect(isAnimating ? 1 : 0.8)
                .opacity(isAnimating ? 1 : 0)
        }
        .padding(.top, BFDesignSystem.Layout.Spacing.xxLarge)
    }
}

private struct PaywallSocialProofView: View {
    let showFeatures: Bool
    
    var body: some View {
        HStack(spacing: BFDesignSystem.Layout.Spacing.large) {
            StatItem(value: "10K+", label: "Members", gradient: BFDesignSystem.Colors.calmingGradient)
            StatItem(value: "87%", label: "Success Rate", gradient: BFDesignSystem.Colors.warmGradient)
            StatItem(value: "4.9★", label: "App Rating", gradient: BFDesignSystem.Colors.mindfulGradient)
        }
        .opacity(showFeatures ? 1 : 0)
        .offset(y: showFeatures ? 0 : 20)
    }
    
    private struct StatItem: View {
        let value: String
        let label: String
        let gradient: LinearGradient
        
        var body: some View {
            VStack {
                Text(value)
                    .font(BFDesignSystem.Typography.titleLarge)
                    .foregroundStyle(gradient)
                Text(label)
                    .font(BFDesignSystem.Typography.caption)
                    .foregroundColor(BFDesignSystem.Colors.textSecondary)
            }
        }
    }
}

private struct PaywallPlanView: View {
    let plan: (name: String, price: String, period: String, savings: String)
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        VStack {
            Text(plan.name)
                .font(BFDesignSystem.Typography.bodyLargeMedium)
            Text(plan.price)
                .font(BFDesignSystem.Typography.titleLarge)
            Text("per \(plan.period)")
                .font(BFDesignSystem.Typography.caption)
            if !plan.savings.isEmpty {
                Text(plan.savings)
                    .font(BFDesignSystem.Typography.caption)
                    .foregroundColor(BFDesignSystem.Colors.success)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.medium)
                .fill(isSelected ? BFDesignSystem.Colors.calmingGradient : LinearGradient(
                    colors: [BFDesignSystem.Colors.cardBackground, BFDesignSystem.Colors.cardBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
        )
        .foregroundColor(isSelected ? .white : BFDesignSystem.Colors.textPrimary)
        .onTapGesture(perform: action)
    }
}

private struct FeatureRow: View {
    let icon: String
    let text: String
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: BFDesignSystem.Layout.Spacing.medium) {
            Image(systemName: icon)
                .font(.system(size: BFDesignSystem.Layout.Size.iconLarge))
                .foregroundStyle(BFDesignSystem.Colors.primaryGradient)
                .frame(width: BFDesignSystem.Layout.Size.iconXLarge)
                .scaleEffect(isHovered ? 1.1 : 1.0)
                .animation(Animation.defaultSpring, value: isHovered)
            
            Text(text)
                .font(BFDesignSystem.Typography.bodyLarge)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
            
            Spacer()
        }
        .padding(BFDesignSystem.Layout.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: BFDesignSystem.Layout.CornerRadius.medium)
                .fill(BFDesignSystem.Colors.cardBackground)
                .withShadow(isHovered ? BFDesignSystem.Layout.Shadow.medium : BFDesignSystem.Layout.Shadow.small)
        )
        .onHover { hovering in
            withAnimation(Animation.defaultSpring) {
                isHovered = hovering
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
} 