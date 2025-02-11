import SwiftUI
import ComposableArchitecture

public struct ProfileView: View {
    @EnvironmentObject private var appState: AppState
    
    public var body: some View {
        List {
            // User Info Section
            Section(header: Text("User Information")) {
                HStack {
                    Text("Username")
                    Spacer()
                    Text(appState.username)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Current Streak")
                    Spacer()
                    Text("\(appState.currentStreak) days")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Total Savings")
                    Spacer()
                    Text("$\(String(format: "%.2f", appState.totalSavings))")
                        .foregroundColor(.secondary)
                }
            }
            
            // Settings Section
            Section(header: Text("Settings")) {
                HStack {
                    Text("Daily Limit")
                    Spacer()
                    Text("$\(String(format: "%.2f", appState.dailyLimit))")
                        .foregroundColor(.secondary)
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
        .environmentObject(AppState.shared)
} 