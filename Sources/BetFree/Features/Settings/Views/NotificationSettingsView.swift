import SwiftUI
import UserNotifications
#if canImport(UIKit)
import UIKit
#endif

public struct NotificationSettingsView: View {
    @State private var notificationTime = Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date()
    @State private var dailyCheckInEnabled = UserDefaults.standard.bool(forKey: "dailyCheckInEnabled", defaultValue: true)
    @State private var progressUpdatesEnabled = UserDefaults.standard.bool(forKey: "progressUpdatesEnabled", defaultValue: true)
    @State private var milestoneAlertsEnabled = UserDefaults.standard.bool(forKey: "milestoneAlertsEnabled", defaultValue: true)
    
    @State private var showingPermissionAlert = false
    @State private var permissionStatus: UNAuthorizationStatus = .notDetermined
    @State private var isLoading = false
    
    let appState: AppState
    
    public var body: some View {
        Form {
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
                        checkAndUpdatePermissions()
                    }
                ))
                
                Toggle("Milestone Alerts", isOn: Binding(
                    get: { milestoneAlertsEnabled },
                    set: { 
                        milestoneAlertsEnabled = $0
                        UserDefaults.standard.set($0, forKey: "milestoneAlertsEnabled")
                        checkAndUpdatePermissions()
                    }
                ))
            } header: {
                Text("Other Notifications")
            } footer: {
                Text("Stay motivated with progress updates and milestone celebrations.")
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
        .alert("Enable Notifications", isPresented: $showingPermissionAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Settings") {
                openSystemSettings()
            }
        } message: {
            Text("Please enable notifications in Settings to receive reminders and updates.")
        }
        .overlay {
            if isLoading {
                SwiftUI.ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.2))
            }
        }
        .onAppear {
            checkPermissionStatus()
        }
    }
    
    private func checkPermissionStatus() {
        Task {
            permissionStatus = await NotificationService.shared.checkPermissionStatus()
            updateTogglesBasedOnPermission()
        }
    }
    
    private func updateTogglesBasedOnPermission() {
        if permissionStatus != .authorized {
            dailyCheckInEnabled = false
            progressUpdatesEnabled = false
            milestoneAlertsEnabled = false
        }
    }
    
    private func checkAndUpdatePermissions() {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            let status = await NotificationService.shared.checkPermissionStatus()
            if status != .authorized {
                showingPermissionAlert = true
                updateTogglesBasedOnPermission()
            }
        }
    }
    
    private func updateDailyCheckIn(enabled: Bool? = nil, time: Date? = nil) {
        Task {
            do {
                if let enabled = enabled, !enabled {
                    NotificationService.shared.cancelNotification(withIdentifier: "dailyCheckIn")
                    return
                }
                
                if dailyCheckInEnabled {
                    try await NotificationService.shared.scheduleDailyCheckIn(at: time ?? notificationTime)
                }
            } catch {
                print("Error updating daily check-in: \(error)")
            }
        }
    }
    
    private func openSystemSettings() {
        #if canImport(UIKit)
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
        #endif
    }
    
    public init(appState: AppState) {
        self.appState = appState
    }
}

#Preview {
    NavigationView {
        NotificationSettingsView(appState: AppState())
    }
} 