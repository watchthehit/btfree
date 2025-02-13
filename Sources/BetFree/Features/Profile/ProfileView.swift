import SwiftUI
import ComposableArchitecture

public struct ProfileView: View {
    @ObservedObject var appState: AppState
    @State private var showingLogoutAlert = false
    
    public var body: some View {
        List {
            // User Info Section
            Section("User Information") {
                HStack {
                    Text("Username")
                    Spacer()
                    Text(appState.username)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Current Streak")
                    Spacer()
                    Text("\(appState.streak) days")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Total Savings")
                    Spacer()
                    Text("$\(String(format: "%.2f", appState.savings))")
                        .foregroundColor(.secondary)
                }
            }
            
            // Settings Section
            Section("Settings") {
                HStack {
                    Text("Daily Limit")
                    Spacer()
                    Text("$\(String(format: "%.2f", appState.dailyLimit))")
                        .foregroundColor(.secondary)
                }
                
                NavigationLink {
                    NotificationSettingsView(appState: appState)
                } label: {
                    Label("Notifications", systemImage: "bell.fill")
                }
            }
            
            // Support Section
            Section(header: Text("Support")) {
                Button(action: {
                    // Add support action
                }) {
                    Label("Contact Support", systemImage: "envelope.fill")
                }
                
                Button(action: {
                    // Add feedback action
                }) {
                    Label("Send Feedback", systemImage: "message.fill")
                }
            }
            
            // About Section
            Section(header: Text("About")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
            }
            
            // Logout Section
            Section {
                Button(role: .destructive) {
                    showingLogoutAlert = true
                } label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Logout")
                    }
                }
            }
        }
        .navigationTitle("Profile")
        #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.sidebar)
        #endif
        .alert("Logout", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                HapticFeedback.fireAndForget()
                appState.logout()
            }
        } message: {
            Text("Are you sure you want to logout? This will reset all your data.")
        }
    }
    
    public init(appState: AppState) {
        self.appState = appState
    }
}

#Preview {
    ProfileView(appState: AppState())
} 