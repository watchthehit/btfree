import Foundation
import CoreData
import SwiftUI

@MainActor
public final class AchievementManager: ObservableObject {
    public static var shared = AchievementManager()
    
    private let achievementService: AchievementService
    private let timeProvider: TimeProvider
    private let notificationService: NotificationServiceType
    
    @Published private(set) var recentlyUnlocked: [Achievement] = []
    @Published private(set) var isShowingUnlockAnimation = false
    @Published private(set) var achievements: [Achievement] = []
    
    init(
        timeProvider: TimeProvider? = nil,
        achievementService: AchievementService? = nil,
        notificationService: NotificationServiceType? = nil
    ) {
        let tp = timeProvider ?? DefaultTimeProvider()
        self.timeProvider = tp
        self.achievementService = achievementService ?? AchievementService(
            context: CoreDataManager.shared.context,
            timeProvider: tp
        )
        self.notificationService = notificationService ?? NotificationService.shared
    }
    
    public func reset() {
        achievementService.reset()
        recentlyUnlocked = []
        isShowingUnlockAnimation = false
        achievements = []
    }
    
    public func initializeAchievements() async throws {
        try await achievementService.initializeDefaultAchievementsIfNeeded()
        achievements = try await achievementService.fetchAchievements()
    }
    
    public func checkProgress(
        streak: Int32,
        savings: Double,
        checkInTime: Date? = nil,
        transactionCount: Int = 0,
        daysUnderLimit: Int = 0,
        goalReached: Bool = false
    ) async throws {
        let unlockedAchievements = try await achievementService.checkProgress(
            streak: streak,
            savings: savings,
            checkInTime: checkInTime,
            transactionCount: transactionCount,
            daysUnderLimit: daysUnderLimit,
            goalReached: goalReached
        )
        
        if !unlockedAchievements.isEmpty {
            recentlyUnlocked = unlockedAchievements
            isShowingUnlockAnimation = true
            
            for achievement in unlockedAchievements {
                await notificationService.scheduleAchievementUnlockNotification(
                    title: achievement.title,
                    description: achievement.desc
                )
            }
            
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 3_000_000_000)
                isShowingUnlockAnimation = false
            }
        }
        
        achievements = try await achievementService.fetchAchievements()
    }
    
    public func getAllAchievements() async throws -> [Achievement] {
        achievements = try await achievementService.fetchAchievements()
        return achievements
    }
}

extension AchievementManager {
    public enum AchievementError: LocalizedError {
        case invalidStreak
        case invalidSavings
        case initializationFailed
        
        public var errorDescription: String? {
            switch self {
            case .invalidStreak:
                return "Streak cannot be negative"
            case .invalidSavings:
                return "Savings cannot be negative"
            case .initializationFailed:
                return "Failed to initialize achievements"
            }
        }
    }
} 