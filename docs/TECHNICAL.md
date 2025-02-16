# BetFree Technical Documentation

## Project Structure

### Main Components
- `BetFreeApp/` - iOS App Target
  - `BetFreeApp.swift` - Main app entry point
  - Uses BetFree package as dependency

- `Sources/BetFree/` - Main Package
  - Core functionality implemented as Swift Package
  - Contains all business logic and UI components

### Dependencies
```swift
dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.7.0")
]
```

### Platform Requirements
- iOS 16.0+
- macOS 13.0+ (for development)

## Architecture

### Design System
- Located in `Sources/BetFree/Core/Design/BFDesignSystem.swift`
- Provides:
  - Colors (adaptive for light/dark mode)
  - Typography
  - Spacing
  - Corner Radius
  - Shadows

#### Colors
```swift
BFDesignSystem.Colors
├── primary          // Main brand color
├── success         // Success states
├── warning         // Warning states
├── error           // Error states
├── background      // Main background
├── secondaryBackground // Secondary background
├── cardBackground  // Card backgrounds
├── textPrimary     // Primary text
├── textSecondary   // Secondary text
└── border          // Borders and separators

// Gradients
├── primaryGradient
├── successGradient
├── warningGradient
├── errorGradient
├── calmingGradient
├── warmGradient
└── mindfulGradient
```

#### Typography
```swift
BFDesignSystem.Typography
├── displayLarge    // 34pt bold
├── displayMedium   // 28pt bold
├── displaySmall    // 24pt bold
├── titleLarge     // .title
├── titleMedium    // .title2
├── titleSmall     // .title3
├── bodyLarge      // .body.medium
├── bodyMedium     // .body
├── bodySmall      // .footnote
├── labelLarge     // .callout.medium
├── labelMedium    // .callout
├── labelSmall     // .caption
├── caption        // .caption
└── captionSmall   // .caption2
```

#### Shadows
```swift
BFDesignSystem.Layout.Shadow
├── small          // radius: 10, y: 4, opacity: 0.1
├── medium         // radius: 15, y: 8, opacity: 0.12
├── large          // radius: 20, y: 12, opacity: 0.14
├── card           // radius: 15, y: 8, opacity: 0.1
└── button         // radius: 12, y: 6, opacity: 0.15

// Usage:
.withViewShadow(BFDesignSystem.Layout.Shadow.card)
```

### Swift 6 Compatibility
The codebase is prepared for Swift 6 with proper handling of future enum cases:
```swift
// Example: ColorScheme handling
switch colorScheme {
case .dark:
    // Handle dark mode
case .light:
    // Handle light mode
case .none:
    // Handle system default
case .some(_):
    // Handle future cases
}
```

### Typography System

The app uses standard SwiftUI typography for better cross-platform compatibility:

```swift
// Display and Titles
.font(.largeTitle)  // Largest headlines
.font(.title)       // Section headers
.font(.title2)      // Subsection headers
.font(.title3)      // Minor headers

// Body Text
.font(.body)        // Primary content
.font(.callout)     // Secondary content
.font(.subheadline) // Supporting text

// Supporting Text
.font(.caption)     // Small supporting text
.font(.caption2)    // Smallest text
```

### Color System

The app uses SwiftUI's semantic colors for consistent appearance across platforms:

```swift
// Text Colors
.foregroundColor(.primary)    // Primary text
.foregroundColor(.secondary)  // Secondary text

// UI Colors
.background(.blue)           // Primary accent
.tint(.blue)                // Tint color for controls
.background(Color.gray.opacity(0.1))  // Subtle background
```

### Button Styles

Standard button styles are used across the app:

```swift
// Primary Actions
Button("Primary") { action() }
    .buttonStyle(.borderedProminent)

// Secondary Actions
Button("Secondary") { action() }
    .buttonStyle(.bordered)

// Plain Actions
Button("Plain") { action() }
    .buttonStyle(.plain)
```

### Form Components

Forms use standard SwiftUI form styling:

```swift
Form {
    Section(header: Text("Section Title")) {
        TextField("Label", text: $binding)
        Toggle("Option", isOn: $binding)
        Picker("Choice", selection: $binding) {
            // Picker content
        }
    }
}
```

### Progress Indicators

Progress indicators use explicit SwiftUI namespace to avoid conflicts:

```swift
// Determinate Progress
SwiftUI.ProgressView(value: progress)
    .tint(.blue)

// Indeterminate Progress
SwiftUI.ProgressView()
    .progressViewStyle(CircularProgressViewStyle())
```

### Platform-Specific Features

The app handles platform differences using conditional compilation:

```swift
// Sheet Presentation
#if os(iOS)
.fullScreenCover(isPresented: $showSheet) {
    SheetContent()
}
#else
.sheet(isPresented: $showSheet) {
    SheetContent()
}
#endif

// Keyboard Types
TextField("Amount", text: $amount)
#if os(iOS)
    .keyboardType(.decimalPad)
#endif

// Toolbar Placement
.toolbar {
    #if os(iOS)
    ToolbarItem(placement: .navigationBarTrailing) {
        // Content
    }
    #else
    ToolbarItem(placement: .automatic) {
        // Content
    }
    #endif
}
```

### Navigation
- Tab-based main navigation
- Uses SwiftUI navigation
- Main entry through `BetFreeRootView`

### State Management
- Uses The Composable Architecture (TCA)
- Global app state managed by `AppState` class
- Core Data for persistent storage
- UserDefaults for app preferences

### Core Data Model
Located in `Sources/BetFree/Core/Data/`

#### Entities
1. UserProfile (`BetFree_UserProfile`)
   - Required Fields:
     - `id`: UUID
     - `name`: String
     - `streak`: Int32
     - `totalSavings`: Double
     - `dailyLimit`: Double
   - Optional Fields:
     - `email`: String
     - `lastCheckIn`: Date

2. Transaction
   - Required Fields:
     - `idString`: String (UUID string)
     - `amount`: Double
     - `date`: Date
     - `category`: String
   - Optional Fields:
     - `note`: String

#### Core Data Managers
- `CoreDataManager`: Main persistence manager
- `MockCDManager`: In-memory store for testing
- Both conform to `BetFreeDataManager` protocol

