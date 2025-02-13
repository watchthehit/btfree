# BetFree Troubleshooting Guide

## Common Issues and Solutions

### UI Issues

#### 1. Paywall Layout Problems
**Issue**: Text doesn't fit properly and background doesn't cover the entire page.

**Solution**:
```swift
// ❌ Wrong Implementation
VStack {
    Text("Long text")
    // Missing proper constraints
}

// ✅ Correct Implementation
ZStack {
    // Full screen background
    BFDesignSystem.Colors.background
        .ignoresSafeArea()
    
    ScrollView {
        VStack {
            Text("Long text")
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
```

#### 2. Gradient Type Mismatches
**Issue**: Type mismatch between LinearGradient and Color in conditional statements.

**Solution**:
```swift
// ❌ Wrong
.fill(isSelected ? BFDesignSystem.Colors.calmingGradient : BFDesignSystem.Colors.cardBackground)

// ✅ Correct
.fill(isSelected ? BFDesignSystem.Colors.calmingGradient : LinearGradient(
    colors: [BFDesignSystem.Colors.cardBackground, BFDesignSystem.Colors.cardBackground],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
))
```

#### 3. Price Display Issues
**Issue**: Decimal points in prices appear misaligned or broken.

**Solution**:
```swift
// ❌ Wrong
HStack {
    Text("$79")
    Text(".99").baselineOffset(-4)
}

// ✅ Correct
Text("$79.99")
    .font(BFDesignSystem.Typography.titleLarge)
```

### iOS Compatibility

#### 1. iOS 17 Compatibility
**Issue**: 'onChange(of:initial:_:)' only available in iOS 17.0 or newer.

**Solution**:
```swift
// ❌ iOS 17 Only
.onChange(of: viewModel.currentStep) { oldValue, newValue in }

// ✅ Compatible Solution
.onChange(of: viewModel.currentStep) { newValue in }
```

#### 2. Async/Await Issues
**Issue**: "No 'async' operations occur within 'await' expression"

**Solution**:
```swift
// ❌ Wrong Implementation
private func initializeAsyncComponents() async {
    try? await AchievementManager.shared.initializeAchievements()
    await checkAchievements()
}

// ✅ Correct Implementation
private func initializeAsyncComponents() async {
    do {
        try await AchievementManager.shared.initializeAchievements()
        await checkAchievements()
    } catch {
        print("Error initializing async components: \(error)")
    }
}
```

### Package Dependencies

#### 1. Swift Syntax Conflicts
**Issue**: Multiple packages depending on different versions of swift-syntax.

**Solution**:
1. Update package dependencies to latest versions
2. Resolve conflicts in Package.swift:
```swift
dependencies: [
    .package(url: "https://github.com/apple/swift-syntax.git", exact: "509.0.0")
]
```

#### 2. Package Resolution
**Issue**: Package resolution fails or shows conflicts.

**Solution**:
```bash
# Clear package cache
rm -rf ~/Library/Caches/org.swift.swiftpm/

# Reset package resolution
rm Package.resolved
xed .
```

### State Management

#### 1. State Update Issues
**Issue**: UI not updating when state changes.

**Solution**:
```swift
// ❌ Wrong
class AppState {
    var currentStreak: Int
}

// ✅ Correct
class AppState: ObservableObject {
    @Published var currentStreak: Int
}
```

#### 2. CoreData Integration
**Issue**: CoreData updates not reflecting in UI.

**Solution**:
```swift
// ❌ Wrong
try? CoreDataManager.shared.updateUserStreak()

// ✅ Correct
do {
    try await CoreDataManager.shared.updateUserStreak()
    await MainActor.run {
        // Update UI state
    }
} catch {
    print("Error updating streak: \(error)")
}
```

### Performance Issues

#### 1. Memory Management
**Issue**: Memory leaks in achievement tracking.

**Solution**:
```swift
// ❌ Memory Leak
class AchievementTracker {
    var handler: (() -> Void)?
    
    init(appState: AppState) {
        handler = { [appState] in
            // This creates a retain cycle
        }
    }
}

// ✅ Correct
class AchievementTracker {
    weak var appState: AppState?
    
    init(appState: AppState) {
        self.appState = appState
    }
}
```

#### 2. Animation Performance
**Issue**: Laggy animations in achievement unlocks.

**Solution**:
```swift
// ❌ Heavy Animation
.animation(.spring(), value: isAnimating) // All properties

// ✅ Optimized
.animation(.spring(response: 0.3), value: isAnimating) // Specific properties
```

### Build Issues

#### 1. Xcode Clean Build
**Issue**: Inconsistent behavior after updates.

**Solution**:
```bash
# Clean build folder
cmd + shift + k

# Clean build folder and derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/*
```

#### 2. SwiftUI Preview Issues
**Issue**: Previews not updating or crashing.

**Solution**:
1. Delete derived data
2. Restart Xcode
3. Use explicit preview configuration:
```swift
#Preview {
    PaywallView(isPresented: .constant(true)) {
        print("Subscribe tapped")
    }
    .environment(\.managedObjectContext, CoreDataManager.preview.context)
}
```

### Testing Issues

#### 1. Unit Test Failures
**Issue**: Async tests timing out.

**Solution**:
```swift
// ❌ Wrong
func testAchievements() async {
    await achievementManager.checkProgress()
}

// ✅ Correct
func testAchievements() async throws {
    try await withTimeout(seconds: 5) {
        await achievementManager.checkProgress()
    }
}
```

#### 2. UI Test Reliability
**Issue**: Flaky UI tests.

**Solution**:
```swift
// ❌ Unreliable
app.buttons["Subscribe"].tap()

// ✅ Reliable
let subscribeButton = app.buttons["Subscribe"]
XCTAssert(subscribeButton.waitForExistence(timeout: 5))
subscribeButton.tap()
```

## Best Practices for Issue Prevention

### 1. Code Organization
- Use proper MVVM architecture
- Implement clear state management
- Follow SwiftUI lifecycle

### 2. Testing Strategy
- Write unit tests for business logic
- Implement UI tests for critical paths
- Use preview testing for quick iterations

### 3. Performance Monitoring
- Monitor memory usage
- Track animation performance
- Log error conditions

### 4. Dependency Management
- Keep dependencies updated
- Resolve conflicts promptly
- Document version requirements 