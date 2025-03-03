import SwiftUI

struct BetFreeRootView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var paywallManager: PaywallManager
    
    var body: some View {
        if !appState.hasCompletedOnboarding {
            EnhancedOnboardingView(onComplete: {
                appState.hasCompletedOnboarding = true
            })
        } else {
            MainContentView()
        }
    }
}

struct MainContentView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var paywallManager: PaywallManager
    
    var body: some View {
        TabView {
            BFEnhancedDashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house")
                }
            
            CravingReportView()
                .tabItem {
                    Label("Report", systemImage: "chart.bar")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .withPaywall(manager: paywallManager)
    }
}

struct DashboardView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        VStack {
            Text("Welcome, \(appState.username)")
                .font(.title)
                .padding()
            
            Text("Current Streak: \(appState.streakCount) days")
                .font(.headline)
            
            Text("Daily Goal: \(appState.dailyGoal) minutes")
                .font(.subheadline)
                .padding(.bottom, 20)
            
            Spacer()
        }
        .padding()
    }
}

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Profile")) {
                    TextField("Username", text: $appState.username)
                }
                
                Section(header: Text("Goals")) {
                    Stepper("Daily Goal: \(appState.dailyGoal) minutes", value: $appState.dailyGoal, in: 0...120, step: 5)
                }
                
                Section(header: Text("Your Triggers")) {
                    ForEach(appState.userTriggers, id: \.self) { trigger in
                        Text(trigger)
                    }
                }
                
                Section(header: Text("Notifications")) {
                    ForEach(Array(appState.notificationPreferences.keys), id: \.self) { key in
                        if let enabled = appState.notificationPreferences[key] {
                            Toggle(key, isOn: Binding(
                                get: { enabled },
                                set: { appState.setNotificationPreference(for: key, enabled: $0) }
                            ))
                        }
                    }
                }
                
                Button("Reset Onboarding") {
                    appState.hasCompletedOnboarding = false
                }
                .foregroundColor(.red)
            }
            .navigationTitle("Settings")
        }
    }
}

struct BetFreeRootView_Previews: PreviewProvider {
    static var previews: some View {
        BetFreeRootView()
            .environmentObject(AppState())
    }
} 