### Transaction Management
```swift
// Add new transaction
Task {
    do {
        let transaction = Transaction(
            amount: 50.0,
            category: .savings,
            date: Date(),
            note: "Weekly savings"
        )
        try await dataManager.addTransaction(transaction)
    } catch {
        print("Error adding transaction: \(error)")
    }
}

// Delete transaction
Task {
    do {
        try await dataManager.deleteTransaction(transaction)
    } catch {
        print("Error deleting transaction: \(error)")
    }
}

// Load transactions
Task {
    await MainActor.run {
        isLoading = true
    }
    do {
        let manager = MockCDManager.shared
        try await Task.sleep(nanoseconds: 100_000_000)  // Simulate network delay
        let transactions = manager.getAllTransactions().map(\.transaction)
        await MainActor.run {
            self.transactions = transactions
            self.isLoading = false
        }
    } catch {
        print("Error loading transactions: \(error)")
        await MainActor.run {
            self.isLoading = false
        }
    }
}
```

### Core Data Best Practices
1. Always use `@MainActor` for UI updates
2. Wrap Core Data operations in `Task` blocks
3. Use proper error handling with try/catch
4. Use in-memory store for mocking and testing
5. Update UI state on the main thread
6. Use proper transaction mapping between Core Data and model objects

#### Mock Data Manager Implementation
```swift
// Initialize in-memory Core Data stack
let storeDescription = NSPersistentStoreDescription()
storeDescription.type = NSInMemoryStoreType

let container = NSPersistentContainer(name: "BetFreeModel")
container.persistentStoreDescriptions = [storeDescription]

// Configure context
context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

// Handle errors properly
do {
    try context.save()
    print("Successfully saved data")
} catch {
    print("Error saving data: \(error)")
    context.rollback()
    throw error
}
```

#### Error Handling
- Always use `try-catch` blocks for Core Data operations
- Roll back context on error
- Provide meaningful error messages
- Log errors for debugging
- Use proper error types and localized descriptions

### Features
- Onboarding
- Dashboard
- Resources
- Profile
- Transactions
- Achievements
- Craving Management

### Card System

The app uses a flexible card system based on the `BFCard` component. All card-based UI elements should use this as their foundation.

#### Card Styles
Three predefined styles are available:
```swift
// Default - Standard card with medium elevation
BFCardStyle.default
    cornerRadius: 12
    shadowRadius: 8
    shadowOpacity: 0.1
    
// Compact - Smaller padding, reduced elevation
BFCardStyle.compact
    cornerRadius: 8
    shadowRadius: 4
    shadowOpacity: 0.05
    
// Elevated - Larger padding, increased elevation
BFCardStyle.elevated
    cornerRadius: 16
    shadowRadius: 12
    shadowOpacity: 0.15
```

#### Basic Usage
```swift
BFCard(style: .default) {
    // Your content here
    Text("Card Content")
}
```

#### Advanced Features
1. Gradient Background:
```swift
BFCard(
    style: .default,
    gradient: BFDesignSystem.Colors.calmingGradient
) {
    Text("Gradient Card")
}
```

2. Interactive Cards:
```swift
BFCard(
    style: .default,
    isInteractive: true
) {
    Text("Tap me!")
}
// Includes touch feedback and scale animation
```

#### Implementation Example
The `BFStatCard` demonstrates proper usage:
```swift
BFCard(style: .default, gradient: gradient) {
    VStack(spacing: BFDesignSystem.Layout.Spacing.small) {
        // Card content with proper typography
        Text(value)
            .font(BFDesignSystem.Typography.titleLarge)
        Text(label)
            .font(BFDesignSystem.Typography.bodyMedium)
    }
}
```

### Animation System

The app uses a structured animation system defined in `BFAnimation` to ensure consistent motion and interactivity.

#### Duration Constants
```swift
BFAnimation.Duration
    .quick      // 100ms - Micro-interactions
    .standard   // 200ms - Standard interactions
    .emphasized // 300ms - Emphasized interactions
    .long       // 500ms - Long animations
```

#### Spring Configurations
```swift
BFAnimation.Spring
    .default  // Response: 0.3, Damping: 0.7 - Most UI interactions
    .bouncy   // Response: 0.5, Damping: 0.5 - Playful feedback
    .tight    // Response: 0.2, Damping: 0.8 - Micro-interactions
```

#### Easing Curves
```swift
BFAnimation.Easing
    .easeOut   // Elements appearing
    .easeIn    // Elements disappearing
    .easeInOut // Smooth transitions
```

#### Common Transitions
```swift
BFAnimation.Transition
    .fadeIn   // Fade in from 0 opacity
    .scaleUp  // Scale up from 95% with fade
    .slideUp  // Slide in from bottom with fade
```

#### View Modifiers
Easy-to-use modifiers for common animations:
```swift
// Fade in when view appears
someView.fadeInOnAppear()

// Scale up when view appears
someView.scaleUpOnAppear()

// Slide up when view appears
someView.slideUpOnAppear()
```

#### Implementation Example
The stats section in HomeView demonstrates proper usage:
```swift
LazyVGrid(columns: gridItems, spacing: 16) {
    ForEach(stats) { stat in
        BFStatCard(value: stat.value, label: stat.label)
            .slideUpOnAppear()  // Animate cards sliding up
    }
}
```

Cards use spring animations for touch feedback:
```swift
BFCard(isInteractive: true) {
    Text("Interactive Card")
}
// Automatically includes:
// - Scale animation with tight spring
// - Opacity change
// - Fade in on appear
```

### Haptic Feedback System

The app uses a structured haptic feedback system defined in `BFHaptics` to provide tactile feedback for important interactions.

#### Basic Feedback
```swift
// Success feedback (e.g., completing a goal)
BFHaptics.success()

// Error feedback (e.g., exceeding daily limit)
BFHaptics.error()

// Warning feedback (e.g., approaching daily limit)
BFHaptics.warning()
```

#### Interactive Feedback
```swift
// Light tap for subtle interactions
BFHaptics.lightTap()

// Medium tap for standard interactions
BFHaptics.mediumTap()

// Heavy tap for emphasized interactions
BFHaptics.heavyTap()

// Soft/Rigid taps for specific feelings
BFHaptics.softTap()
BFHaptics.rigidTap()
```

#### View Modifiers
```swift
// Add haptic feedback to any button
someButton.withHaptics(style: .light)

// Trigger success haptics on condition
someView.withSuccessHaptics(when: condition)

// Trigger error haptics on condition
someView.withErrorHaptics(when: condition)
```

#### Custom Patterns
For special achievements or milestones, use the `BFHapticEngine`:
```swift
let engine = BFHapticEngine()
engine.playAchievementPattern()  // Custom celebration pattern
engine.playProgressCompletionPattern()  // Custom progress pattern
```

#### Implementation Example
The progress section demonstrates proper usage:
```swift
progressSection
    .onChange(of: dailySpentAmount) { newAmount in
        if newAmount >= dailyLimit {
            BFHaptics.error()  // Over limit
        } else if newAmount >= dailyLimit * 0.8 {
            BFHaptics.warning()  // Approaching limit
        }
    }
```

