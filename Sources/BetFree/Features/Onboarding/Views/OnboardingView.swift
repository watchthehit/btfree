import SwiftUI

public struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @State private var currentPage = 0
    @State private var name = ""
    @State private var typicalBet = ""
    @State private var selectedSports: Set<Sport> = []
    
    private let pages = [
        OnboardingPage(
            title: "Welcome to BetFree",
            subtitle: "Your companion for sports betting recovery",
            image: "person.fill.checkmark",
            color: BFDesignSystem.Colors.primary
        ),
        OnboardingPage(
            title: "Track Your Progress",
            subtitle: "Monitor bet-free days and savings from avoided sports bets",
            image: "chart.line.uptrend.xyaxis",
            color: BFDesignSystem.Colors.success
        ),
        OnboardingPage(
            title: "Game Day Support",
            subtitle: "Get alerts and strategies for high-risk sports events",
            image: "exclamationmark.triangle.fill",
            color: BFDesignSystem.Colors.warning
        ),
        OnboardingPage(
            title: "24/7 Recovery Tools",
            subtitle: "Access support resources and track your journey",
            image: "hand.raised.fill",
            color: BFDesignSystem.Colors.error
        )
    ]
    
    private let sports = [
        Sport(name: "Football", icon: "football.fill"),
        Sport(name: "Basketball", icon: "basketball.fill"),
        Sport(name: "Baseball", icon: "baseball.fill"),
        Sport(name: "Hockey", icon: "hockey.puck.fill"),
        Sport(name: "Soccer", icon: "soccerball"),
        Sport(name: "Tennis", icon: "tennis.racket"),
        Sport(name: "Golf", icon: "golf.ball.fill"),
        Sport(name: "Racing", icon: "car.fill")
    ]
    
    public var body: some View {
        if currentPage < pages.count {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    VStack(spacing: 40) {
                        Spacer()
                        
                        Image(systemName: pages[index].image)
                            .font(.system(size: 80))
                            .foregroundColor(pages[index].color)
                        
                        VStack(spacing: 16) {
                            Text(pages[index].title)
                                .font(BFDesignSystem.Typography.displaySmall)
                                .multilineTextAlignment(.center)
                            
                            Text(pages[index].subtitle)
                                .font(BFDesignSystem.Typography.bodyLarge)
                                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                currentPage += 1
                            }
                        } label: {
                            Text(index == pages.count - 1 ? "Get Started" : "Next")
                                .font(BFDesignSystem.Typography.labelLarge)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(pages[index].color)
                    }
                    .padding()
                    .tag(index)
                }
            }
            .tabViewStyle(.page)
        } else {
            setupView
        }
    }
    
    private var setupView: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("Let's Personalize Your Recovery")
                    .font(BFDesignSystem.Typography.titleLarge)
                    .multilineTextAlignment(.center)
                
                // Name Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("What's your name?")
                        .font(BFDesignSystem.Typography.labelLarge)
                    
                    TextField("Enter your name", text: $name)
                        .textFieldStyle(.roundedBorder)
                }
                
                // Typical Bet Amount
                VStack(alignment: .leading, spacing: 8) {
                    Text("What's your typical bet amount?")
                        .font(BFDesignSystem.Typography.labelLarge)
                    
                    TextField("Enter amount", text: $typicalBet)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                }
                
                // Sports Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Which sports do you bet on?")
                        .font(BFDesignSystem.Typography.labelLarge)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(sports) { sport in
                            SportToggle(
                                sport: sport,
                                isSelected: selectedSports.contains(sport)
                            ) {
                                if selectedSports.contains(sport) {
                                    selectedSports.remove(sport)
                                } else {
                                    selectedSports.insert(sport)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    completeOnboarding()
                } label: {
                    Text("Start Recovery Journey")
                        .font(BFDesignSystem.Typography.labelLarge)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty || typicalBet.isEmpty || selectedSports.isEmpty)
            }
            .padding()
        }
    }
    
    private func completeOnboarding() {
        appState.username = name
        if let betAmount = Double(typicalBet) {
            appState.typicalBetAmount = betAmount
        }
        appState.preferredSports = selectedSports.map { $0.name }
        appState.isOnboarded = true
    }
}

private struct OnboardingPage {
    let title: String
    let subtitle: String
    let image: String
    let color: Color
}

private struct Sport: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Sport, rhs: Sport) -> Bool {
        lhs.id == rhs.id
    }
}

private struct SportToggle: View {
    let sport: Sport
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: sport.icon)
                Text(sport.name)
                    .font(BFDesignSystem.Typography.bodyMedium)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSelected ? BFDesignSystem.Colors.primary.opacity(0.1) : Color.clear)
            .foregroundColor(isSelected ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.textPrimary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? BFDesignSystem.Colors.primary : BFDesignSystem.Colors.textSecondary,
                        lineWidth: 1
                    )
            )
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState.preview)
}