import Foundation
@testable import BetFree

extension AchievementManager {
    static func createForTesting() -> AchievementManager {
        let mockTimeProvider = MockTimeProvider(fixedHour: 12)
        let manager = AchievementManager(
            timeProvider: mockTimeProvider,
            achievementService: AchievementService(
                context: MockCoreDataManager.shared.context,
                timeProvider: mockTimeProvider
            ),
            notificationService: MockNotificationService.shared
        )
        return manager
    }
    
    static func resetForTesting() {
        print("Resetting AchievementManager shared instance for testing...")
        shared = createForTesting()
        print("Successfully reset AchievementManager shared instance")
    }
} 