### Haptic Feedback Patterns

The app uses consistent haptic feedback patterns to provide clear tactile responses:

1. **Success Feedback**
   - Achievement milestones
   - Task completion
   - Positive actions
   ```swift
   BFHaptics.success()  // Positive completion
   ```

2. **Warning Feedback**
   - Important actions
   - State changes
   - User attention needed
   ```swift
   BFHaptics.warning()  // Important action
   ```

3. **Error Feedback**
   - Cancellations
   - Invalid input
   - Error states
   ```swift
   BFHaptics.error()  // Negative action
   ```

Example implementation in SavingsView:
```swift
// Milestone achieved
BFHaptics.success()  // Celebration feedback

// Important action
Button("Add Savings") {
    BFHaptics.warning()  // Draw attention
    showAddSheet()
}

// Cancellation
Button("Cancel") {
    BFHaptics.error()  // Clear negative feedback
    dismiss()
}
```

### Accessibility System

The app uses a comprehensive accessibility system defined in `BFAccessibility` to ensure the app is usable by everyone.

#### Dynamic Type Support
```swift
// Scale font size based on user preferences
BFAccessibility.TextSize.scaled(16)

// Create dynamically scaled font
BFAccessibility.TextSize.scaledFont(size: 16, weight: .bold)
```

#### Reduced Motion Support
```swift
// Check if reduced motion is enabled
if BFAccessibility.Motion.isReduced {
    // Use simpler animation
}

// Get motion-respecting animation
animation(BFAccessibility.Motion.animation(.default))

// Get motion-respecting transition
transition(BFAccessibility.Motion.transition(.scale))
```

#### High Contrast Support
```swift
// Check if increased contrast is enabled
if BFAccessibility.Contrast.isIncreased {
    // Use higher contrast colors
}

// Apply high contrast modifier to any view
someView.respectIncreaseContrast()  // Automatically adjusts contrast

// Get contrast-appropriate color
BFAccessibility.Contrast.color(.blue, increased: .blue.opacity(0.8))

// Get contrast-adjusted opacity
BFAccessibility.Contrast.opacity(0.7)
```

The high contrast mode:
- Forces dark mode for better contrast
- Adjusts brightness levels
- Maintains original appearance when disabled
- Respects system contrast settings

#### VoiceOver Support
```swift
// Check if VoiceOver is running
if BFAccessibility.VoiceOver.isRunning {
    // Provide additional context
}

// Combine multiple elements into single announcement
BFAccessibility.VoiceOver.combine("Amount", "$100", "Saved")
```

#### View Modifiers
```swift
// Add semantic meaning
someView.semanticMeaning("Daily Progress")

// Add value description
someView.semanticValue("50% complete")

// Add usage hint
someView.semanticHint("Double tap to view details")

// Group related elements
someView.semanticGroup("Progress Section")

// Add custom trait
someView.semanticTrait(.isButton)

// Respect motion preferences
someView.respectReducedMotion()

// Respect contrast preferences
someView.respectIncreaseContrast()
```

#### Implementation Example
The progress section demonstrates proper accessibility:
```swift
VStack {
    Text("Daily Progress")
    SwiftUI.ProgressView(value: progress)
}
.semanticGroup("Daily Progress Section")
.semanticValue("\(Int(progress * 100))% of daily limit")
.semanticHint("Shows your spending progress for today")
.respectReducedMotion()
.respectIncreaseContrast()
```

### Design System Overview

The BetFree app uses a comprehensive design system with several key components:

1. **Typography**
   - Dynamic type support for all text
   - Semantic styles for consistent hierarchy
   - High contrast support
   ```swift
   BFDesignSystem.Typography.titleLarge
   BFDesignSystem.Typography.bodyMedium
   ```

2. **Card System**
   - Accessible tap targets
   - High contrast support
   - VoiceOver optimizations
   ```swift
   BFCard(style: .default)
       .semanticMeaning("Statistics Card")
   ```

3. **Animation System**
   - Reduced motion support
   - Optional animations
   - Subtle transitions
   ```swift
   .animation(BFAccessibility.Motion.animation(.default))
   ```

4. **Haptic Feedback**
   - Complementary to visual feedback
   - Clear tactile patterns
   - Important state changes

5. **Layout & Spacing**
   - Generous tap targets
   - Clear visual hierarchy
   - Consistent spacing
   ```swift
   BFDesignSystem.Layout.Spacing.medium
   ```

### Best Practices

1. **Typography**
   - Always use dynamic type
   - Maintain readable contrast
   - Provide clear hierarchy

2. **Interaction**
   - Ensure large touch targets
   - Provide multiple feedback types
   - Support both touch and VoiceOver navigation

3. **Progress**
   - Always use `SwiftUI.ProgressView`
   - Include clear progress values
   - Provide appropriate haptic feedback

4. **Contrast**
   - Ensure sufficient contrast
   - Don't rely solely on color
   - Support dark mode

5. **Motion**
   - Respect reduced motion
   - Keep animations optional
   - Provide static alternatives

### Implementation Checklist

When implementing new features, ensure:

1. **Accessibility**
   - [ ] VoiceOver support added
   - [ ] Dynamic type implemented
   - [ ] High contrast support added
   - [ ] Reduced motion respected

2. **Feedback**
   - [ ] Appropriate haptics used
   - [ ] Visual feedback provided
   - [ ] Clear error states
   - [ ] Progress indicators

3. **Documentation**
   - [ ] Accessibility features documented
   - [ ] Usage examples provided
   - [ ] Testing guidelines included
   - [ ] Best practices noted

## Paywall & Subscription

### Overview
BetFree uses a hard paywall with a 7-day free trial. The paywall is presented during onboarding after the user enters their initial information but before they can access the main app.

### Implementation

#### 1. Subscription Products
```swift
enum BFSubscriptionProduct: String {
    case monthly = "com.betfree.subscription.monthly"
    case yearly = "com.betfree.subscription.yearly"
    
    var id: String { rawValue }
    var period: String {
        switch self {
        case .monthly: return "month"
        case .yearly: return "year"
        }
    }
}
```

#### 2. Trial Period
- 7-day free trial for all new users
- Full app access during trial
- Automatic conversion to paid subscription after trial
- Trial status persisted in UserDefaults and verified with receipt

#### 3. Paywall Presentation
The paywall is shown:
1. During onboarding (after user info collection)
2. When trial expires
3. When subscription expires
4. When trying to access premium features without subscription

