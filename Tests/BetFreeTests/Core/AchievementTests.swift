import XCTest
@testable import BetFree

@MainActor
final class AchievementTests: XCTestCase {
    var achievementManager: AchievementManager!
    var mockDataManager: MockDataManager!
    var mockNotificationService: MockNotificationService!
    var mockCoreDataManager: MockCoreDataManager!
    var mockTimeProvider: MockTimeProvider!
    var achievementService: AchievementService!
    
    override func setUp() async throws {
        try await super.setUp()
        
        print("Setting up test environment...")
        
        // Create fresh instances in order
        print("Creating fresh instances...")
        mockCoreDataManager = MockCoreDataManager()
        mockDataManager = MockDataManager(context: mockCoreDataManager.context)
        mockNotificationService = MockNotificationService()
        mockTimeProvider = MockTimeProvider(fixedHour: 12) // Use noon as default test time
        
        // Create achievement service with mock time provider
        achievementService = AchievementService(
            context: mockCoreDataManager.context,
            timeProvider: mockTimeProvider
        )
        
        // Set up shared instances
        MockNotificationService.shared = mockNotificationService
        
        // Initialize managers using the new testing extension
        print("Initializing managers...")
        AchievementManager.resetForTesting()
        achievementManager = AchievementManager.shared
        
        // Initialize achievements
        print("Initializing achievements...")
        try await achievementManager.initializeAchievements()
        
        print("Test environment setup complete")
    }
    
    override func tearDown() async throws {
        print("Tearing down test environment...")
        
        // Clear references in reverse order
        print("Clearing references...")
        achievementManager = nil
        mockDataManager = nil
        mockNotificationService = nil
        mockCoreDataManager = nil
        mockTimeProvider = nil
        achievementService = nil
        
        // Reset shared instances
        MockNotificationService.shared = MockNotificationService()
        AchievementManager.resetForTesting()
        
        try await super.tearDown()
        
        print("Test environment teardown complete")
    }
    
    // MARK: - Achievement Initialization Tests
    
    func testAchievementInitialization() async throws {
        print("Starting testAchievementInitialization...")
        
        // When
        print("Fetching achievements...")
        let achievements = try await achievementManager.getAllAchievements()
        
        // Then
        print("Verifying achievements...")
        XCTAssertFalse(achievements.isEmpty, "Should have default achievements")
        XCTAssertTrue(achievements.contains { $0.title == "First Step" }, "Should contain First Step achievement")
        XCTAssertTrue(achievements.contains { $0.title == "Week Warrior" }, "Should contain Week Warrior achievement")
        
        print("Test completed successfully")
    }
    
    // MARK: - Achievement Progress Tests
    
    func testStreakAchievementProgress() async throws {
        do {
            // Given
            let streakDays: Int32 = 5
            mockTimeProvider.setFixedHour(12) // Use noon to avoid time-based achievements
            
            // When
            let unlockedAchievements = try await achievementService.checkProgress(
                streak: streakDays,
                savings: 0,
                checkInTime: mockTimeProvider.now(),
                transactionCount: 0,
                daysUnderLimit: 0,
                goalReached: false
            )
            
            // Then
            let achievements = try await achievementManager.getAllAchievements()
            let firstStepAchievement = achievements.first { $0.title == "First Step" }
            XCTAssertNotNil(firstStepAchievement)
            XCTAssertEqual(firstStepAchievement?.progress, 1.0)
            XCTAssertTrue(firstStepAchievement?.isUnlocked == true)
            XCTAssertTrue(unlockedAchievements.contains { $0.title == "First Step" })
            
            // Verify notification was scheduled
            XCTAssertTrue(mockNotificationService.wasNotificationScheduled(forMilestone: "the 'First Step' achievement"))
            
            let weekWarriorAchievement = achievements.first { $0.title == "Week Warrior" }
            XCTAssertNotNil(weekWarriorAchievement)
            XCTAssertEqual(weekWarriorAchievement?.progress, Double(streakDays) / 7.0)
            XCTAssertFalse(weekWarriorAchievement?.isUnlocked == true)
            XCTAssertFalse(unlockedAchievements.contains { $0.title == "Week Warrior" })
        } catch {
            XCTFail("Test failed with error: \(error)")
            throw error
        }
    }
    
