#if DEBUG
import Foundation
import UserNotifications

@MainActor
public final class MockNotificationService: NotificationServiceType {
    public static var shared = MockNotificationService()
    
    private(set) var scheduledMilestones: [(milestone: String, date: Date)] = []
    private(set) var scheduledNotifications: [String] = []
    private(set) var permissionStatus: UNAuthorizationStatus = .notDetermined
    private var shouldGrantPermission = true
    private(set) var permissionRequests: Int = 0
    
    public init() {
        print("MockNotificationService initialized")
    }
    
    public func scheduleMilestoneCelebration(milestone: String) async throws {
        print("Mock: Scheduling notification for milestone: \(milestone)")
        scheduledMilestones.append((milestone: milestone, date: Date()))
    }
    
    public func removeAllNotifications() async {
        scheduledNotifications.removeAll()
    }
    
    public func checkPermissionStatus() async -> UNAuthorizationStatus {
        print("Mock: Checking permission status: \(permissionStatus)")
        return permissionStatus
    }
    
    public func requestPermissions() async throws -> Bool {
        print("Mock: Requesting permissions")
        permissionRequests += 1
        return shouldGrantPermission
    }
    
    // Test helper methods
    public func reset() {
        print("Mock: Resetting notification service state")
        scheduledMilestones.removeAll()
        scheduledNotifications.removeAll()
        permissionStatus = .notDetermined
        permissionRequests = 0
    }
    
    public func setPermissionStatus(_ status: UNAuthorizationStatus) {
        print("Mock: Setting permission status to: \(status)")
        permissionStatus = status
    }
    
    public func setShouldGrantPermission(_ shouldGrant: Bool) {
        shouldGrantPermission = shouldGrant
    }
    
    public func getScheduledMilestoneCount() -> Int {
        return scheduledMilestones.count
    }
    
    public func wasNotificationScheduled(forMilestone milestone: String) -> Bool {
        return scheduledMilestones.contains { $0.milestone == milestone }
    }
    
    // For testing purposes
    public static func resetShared() {
        print("Resetting MockNotificationService shared instance")
        shared = MockNotificationService()
        shared.reset()
    }
}
#endif