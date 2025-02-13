import XCTest
@testable import BetFree

final class AppStateTests: XCTestCase {
    var appState: AppState!
    
    override func setUp() async throws {
        appState = AppState()
    }
    
    override func tearDown() async throws {
        appState = nil
    }
    
    // MARK: - Streak Tests
    
    func testStreakIncrement() async throws {
        // Given
        XCTAssertEqual(appState.currentStreak, 0)
        
        // When
        appState.updateStreak(1)
        
        // Then
        XCTAssertEqual(appState.currentStreak, 1)
    }
    
    func testStreakReset() async throws {
        // Given
        appState.updateStreak(7)
        XCTAssertEqual(appState.currentStreak, 7)
        
        // When
        appState.updateStreak(0)
        
        // Then
        XCTAssertEqual(appState.currentStreak, 0)
    }
    
    // MARK: - Savings Tests
    
    func testSavingsUpdate() async throws {
        // Given
        XCTAssertEqual(appState.totalSavings, 0)
        
        // When
        appState.updateSavings(100)
        
        // Then
        XCTAssertEqual(appState.totalSavings, 100)
    }
    
    func testSavingsAccumulation() async throws {
        // Given
        appState.updateSavings(100)
        
        // When
        appState.updateSavings(150)
        
        // Then
        XCTAssertEqual(appState.totalSavings, 150)
    }
    
    // MARK: - Daily Limit Tests
    
    func testDailyLimitUpdate() async throws {
        // Given
        XCTAssertEqual(appState.dailyLimit, 0)
        
        // When
        appState.updateDailyLimit(50)
        
        // Then
        XCTAssertEqual(appState.dailyLimit, 50)
    }
    
    // MARK: - Achievement Tests
    
    func testTransactionCountIncrement() async throws {
        // Given initial state
        let initialCount = await appState.transactionCount
        
        // When
        await appState.incrementTransactionCount()
        
        // Then
        let newCount = await appState.transactionCount
        XCTAssertEqual(newCount, initialCount + 1)
    }
    
    func testDaysUnderLimitUpdate() async throws {
        // Given
        let days = 5
        
        // When
        await appState.updateDaysUnderLimit(days)
        
        // Then
        let updatedDays = await appState.daysUnderLimit
        XCTAssertEqual(updatedDays, days)
    }
    
    // MARK: - Onboarding Tests
    
    func testOnboardingCompletion() async throws {
        // Given
        XCTAssertFalse(appState.isOnboarded)
        
        // When
        appState.completeOnboarding()
        
        // Then
        XCTAssertTrue(appState.isOnboarded)
    }
    
    // MARK: - Logout Tests
    
    func testLogout() async throws {
        // Given
        appState.updateStreak(7)
        appState.updateSavings(100)
        appState.updateDailyLimit(50)
        appState.completeOnboarding()
        
        // When
        appState.logout()
        
        // Then
        XCTAssertEqual(appState.currentStreak, 0)
        XCTAssertEqual(appState.totalSavings, 0)
        XCTAssertEqual(appState.dailyLimit, 0)
        XCTAssertFalse(appState.isOnboarded)
    }
} 