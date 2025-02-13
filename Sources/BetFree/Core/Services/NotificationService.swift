import Foundation
@preconcurrency import UserNotifications

@MainActor
public final class NotificationService {
    public static let shared = NotificationService()
    
    private init() {}
    
    // MARK: - Permission Handling
    
    public func requestAuthorization() async throws -> Bool {
        try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
    }
    
    public func checkPermissionStatus() async -> UNAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus
    }
    
    // MARK: - Notification Scheduling
    
    public func scheduleDailyCheckIn(at date: Date) async throws {
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
        
        try await UNUserNotificationCenter.current().add(request)
    }
    
    public func scheduleProgressUpdate(title: String, message: String, at date: Date) async throws {
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
        
        try await UNUserNotificationCenter.current().add(request)
    }
    
    public func scheduleMilestoneCelebration(milestone: String) async throws {
        let content = UNMutableNotificationContent()
        content.title = "Milestone Achieved! 🎉"
        content.body = "Congratulations! You've reached \(milestone). Keep up the great work!"
        content.sound = .default
        content.categoryIdentifier = "milestone"
        
        // Schedule for immediate delivery
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "milestone-\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        
        try await UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Notification Management
    
    public func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    public func cancelNotification(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    public func setupNotificationCategories() {
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
        
        let celebrateAction = UNNotificationAction(
            identifier: "CELEBRATE",
            title: "View Achievement",
            options: .foreground
        )
        
        let milestoneCategory = UNNotificationCategory(
            identifier: "milestone",
            actions: [celebrateAction],
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([
            checkInCategory,
            progressCategory,
            milestoneCategory
        ])
    }
} 