#### 4. User States
```swift
enum BFUserState {
    case trial(endDate: Date)
    case subscribed(expiryDate: Date)
    case expired
    case needsRestore
}
```

#### 5. Receipt Validation
- Local receipt validation for basic checks
- Server-side validation for security
- Periodic validation checks

### Security Measures

1. **Receipt Validation**
```swift
class ReceiptValidator {
    func validateReceipt() async throws -> ReceiptValidationResult
    func verifyTrialEligibility() async throws -> Bool
    func validateSubscriptionStatus() async throws -> BFUserState
}
```

2. **Anti-Tampering**
- Cryptographic verification of local data
- Server-side state verification
- Secure storage of subscription status

### User Flow

1. **New User**
```
Onboarding Start
└── User Info Collection
    └── Trial Offer
        ├── Accept Trial
        │   └── Main App (7 days)
        │       └── Paywall
        └── Skip Trial
            └── Paywall
```

2. **Trial User**
```
App Launch
└── Check Trial Status
    ├── Active
    │   └── Main App
    └── Expired
        └── Paywall
```

3. **Subscribed User**
```
App Launch
└── Validate Receipt
    ├── Valid
    │   └── Main App
    └── Invalid/Expired
        └── Paywall
```

### StoreKit Integration

1. **Product Loading**
```swift
class StoreManager {
    func loadProducts() async throws -> [Product]
    func purchase(_ product: Product) async throws -> PurchaseResult
    func restorePurchases() async throws
    func checkTrialEligibility() async throws -> Bool
}
```

2. **Transaction Handling**
```swift
extension StoreManager {
    func handlePurchaseResult(_ result: PurchaseResult) async
    func handleVerificationResult(_ result: VerificationResult)
    func updateSubscriptionStatus()
}
```

### Error Handling

1. **Purchase Errors**
```swift
enum PurchaseError: Error {
    case productNotFound
    case purchaseFailed(reason: String)
    case receiptValidationFailed
    case networkError
    case userCancelled
}
```

2. **Recovery Actions**
```swift
extension StoreManager {
    func retryFailedTransaction()
    func refreshReceipt()
    func syncSubscriptionStatus()
}
```

### Testing

1. **StoreKit Configuration**
- Use StoreKit configuration file for testing
- Test various subscription states
- Simulate receipt validation scenarios

2. **Test Cases**
```swift
class SubscriptionTests: XCTestCase {
    func testTrialEligibility()
    func testExpiredSubscription()
    func testRestorePurchases()
    func testReceiptValidation()
}
```

### Analytics

Track key subscription events:
- Trial starts/conversions
- Subscription purchases
- Cancellations
- Renewal failures
- Restore purchases

## Building the Project

### Prerequisites
1. Xcode 14.0+
2. iOS 16.0+ Simulator or device
3. Swift 5.9+

### Setup Steps
1. Open `BetFree.xcworkspace`
2. Wait for package resolution
3. Build and run

### Important Notes
- Package uses local dependencies
- Resources are processed during build
- Requires macOS 13+ for development due to TCA requirements
- Core Data model is created programmatically

## File Structure
```
project/
├── BetFreeApp/
│   └── BetFreeApp/
│       ├── BetFreeApp.swift
│       └── Assets.xcassets
├── Sources/
│   └── BetFree/
│       ├── Core/
│       │   ├── Data/
│       │   │   ├── CoreDataManager.swift
│       │   │   ├── MockCDManager.swift
│       │   │   └── Models/
│       │   │       └── CoreDataModel.swift
│       │   ├── Design/
│       │   │   └── BFDesignSystem.swift
│       │   └── State/
│       │       └── AppState.swift
│       └── Features/
│           ├── Dashboard/
│           ├── Resources/
│           ├── Profile/
│           ├── Transactions/
│           ├── Achievements/
│           └── Cravings/
├── docs/
├── Package.swift
└── README.md
```

## Current Working Version
- Package.swift configuration:
```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BetFree",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    // ... rest of configuration
)
```

## Implementation Guidelines

### Core Data Usage
```swift
// Fetching current user
let user = CoreDataManager.shared.getCurrentUser()

// Creating/updating user
try CoreDataManager.shared.createOrUpdateUser(
    name: "John Doe",
    email: "john@example.com",
    dailyLimit: 100.0
)

// Adding transaction
try CoreDataManager.shared.addTransaction(
    amount: 50.0,
    note: "Weekly savings"
)

// Getting today's transactions
let transactions = CoreDataManager.shared.getTodaysTransactions()
```

### View Implementation
```swift
struct FeatureView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: FeatureViewModel
    
    var body: some View {
        // View implementation
    }
}
```

## Troubleshooting

### Common Issues and Solutions

#### 1. SwiftUI ProgressView Naming Conflict
When using SwiftUI's ProgressView, you must use the explicit namespace to avoid conflicts:

```swift
// ❌ Will not compile - naming conflict with custom ProgressView
ProgressView(value: progressValue)

// ✅ Correct usage with explicit namespace
SwiftUI.ProgressView(value: progressValue)
```

This is necessary because we have a custom `ProgressView` component in `/Sources/BetFree/Features/Progress/ProgressView.swift`.

#### 2. Core Data Context Issues
If you encounter Core Data context issues:

```swift
// ❌ Don't access context from background thread
backgroundQueue.async {
    let context = CoreDataManager.shared.context
    // ... operations
}

// ✅ Do use @MainActor and async/await
@MainActor
func performOperation() async {
    let context = CoreDataManager.shared.context
    // ... operations
}
```

#### 3. ResourcesView Access
When using ResourcesView, ensure proper module access:

```swift
// ❌ Don't redeclare ResourcesView
struct ResourcesView: View { ... }

// ✅ Do use the existing ResourcesView
import BetFree
// ... then use ResourcesView directly
```

#### 4. Transaction Management
Common transaction-related issues:

```swift
// ❌ Don't modify transactions directly
transaction.amount = newAmount

// ✅ Do use the DataManager
try await dataManager.updateTransaction(
    id: transaction.id,
    amount: newAmount
)
```

#### 5. State Updates
Handle state updates properly:

```swift
// ❌ Don't update state directly from background
DispatchQueue.global().async {
    self.someState = newValue // Will crash
}

// ✅ Do use MainActor
@MainActor
func updateState() {
    self.someState = newValue
}
```

### Build Issues

#### 1. Package Resolution
If packages fail to resolve:
1. Delete derived data: `~/Library/Developer/Xcode/DerivedData`
2. Clean build folder: `Cmd + Shift + K`
3. Reset package caches: `File > Packages > Reset Package Caches`

