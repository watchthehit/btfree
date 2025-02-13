import XCTest
@testable import BetFree

final class AchievementTests: XCTestCase {
    var achievementManager: AchievementManager!
    
    override func setUp() async throws {
        achievementManager = AchievementManager.shared
        try await achievementManager.initializeAchievements()
    }
    
    override func tearDown() async throws {
        achievementManager = nil
    }
    
    // MARK: - Achievement Progress Tests
    
    func testStreakAchievementProgress() async throws {
        // Given
        let streakDays: Int32 = 5
        
        // When
        try await achievementManager.checkProgress(streak: streakDays)
        
        // Then
        let weeklyAchievement = achievementManager.achievements
            .first { $0.id == "weekly_warrior" }
        XCTAssertNotNil(weeklyAchievement)
        XCTAssertEqual(weeklyAchievement?.progress, Double(streakDays) / 7.0)
    }
    
    func testSavingsAchievementProgress() async throws {
        // Given
        let savings = 75.0 // $75 out of $100 goal
        
        // When
        try await achievementManager.checkProgress(savings: savings)
        
        // Then
        let savingsAchievement = achievementManager.achievements
            .first { $0.id == "savings_100" }
        XCTAssertNotNil(savingsAchievement)
        XCTAssertEqual(savingsAchievement?.progress, 0.75)
    }
    
    // MARK: - Achievement Unlock Tests
    
    func testFirstDayAchievementUnlock() async throws {
        // Given
        let streakDays: Int32 = 1
        
        // When
        try await achievementManager.checkProgress(streak: streakDays)
        
        // Then
        let firstDayAchievement = achievementManager.achievements
            .first { $0.id == "first_day" }
        XCTAssertNotNil(firstDayAchievement)
        XCTAssertTrue(firstDayAchievement?.isUnlocked == true)
    }
    
    func testWeeklyWarriorUnlock() async throws {
        // Given
        let streakDays: Int32 = 7
        
        // When
        try await achievementManager.checkProgress(streak: streakDays)
        
        // Then
        let weeklyAchievement = achievementManager.achievements
            .first { $0.id == "weekly_warrior" }
        XCTAssertNotNil(weeklyAchievement)
        XCTAssertTrue(weeklyAchievement?.isUnlocked == true)
    }
    
    // MARK: - Achievement Date Tests
    
    func testAchievementUnlockDate() async throws {
        // Given
        let streakDays: Int32 = 1
        
        // When
        try await achievementManager.checkProgress(streak: streakDays)
        
        // Then
        let firstDayAchievement = achievementManager.achievements
            .first { $0.id == "first_day" }
        XCTAssertNotNil(firstDayAchievement?.unlockDate)
        
        // Verify unlock date is recent
        if let unlockDate = firstDayAchievement?.unlockDate {
            let timeDifference = Date().timeIntervalSince(unlockDate)
            XCTAssertLessThan(timeDifference, 1.0) // Less than 1 second ago
        }
    }
    
    // MARK: - Multiple Achievement Tests
    
    func testMultipleAchievementUnlocks() async throws {
        // Given
        let streakDays: Int32 = 7
        let savings = 100.0
        
        // When
        try await achievementManager.checkProgress(
            streak: streakDays,
            savings: savings
        )
        
        // Then
        let unlockedAchievements = achievementManager.achievements
            .filter { $0.isUnlocked }
        
        // Should have unlocked at least:
        // 1. First Day
        // 2. Weekly Warrior
        // 3. First $100
        XCTAssertGreaterThanOrEqual(unlockedAchievements.count, 3)
        
        // Verify specific achievements
        XCTAssertTrue(unlockedAchievements.contains { $0.id == "first_day" })
        XCTAssertTrue(unlockedAchievements.contains { $0.id == "weekly_warrior" })
        XCTAssertTrue(unlockedAchievements.contains { $0.id == "savings_100" })
    }
    
    // MARK: - Error Tests
    
    func testNegativeStreakHandling() async throws {
        // Given
        let negativeStreak: Int32 = -1
        
        // When/Then
        await XCTAssertThrowsError(
            try await achievementManager.checkProgress(streak: negativeStreak)
        )
    }
    
    func testNegativeSavingsHandling() async throws {
        // Given
        let negativeSavings = -100.0
        
        // When/Then
        await XCTAssertThrowsError(
            try await achievementManager.checkProgress(savings: negativeSavings)
        )
    }
} 