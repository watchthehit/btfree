# BetFree Testing Plan

## Overview
This document outlines the comprehensive testing strategy for the BetFree iOS application, covering unit tests, integration tests, UI tests, and performance testing.

## Test Coverage Goals

### Target Metrics
- Unit Test Coverage: 80%
- Integration Test Coverage: 70%
- UI Test Coverage: Key user flows
- Performance Test Baselines: Established for critical paths

## Testing Levels

### 1. Unit Tests

#### Core State Tests
```swift
class AppStateTests: XCTestCase {
    var appState: AppState!
    
    override func setUp() {
        appState = AppState()
    }
    
    func testStreakIncrement() async throws {
        // Given
        XCTAssertEqual(appState.currentStreak, 0)
        
        // When
        appState.updateStreak(1)
        
        // Then
        XCTAssertEqual(appState.currentStreak, 1)
    }
    
    func testSavingsUpdate() async throws {
        // Given
        XCTAssertEqual(appState.totalSavings, 0)
        
        // When
        appState.updateSavings(100)
        
        // Then
        XCTAssertEqual(appState.totalSavings, 100)
    }
}
```

#### Achievement System Tests
```swift
class AchievementTests: XCTestCase {
    var achievementManager: AchievementManager!
    
    func testAchievementUnlock() async throws {
        // Given
        let achievement = Achievement(id: "first_day", 
                                   title: "First Day",
                                   desc: "Complete your first day",
                                   type: .streak)
        
        // When
        try await achievementManager.checkProgress(streak: 1)
        
        // Then
        XCTAssertTrue(achievement.isUnlocked)
    }
    
    func testProgressCalculation() async throws {
        // Given
        let achievement = Achievement(id: "savings_100",
                                   title: "First Savings",
                                   desc: "Save your first $100",
                                   type: .savings)
        
        // When
        try await achievementManager.checkProgress(savings: 50)
        
        // Then
        XCTAssertEqual(achievement.progress, 0.5)
    }
}
```

### 2. Integration Tests

#### Data Flow Tests
```swift
class DataFlowTests: XCTestCase {
    var appState: AppState!
    var achievementManager: AchievementManager!
    
    func testStreakAchievementIntegration() async throws {
        // Given
        appState.updateStreak(7)
        
        // When
        try await achievementManager.checkProgress(streak: Int32(appState.currentStreak))
        
        // Then
        let weeklyAchievement = achievementManager.achievements
            .first { $0.id == "weekly_warrior" }
        XCTAssertTrue(weeklyAchievement?.isUnlocked == true)
    }
}
```

#### Service Integration Tests
```swift
class ServiceIntegrationTests: XCTestCase {
    var notificationService: NotificationService!
    var achievementManager: AchievementManager!
    
    func testAchievementNotification() async throws {
        // Given
        let achievement = Achievement(id: "first_day")
        
        // When
        try await achievementManager.unlockAchievement(achievement)
        
        // Then
        // Verify notification was scheduled
        let notifications = await notificationService.pendingNotifications()
        XCTAssertTrue(notifications.contains { $0.identifier == "achievement_\(achievement.id)" })
    }
}
```

### 3. UI Tests

#### User Flow Tests
```swift
class UserFlowUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        app.launch()
    }
    
    func testOnboardingFlow() {
        // Test welcome screen
        XCTAssertTrue(app.staticTexts["Welcome to BetFree"].exists)
        
        // Navigate through onboarding
        app.buttons["Continue"].tap()
        
        // Verify goal selection
        XCTAssertTrue(app.staticTexts["Select Your Goal"].exists)
        
        // Complete onboarding
        app.buttons["Get Started"].tap()
        
        // Verify dashboard is shown
        XCTAssertTrue(app.navigationBars["Dashboard"].exists)
    }
    
    func testPaywallFlow() {
        // Navigate to paywall
        app.buttons["Upgrade"].tap()
        
        // Verify paywall content
        XCTAssertTrue(app.staticTexts["Transform Your Life"].exists)
        
        // Test plan selection
        app.buttons["Annual Plan"].tap()
        XCTAssertTrue(app.staticTexts["$79.99"].exists)
    }
}
```

### 4. Performance Tests

#### Memory Tests
```swift
class MemoryTests: XCTestCase {
    func testMemoryLeaks() {
        measure(metrics: [XCTMemoryMetric()]) {
            // Create and destroy view hierarchy
            let view = OnboardingView()
            let _ = view.body
        }
    }
}
```

#### Animation Performance
```swift
class AnimationPerformanceTests: XCTestCase {
    func testAchievementUnlockAnimation() {
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            // Trigger achievement unlock animation
            let view = AchievementUnlockView(achievement: Achievement.sample)
            let _ = view.body
        }
    }
}
```

## Test Implementation Plan

### Phase 1: Core Testing (Week 1-2)
1. Setup XCTest framework
2. Implement core state tests
3. Add basic UI tests
4. Setup CI for tests

### Phase 2: Integration Testing (Week 3-4)
1. Implement service integration tests
2. Add data flow tests
3. Setup test data management
4. Add mock services

### Phase 3: UI Testing (Week 5-6)
1. Implement key user flow tests
2. Add accessibility tests
3. Setup UI test automation
4. Create UI test reports

### Phase 4: Performance Testing (Week 7-8)
1. Setup performance metrics
2. Implement memory tests
3. Add animation performance tests
4. Create performance baselines

## Test Automation

### CI/CD Integration
```yaml
# .github/workflows/tests.yml
name: Tests

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build and Test
        run: |
          xcodebuild test -scheme BetFree -destination 'platform=iOS Simulator,name=iPhone 14'
```

### Test Reports
- Generate test coverage reports
- Track performance metrics over time
- Monitor UI test success rates

## Best Practices

### Code Coverage
- Use `@testable import BetFree`
- Cover edge cases
- Test async/await properly
- Include error scenarios

### UI Testing
- Use accessibility identifiers
- Test different device sizes
- Include orientation changes
- Test offline scenarios

### Performance Testing
- Establish baselines
- Monitor memory usage
- Track frame rates
- Test background operations

## Tools and Dependencies

### Required Tools
- XCTest
- XCUITest
- XCTMetrics
- Code Coverage tools

### Optional Tools
- Quick/Nimble for BDD
- SwiftLint for code quality
- Fastlane for automation

## Maintenance

### Regular Tasks
1. Update test cases for new features
2. Review and update performance baselines
3. Maintain mock data
4. Update UI tests for design changes

### Documentation
1. Keep test documentation updated
2. Document test patterns
3. Maintain testing guidelines
4. Update setup instructions 