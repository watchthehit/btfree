import SwiftUI
import UserNotifications

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public struct NotificationSettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var notificationTime = Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date()
    @State private var dailyCheckInEnabled = UserDefaults.standard.bool(forKey: "dailyCheckInEnabled", defaultValue: true)
    @State private var progressUpdatesEnabled = UserDefaults.standard.bool(forKey: "progressUpdatesEnabled", defaultValue: true)
    @State private var milestoneAlertsEnabled = UserDefaults.standard.bool(forKey: "milestoneAlertsEnabled", defaultValue: true)
    
    @State private var showingPermissionAlert = false
    @State private var permissionStatus: UNAuthorizationStatus = .notDetermined
    @State private var isLoading = false
    
    public init() {}
    
    public var body: some View {
        Form {
            if isLoading {
                Section {
                    HStack {
                        Spacer()
                        SwiftUI.ProgressView()
                            .progressViewStyle(.circular)
                        Spacer()
                    }
                }
            }
            
            Section {
                Toggle("Enable Daily Check-In", isOn: Binding(
                    get: { dailyCheckInEnabled },
                    set: { 
                        dailyCheckInEnabled = $0
                        UserDefaults.standard.set($0, forKey: "dailyCheckInEnabled")
                        updateDailyCheckIn(enabled: $0)
                    }
                ))
                
                if dailyCheckInEnabled {
                    DatePicker(
                        "Reminder Time",
                        selection: Binding(
                            get: { notificationTime },
                            set: { 
                                notificationTime = $0
                                UserDefaults.standard.set($0, forKey: "notificationTime")
                                updateDailyCheckIn(time: $0)
                            }
                        ),
                        displayedComponents: .hourAndMinute
                    )
                }
            } header: {
                Text("Daily Check-In")
            } footer: {
                Text("Get reminded to check in and track your progress every day.")
            }
            
            Section {
                Toggle("Progress Updates", isOn: Binding(
                    get: { progressUpdatesEnabled },
                    set: { 
                        progressUpdatesEnabled = $0
                        UserDefaults.standard.set($0, forKey: "progressUpdatesEnabled")
                        updateProgressUpdates(enabled: $0)
                    }
                ))
                Toggle("Milestone Alerts", isOn: Binding(
                    get: { milestoneAlertsEnabled },
                    set: { 
                        milestoneAlertsEnabled = $0
                        UserDefaults.standard.set($0, forKey: "milestoneAlertsEnabled")
                        updateMilestoneAlerts(enabled: $0)
                    }
                ))
            } header: {
                Text("Other Notifications")
            } footer: {
                Text("Stay motivated with updates about your progress and achievements.")
            }
            
            Section {
                Button(action: openSystemSettings) {
                    HStack {
                        Text("System Notification Settings")
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                            .foregroundColor(BFDesignSystem.Colors.primary)
                    }
                }
            } footer: {
                Text("Manage all notification settings in your device's Settings app.")
            }
        }
        .navigationTitle("Notifications")
        .onAppear {
            checkAndUpdatePermissions()
        }
        .alert("Enable Notifications", isPresented: $showingPermissionAlert) {
            Button("Settings") {
                if let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications") {
                    NSWorkspace.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please enable notifications in Settings to receive reminders and updates.")
        }
    }
    
    private func updateDailyCheckIn(enabled: Bool? = nil, time: Date? = nil) {
        // TODO: Implement notification scheduling
    }
    
    private func updateProgressUpdates(enabled: Bool) {
        // TODO: Implement notification scheduling
    }
    
    private func updateMilestoneAlerts(enabled: Bool) {
        // TODO: Implement notification scheduling
    }
    
    private func checkAndUpdatePermissions() {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            let center = UNUserNotificationCenter.current()
            let status = await center.notificationSettings().authorizationStatus
            
            await MainActor.run {
                permissionStatus = status
                
                if status == .denied {
                    showingPermissionAlert = true
                } else if status == .notDetermined {
                    requestPermissions()
                }
            }
        }
    }
    
    private func requestPermissions() {
        Task {
            let center = UNUserNotificationCenter.current()
            do {
                let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
                if !granted {
                    showingPermissionAlert = true
                }
            } catch {
                print("Error requesting notification permissions: \(error)")
            }
        }
    }
    
    private func openSystemSettings() {
        #if os(iOS)
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
        #elseif os(macOS)
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications") {
            NSWorkspace.shared.open(url)
        }
        #endif
    }
}

#Preview {
    NotificationSettingsView()
        .environmentObject(AppState.preview)
}