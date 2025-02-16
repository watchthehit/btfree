import SwiftUI
import BetFreeUI
import BetFreeModels

public struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    @State private var showingLogoutAlert = false
    @State private var showingResetAlert = false
    @State private var dailyLimit = ""
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            List {
                // Profile Section
                Section("Profile") {
                    TextField("Name", text: $appState.username)
                        .textContentType(.name)
                        .autocapitalization(.words)
                    
                    HStack {
                        Text("Daily Limit")
                        Spacer()
                        TextField("$0.00", text: $dailyLimit)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: dailyLimit) { newValue in
                                if let amount = Double(newValue) {
                                    appState.updateDailyLimit(amount)
                                }
                            }
                    }
                }
                
                // Notifications Section
                Section("Notifications") {
                    Toggle("Daily Check-in Reminder", isOn: .constant(true))
                    Toggle("Milestone Alerts", isOn: .constant(true))
                    Toggle("Weekly Progress Report", isOn: .constant(true))
                }
                
                // Support Section
                Section("Support") {
                    NavigationLink {
                        CrisisView()
                    } label: {
                        Label("Crisis Support", systemImage: "heart.circle.fill")
                            .foregroundColor(BFDesignSystem.Colors.error)
                    }
                    
                    NavigationLink {
                        ResourcesView()
                    } label: {
                        Label("Resources", systemImage: "book.circle.fill")
                    }
                    
                    NavigationLink {
                        ContactView()
                    } label: {
                        Label("Contact Us", systemImage: "envelope.circle.fill")
                    }
                }
                
                // Account Section
                Section {
                    Button(role: .destructive) {
                        showingLogoutAlert = true
                    } label: {
                        Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                    
                    Button(role: .destructive) {
                        showingResetAlert = true
                    } label: {
                        Label("Reset All Data", systemImage: "trash")
                    }
                }
                
                // About Section
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.appVersion)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .onAppear {
            dailyLimit = String(format: "%.2f", appState.dailyLimit)
        }
        .alert("Log Out", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Log Out", role: .destructive) {
                appState.logout()
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
        .alert("Reset Data", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                appState.logout()
            }
        } message: {
            Text("This will permanently delete all your data. This action cannot be undone.")
        }
    }
}

// MARK: - Supporting Views
private struct CrisisView: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Need immediate help?")
                        .font(BFDesignSystem.Typography.titleMedium)
                    
                    Text("If you're experiencing a crisis or having thoughts of self-harm, help is available 24/7.")
                        .font(BFDesignSystem.Typography.bodyMedium)
                        .foregroundColor(BFDesignSystem.Colors.textSecondary)
                }
                .padding(.vertical, 8)
                
                Link(destination: URL(string: "tel:1800858858")!) {
                    Label("Call 1800 858 858", systemImage: "phone.fill")
                        .foregroundColor(BFDesignSystem.Colors.success)
                }
                
                Link(destination: URL(string: "https://www.gamblinghelponline.org.au")!) {
                    Label("Visit Gambling Help Online", systemImage: "globe")
                }
            }
            
            Section("Other Resources") {
                Link(destination: URL(string: "https://www.lifeline.org.au")!) {
                    Label("Lifeline: 13 11 14", systemImage: "heart.circle.fill")
                }
                
                Link(destination: URL(string: "https://www.beyondblue.org.au")!) {
                    Label("Beyond Blue: 1300 22 4636", systemImage: "brain.head.profile")
                }
            }
        }
        .navigationTitle("Crisis Support")
    }
}

private struct ContactView: View {
    @State private var subject = ""
    @State private var message = ""
    @State private var showingMailAlert = false
    
    var body: some View {
        Form {
            Section {
                TextField("Subject", text: $subject)
                TextEditor(text: $message)
                    .frame(height: 150)
            }
            
            Section {
                Button {
                    #if os(iOS)
                    if let url = createEmailUrl() {
                        UIApplication.shared.open(url)
                    } else {
                        showingMailAlert = true
                    }
                    #endif
                } label: {
                    Label("Send Email", systemImage: "envelope.fill")
                }
            }
        }
        .navigationTitle("Contact Us")
        .alert("Cannot Send Mail", isPresented: $showingMailAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please make sure you have an email account set up on your device.")
        }
    }
    
    private func createEmailUrl() -> URL? {
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "mailto:support@betfree.app?subject=\(encodedSubject)&body=\(encodedMessage)"
        return URL(string: urlString)
    }
}

// MARK: - Bundle Extension
extension Bundle {
    var appVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
} 