import XCTest
@testable import BetFree

@MainActor
final class AppStateTests: XCTestCase {
    var appState: AppState!
    var mockDataManager: MockDataManager!
    var mockCoreDataManager: MockCoreDataManager!
    
    override func setUp() async throws {
        try await super.setUp()
        
        print("Setting up AppStateTests environment...")
        
        // Create fresh instances
        mockCoreDataManager = MockCoreDataManager()
        mockDataManager = MockDataManager(context: mockCoreDataManager.context)
        
        // Initialize app state
        do {
            appState = try await AppState(dataManager: mockDataManager)
        } catch {
            XCTFail("Failed to initialize AppState: \(error)")
            throw error
        }
        
        // Verify initialization
        XCTAssertNotNil(appState, "AppState should be initialized")
        XCTAssertNotNil(mockDataManager.getCurrentUser(), "User should be created")
        
        print("AppStateTests environment setup complete")
    }
    
    override func tearDown() async throws {
        print("Tearing down AppStateTests environment...")
        
        // Clear references in reverse order
        appState = nil
        mockDataManager = nil
        mockCoreDataManager = nil
        
        try await super.tearDown()
        
        print("AppStateTests environment teardown complete")
    }
    
    // MARK: - Streak Tests
    
    func testStreakIncrement() async throws {
        // Given
        XCTAssertEqual(appState.currentStreak, 0)
        
        // When
        appState.updateStreak(1)
        
        // Then
        XCTAssertEqual(appState.currentStreak, 1)
        XCTAssertEqual(mockDataManager.getCurrentUser()?.streak, 1)
    }
    
    func testStreakReset() async throws {
        // Given
        appState.updateStreak(7)
        XCTAssertEqual(appState.currentStreak, 7)
        XCTAssertEqual(mockDataManager.getCurrentUser()?.streak, 7)
        
        // When
        appState.updateStreak(0)
        
        // Then
        XCTAssertEqual(appState.currentStreak, 0)
        XCTAssertEqual(mockDataManager.getCurrentUser()?.streak, 0)
    }
    
    // MARK: - Savings Tests
    
    func testSavingsUpdate() async throws {
        // Given
        XCTAssertEqual(appState.totalSavings, 0)
        
        // When
        appState.updateSavings(100)
        
        // Then
        XCTAssertEqual(appState.totalSavings, 100)
        XCTAssertEqual(mockDataManager.getCurrentUser()?.totalSavings, 100)
    }
    
    func testSavingsAccumulation() async throws {
        // Given
        appState.updateSavings(100)
        XCTAssertEqual(mockDataManager.getCurrentUser()?.totalSavings, 100)
        
        // When
        appState.updateSavings(150)
        
        // Then
        XCTAssertEqual(appState.totalSavings, 150)
        XCTAssertEqual(mockDataManager.getCurrentUser()?.totalSavings, 150)
    }
    
    // MARK: - Daily Limit Tests
    
    func testDailyLimitUpdate() async throws {
        // Given
        XCTAssertEqual(appState.dailyLimit, 0)
        
        // When
        appState.updateDailyLimit(50)
        
        // Then
        XCTAssertEqual(appState.dailyLimit, 50)
        
        // Verify Core Data was updated
        let user = mockDataManager.getCurrentUser()
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.dailyLimit, 50)
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
        
        // Verify Core Data was reset
        let user = mockDataManager.getCurrentUser()
        XCTAssertNil(user)
    }
} 