#### 2. Compilation Errors
Common compilation fixes:
1. Check module imports
2. Verify access levels (public/internal)
3. Ensure MainActor usage for UI updates
4. Validate Core Data model versions

#### 3. Runtime Crashes
Common crash solutions:
1. Verify Core Data migrations
2. Check thread safety with @MainActor
3. Validate optional unwrapping
4. Ensure proper initialization order

### Performance Issues

#### 1. Memory Management
Handle memory efficiently:

```swift
// ❌ Don't hold strong references
class SomeManager {
    var handler: (() -> Void)?
}

// ✅ Do use weak references
class SomeManager {
    weak var delegate: SomeDelegate?
}
```

#### 2. Core Data Performance
Optimize Core Data usage:

```swift
// ❌ Don't fetch all records
let allRecords = try context.fetch(request)

// ✅ Do use batch fetching
request.fetchBatchSize = 20
request.fetchLimit = 50
```

### Testing Issues

#### 1. Mock Data Manager
Use the mock data manager for testing:

```swift
// ❌ Don't use production manager in tests
let manager = CoreDataManager.shared

// ✅ Do use mock manager
let manager = MockCDManager()
```

#### 2. UI Testing
Handle UI test specific cases:

```swift
// ❌ Don't hardcode test values
if isUITesting {
    username = "test"
}

// ✅ Do use launch arguments
if CommandLine.arguments.contains("--uitesting") {
    username = ProcessInfo.processInfo.environment["TEST_USERNAME"]
}
```

### Debugging Tips

#### 1. Core Data Debugging
Enable SQL debugging:
```swift
// Add to scheme arguments
-com.apple.CoreData.SQLDebug 1
```

#### 2. View Hierarchy
Debug view issues:
```swift
// Add to any view
.border(Color.red) // Visualize boundaries
.background(Color.blue.opacity(0.2)) // Check layout
```

#### 3. State Changes
Track state updates:
```swift
// Add property wrapper
@Published var someState: String {
    willSet { print("State changing from \(someState) to \(newValue)") }
    didSet { print("State changed to \(someState)") }
}
```

### Common Error Messages

1. "Invalid redeclaration":
   - Check for duplicate type declarations
   - Verify module imports
   - Ensure proper access levels

2. "Thread-related crash":
   - Add @MainActor to view models
   - Use async/await for Core Data
   - Dispatch UI updates to main thread

3. "Core Data constraint failure":
   - Verify unique constraints
   - Check relationship rules
   - Validate data before saving

4. "View identity error":
   - Ensure proper ForEach identifiers
   - Use stable IDs for list items
   - Avoid changing view identity

## Code Examples

### Craving Management

#### 1. Tracking a New Craving

```swift
// Create a new craving instance
let craving = Craving(
    intensity: 4,
    trigger: "Sports advertisement",
    location: "Living room",
    emotion: "Excited",
    duration: 600, // 10 minutes
    copingStrategy: "Deep breathing",
    outcome: "Used breathing technique and urge passed"
)

// Add it to the manager
@StateObject private var manager = CravingManager()
manager.add(craving)
```

#### 2. Custom Bar Chart Implementation

```swift
struct TimeBarChart: View {
    let data: [(hour: Int, count: Int)]
    
    private var maxCount: Int {
        data.map(\.count).max() ?? 1
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 4) {
                ForEach(data, id: \.hour) { hourData in
                    VStack {
                        let height = getBarHeight(
                            count: hourData.count,
                            maxCount: maxCount,
                            availableHeight: geometry.size.height - 40
                        )
                        
                        Rectangle()
                            .fill(BFDesignSystem.Colors.primary)
                            .frame(height: height)
                        
                        // Show hour label every 6 hours
                        if hourData.hour % 6 == 0 {
                            Text("\(hourData.hour)")
                                .font(BFDesignSystem.Typography.labelSmall)
                                .foregroundColor(BFDesignSystem.Colors.textSecondary)
                        }
                    }
                    .frame(width: (geometry.size.width - 100) / 24)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func getBarHeight(count: Int, maxCount: Int, availableHeight: CGFloat) -> CGFloat {
        guard maxCount > 0 else { return 0 }
        return (CGFloat(count) / CGFloat(maxCount)) * availableHeight
    }
}
```

#### 3. Accessible Detail Row

```swift
struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(BFDesignSystem.Colors.textSecondary)
            Spacer()
            Text(value)
                .foregroundColor(BFDesignSystem.Colors.textPrimary)
        }
        .semanticMeaning("\(label) Row")
        .semanticValue(value)
        .semanticHint("Shows \(label.lowercased())")
    }
}

// Usage example
DetailRow(label: "Intensity", value: "4/5")
```

### Savings Tracking

#### 1. Adding a New Savings Entry

```swift
// Track a new savings amount
let amount = 50.0
let manager = SavingsManager()

manager.add(amount) { result in
    switch result {
    case .success(let milestone):
        if let milestone = milestone {
            // Celebrate milestone
            BFHaptics.success()
        }
    case .failure(let error):
        // Handle error
        BFHaptics.error()
    }
}
```

#### 2. Accessible Stats Card

```swift
struct StatsCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        BFCard(style: .default) {
            VStack(alignment: .center, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(color)
                    Text(title)
                        .font(BFDesignSystem.Typography.labelMedium)
                }
                
                Text(value)
                    .font(BFDesignSystem.Typography.titleLarge)
                    .foregroundColor(color)
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .semanticMeaning("\(title) Card")
        .semanticValue(value)
        .semanticHint("Shows \(title.lowercased())")
    }
}

// Usage example
StatsCard(
    title: "Total Savings",
    value: "$1,250",
    icon: "dollarsign.circle.fill",
    color: BFDesignSystem.Colors.success
)
```

#### 3. Haptic Feedback Integration

```swift
enum BFHaptics {
    static func success() {
        UINotificationFeedbackGenerator()
            .notificationOccurred(.success)
    }
    
    static func warning() {
        UINotificationFeedbackGenerator()
            .notificationOccurred(.warning)
    }
    
    static func error() {
        UINotificationFeedbackGenerator()
            .notificationOccurred(.error)
    }
}

// Usage examples
// 1. Milestone achieved
BFHaptics.success()

// 2. High intensity craving
BFHaptics.warning()

// 3. Operation cancelled
BFHaptics.error()
```

### Best Practices

1. **Accessibility First**
   ```swift
   // ❌ Don't
   Button("Add") { ... }
   
   // ✅ Do
   Button {
       // action
   } label: {
       Image(systemName: "plus")
   }
   .semanticMeaning("Add Button")
   .semanticHint("Double tap to add new entry")
   ```

