import SwiftUI

/**
 * ProfileView
 * A user profile view that allows users to edit their information, goals, and settings.
 * Implements the new unified BF Design System.
 */

struct ProfileView: View {
    @EnvironmentObject var enhancedAppState: EnhancedAppState
    
    @State private var userName: String = UserDefaults.standard.string(forKey: "userName") ?? "User"
    @State private var userGoal: String = UserDefaults.standard.string(forKey: "selectedGoal") ?? "Reduce"
    @State private var userMotivation: String = UserDefaults.standard.string(forKey: "userMotivation") ?? "To live a healthier life"
    
    @State private var showEditProfile = false
    @State private var showSubscriptionOptions = false
    @State private var showResetConfirmation = false
    @State private var showDeleteConfirmation = false
    
    @State private var notificationsEnabled = true
    @State private var reminderTime = Date()
    
    @StateObject private var paywallViewModel = EnhancedOnboardingViewModel()
    
    @State private var opacity: Double = 0
    @State private var yOffset: CGFloat = 20
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Main background
                BFColorSystem.background
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: BFDesignTokens.Spacing.large) {
                        profileHeaderView
                            .withBFEntranceAnimation(delay: 0.1)
                        
                        statsOverview
                            .withBFEntranceAnimation(delay: 0.2)
                            .background(
                                RoundedRectangle(cornerRadius: BFDesignTokens.BorderRadius.card)
                                    .fill(Color(hex: "#232B3D"))
                            )
                        
                        settingsSection
                            .withBFEntranceAnimation(delay: 0.3)
                            .background(
                                RoundedRectangle(cornerRadius: BFDesignTokens.BorderRadius.card)
                                    .fill(Color(hex: "#232B3D"))
                            )
                        
                        subscriptionSection
                            .withBFEntranceAnimation(delay: 0.4)
                            .background(
                                RoundedRectangle(cornerRadius: BFDesignTokens.BorderRadius.card)
                                    .fill(Color(hex: "#232B3D"))
                            )
                        
                        dangerZone
                            .withBFEntranceAnimation(delay: 0.5)
                            .background(
                                RoundedRectangle(cornerRadius: BFDesignTokens.BorderRadius.card)
                                    .fill(Color(hex: "#232B3D"))
                            )
                            
                        // Extra spacer at the bottom to force scrolling
                        Spacer().frame(height: 200)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 150) // Add extra padding at bottom for scrolling past tab bar
                    .frame(minWidth: geometry.size.width, minHeight: geometry.size.height * 1.5)
                }
                .onAppear {
                    // Force scroll view to always be scrollable
                    UIScrollView.appearance().bounces = true
                    UIScrollView.appearance().alwaysBounceVertical = true
                    
                    // Refresh tab bar to help with scrolling issues
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        enhancedAppState.refreshTabBarVisibility()
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $showEditProfile) {
            EditProfileView(
                userName: $userName,
                userGoal: $userGoal,
                userMotivation: $userMotivation
            )
        }
        .confirmationDialog("Reset App", isPresented: $showResetConfirmation) {
            Button("Yes, Reset Everything", role: .destructive) {
                resetApp()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to reset all data? This cannot be undone.")
        }
        .confirmationDialog("Delete Account", isPresented: $showDeleteConfirmation) {
            Button("Yes, Delete My Account", role: .destructive) {
                deleteAccount()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete your account? All your data will be permanently lost.")
        }
    }
    
    private var profileHeaderView: some View {
        VStack(spacing: 24) {
            // Profile image
            ZStack {
                Circle()
                    .fill(Color(hex: "#223049"))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 60))
                    .foregroundColor(BFColorSystem.primary)
            }
            .padding(.top, 20)
            
            // User info
            VStack(spacing: 8) {
                Text(userName)
                    .font(BFDesignTokens.Typography.titleLarge)
                    .foregroundColor(BFColorSystem.textPrimary)
                
                HStack(spacing: 8) {
                    Text("Goal:")
                        .font(BFDesignTokens.Typography.bodyLarge)
                        .foregroundColor(BFColorSystem.textSecondary)
                    
                    Text(userGoal)
                        .font(BFDesignTokens.Typography.bodyLarge.bold())
                        .foregroundColor(BFDesignTokens.Colors.primary)
                }
            }
            
            // Edit button
            Button(action: {
                showEditProfile = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit Profile")
                }
                .font(BFDesignTokens.Typography.bodyMedium)
                .foregroundColor(Color.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(BFColorSystem.primary.opacity(0.7))
                .cornerRadius(20)
            }
        }
        .padding(.bottom, 20)
    }
    
    private var statsOverview: some View {
        VStack(alignment: .leading, spacing: BFDesignTokens.Spacing.small) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(BFColorSystem.accent)
                Text("Your Progress")
                    .font(BFDesignTokens.Typography.headingMedium)
                    .foregroundColor(BFColorSystem.textPrimary)
                Spacer()
            }
            .padding(.bottom, 4)
            
            VStack(spacing: BFDesignTokens.Spacing.medium) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Current Streak")
                            .font(BFDesignTokens.Typography.bodyMedium)
                            .foregroundColor(BFColorSystem.textSecondary)
                        
                        Text("\(enhancedAppState.streakDays) days")
                            .font(BFDesignTokens.Typography.headingMedium)
                            .foregroundColor(BFColorSystem.textPrimary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "flame.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "#FF9500"))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: BFDesignTokens.BorderRadius.medium)
                        .fill(Color.white.opacity(0.05))
                )
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Money Saved")
                            .font(BFDesignTokens.Typography.bodyMedium)
                            .foregroundColor(BFColorSystem.textSecondary)
                        
                        Text("$\(Int(enhancedAppState.costPerUrge * Double(enhancedAppState.urgesHandled)))")
                            .font(BFDesignTokens.Typography.headingMedium)
                            .foregroundColor(BFColorSystem.textPrimary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "#34C759"))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: BFDesignTokens.BorderRadius.medium)
                        .fill(Color.white.opacity(0.05))
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: BFDesignTokens.BorderRadius.card)
                .fill(BFColorSystem.cardBackground)
        )
    }
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: BFDesignTokens.Spacing.small) {
            HStack {
                Image(systemName: "gear")
                    .foregroundColor(BFColorSystem.accent)
                Text("Settings")
                    .font(BFDesignTokens.Typography.headingMedium)
                    .foregroundColor(BFColorSystem.textPrimary)
                Spacer()
            }
            .padding(.bottom, 4)
            
            VStack(spacing: BFDesignTokens.Spacing.medium) {
                Toggle("Daily Reminders", isOn: $notificationsEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: BFDesignTokens.Colors.success))
                    .font(BFDesignTokens.Typography.bodyLarge)
                
                if notificationsEnabled {
                    DatePicker(
                        "Reminder Time",
                        selection: $reminderTime,
                        displayedComponents: .hourAndMinute
                    )
                    .font(BFDesignTokens.Typography.bodyLarge)
                    .accentColor(BFColorSystem.accent)
                }
                
                Divider()
                
                HStack {
                    Image(systemName: "bookmark.fill")
                        .foregroundColor(Color(hex: "#007AFF"))
                    
                    Text("App Theme")
                        .font(BFDesignTokens.Typography.bodyLarge)
                        .foregroundColor(BFColorSystem.textPrimary)
                    
                    Spacer()
                    
                    Text("Default")
                        .font(BFDesignTokens.Typography.bodySmall)
                        .foregroundColor(BFColorSystem.textSecondary)
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(BFColorSystem.textSecondary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: BFDesignTokens.BorderRadius.card)
                .fill(BFColorSystem.cardBackground)
        )
    }
    
    private var subscriptionSection: some View {
        VStack(alignment: .leading, spacing: BFDesignTokens.Spacing.small) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(BFColorSystem.accent)
                Text("Premium Features")
                    .font(BFDesignTokens.Typography.headingMedium)
                    .foregroundColor(BFColorSystem.textPrimary)
                Spacer()
            }
            .padding(.bottom, 4)
            
            VStack(spacing: BFDesignTokens.Spacing.small) {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundColor(Color(hex: "#FFD700"))
                    
                    VStack(alignment: .leading) {
                        Text("BetFree Premium")
                            .font(BFDesignTokens.Typography.bodyLarge)
                            .foregroundColor(BFColorSystem.textPrimary)
                        
                        Text("Unlock advanced features and insights")
                            .font(BFDesignTokens.Typography.bodySmall)
                            .foregroundColor(BFColorSystem.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showSubscriptionOptions = true
                    }) {
                        Text("Upgrade")
                            .font(BFDesignTokens.Typography.bodyMedium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(hex: "#FFD700"))
                            .foregroundColor(Color.black)
                            .cornerRadius(8)
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 10) {
                    Label {
                        Text("Advanced Analytics")
                            .font(BFDesignTokens.Typography.bodyMedium)
                    } icon: {
                        Image(systemName: "chart.pie.fill")
                            .foregroundColor(BFColorSystem.primary)
                    }
                    
                    Label {
                        Text("AI-Powered Insights")
                            .font(BFDesignTokens.Typography.bodyMedium)
                    } icon: {
                        Image(systemName: "brain.head.profile")
                            .foregroundColor(BFColorSystem.primary)
                    }
                    
                    Label {
                        Text("Ad-Free Experience")
                            .font(BFDesignTokens.Typography.bodyMedium)
                    } icon: {
                        Image(systemName: "eye.slash.fill")
                            .foregroundColor(BFColorSystem.primary)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: BFDesignTokens.BorderRadius.card)
                .fill(BFColorSystem.cardBackground)
        )
    }
    
    private var dangerZone: some View {
        VStack(alignment: .leading, spacing: BFDesignTokens.Spacing.small) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(BFColorSystem.error)
                Text("Danger Zone")
                    .font(BFDesignTokens.Typography.headingMedium)
                    .foregroundColor(BFColorSystem.textPrimary)
                Spacer()
            }
            .padding(.bottom, 4)
            
            VStack(spacing: BFDesignTokens.Spacing.medium) {
                Button(action: {
                    showResetConfirmation = true
                }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(BFColorSystem.warning)
                        
                        Text("Reset App Data")
                            .font(BFDesignTokens.Typography.bodyLarge)
                            .foregroundColor(BFColorSystem.textPrimary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(BFColorSystem.textSecondary)
                    }
                }
                
                Divider()
                
                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    HStack {
                        Image(systemName: "trash.fill")
                            .foregroundColor(BFColorSystem.error)
                        
                        Text("Delete Account")
                            .font(BFDesignTokens.Typography.bodyLarge)
                            .foregroundColor(BFColorSystem.textPrimary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(BFColorSystem.textSecondary)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: BFDesignTokens.BorderRadius.card)
                .fill(BFColorSystem.cardBackground)
        )
    }
    
    // MARK: - Actions
    
    private func resetApp() {
        // Clear all user data except for authentication
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        
        // Reset any in-memory state by manually resetting critical properties
        // since enhancedAppState doesn't have a reset() method
        enhancedAppState.urgesHandled = 0
        enhancedAppState.streakDays = 0
        enhancedAppState.enhancedUrgeHistory = []
        enhancedAppState.enhancedUserGoals = []
        
        // Update UI with defaults
        userName = "User"
        userGoal = "Reduce"
        userMotivation = "To live a healthier life"
    }
    
    private func deleteAccount() {
        // In a real app, this would connect to your backend
        // For now, we'll just reset everything
        resetApp()
    }
}

