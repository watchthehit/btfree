import SwiftUI

public struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var storeManager = BFStoreManager.shared
    @State private var currentStep = 0
    @State private var showingPaywall = false
    @State private var name = ""
    @State private var typicalBetAmount = ""
    @State private var selectedSports: Set<String> = []
    
    private let sports = ["Football", "Basketball", "Baseball", "Hockey", "Soccer", "Tennis", "Golf", "MMA/Boxing", "Other"]
    
    public var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $currentStep) {
                    // Welcome
                    welcomeView()
                        .tag(0)
                    
                    // Name
                    nameView()
                        .tag(1)
                    
                    // Typical Bet
                    typicalBetView()
                        .tag(2)
                    
                    // Sports
                    sportsView()
                        .tag(3)
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                // Navigation
                HStack {
                    if currentStep > 0 {
                        Button("Back") {
                            withAnimation {
                                currentStep -= 1
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(currentStep == 3 ? "Start" : "Next") {
                        if currentStep < 3 {
                            withAnimation {
                                currentStep += 1
                            }
                        } else {
                            completeOnboarding()
                        }
                    }
                    .buttonStyle(BFPrimaryButtonStyle())
                }
                .padding()
            }
            .navigationTitle("Welcome to BetFree")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView {
                appState.isOnboarded = true
            }
        }
    }
    
    private func welcomeView() -> some View {
        VStack(spacing: 24) {
            Image(systemName: "shield.fill")
                .font(.system(size: 64))
                .foregroundColor(BFDesignSystem.Colors.primary)
            
            Text("Take Control of Your Betting")
                .font(BFDesignSystem.Typography.titleLarge)
            
            Text("BetFree helps you track your progress, block betting apps, and save money.")
                .font(BFDesignSystem.Typography.bodyLarge)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private func nameView() -> some View {
        VStack(spacing: 24) {
            Text("What's your name?")
                .font(BFDesignSystem.Typography.titleLarge)
            
            TextField("Enter your name", text: $name)
                .textFieldStyle(BFTextFieldStyle())
                .padding(.horizontal)
        }
        .padding()
    }
    
    private func typicalBetView() -> some View {
        VStack(spacing: 24) {
            Text("What's your typical bet amount?")
                .font(BFDesignSystem.Typography.titleLarge)
            
            TextField("Enter amount", text: $typicalBetAmount)
                .textFieldStyle(BFTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding(.horizontal)
        }
        .padding()
    }
    
    private func sportsView() -> some View {
        VStack(spacing: 24) {
            Text("Which sports do you bet on?")
                .font(BFDesignSystem.Typography.titleLarge)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(sports, id: \.self) { sport in
                        Button {
                            if selectedSports.contains(sport) {
                                selectedSports.remove(sport)
                            } else {
                                selectedSports.insert(sport)
                            }
                        } label: {
                            Text(sport)
                                .font(BFDesignSystem.Typography.labelLarge)
                                .foregroundColor(selectedSports.contains(sport) ? .white : BFDesignSystem.Colors.textPrimary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(selectedSports.contains(sport) ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.background)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(BFDesignSystem.Colors.border, lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
    }
    
    private func completeOnboarding() {
        // Save user info
        appState.username = name
        appState.typicalBetAmount = Double(typicalBetAmount) ?? 0
        appState.preferredSports = Array(selectedSports)
        
        // Show paywall
        showingPaywall = true
    }
}
