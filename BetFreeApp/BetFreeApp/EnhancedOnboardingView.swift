import SwiftUI

// MARK: - OnboardingViewModel
@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    @Published var username: String = ""
    @Published var dailyGoal: Int = 30
    @Published var userTriggers: [String] = []
    @Published var customTrigger: String = ""
    @Published var notificationPreferences: [String: Bool] = [
        "Daily Check-in": true,
        "Weekly Summary": true,
        "Craving Alerts": false,
        "Achievement Notifications": true
    ]
    
    private let commonTriggers = [
        "Stress", "Boredom", "Social Pressure", "Celebration", 
        "After Meals", "While Drinking", "Financial Concerns"
    ]
    
    var availableTriggers: [String] {
        commonTriggers.filter { !userTriggers.contains($0) }
    }
    
    func nextPage() {
        if currentPage < 7 {
            currentPage += 1
        }
    }
    
    func previousPage() {
        if currentPage > 0 {
            currentPage -= 1
        }
    }
    
    func addTrigger(_ trigger: String) {
        if !trigger.isEmpty && !userTriggers.contains(trigger) {
            userTriggers.append(trigger)
            customTrigger = ""
        }
    }
    
    func removeTrigger(_ trigger: String) {
        if let index = userTriggers.firstIndex(of: trigger) {
            userTriggers.remove(at: index)
        }
    }
    
    func saveToAppState(_ appState: AppState) {
        appState.username = username
        appState.dailyGoal = dailyGoal
        appState.userTriggers = userTriggers
        appState.notificationPreferences = notificationPreferences
        appState.completeOnboarding()
    }
}