2. **Color Usage**
   ```swift
   // ❌ Don't
   Text("High Risk")
       .foregroundColor(.red)
   
   // ✅ Do
   Text("High Risk")
       .foregroundColor(BFDesignSystem.Colors.error)
   ```

3. **Haptic Feedback**
   ```swift
   // ❌ Don't
   @State private var showingSheet = false
   Button("Add") {
       showingSheet = true
   }
   
   // ✅ Do
   @State private var showingSheet = false
   Button("Add") {
       BFHaptics.warning()
       showingSheet = true
   }
   ```

4. **Contrast**
   - Ensure sufficient contrast
   - Don't rely solely on color
   - Support dark mode

5. **Motion**
   - Respect reduced motion
   - Keep animations optional
   - Provide static alternatives

### Implementation Checklist

When implementing new features, ensure:

1. **Accessibility**
   - [ ] VoiceOver support added
   - [ ] Dynamic type implemented
   - [ ] High contrast support added
   - [ ] Reduced motion respected

2. **Feedback**
   - [ ] Appropriate haptics used
   - [ ] Visual feedback provided
   - [ ] Clear error states
   - [ ] Progress indicators

3. **Documentation**
   - [ ] Accessibility features documented
   - [ ] Usage examples provided
   - [ ] Testing guidelines included
   - [ ] Best practices noted

## Cravings Tracking System
Located in `Sources/BetFree/Features/Cravings/CravingManager.swift`

The cravings tracking system provides comprehensive monitoring of betting urges and user progress.

#### Key Features
1. **Craving Statistics**
   ```swift
   @Published public private(set) var totalCravingsResisted: Int
   @Published public private(set) var highRiskDaysSurvived: Int
   @Published public private(set) var averageIntensity: Double
   @Published public private(set) var commonTriggers: [(trigger: String, count: Int)]
   @Published public private(set) var cravingsByTime: [(hour: Int, count: Int)]
   ```

2. **Date-Based Tracking**
   ```swift
   // Check for cravings on a specific date
   func hadCravingOn(_ date: Date) -> Bool
   
   // Group cravings by day
   Dictionary(grouping: cravings) { craving in
       calendar.startOfDay(for: craving.timestamp)
   }
   ```

3. **Statistics Calculation**
   - Uses modern Swift collection methods
   - Automatically updates when cravings change
   - Provides time-based analysis

#### Progress View Integration
Located in `Sources/BetFree/Features/Progress/ProgressView.swift`

The progress view displays user achievements and craving data:

1. **Weekly Calendar**
   - Shows clean days and craving incidents
   - Uses custom DayCell component
   - Integrates with AppState for bet-free status

2. **Achievement Statistics**
   - Games resisted counter
   - Clean weekends tracker
   - Urges overcome display
   - High-risk days survived

3. **Implementation Notes**
   - Always use `SwiftUI.ProgressView` for progress indicators to avoid naming conflicts
   - Use Calendar for all date comparisons
   - Consider timezone handling for date-based features

#### Usage Example
```swift
// Initialize CravingManager
@StateObject private var cravingManager = CravingManager()

// Check for cravings on a specific date
let hadCraving = cravingManager.hadCravingOn(date)

// Display in weekly calendar
DayCell(
    date: date,
    isClean: appState.wasCleanOn(date),
    hadCraving: hadCraving
)
```

### Important Implementation Patterns

1. **Enum Pattern Matching**
   ```swift
   if case let .article(articleId) = resource.action {
       ArticleView(articleId: articleId)
   }
   ```

2. **Date Grouping**
   ```swift
   let cravingsByDay = Dictionary(grouping: cravings) { craving in
       calendar.startOfDay(for: craving.timestamp)
   }
   ```

3. **Modern Collection Methods**
   ```swift
   let total = items
       .map { $0.intensity }
       .reduce(0, +)
   ```

### Features

### Savings Tracking
The savings tracking feature helps users monitor their financial progress in their recovery journey:

- Total savings display with milestone celebrations
- Daily average calculations
- Streak tracking for consistent saving
- Haptic feedback for positive reinforcement
- Accessibility support with VoiceOver descriptions

Location: `/Sources/BetFree/Features/Savings/`

### Craving Management
The craving management system helps users track and understand their gambling urges:

#### Core Features
- Intensity tracking (1-5 scale)
- Trigger identification
- Location and emotion tracking
- Duration monitoring
- Coping strategy suggestions
- Outcome recording

#### Analytics
- Average intensity tracking
- Trend analysis (increasing/stable/decreasing)
- Time-based pattern recognition
- Common trigger identification

#### Implementation Details
The feature is implemented in two main components:

1. **CravingManager** (`/Sources/BetFree/Features/Cravings/CravingManager.swift`)
   - Data persistence using UserDefaults
   - Statistical analysis methods
   - Haptic feedback integration
   - Coping strategy suggestions

2. **CravingView** (`/Sources/BetFree/Features/Cravings/CravingView.swift`)
   - Custom bar chart implementation for iOS compatibility
   - Intensity visualization with color coding
   - Form-based data entry
   - Detail view with custom row components
   - Full VoiceOver support

#### Accessibility Features
- Semantic descriptions for all UI elements
- High contrast support
- VoiceOver optimization
- Haptic feedback for actions
- Reduced motion support

#### iOS Compatibility
The feature is designed to work across iOS versions:
- Custom bar chart implementation instead of Charts framework
- Custom detail row components instead of LabeledContent
- Consistent styling using BFDesignSystem
- Proper date formatting for all iOS versions

### Settings Module
Located in `Sources/BetFree/Features/Settings/`

#### SettingsView
Main settings interface with the following sections:
```swift
// Profile Section
- Name input (TextField)
- Daily limit management (TextField with decimal keyboard)

// Notifications Section
- Daily check-in reminder toggle
- Milestone alerts toggle
- Weekly progress report toggle

// Support Section
- Crisis Support (NavigationLink to CrisisView)
- Resources (NavigationLink to ResourcesView)
- Contact Us (NavigationLink to ContactView)

// Account Section
- Log Out (Destructive button with confirmation)
- Reset All Data (Destructive button with confirmation)

// About Section
- Version information
```

#### Supporting Views
1. CrisisView
   - Emergency contact information
   - Direct call links
   - Online resources
   - 24/7 helpline access

2. ContactView
   - Email form interface
   - Subject and message input
   - Mail composition handling
   - Error handling for mail setup
```

### Proper Logout Handling
When implementing logout functionality:

```swift
// ❌ Don't reset state without cleaning Core Data
func logout() {
    currentStreak = 0
    totalSavings = 0
    // This can lead to crashes if Core Data objects are accessed
}

