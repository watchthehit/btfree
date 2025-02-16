# BetFree Troubleshooting Guide

## Common Issues and Solutions

### Core Data Issues

#### 1. Entity Not Found
**Issue**: "NSEntityDescription could not locate an NSEntityDescription for entity name 'UserProfile'"

**Solution**:
```swift
// ❌ Wrong Entity Name
let request: NSFetchRequest<UserProfileEntity> = UserProfileEntity.fetchRequest()
request.entityName = "UserProfile"  // Wrong name

// ✅ Correct Entity Name
let request = NSFetchRequest<UserProfileEntity>(entityName: "BetFree_UserProfile")
```

#### 2. Invalid NSManagedObject
**Issue**: "An NSManagedObject of class 'UserProfileEntity' must have a valid NSEntityDescription."

**Solution**:
```swift
// ❌ Wrong Initialization
let user = UserProfileEntity(context: context)  // Missing entity description

// ✅ Correct Initialization
let entity = NSEntityDescription.entity(forEntityName: "BetFree_UserProfile", in: context)!
let user = UserProfileEntity(entity: entity, insertInto: context)
```

#### 3. Core Data Concurrency
**Issue**: CoreData violations when accessing context from background threads.

**Solution**:
```swift
// ❌ Wrong Implementation
DispatchQueue.global().async {
    let user = CoreDataManager.shared.getCurrentUser()  // Violation!
}

// ✅ Correct Implementation
@MainActor
func fetchUser() async {
    let user = CoreDataManager.shared.getCurrentUser()
}
```

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

#### 3. ProgressView Naming Conflict
**Issue**: "Argument passed to call that takes no arguments" when using SwiftUI ProgressView

**Solution**:
```swift
// ❌ Wrong Usage - Naming conflict with custom ProgressView
ProgressView(value: progressValue)

// ✅ Correct Usage - Explicit SwiftUI namespace
SwiftUI.ProgressView(value: progressValue)
```

This error occurs because we have a custom `ProgressView` component in `/Sources/BetFree/Features/Progress/ProgressView.swift` that conflicts with SwiftUI's built-in ProgressView.

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

### Cross-Platform Compatibility

#### 1. Platform-Specific Sheet Presentation
**Issue**: `fullScreenCover` is not available on macOS.

**Solution**:
```swift
// ❌ Wrong Implementation - iOS only
.fullScreenCover(isPresented: $showPaywall) {
    PaywallView()
}

// ✅ Correct Implementation - Cross-platform
#if os(iOS)
.fullScreenCover(isPresented: $showPaywall) {
    PaywallView()
}
#else
.sheet(isPresented: $showPaywall) {
    PaywallView()
}
#endif
```

#### 2. Keyboard Type Compatibility
**Issue**: `keyboardType` modifier not available on macOS TextField.

**Solution**:
```swift
// ❌ Wrong Implementation
TextField("Amount", text: $amount)
    .keyboardType(.decimalPad)

// ✅ Correct Implementation
TextField("Amount", text: $amount)
#if os(iOS)
    .keyboardType(.decimalPad)
#endif
```

#### 3. Toolbar Placement
**Issue**: Different toolbar placement requirements for iOS and macOS.

**Solution**:
```swift
.toolbar {
    #if os(iOS)
    ToolbarItem(placement: .navigationBarTrailing) {
        Button("Cancel") {
            dismiss()
        }
    }
    #else
    ToolbarItem(placement: .automatic) {
        Button("Cancel") {
            dismiss()
        }
    }
    #endif
}
```

### Design System Integration

#### 1. Custom Style Migration
**Issue**: Custom design system styles causing compilation errors.

**Solution**:
```swift
// ❌ Wrong Implementation - Custom styles
.font(BFDesignSystem.Typography.titleLarge)
.foregroundColor(BFDesignSystem.Colors.textPrimary)

// ✅ Correct Implementation - SwiftUI styles
.font(.title)
.foregroundColor(.primary)
```

#### 2. Button Styling
**Issue**: Custom button styles causing compilation errors.

**Solution**:
```swift
// ❌ Wrong Implementation
Button("Save") { action() }
    .primaryStyle()

// ✅ Correct Implementation
Button("Save") { action() }
    .buttonStyle(.borderedProminent)
```

#### 3. Background and Corner Radius
**Issue**: Custom background and corner radius properties not found.

**Solution**:
```swift
// ❌ Wrong Implementation
.background(BFDesignSystem.Colors.surface)
.cornerRadius(BFDesignSystem.CornerRadius.lg)

// ✅ Correct Implementation
.background(Color.gray.opacity(0.1))
.cornerRadius(12)
```

### Form and Input Handling

#### 1. Form Section Headers
**Issue**: Incorrect form section header syntax.

**Solution**:
```swift
// ❌ Wrong Implementation
Section {
    // Content
} header: {
    Text("Section Title")
}

// ✅ Correct Implementation
Section(header: Text("Section Title")) {
    // Content
}
```

#### 2. TextField Validation
**Issue**: Unused guard let values in validation.

**Warning**:
```swift
// ⚠️ Warning: Unused value
guard let amount = Double(amount) else { return }

// ✅ Better Implementation
guard let parsedAmount = Double(amount) else { return }
// Use parsedAmount in subsequent code
```

### Progress Indicators

#### 1. Progress View Style
**Issue**: Incorrect progress view styling.

**Solution**:
```swift
// ❌ Wrong Implementation
ProgressView()
    .tint(.white)

// ✅ Correct Implementation
SwiftUI.ProgressView()
    .progressViewStyle(CircularProgressViewStyle())
```

#### 2. Loading State
**Issue**: Inconsistent loading state handling.

**Solution**:
```swift
// ❌ Wrong Implementation
if isLoading {
    ProgressView()
} else {
    Button("Submit") { action() }
}

// ✅ Correct Implementation
Button(action: action) {
    if isLoading {
        SwiftUI.ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
    } else {
        Text("Submit")
    }
}
.buttonStyle(.borderedProminent)
.disabled(isLoading)
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