// MARK: - Main Onboarding View
struct EnhancedOnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        VStack {
            HStack {
                if viewModel.currentPage > 0 {
                    Button(action: {
                        viewModel.previousPage()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
                
                Spacer()
                
                Text("Step \(viewModel.currentPage + 1) of 8")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if viewModel.currentPage < 7 {
                    Button(action: {
                        viewModel.nextPage()
                    }) {
                        Text("Skip")
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
            }
            .padding(.horizontal)
            
            TabView(selection: $viewModel.currentPage) {
                WelcomeScreen()
                    .tag(0)
                
                NameInputScreen(username: $viewModel.username)
                    .tag(1)
                
                GoalSettingScreen(dailyGoal: $viewModel.dailyGoal)
                    .tag(2)
                
                TriggerSelectionScreen(
                    availableTriggers: viewModel.availableTriggers,
                    userTriggers: $viewModel.userTriggers,
                    customTrigger: $viewModel.customTrigger,
                    addTrigger: viewModel.addTrigger,
                    removeTrigger: viewModel.removeTrigger
                )
                    .tag(3)
                
                NotificationSetupScreen(preferences: $viewModel.notificationPreferences)
                    .tag(4)
                
                FeatureOverviewScreen()
                    .tag(5)
                
                PrivacyScreen()
                    .tag(6)
                
                CompletionScreen {
                    viewModel.saveToAppState(appState)
                }
                .tag(7)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: viewModel.currentPage)
            
            HStack {
                ForEach(0..<8) { index in
                    Circle()
                        .fill(viewModel.currentPage == index ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom)
            
            if viewModel.currentPage < 7 {
                Button(action: {
                    viewModel.nextPage()
                }) {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .environmentObject(viewModel)
    }
}

// MARK: - Individual Screens
struct WelcomeScreen: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding()
            
            Text("Welcome to BetFree")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Your journey to a healthier relationship with gambling starts here.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
            
            Text("This app will help you track triggers, manage cravings, and build healthier habits.")
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}

struct NameInputScreen: View {
    @Binding var username: String
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Let's Get to Know You")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("How should we call you?")
                .font(.title3)
            
            TextField("Your Name", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.words)
            
            Text("We'll use this to personalize your experience.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct GoalSettingScreen: View {
    @Binding var dailyGoal: Int
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Set Your Daily Goal")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("How many minutes each day do you want to commit to mindfulness exercises?")
                .font(.title3)
                .multilineTextAlignment(.center)
            
            VStack {
                Text("\(dailyGoal) minutes")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.blue)
                
                Slider(value: Binding(
                    get: { Double(dailyGoal) },
                    set: { dailyGoal = Int($0) }
                ), in: 5...60, step: 5)
                .padding()
            }
            .padding()
            
            Text("Research shows that even short mindfulness sessions can help reduce cravings.")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding()
        }
        .padding()
    }
}

struct TriggerSelectionScreen: View {
    let availableTriggers: [String]
    @Binding var userTriggers: [String]
    @Binding var customTrigger: String
    let addTrigger: (String) -> Void
    let removeTrigger: (String) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Identify Your Triggers")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("What situations typically trigger gambling cravings for you?")
                .font(.title3)
                .multilineTextAlignment(.center)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your selected triggers:")
                        .font(.headline)
                        .padding(.top)
                    
                    if userTriggers.isEmpty {
                        Text("None selected yet")
                            .italic()
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(userTriggers, id: \.self) { trigger in
                            HStack {
                                Text(trigger)
                                Spacer()
                                Button(action: {
                                    removeTrigger(trigger)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    
                    Divider()
                    
                    Text("Common triggers:")
                        .font(.headline)
                        .padding(.top)
                    
                    ForEach(availableTriggers, id: \.self) { trigger in
                        HStack {
                            Text(trigger)
                            Spacer()
                            Button(action: {
                                addTrigger(trigger)
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    
                    Divider()
                    
                    Text("Add a custom trigger:")
                        .font(.headline)
                        .padding(.top)
                    
                    HStack {
                        TextField("Custom trigger", text: $customTrigger)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            addTrigger(customTrigger)
                        }) {
                            Text("Add")
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(customTrigger.isEmpty ? Color.gray : Color.blue)
                                .cornerRadius(5)
                        }
                        .disabled(customTrigger.isEmpty)
                    }
                }
                .padding()
            }
        }
        .padding()
    }
}

struct NotificationSetupScreen: View {
    @Binding var preferences: [String: Bool]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Notification Preferences")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("How would you like to receive support from the app?")
                .font(.title3)
                .multilineTextAlignment(.center)
            
            Form {
                ForEach(Array(preferences.keys.sorted()), id: \.self) { key in
                    if let isEnabled = preferences[key] {
                        Toggle(key, isOn: Binding(
                            get: { isEnabled },
                            set: { preferences[key] = $0 }
                        ))
                    }
                }
            }
            .frame(height: 250)
            
            Text("You can always change these later in Settings.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct FeatureOverviewScreen: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("App Features")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Everything you need to stay on track")
                .font(.title3)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 15) {
                FeatureRow(icon: "chart.bar.fill", title: "Track Progress", description: "Monitor your daily and weekly achievements")
                
                FeatureRow(icon: "bell.fill", title: "Smart Alerts", description: "Get notified when you're near known triggers")
                
                FeatureRow(icon: "brain.head.profile", title: "Mindfulness Exercises", description: "Quick activities to help manage cravings")
                
                FeatureRow(icon: "person.3.fill", title: "Community Support", description: "Connect with others on similar journeys")
                
                FeatureRow(icon: "lock.shield.fill", title: "Private & Secure", description: "Your data never leaves your device")
            }
            .padding()
        }
        .padding()
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.system(size: 30))
                .frame(width: 40)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 5)
    }
}

struct PrivacyScreen: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Your Privacy Matters")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("We take your privacy seriously")
                .font(.title3)
                .multilineTextAlignment(.center)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    PrivacySection(
                        title: "Local Storage Only",
                        description: "All your personal data is stored locally on your device. We don't upload or share your information with any third parties."
                    )
                    
                    PrivacySection(
                        title: "No Tracking",
                        description: "We don't track your location or online activities. The app only uses the information you explicitly provide."
                    )
                    
                    PrivacySection(
                        title: "Notifications",
                        description: "Notifications are generated on your device based on your settings and are not monitored externally."
                    )
                    
                    PrivacySection(
                        title: "Data Control",
                        description: "You can export or delete your data at any time from the Settings menu."
                    )
                }
                .padding()
            }
            
            Text("By continuing, you agree to our Privacy Policy and Terms of Service.")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding()
        }
        .padding()
    }
}

struct PrivacySection: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 5)
    }
}

struct CompletionScreen: View {
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
            
            Text("You're All Set!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Your BetFree journey begins now")
                .font(.title3)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("• Track your progress daily")
                Text("• Complete mindfulness exercises")
                Text("• Report cravings when they happen")
                Text("• Review your insights weekly")
            }
            .padding()
            
            Spacer()
            
            Button(action: onComplete) {
                Text("Get Started")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}

// MARK: - Preview
struct EnhancedOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedOnboardingView()
            .environmentObject(AppState())
    }
} 