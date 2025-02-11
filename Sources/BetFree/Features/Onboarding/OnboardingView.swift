import SwiftUI

public struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @State private var username: String = ""
    @State private var dailyLimit: String = ""
    @State private var currentStep = 0
    
    public var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Progress indicators
            HStack {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(currentStep >= index ? BFDesignSystem.Colors.primary : .gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                }
            }
            
            // Content
            switch currentStep {
            case 0:
                welcomeStep
            case 1:
                usernameStep
            case 2:
                dailyLimitStep
            default:
                EmptyView()
            }
            
            Spacer()
            
            // Navigation buttons
            HStack {
                if currentStep > 0 {
                    Button("Back") {
                        withAnimation {
                            currentStep -= 1
                        }
                    }
                }
                
                Spacer()
                
                Button(currentStep == 2 ? "Get Started" : "Next") {
                    withAnimation {
                        if currentStep == 2 {
                            completeOnboarding()
                        } else {
                            currentStep += 1
                        }
                    }
                }
                .disabled(isNextDisabled)
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    private var welcomeStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.fill")
                .font(.system(size: 60))
                .foregroundColor(BFDesignSystem.Colors.primary)
            
            Text("Welcome to BetFree")
                .font(.title)
                .bold()
            
            Text("Your journey to responsible gaming starts here")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
    }
    
    private var usernameStep: some View {
        VStack(spacing: 20) {
            Text("What should we call you?")
                .font(.title2)
                .bold()
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
        }
    }
    
    private var dailyLimitStep: some View {
        VStack(spacing: 20) {
            Text("Set Your Daily Limit")
                .font(.title2)
                .bold()
            
            TextField("Amount ($)", text: $dailyLimit)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                #if os(iOS)
                .keyboardType(.decimalPad)
                #endif
                .padding([.leading, .trailing])
            
            Text("You can always change this later")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var isNextDisabled: Bool {
        switch currentStep {
        case 1:
            return username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 2:
            return dailyLimit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        default:
            return false
        }
    }
    
    private func completeOnboarding() {
        appState.updateUsername(username)
        if let limit = Double(dailyLimit) {
            appState.updateDailyLimit(limit)
        }
        appState.completeOnboarding()
    }
    
    public init() {}
} 