// ✅ Do clean Core Data first, then reset state
func logout() {
    // First reset Core Data
    dataManager.reset()
    
    // Then reset app state
    currentStreak = 0
    totalSavings = 0
    // ... other state resets
}
```

This ensures that:
1. Core Data objects are properly cleaned up
2. No dangling references remain
3. App state is consistent with data layer
4. Prevents crashes from accessing deleted objects

## Core Data Model Changes

### Entity Attributes
The `UserProfileEntity` in Core Data requires these attributes:
```swift
idString: String (non-optional, default: "")  // Used as unique identifier
name: String (non-optional, default: "")
email: String? (optional)
dailyLimit: Double (non-optional, default: 0.0)
streak: Int32 (non-optional, default: 0)
totalSavings: Double (non-optional, default: 0.0)
lastCheckIn: Date? (optional)
```

### Making Model Changes
When modifying the Core Data model:
1. Always update both `.xcdatamodeld` files:
   - `Sources/BetFree/Core/Data/BetFree.xcdatamodeld`
   - `Sources/BetFree/Core/Data/Resources/CoreData/BetFreeModel.xcdatamodeld`

2. After model changes:
   - Clean build folder
   - Delete app from simulator
   - Reset derived data if needed
   - Update mock managers if necessary

3. For production updates:
   - Create new model version
   - Set up mapping model
   - Test migration path
   - Update documentation

### Common Pitfalls
1. **Unmatched Models**: Ensure both `.xcdatamodeld` files are in sync
2. **Missing Attributes**: Add all required attributes to both models
3. **Type Mismatches**: Use consistent types across models
4. **Default Values**: Set appropriate defaults for non-optional attributes
5. **Migration Issues**: Test migration paths thoroughly

### Onboarding Implementation

#### View Structure
The onboarding flow is implemented using SwiftUI and follows the MVVM pattern:

```swift
public struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = OnboardingViewModel()
}
```

#### Key Components

1. **Navigation System**
   - TabView with custom page style
   - Progress indicator using dynamic dots
   - Animated transitions between steps
   - Custom back/continue navigation

2. **Authentication**
   - Sign in with Apple integration
   - Email/password authentication
   - Secure password handling
   - Loading state management
   - Error handling and display

3. **Daily Limit Implementation**
   - Custom slider component
   - Real-time value updates
   - Savings projection calculations
   - Preset value handling
   ```swift
   struct CustomSlider: View {
       @Binding var value: Double
       let range: ClosedRange<Double>
       // Custom implementation for smooth sliding
   }
   ```

4. **Goal Management**
   - Dynamic goal addition (up to 3)
   - Suggestion system
   - Timeline-based milestone tracking
   ```swift
   struct GoalInputRow: View {
       @Binding var goal: String
       let suggestions: [String]
       // Smart suggestion handling
   }
   ```

5. **Sports Selection**
   - Grid-based layout
   - Toggle state management
   - Custom sport button component
   ```swift
   struct SportButton: View {
       let sport: Sport
       let isSelected: Bool
       // Visual feedback implementation
   }
   ```

6. **UI Components**
   - Custom text field style
   - Trust badge component
   - Feature row component
   - Premium feature row
   - Savings projection view

7. **State Management**
   ```swift
   @MainActor
   final class OnboardingViewModel: ObservableObject {
       @Published var currentStep: OnboardingStep
       @Published var name: String
       @Published var email: String
       @Published var password: String
       @Published var dailyLimitDouble: Double
       @Published var goals: [String]
       @Published var selectedSports: Set<Sport>
       // State management implementation
   }
   ```

### Data Flow
1. User input validation
2. Secure data storage
3. Step progression logic
4. Completion handling

### Animations
- Scale effects
- Opacity transitions
- Sliding transitions
- Custom timing curves
```

### Layout Guidelines

#### Spacing System
```swift
// Standard spacing values
BFDesignSystem.Layout.Spacing.small   // 8 points
BFDesignSystem.Layout.Spacing.medium  // 16 points
BFDesignSystem.Layout.Spacing.large   // 24 points
BFDesignSystem.Layout.Spacing.xlarge  // 32 points
```

#### Safe Area Handling
```swift
// Proper safe area handling
.padding(.top, geometry.safeAreaInsets.top + 16)
.padding(.bottom, geometry.safeAreaInsets.bottom + 20)
```

#### Scroll Implementation
```swift
// Scrollable content with proper spacing
ScrollView(showsIndicators: false) {
    VStack(spacing: 24) {
        // Content
    }
    .padding(.bottom, 32)
}
```

#### Grid Layout
```swift
// Two-column grid layout
LazyVGrid(
    columns: [
        GridItem(.flexible()),
        GridItem(.flexible())
    ],
    spacing: 16
) {
    // Grid items
}
```

### Visual Feedback

#### Selection States
```swift
// Button selection state
.background(isSelected ? Color.white : Color.white.opacity(0.2))
.foregroundColor(isSelected ? BFDesignSystem.Colors.primary : .white)
```

#### Animations
```swift
// Standard transitions
.animation(.easeInOut, value: someState)
.transition(.opacity.combined(with: .move(edge: .bottom)))

// Custom animations
.animation(.spring(response: 0.3), value: currentStep)
```

### Content Organization

#### Section Layout
```swift
VStack(spacing: 8) {
    // Title section
    Text("Section Title")
        .font(BFDesignSystem.Typography.titleLarge)
    
    // Description
    Text("Section description")
        .font(BFDesignSystem.Typography.bodyLarge)
        .foregroundColor(.white.opacity(0.8))
}
.padding(.top, 8)
```

#### Card Components
```swift
// Standard card layout
.padding()
.background(Color.white.opacity(0.1))
.cornerRadius(12)
```

### Navigation System

#### Progress Tracking
```swift
// Progress dots
HStack(spacing: 8) {
    ForEach(OnboardingStep.allCases, id: \.self) { step in
        Circle()
            .fill(step.rawValue <= currentStep.rawValue 
                ? Color.white 
                : Color.white.opacity(0.3))
            .frame(width: 8, height: 8)
            .scaleEffect(step == currentStep ? 1.2 : 1)
    }
}
```

#### Navigation Buttons
```swift
// Navigation button style
Button(action: action) {
    HStack {
        Text("Continue")
        Image(systemName: "chevron.right")
    }
    .foregroundColor(.white)
    .padding()
}
```

### Accessibility Considerations

#### VoiceOver Support
```swift
// Semantic descriptions
.semanticMeaning("Section Title")
.semanticValue("Selected value")
.semanticHint("Double tap to select")
```