    func testSavingsAchievementProgress() async throws {
        do {
            // Given
            let savings = 75.0 // $75 out of $100 goal
            mockTimeProvider.setFixedHour(12) // Use noon to avoid time-based achievements
            
            // When
            let unlockedAchievements = try await achievementService.checkProgress(
                streak: 0,
                savings: savings,
                checkInTime: mockTimeProvider.now(),
                transactionCount: 0,
                daysUnderLimit: 0,
                goalReached: false
            )
            
            // Then
            let achievements = try await achievementManager.getAllAchievements()
            let moneyMasterAchievement = achievements.first { $0.title == "Money Master" }
            XCTAssertNotNil(moneyMasterAchievement)
            XCTAssertEqual(moneyMasterAchievement?.progress, 0.75)
            XCTAssertFalse(moneyMasterAchievement?.isUnlocked == true)
            XCTAssertFalse(unlockedAchievements.contains { $0.title == "Money Master" })
            
            // Verify no notification was scheduled
            XCTAssertFalse(mockNotificationService.wasNotificationScheduled(forMilestone: "the 'Money Master' achievement"))
        } catch {
            XCTFail("Test failed with error: \(error)")
            throw error
        }
    }
    
    func testConsistencyKingProgress() async throws {
        do {
            // Given
            let streakDays: Int32 = 7 // Need 7-day streak first
            mockTimeProvider.setFixedHour(9) // Set consistent check-in time
            
            // First unlock Week Warrior (prerequisite)
            _ = try await achievementService.checkProgress(
                streak: streakDays,
                savings: 0,
                checkInTime: mockTimeProvider.now(),
                transactionCount: 0,
                daysUnderLimit: 0,
                goalReached: false
            )
            
            // Then test Consistency King progress
            for day in 1...5 {
                // When - Check in at the same time for 5 days
                let unlockedAchievements = try await achievementService.checkProgress(
                    streak: streakDays + Int32(day),
                    savings: 0,
                    checkInTime: mockTimeProvider.now(),
                    transactionCount: 0,
                    daysUnderLimit: 0,
                    goalReached: false
                )
                
                // Then
                let achievements = try await achievementManager.getAllAchievements()
                let consistencyKing = achievements.first { $0.title == "Consistency King" }
                XCTAssertNotNil(consistencyKing)
                XCTAssertEqual(consistencyKing?.progress, Double(day) * 0.2)
                
                if day < 5 {
                    XCTAssertFalse(consistencyKing?.isUnlocked == true)
                    XCTAssertFalse(unlockedAchievements.contains { $0.title == "Consistency King" })
                } else {
                    XCTAssertTrue(consistencyKing?.isUnlocked == true)
                    XCTAssertTrue(unlockedAchievements.contains { $0.title == "Consistency King" })
                    XCTAssertTrue(mockNotificationService.wasNotificationScheduled(forMilestone: "the 'Consistency King' achievement"))
                }
            }
        } catch {
            XCTFail("Test failed with error: \(error)")
            throw error
        }
    }
    
    func testConsistencyKingProgressReset() async throws {
        do {
            // Given
            let streakDays: Int32 = 7 // Need 7-day streak first
            mockTimeProvider.setFixedHour(9) // Start with morning check-in
            
            // First unlock Week Warrior (prerequisite)
            _ = try await achievementService.checkProgress(
                streak: streakDays,
                savings: 0,
                checkInTime: mockTimeProvider.now(),
                transactionCount: 0,
                daysUnderLimit: 0,
                goalReached: false
            )
            
            // Get some progress
            _ = try await achievementService.checkProgress(
                streak: streakDays + 1,
                savings: 0,
                checkInTime: mockTimeProvider.now(),
                transactionCount: 0,
                daysUnderLimit: 0,
                goalReached: false
            )
            
            // Verify initial progress
            var achievements = try await achievementManager.getAllAchievements()
            var consistencyKing = achievements.first { $0.title == "Consistency King" }
            XCTAssertEqual(consistencyKing?.progress, 0.2)
            
            // When - Check in at a different time
            mockTimeProvider.setFixedHour(20) // Evening check-in
            let unlockedAchievements = try await achievementService.checkProgress(
                streak: streakDays + 2,
                savings: 0,
                checkInTime: mockTimeProvider.now(),
                transactionCount: 0,
                daysUnderLimit: 0,
                goalReached: false
            )
            
            // Then - Progress should reset
            achievements = try await achievementManager.getAllAchievements()
            consistencyKing = achievements.first { $0.title == "Consistency King" }
            XCTAssertEqual(consistencyKing?.progress, 0.0)
            XCTAssertFalse(consistencyKing?.isUnlocked == true)
            XCTAssertFalse(unlockedAchievements.contains { $0.title == "Consistency King" })
        } catch {
            XCTFail("Test failed with error: \(error)")
            throw error
        }
    }
    
