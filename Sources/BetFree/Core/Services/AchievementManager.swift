import Foundation
import CoreData

@MainActor
public final class AchievementManager: ObservableObject {
    public static let shared = AchievementManager()
    
    private let achievementService: AchievementService
    private let notificationService: NotificationService
    
    @Published private(set) var recentlyUnlocked: [Achievement] = []
    @Published private(set) var isShowingUnlockAnimation = false
    @Published private(set) var achievements: [Achievement] = []
    
    private init() {
        self.achievementService = AchievementService(context: CoreDataManager.shared.context)
        self.notificationService = NotificationService.shared
    }
    
    public func checkProgress(
        streak: Int32,
        savings: Double,
        checkInTime: Date? = nil,
        transactionCount: Int = 0,
        daysUnderLimit: Int = 0,
        goalReached: Bool = false
    ) async throws {
        let previouslyUnlocked = try await achievementService.fetchAchievements().filter(\.isUnlocked)
        try await achievementService.checkAndUpdateAchievements(
            streak: streak,
            savings: savings,
            checkInTime: checkInTime,
            transactionCount: transactionCount,
            daysUnderLimit: daysUnderLimit,
            goalReached: goalReached
        )
        
        // Refresh achievements after update
        achievements = try await achievementService.fetchAchievements()
        
        // Find newly unlocked achievements
        let currentlyUnlocked = achievements.filter(\.isUnlocked)
        let newlyUnlocked = Set(currentlyUnlocked.map(\.id)).subtracting(Set(previouslyUnlocked.map(\.id)))
        if !newlyUnlocked.isEmpty {
            let newAchievements = currentlyUnlocked.filter { newlyUnlocked.contains($0.id) }
            await handleNewlyUnlockedAchievements(newAchievements)
        }
    }
    
    private func handleNewlyUnlockedAchievements(_ achievements: [Achievement]) async {
        // Update UI
        recentlyUnlocked = achievements
        isShowingUnlockAnimation = true
        
        // Schedule notifications
        for achievement in achievements {
            do {
                try await notificationService.scheduleMilestoneCelebration(
                    milestone: "the '\(achievement.title)' achievement"
                )
            } catch {
                print("Failed to schedule achievement notification: \(error)")
            }
        }
        
        // Auto-dismiss after delay
        try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds
        isShowingUnlockAnimation = false
        recentlyUnlocked.removeAll()
    }
    
    public func getProgress(forAchievement achievement: Achievement) -> Double {
        achievement.progress
    }
    
    public func getAllAchievements() async throws -> [Achievement] {
        achievements = try await achievementService.fetchAchievements()
        return achievements
    }
    
    public func initializeAchievements() async throws {
        try await achievementService.initializeDefaultAchievementsIfNeeded()
        achievements = try await achievementService.fetchAchievements()
    }
} 