#### Dynamic Type
```swift
// Scalable typography
.font(BFDesignSystem.Typography.bodyLarge)
.minimumScaleFactor(0.8)
```

### Implementation Best Practices

1. **Content Scrolling**
   - Use ScrollView for potentially overflowing content
   - Hide scroll indicators for cleaner UI
   - Add proper bottom padding for content

2. **Layout Structure**
   - Maintain consistent spacing hierarchy
   - Use proper safe area insets
   - Implement responsive layouts

3. **Visual Feedback**
   - Provide clear selection states
   - Use smooth animations
   - Maintain proper contrast

4. **Navigation**
   - Clear progress indication
   - Intuitive navigation controls
   - Proper back/forward flow

5. **Accessibility**
   - Support VoiceOver
   - Implement proper semantic descriptions
   - Support dynamic type

### Savings System

The savings tracking system is implemented in `Sources/BetFree/Features/Savings/` and consists of several key components:

#### SavingsManager
```swift
public class SavingsManager: ObservableObject {
    @Published public private(set) var totalSaved: Double
    @Published public private(set) var dailyAverage: Double
    @Published public private(set) var streakDays: Int
    @Published public private(set) var lastUpdate: Date?
    @Published public private(set) var recentSavings: [Saving]
}
```

Key features:
1. **Recent Savings Tracking**
   - Maintains list of last 10 savings
   - Persists in UserDefaults
   - Includes amount, date, and notes

2. **Daily Statistics**
   - Tracks daily savings amounts
   - Calculates running average
   - Maintains streak information

3. **Data Persistence**
   - Uses UserDefaults for storage
   - Encodes/decodes Saving objects
   - Maintains separate date-based tracking

4. **Milestone Tracking**
   - Monitors savings milestones
   - Triggers notifications on achievements
   - Supports haptic feedback

#### Implementation Details

1. **Saving Model**
```swift
public struct Saving: Identifiable, Codable {
    public let id: UUID
    public let amount: Double
    public let date: Date
    public let sport: String
    public let notes: String?
}
```

2. **Recent Savings Management**
```swift
// Adding a new saving
let saving = Saving(amount: amount, date: Date(), sport: "", notes: nil)
recentSavings.insert(saving, at: 0)

// Maintain maximum of 10 entries
if recentSavings.count > 10 {
    recentSavings.removeLast()
}
```

3. **UserDefaults Storage**
```swift
// Saving
if let encoded = try? JSONEncoder().encode(recentSavings) {
    defaults.set(encoded, forKey: "recentSavings")
}

// Loading
if let savedData = defaults.data(forKey: "recentSavings"),
   let decoded = try? JSONDecoder().decode([Saving].self, from: savedData) {
    recentSavings = decoded
}
```

#### UI Components

1. **SavingsView**
   - Main view for savings tracking
   - Shows total and recent savings
   - Provides time-based filtering

2. **Statistics Cards**
   - Daily average display
   - Highest day amount
   - Total days tracked
   - Current streak

3. **Recent Savings List**
   - Chronological display
   - Shows amount and notes
   - Supports optional details

#### Usage Example
```swift
let manager = SavingsManager()

// Add a new saving
manager.addSaving(50.0)

// Access statistics
let total = manager.totalSaved
let average = manager.dailyAverage
let streak = manager.streakDays

// Get recent savings
let recent = manager.recentSavings
```

### Scrolling Implementation

The app implements consistent scrolling behavior across all views:

#### Main Views
```swift
ScrollView(showsIndicators: false) {
    VStack(spacing: 24) {
        // Content
    }
    .padding(.horizontal)
    .padding(.vertical, 24)
    .frame(maxWidth: .infinity)
}
```

Key features:
1. **Hidden Indicators**
   - Uses `showsIndicators: false` for cleaner UI
   - Maintains consistent appearance

2. **Proper Spacing**
   - Consistent vertical spacing (24pt)
   - Horizontal padding for content
   - Full width frame for proper layout

3. **Content Organization**
   - Card-based layout for sections
   - Proper padding inside cards
   - Animated content transitions

4. **Form Views**
```swift
ScrollView(showsIndicators: false) {
    VStack(spacing: 24) {
        // Form sections in cards
        BFCard(style: .elevated) {
            VStack(spacing: 16) {
                // Form fields
            }
            .padding()
        }
    }
    .padding()
}
```

5. **List Views**
```swift
ScrollView(showsIndicators: false) {
    LazyVStack(spacing: 16) {
        ForEach(items) { item in
            // Item view
        }
    }
    .padding()
}
```

#### Best Practices
1. Always use ScrollView for potentially long content
2. Hide scroll indicators for cleaner UI
3. Use consistent padding and spacing
4. Implement proper safe area handling
5. Support dynamic content height
```

### Dark Mode Support

The app implements a comprehensive dark mode system with three states:
- System (follows device settings)
- Light Mode (forced light)
- Dark Mode (forced dark)

#### Color System
```swift
// Adaptive colors that respond to color scheme
public static var primary: Color {
    Color(light: Color(hex: "007AFF"), dark: Color(hex: "0A84FF"))
}

// Semantic colors for text
public static var textPrimary: Color {
    Color(light: Color(hex: "000000"), dark: .white)
}

// Background colors
public static var background: Color {
    Color(light: .white, dark: Color(hex: "1C1C1E"))
}
```

#### User Preferences
```swift
// Color scheme state in AppState
@Published public var colorScheme: ColorScheme? = nil {
    didSet {
        defaults.set(colorScheme?.rawValue, forKey: colorSchemeKey)
    }
}

// Toggle between modes
public func toggleColorScheme() {
    withAnimation {
        switch colorScheme {
        case .none: colorScheme = .dark
        case .dark: colorScheme = .light
        case .light: colorScheme = nil
        }
    }
}
```

#### UI Implementation
```swift
// Apply color scheme to view hierarchy
.preferredColorScheme(appState.colorScheme)

// Color scheme toggle button
ColorSchemeButton(colorScheme: appState.colorScheme) {
    appState.toggleColorScheme()
}
```

#### Best Practices
1. **Color Definition**
   - Use semantic color names
   - Define both light and dark variants
   - Support opacity variants

2. **UI Components**
   - Test in both modes
   - Use system colors when possible
   - Support dynamic type

3. **Gradients**
   - Adapt gradient colors
   - Maintain contrast ratios
   - Consider reduced transparency

4. **Assets**
   - Provide dark variants
   - Test contrast levels
   - Support reduced motion

5. **Testing**
   - Test mode transitions
   - Verify color contrast
   - Check accessibility

// ... existing content ...