    // MARK: - Achievement Unlock Tests
    
    func testFirstDayAchievementUnlock() async throws {
        do {
            // Given
            let streakDays: Int32 = 1
            mockTimeProvider.setFixedHour(12) // Use noon to avoid time-based achievements
            
            // When
            let unlockedAchievements = try await achievementService.checkProgress(
                streak: streakDays,
                savings: 0,
                checkInTime: mockTimeProvider.now(),
                transactionCount: 0,
                daysUnderLimit: 0,
                goalReached: false
            )
            
            // Then
            let achievements = try await achievementManager.getAllAchievements()
            let firstStepAchievement = achievements.first { $0.title == "First Step" }
            XCTAssertNotNil(firstStepAchievement)
            XCTAssertTrue(firstStepAchievement?.isUnlocked == true)
            XCTAssertNotNil(firstStepAchievement?.unlockDate)
            XCTAssertTrue(unlockedAchievements.contains { $0.title == "First Step" })
            
            // Verify notification was scheduled
            XCTAssertTrue(mockNotificationService.wasNotificationScheduled(forMilestone: "the 'First Step' achievement"))
            XCTAssertEqual(mockNotificationService.getScheduledMilestoneCount(), 1)
        } catch {
            XCTFail("Test failed with error: \(error)")
            throw error
        }
    }
    
    func testWeeklyWarriorUnlock() async throws {
        do {
            // Given
            let streakDays: Int32 = 7
            mockTimeProvider.setFixedHour(12) // Use noon to avoid time-based achievements
            
            // When
            let unlockedAchievements = try await achievementService.checkProgress(
                streak: streakDays,
                savings: 0,
                checkInTime: mockTimeProvider.now(),
                transactionCount: 0,
                daysUnderLimit: 0,
                goalReached: false
            )
            
            // Then
            let achievements = try await achievementManager.getAllAchievements()
            let weekWarriorAchievement = achievements.first { $0.title == "Week Warrior" }
            XCTAssertNotNil(weekWarriorAchievement)
            XCTAssertTrue(weekWarriorAchievement?.isUnlocked == true)
            XCTAssertNotNil(weekWarriorAchievement?.unlockDate)
            XCTAssertTrue(unlockedAchievements.contains { $0.title == "Week Warrior" })
            
            // Verify notifications were scheduled for both First Step and Week Warrior
            XCTAssertTrue(mockNotificationService.wasNotificationScheduled(forMilestone: "the 'First Step' achievement"))
            XCTAssertTrue(mockNotificationService.wasNotificationScheduled(forMilestone: "the 'Week Warrior' achievement"))
            XCTAssertEqual(mockNotificationService.getScheduledMilestoneCount(), 2)
        } catch {
            XCTFail("Test failed with error: \(error)")
            throw error
        }
    }
    
    // MARK: - Achievement Date Tests
    
    func testAchievementUnlockDate() async throws {
        do {
            // Given
            let streakDays: Int32 = 1
            let startDate = mockTimeProvider.now()
            mockTimeProvider.setFixedHour(12) // Use noon to avoid time-based achievements
            
            // When
            let unlockedAchievements = try await achievementService.checkProgress(
                streak: streakDays,
                savings: 0,
                checkInTime: mockTimeProvider.now(),
                transactionCount: 0,
                daysUnderLimit: 0,
                goalReached: false
            )
            
            // Then
            let achievements = try await achievementManager.getAllAchievements()
            let firstStepAchievement = achievements.first { $0.title == "First Step" }
            XCTAssertNotNil(firstStepAchievement)
            XCTAssertNotNil(firstStepAchievement?.unlockDate)
            XCTAssertTrue(unlockedAchievements.contains { $0.title == "First Step" })
            
            // Verify unlock date is recent
            if let unlockDate = firstStepAchievement?.unlockDate {
                let timeDifference = unlockDate.timeIntervalSince(startDate)
                XCTAssertLessThan(timeDifference, 1.0) // Less than 1 second ago
            }
            
            // Verify notification was scheduled
            XCTAssertTrue(mockNotificationService.wasNotificationScheduled(forMilestone: "the 'First Step' achievement"))
        } catch {
            XCTFail("Test failed with error: \(error)")
            throw error
        }
    }
    
    // MARK: - Multiple Achievement Tests
    