// MARK: - Edit Profile View

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var userName: String
    @Binding var userGoal: String
    @Binding var userMotivation: String
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Your Name", text: $userName)
                }
                
                Section(header: Text("Your Goal")) {
                    Picker("Goal", selection: $userGoal) {
                        Text("Quit").tag("Quit")
                        Text("Reduce").tag("Reduce")
                        Text("Take a Break").tag("Take a Break")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Your Motivation")) {
                    TextField("What motivates you?", text: $userMotivation)
                }
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Save to UserDefaults
                        UserDefaults.standard.set(userName, forKey: "userName")
                        UserDefaults.standard.set(userGoal, forKey: "selectedGoal")
                        UserDefaults.standard.set(userMotivation, forKey: "userMotivation")
                        
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - View Modifiers

extension View {
    func withBFEntranceAnimation(delay: Double = 0) -> some View {
        modifier(EntranceAnimationModifier(delay: delay))
    }
}

struct EntranceAnimationModifier: ViewModifier {
    let delay: Double
    @State private var opacity: Double = 0
    @State private var yOffset: CGFloat = 20
    
    func body(content: Content) -> some View {
        content
            .offset(y: yOffset)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 0.4).delay(delay)) {
                    opacity = 1
                    yOffset = 0
                }
            }
    }
}

class MockEnhancedAppState: ObservableObject {
    @Published var currentStreak: Int = 14
    @Published var moneySaved: Int = 240
    
    func updateStats(urgesHandled: Int) {
        currentStreak = urgesHandled / 3
        moneySaved = urgesHandled * 5
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
                .preferredColorScheme(.dark)
        }
    }
} 