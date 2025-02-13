import Foundation
import CoreData

@MainActor
public final class AchievementManager: ObservableObject {
    public static let shared = AchievementManager()
    
    private let achievementService: AchievementService
    private let notificationService: NotificationService
    
    @Published private(set) var recentlyUnlocked: [Achievement] = []
    @Published private(set) var isShowingUnlockAnimation = false
    
    private init() {
        self.achievementService = AchievementService(context: CoreDataManager.shared.context)
        self.notificationService = NotificationService.shared
    }
    
    public func checkProgress(streak: Int32, savings: Double) async throws {
        let previouslyUnlocked = try achievementService.fetchAchievements().filter(\.isUnlocked)
        try await achievementService.checkAndUpdateAchievements(streak: streak, savings: savings)
        let currentlyUnlocked = try achievementService.fetchAchievements().filter(\.isUnlocked)
        
        // Find newly unlocked achievements
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.isShowingUnlockAnimation = false
            self?.recentlyUnlocked.removeAll()
        }
    }
    
    public func getProgress(forAchievement achievement: Achievement) -> Double {
        achievement.progress
    }
    
    public func getAllAchievements() throws -> [Achievement] {
        try achievementService.fetchAchievements()
    }
    
    public func initializeAchievements() throws {
        try achievementService.initializeDefaultAchievementsIfNeeded()
    }
} 