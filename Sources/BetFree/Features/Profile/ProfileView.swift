import SwiftUI
import ComposableArchitecture

public struct ProfileView: View {
    @EnvironmentObject private var appState: AppState
    
    public var body: some View {
        List {
            // User Info Section
            Section {
                HStack {
                    Text("Username")
                    Spacer()
                    Text(appState.username)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Daily Limit")
                    Spacer()
                    Text("$\(appState.dailyLimit, specifier: "%.2f")")
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("User Information")
            }
            
            // Stats Section
            Section {
                HStack {
                    Text("Current Streak")
                    Spacer()
                    Text("\(appState.streak) days")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Total Savings")
                    Spacer()
                    Text("$\(appState.savings, specifier: "%.2f")")
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("Statistics")
            }
            
            // Settings Section
            Section {
                Button(action: {
                    // Reset action
                }) {
                    Text("Reset Progress")
                        .foregroundColor(.red)
                }
            } header: {
                Text("Settings")
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
        }
        .navigationTitle("Profile")
        #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.sidebar)
        #endif
    }
    
    public init() {}
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
} 