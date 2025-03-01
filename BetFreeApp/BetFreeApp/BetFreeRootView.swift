import SwiftUI

struct BetFreeRootView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        if !appState.hasCompletedOnboarding {
            EnhancedOnboardingView()
        } else {
            MainContentView()
        }
    }
}

struct MainContentView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
                .tag(0)
            
            MindfulnessView()
                .tabItem {
                    Label("Mindfulness", systemImage: "brain.head.profile")
                }
                .tag(1)
            
            CravingReportView()
                .tabItem {
                    Label("Report", systemImage: "chart.bar.fill")
                }
                .tag(2)
            
            AchievementsView()
                .tabItem {
                    Label("Progress", systemImage: "trophy.fill")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(4)
        }
        .accentColor(BFColors.primary)
        .onAppear {
            // Check for completed daily goal on app launch
            checkDailyGoalStatus()
        }
    }
    
    private func checkDailyGoalStatus() {
        // Implement daily goal check and streak calculation
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Check if we've already marked today as completed
        if !appState.dailyProgress.contains(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            // No entry for today yet, create one
            appState.dailyProgress.append(DailyProgress(date: today))
        }
    }
}

struct DashboardView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // User greeting and stats
                    BFCard {
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Welcome back,")
                                        .bodyStyle()
                                        .foregroundColor(BFColors.textSecondary)
                                    
                                    Text(appState.username.isEmpty ? "Friend" : appState.username)
                                        .titleStyle()
                                        .foregroundColor(BFColors.textPrimary)
                                }
                                
                                Spacer()
                                
                                // User avatar or icon
                                Circle()
                                    .fill(BFColors.primary.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Text(appState.username.prefix(1).uppercased())
                                            .fontWeight(.bold)
                                            .foregroundColor(BFColors.primary)
                                    )
                            }
                            
                            Divider()
                            
                            // Streak counter
                            HStack(spacing: 20) {
                                VStack(spacing: 8) {
                                    Text("\(appState.streakCount)")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(BFColors.primary)
                                    
                                    Text("Day Streak")
                                        .smallStyle()
                                        .foregroundColor(BFColors.textSecondary)
                                }
                                
                                Divider()
                                    .frame(height: 40)
                                
                                VStack(spacing: 8) {
                                    Text("$\(Int(appState.moneySaved))")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(BFColors.success)
                                    
                                    Text("Saved")
                                        .smallStyle()
                                        .foregroundColor(BFColors.textSecondary)
                                }
                                
                                Divider()
                                    .frame(height: 40)
                                
                                VStack(spacing: 8) {
                                    Text("\(appState.totalDaysGambleFree)")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(BFColors.accent)
                                    
                                    Text("Total Days")
                                        .smallStyle()
                                        .foregroundColor(BFColors.textSecondary)
                                }
                            }
                        }
                    }
                    
                    // Daily goal progress
                    BFCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Your \(appState.dailyGoal)-Day Goal")
                                .headlineStyle()
                                .foregroundColor(BFColors.textPrimary)
                            
                            HStack {
                                BFProgressCircle(
                                    progress: min(Double(appState.streakCount) / Double(appState.dailyGoal), 1.0),
                                    size: 120,
                                    lineWidth: 12,
                                    gradient: BFColors.progressGradient()
                                )
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("\(appState.streakCount) of \(appState.dailyGoal) days")
                                        .bodyBoldStyle()
                                        .foregroundColor(BFColors.textPrimary)
                                    
                                    Text("Keep going! You're making great progress on your journey.")
                                        .smallStyle()
                                        .foregroundColor(BFColors.textSecondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    if appState.streakCount >= appState.dailyGoal {
                                        Text("Goal achieved! 🎉")
                                            .bodyBoldStyle()
                                            .foregroundColor(BFColors.success)
                                    }
                                }
                                .padding(.leading, 8)
                            }
                        }
                    }
                    
                    // Quick access tools
                    BFCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Tools & Resources")
                                .headlineStyle()
                                .foregroundColor(BFColors.textPrimary)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                QuickAccessButton(
                                    title: "Urge Surfing",
                                    icon: "wave.3.right",
                                    color: BFColors.calm
                                ) {
                                    // Action for urge surfing tool
                                }
                                
                                QuickAccessButton(
                                    title: "Breathing",
                                    icon: "lungs.fill",
                                    color: BFColors.primary
                                ) {
                                    // Action for breathing exercises
                                }
                                
                                QuickAccessButton(
                                    title: "Journal",
                                    icon: "book.fill",
                                    color: BFColors.focus
                                ) {
                                    // Action for journaling
                                }
                                
                                QuickAccessButton(
                                    title: "Support",
                                    icon: "person.2.fill",
                                    color: BFColors.accent
                                ) {
                                    // Action for support contacts
                                }
                            }
                        }
                    }
                    
                    // Recent achievements
                    if !appState.achievements.isEmpty {
                        BFCard {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Recent Achievements")
                                    .headlineStyle()
                                    .foregroundColor(BFColors.textPrimary)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(appState.achievements.prefix(3)) { achievement in
                                            AchievementCard(achievement: achievement)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct QuickAccessButton: View {
    var title: String
    var icon: String
    var color: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(color)
                
                Text(title)
                    .smallBoldStyle()
                    .foregroundColor(BFColors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(color.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

struct AchievementCard: View {
    var achievement: UserAchievement
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: achievement.iconName)
                .font(.system(size: 32))
                .foregroundColor(BFColors.accent)
            
            Text(achievement.title)
                .bodyBoldStyle()
                .foregroundColor(BFColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(achievement.dateEarned.formatted(date: .abbreviated, time: .omitted))
                .smallStyle()
                .foregroundColor(BFColors.textSecondary)
        }
        .frame(width: 140)
        .padding()
        .background(BFColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(BFColors.accent.opacity(0.3), lineWidth: 1)
        )
    }
}

struct MindfulnessView: View {
    // Mindfulness exercises view implementation
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Mindfulness Exercises")
                        .titleStyle()
                        .padding(.horizontal)
                    
                    Text("Take a moment for yourself with these guided exercises")
                        .bodyStyle()
                        .foregroundColor(BFColors.textSecondary)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    
                    ForEach(MindfulnessExercise.samples) { exercise in
                        BFCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text(exercise.title)
                                        .headlineStyle()
                                    
                                    Spacer()
                                    
                                    Text("\(exercise.durationMinutes) min")
                                        .smallBoldStyle()
                                        .foregroundColor(BFColors.primary)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(BFColors.primary.opacity(0.1))
                                        .cornerRadius(20)
                                }
                                
                                Text(exercise.description)
                                    .bodyStyle()
                                    .foregroundColor(BFColors.textSecondary)
                                
                                Button(action: {
                                    // Action to start exercise
                                }) {
                                    Text("Start Exercise")
                                        .frame(maxWidth: .infinity)
                                }
                                .primaryButtonStyle()
                                .padding(.top, 8)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Mindfulness")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AchievementsView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Progress overview
                    BFCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Your Progress")
                                .headlineStyle()
                            
                            HStack(spacing: 20) {
                                VStack(spacing: 8) {
                                    Text("\(appState.totalDaysGambleFree)")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(BFColors.primary)
                                    
                                    Text("Gambling-Free Days")
                                        .smallStyle()
                                        .foregroundColor(BFColors.textSecondary)
                                        .multilineTextAlignment(.center)
                                }
                                
                                Spacer()
                                
                                VStack(spacing: 8) {
                                    Text("\(appState.mindfulnessMinutesTotal)")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(BFColors.focus)
                                    
                                    Text("Mindful Minutes")
                                        .smallStyle()
                                        .foregroundColor(BFColors.textSecondary)
                                        .multilineTextAlignment(.center)
                                }
                                
                                Spacer()
                                
                                VStack(spacing: 8) {
                                    let resistedCravings = appState.cravingReports.filter { !$0.didGiveIn }.count
                                    Text("\(resistedCravings)")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(BFColors.success)
                                    
                                    Text("Urges Resisted")
                                        .smallStyle()
                                        .foregroundColor(BFColors.textSecondary)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                    }
                    
                    // Achievements
                    BFCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Achievements")
                                .headlineStyle()
                            
                            if appState.achievements.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "trophy")
                                        .font(.system(size: 40))
                                        .foregroundColor(BFColors.textTertiary)
                                    
                                    Text("Complete activities to earn achievements")
                                        .bodyStyle()
                                        .foregroundColor(BFColors.textSecondary)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 30)
                            } else {
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                                    ForEach(appState.achievements) { achievement in
                                        AchievementCard(achievement: achievement)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    @State private var showResetConfirmation = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Profile")) {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Your name", text: $appState.username)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Goal duration")
                        Spacer()
                        Picker("", selection: $appState.dailyGoal) {
                            ForEach([1, 7, 14, 30, 60, 90, 120], id: \.self) { day in
                                Text("\(day) days").tag(day)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    HStack {
                        Text("Daily gambling spend")
                        Spacer()
                        TextField("Amount", value: $appState.averageDailySpend, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section(header: Text("Appearance")) {
                    Picker("Theme", selection: $appState.preferredTheme) {
                        Text("Standard").tag(AppState.AppTheme.standard)
                        Text("Calm").tag(AppState.AppTheme.calm)
                        Text("Focus").tag(AppState.AppTheme.focus)
                        Text("Hope").tag(AppState.AppTheme.hope)
                    }
                    .pickerStyle(.menu)
                    
                    Toggle("Use Calming Mode", isOn: $appState.useCalming)
                }
                
                Section(header: Text("Your Triggers")) {
                    ForEach(appState.userTriggers, id: \.self) { trigger in
                        Text(trigger)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            if index < appState.userTriggers.count {
                                appState.removeTrigger(appState.userTriggers[index])
                            }
                        }
                    }
                    
                    NavigationLink(destination: AddTriggerView()) {
                        Label("Add Trigger", systemImage: "plus")
                            .foregroundColor(BFColors.primary)
                    }
                }
                
                Section(header: Text("Support Contacts")) {
                    ForEach(appState.supportContacts.indices, id: \.self) { index in
                        let contact = appState.supportContacts[index]
                        VStack(alignment: .leading) {
                            Text(contact.name)
                                .font(.headline)
                            Text(contact.relationship)
                                .font(.subheadline)
                                .foregroundColor(BFColors.textSecondary)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            appState.removeSupportContact(at: index)
                        }
                    }
                    
                    NavigationLink(destination: AddSupportContactView()) {
                        Label("Add Contact", systemImage: "plus")
                            .foregroundColor(BFColors.primary)
                    }
                }
                
                Section(header: Text("Notifications")) {
                    ForEach(Array(appState.notificationPreferences.keys.sorted()), id: \.self) { key in
                        if let enabled = appState.notificationPreferences[key] {
                            Toggle(key, isOn: Binding(
                                get: { enabled },
                                set: { appState.setNotificationPreference(for: key, enabled: $0) }
                            ))
                        }
                    }
                }
                
                Section {
                    Button("Reset Onboarding") {
                        showResetConfirmation = true
                    }
                    .foregroundColor(.red)
                }
                .alert("Reset Onboarding", isPresented: $showResetConfirmation) {
                    Button("Cancel", role: .cancel) { }
                    Button("Reset", role: .destructive) {
                        appState.hasCompletedOnboarding = false
                    }
                } message: {
                    Text("This will reset the app to the initial onboarding state. Your data won't be deleted.")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct AddTriggerView: View {
    @EnvironmentObject private var appState: AppState
    @State private var newTrigger = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Add a new trigger")) {
                TextField("Trigger description", text: $newTrigger)
                
                Button("Add Trigger") {
                    if !newTrigger.isEmpty {
                        appState.addTrigger(newTrigger)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .disabled(newTrigger.isEmpty)
            }
        }
        .navigationTitle("Add Trigger")
    }
}

struct AddSupportContactView: View {
    @EnvironmentObject private var appState: AppState
    @State private var newContact = SupportContact(name: "", relationship: "")
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Contact Information")) {
                TextField("Name", text: $newContact.name)
                TextField("Relationship", text: $newContact.relationship)
                TextField("Phone Number (Optional)", text: Binding(
                    get: { newContact.phoneNumber ?? "" },
                    set: { newContact.phoneNumber = $0.isEmpty ? nil : $0 }
                ))
                .keyboardType(.phonePad)
                
                TextField("Email (Optional)", text: Binding(
                    get: { newContact.email ?? "" },
                    set: { newContact.email = $0.isEmpty ? nil : $0 }
                ))
                .keyboardType(.emailAddress)
                
                Toggle("Emergency Contact", isOn: $newContact.isEmergencyContact)
            }
            
            Section {
                Button("Save Contact") {
                    if !newContact.name.isEmpty {
                        appState.addSupportContact(newContact)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .disabled(newContact.name.isEmpty)
            }
        }
        .navigationTitle("Add Support Contact")
    }
}

struct BetFreeRootView_Previews: PreviewProvider {
    static var previews: some View {
        BetFreeRootView()
            .environmentObject(AppState())
    }
} 