import Foundation
@preconcurrency import UserNotifications

@MainActor
public protocol NotificationServiceType {
    func scheduleMilestoneCelebration(milestone: String) async throws
    func checkPermissionStatus() async -> UNAuthorizationStatus
    func requestPermissions() async throws -> Bool
}

@MainActor
public final class NotificationService: NotificationServiceType {
    public static var shared = NotificationService()
    
    private var _notificationCenter: UNUserNotificationCenter?
    private var isTestEnvironment: Bool
    
    private var notificationCenter: UNUserNotificationCenter? {
        if isTestEnvironment {
            // Running in tests, don't initialize notification center
            print("NotificationService running in test mode")
            return nil
        }
        
        if _notificationCenter == nil {
            print("Setting up real notification center")
            _notificationCenter = UNUserNotificationCenter.current()
        }
        return _notificationCenter
    }
    
    private init() {
        print("NotificationService initialized")
        self.isTestEnvironment = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        print(isTestEnvironment ? "Running in test environment" : "Running in production environment")
    }
    
    // MARK: - Permission Handling
    
    public func checkPermissionStatus() async -> UNAuthorizationStatus {
        if isTestEnvironment {
            print("Mock: Checking permission status in test mode")
            return .authorized
        }
        
        guard let notificationCenter = notificationCenter else {
            print("Warning: No notification center available")
            return .notDetermined
        }
        
        let settings = await notificationCenter.notificationSettings()
        return settings.authorizationStatus
    }
    
    public func requestPermissions() async throws -> Bool {
        if isTestEnvironment {
            print("Mock: Requesting permissions in test mode")
            return true
        }
        
        guard let notificationCenter = notificationCenter else {
            print("Warning: No notification center available")
            return false
        }
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        do {
            return try await notificationCenter.requestAuthorization(options: options)
        } catch {
            print("Error requesting notification permissions: \(error)")
            throw error
        }
    }
    
    // MARK: - Scheduling Notifications
    
    public func scheduleMilestoneCelebration(milestone: String) async throws {
        if isTestEnvironment {
            print("Mock: Would schedule notification for milestone: \(milestone)")
            return
        }
        
        guard let notificationCenter = notificationCenter else {
            print("Warning: No notification center available")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Milestone Achieved! 🎉"
        content.body = "Congratulations on reaching \(milestone)!"
        content.sound = .default
        
        // Create a unique identifier for the notification
        let identifier = "milestone_\(UUID().uuidString)"
        
        // Schedule for immediate delivery
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: nil // nil trigger means deliver immediately
        )
        
        do {
            try await notificationCenter.add(request)
        } catch {
            print("Error scheduling milestone notification: \(error)")
            throw error
        }
    }
    
    // MARK: - Notification Scheduling
    
    public func scheduleDailyCheckIn(at date: Date) async throws {
        if isTestEnvironment {
            print("Mock: Would schedule daily check-in notification")
            return
        }
        
        guard let notificationCenter = notificationCenter else {
            print("Warning: No notification center available")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Daily Check-In"
        content.body = "Time to track your progress and stay on course!"
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "dailyCheckIn",
            content: content,
            trigger: trigger
        )
        
        try await notificationCenter.add(request)
    }
    
    public func scheduleProgressUpdate(title: String, message: String, at date: Date) async throws {
        if isTestEnvironment {
            print("Mock: Would schedule progress update notification")
            return
        }
        
        guard let notificationCenter = notificationCenter else {
            print("Warning: No notification center available")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default
        content.categoryIdentifier = "progressUpdate"
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date),
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "progressUpdate-\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        
        try await notificationCenter.add(request)
    }
    
    // MARK: - Notification Management
    
    public func cancelAllNotifications() {
        if isTestEnvironment {
            print("Mock: Would cancel all notifications")
            return
        }
        notificationCenter?.removeAllPendingNotificationRequests()
    }
    
    public func cancelNotification(withIdentifier identifier: String) {
        if isTestEnvironment {
            print("Mock: Would cancel notification with identifier: \(identifier)")
            return
        }
        notificationCenter?.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    public func setupNotificationCategories() {
        if isTestEnvironment {
            print("Mock: Would setup notification categories")
            return
        }
        
        guard let notificationCenter = notificationCenter else {
            print("Warning: No notification center available")
            return
        }
        
        let checkInAction = UNNotificationAction(
            identifier: "CHECK_IN",
            title: "Check In Now",
            options: .foreground
        )
        
        let checkInCategory = UNNotificationCategory(
            identifier: "dailyCheckIn",
            actions: [checkInAction],
            intentIdentifiers: [],
            options: []
        )
        
        let viewProgressAction = UNNotificationAction(
            identifier: "VIEW_PROGRESS",
            title: "View Progress",
            options: .foreground
        )
        
        let progressCategory = UNNotificationCategory(
            identifier: "progressUpdate",
            actions: [viewProgressAction],
            intentIdentifiers: [],
            options: []
        )
        
        notificationCenter.setNotificationCategories([
            checkInCategory,
            progressCategory
        ])
    }
    
    // For testing purposes
    #if DEBUG
    public static func resetShared() {
        print("Resetting NotificationService shared instance")
        shared = NotificationService()
    }
    #endif
} 