    func testMultipleAchievementUnlocks() async throws {
        do {
            // Given
            let streakDays: Int32 = 7
            let savings = 100.0
            mockTimeProvider.setFixedHour(12) // Use noon to avoid time-based achievements
            
            // When
            let unlockedAchievements = try await achievementService.checkProgress(
                streak: streakDays,
                savings: savings,
                checkInTime: mockTimeProvider.now(),
                transactionCount: 0,
                daysUnderLimit: 0,
                goalReached: false
            )
            
            // Then
            let achievements = try await achievementManager.getAllAchievements()
            let unlockedAchievementsFromDB = achievements.filter { $0.isUnlocked }
            
            // Should have unlocked exactly:
            // 1. First Step
            // 2. Week Warrior
            // 3. Money Master
            XCTAssertEqual(unlockedAchievements.count, 3)
            XCTAssertEqual(unlockedAchievementsFromDB.count, 3)
            
            // Verify specific achievements
            XCTAssertTrue(unlockedAchievements.contains { $0.title == "First Step" })
            XCTAssertTrue(unlockedAchievements.contains { $0.title == "Week Warrior" })
            XCTAssertTrue(unlockedAchievements.contains { $0.title == "Money Master" })
            
            // Verify notifications were scheduled for all unlocked achievements
            XCTAssertTrue(mockNotificationService.wasNotificationScheduled(forMilestone: "the 'First Step' achievement"))
            XCTAssertTrue(mockNotificationService.wasNotificationScheduled(forMilestone: "the 'Week Warrior' achievement"))
            XCTAssertTrue(mockNotificationService.wasNotificationScheduled(forMilestone: "the 'Money Master' achievement"))
            XCTAssertEqual(mockNotificationService.getScheduledMilestoneCount(), 3)
        } catch {
            XCTFail("Test failed with error: \(error)")
            throw error
        }
    }
    
    // MARK: - Error Tests
    
    func testNegativeStreakHandling() async throws {
        do {
            // Given
            let negativeStreak: Int32 = -1
            
            // When/Then
            do {
                _ = try await achievementManager.checkProgress(
                    streak: negativeStreak,
                    savings: 0,
                    checkInTime: Date(),
                    transactionCount: 0,
                    daysUnderLimit: 0,
                    goalReached: false
                )
                XCTFail("Expected error to be thrown")
            } catch {
                // Success - error was thrown as expected
            }
            
            // Verify no notifications were scheduled
            XCTAssertEqual(mockNotificationService.getScheduledMilestoneCount(), 0)
        } catch {
            XCTFail("Test failed with error: \(error)")
            throw error
        }
    }
    
    func testNegativeSavingsHandling() async throws {
        do {
            // Given
            let negativeSavings = -100.0
            
            // When/Then
            do {
                _ = try await achievementManager.checkProgress(
                    streak: 0,
                    savings: negativeSavings,
                    checkInTime: Date(),
                    transactionCount: 0,
                    daysUnderLimit: 0,
                    goalReached: false
                )
                XCTFail("Expected error to be thrown")
            } catch {
                // Success - error was thrown as expected
            }
            
            // Verify no notifications were scheduled
            XCTAssertEqual(mockNotificationService.getScheduledMilestoneCount(), 0)
        } catch {
            XCTFail("Test failed with error: \(error)")
            throw error
        }
    }
    
    // MARK: - Notification Permission Tests
    
    func testNotificationPermissionDenied() async throws {
        do {
            // Given
            mockNotificationService.setPermissionStatus(.denied)
            let streakDays: Int32 = 1
            mockTimeProvider.setFixedHour(12) // Use noon to avoid time-based achievements
            
            // When
            let unlockedAchievements = try await achievementService.checkProgress(
                streak: streakDays,
                savings: 0,
                checkInTime: mockTimeProvider.now(),
                transactionCount: 0,
                daysUnderLimit: 0,
                goalReached: false
            )
            
            // Then
            // Achievement should still unlock
            let achievements = try await achievementManager.getAllAchievements()
            let firstStepAchievement = achievements.first { $0.title == "First Step" }
            XCTAssertNotNil(firstStepAchievement)
            XCTAssertTrue(firstStepAchievement?.isUnlocked == true)
            XCTAssertTrue(unlockedAchievements.contains { $0.title == "First Step" })
            
            // But no notification should be scheduled
            XCTAssertEqual(mockNotificationService.getScheduledMilestoneCount(), 0)
        } catch {
            XCTFail("Test failed with error: \(error)")
            throw error
        }
    }
} 