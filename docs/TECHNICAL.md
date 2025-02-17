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
Located in `Sources/BetFree/Core/Data/Resources/CoreData/BetFreeModel.xcdatamodeld`

#### Model Registration
The Core Data model is registered using a standardized approach:
```swift
// Initialize Core Data stack with explicit model loading
guard let modelURL = Bundle.module.url(forResource: "BetFreeModel", withExtension: "momd"),
      let model = NSManagedObjectModel(contentsOf: modelURL) else {
    fatalError("Failed to load Core Data model")
}

let container = NSPersistentContainer(name: "BetFreeModel", managedObjectModel: model)
```

#### Entities
1. UserProfile (`UserProfileEntity`)
   - Required Fields:
     - `id`: UUID
     - `name`: String
     - `streak`: Int32
     - `totalSavings`: Double
     - `dailyLimit`: Double
   - Optional Fields:
     - `email`: String?
     - `lastCheckIn`: Date?

2. Transaction (`TransactionEntity`)
   - Required Fields:
     - `id`: UUID
     - `amount`: Double
     - `date`: Date
   - Optional Fields:
     - `note`: String?
     - `category`: String?

3. Craving (`CravingEntity`)
   - Required Fields:
     - `id`: UUID
     - `intensity`: Int32
     - `timestamp`: Date
     - `duration`: Int32
   - Optional Fields:
     - `triggers`: String?
     - `strategies`: String?

#### Core Data Best Practices
1. **Model Loading**
   ```swift
   // Always load model explicitly from bundle
   guard let modelURL = Bundle.module.url(forResource: "BetFreeModel", withExtension: "momd"),
         let model = NSManagedObjectModel(contentsOf: modelURL) else {
       fatalError("Failed to load Core Data model")
   }
   ```

2. **Error Handling**
   ```swift
   // Proper error handling with descriptive messages
   container.loadPersistentStores { description, error in
       if let error = error {
           print("Core Data failed to load: \(error.localizedDescription)")
           print("Store description: \(description)")
           fatalError(error.localizedDescription)
       }
   }
   ```

3. **Context Configuration**
   ```swift
   // Standard context configuration
   container.viewContext.automaticallyMergesChangesFromParent = true
   container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
   ```

4. **Entity Creation**
   ```swift
   // Safe entity creation with proper context
   let entity = CravingEntity(context: context)
   entity.id = UUID()  // Always set required fields
   try context.save()  // Save after modifications
   ```

5. **Type Consistency**
   ```swift
   // Consistent type handling
   public var duration: Int32  // Core Data storage
   var durationInterval: TimeInterval {  // Public interface
       get { TimeInterval(duration) }
       set { duration = Int32(newValue) }
   }
   ```

#### Core Data Managers
The app uses two data managers that conform to `BetFreeDataManager` protocol:

1. `CoreDataManager` - Production implementation
   - Handles persistent storage
   - Thread-safe with @MainActor
   - Proper error handling
   - Consistent type conversion

2. `MockCDManager` - Testing implementation
   - In-memory store
   - Mirrors production functionality
   - Supports test isolation
   - Thread-safe with @MainActor

### Data Management

The app uses two data managers that conform to `BetFreeDataManager` protocol:

1. `CoreDataManager` - Production implementation
   - Handles persistent storage using Core Data
   - Manages user profiles, transactions, and cravings
   - Implements CRUD operations for all entities
   - Thread-safe with @MainActor attribute

2. `MockCDManager` - Testing implementation
   - In-memory Core Data store for testing
   - Mirrors all functionality of CoreDataManager
   - Provides reset capability for test isolation
   - Thread-safe with @MainActor attribute

#### Type Consistency
- Duration values are consistently handled as TimeInterval (Double) in models
- Core Data stores duration as Int32 for efficiency
- Automatic conversion between Int32 and TimeInterval in data managers

#### Parameter Ordering
Standard parameter ordering for UserProfile initialization:
1. name: String
2. email: String?
3. streak: Int
4. totalSavings: Double
5. dailyLimit: Double
6. lastCheckIn: Date?

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

#### 1. Type Consistency Issues
When dealing with type mismatches between models and Core Data entities:

```swift
// ❌ Don't mix types between models and Core Data
struct Craving {
    let duration: TimeInterval  // Double
}
class CravingEntity: NSManagedObject {
    @NSManaged var duration: Int32  // Int32
}

// ✅ Do use consistent type conversion
struct Craving {
    let duration: TimeInterval
}
class CravingEntity: NSManagedObject {
    @NSManaged var duration: Int32
    
    var durationInterval: TimeInterval {
        get { TimeInterval(duration) }
        set { duration = Int32(newValue) }
    }
}
```

#### 2. Parameter Ordering Issues
When initializing models, maintain consistent parameter order:

```swift
// ❌ Don't use arbitrary ordering
UserProfile(
    streak: streak,
    dailyLimit: limit,
    name: name,
    email: email
)

// ✅ Do follow standard order
UserProfile(
    name: name,        // 1. name (String)
    email: email,      // 2. email (String?)
    streak: streak,    // 3. streak (Int)
    totalSavings: savings, // 4. totalSavings (Double)
    dailyLimit: limit, // 5. dailyLimit (Double)
    lastCheckIn: date  // 6. lastCheckIn (Date?)
)
```

#### 3. Core Data Manager Issues
When implementing Core Data managers:

```swift
// ❌ Don't mix Core Data operations across threads
func someOperation() {
    DispatchQueue.global().async {
        context.perform {
            // Core Data operations
        }
    }
}

// ✅ Do use @MainActor and async/await
@MainActor
func someOperation() async {
    // Core Data operations are automatically on main thread
}
```

#### 4. Transaction Mapping Issues
When mapping between Core Data entities and models:

```swift
// ❌ Don't force unwrap optional values
Transaction(
    id: UUID(uuidString: entity.idString!)!,
    amount: entity.amount,
    category: TransactionCategory(rawValue: entity.category!)!
)

// ✅ Do handle optionals safely with defaults
Transaction(
    id: UUID(uuidString: entity.idString ?? "") ?? UUID(),
    amount: entity.amount,
    category: TransactionCategory(rawValue: entity.category ?? "") ?? .other,
    date: entity.date ?? Date(),
    note: entity.note
)
```

#### 5. Mock Manager Implementation
When implementing mock managers:

```swift
// ❌ Don't skip Core Data setup in mocks
class MockManager {
    var context: NSManagedObjectContext!  // Uninitialized!
    
    init() {
        // Missing Core Data setup
    }
}

// ✅ Do properly initialize in-memory store
class MockManager {
    let context: NSManagedObjectContext
    
    init() {
        let storeDescription = NSPersistentStoreDescription()
        storeDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: "BetFreeModel")
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
        
        self.context = container.viewContext
        self.context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
```

### Build Issues

#### 1. Compilation Errors
Common compilation fixes:
1. Check for type mismatches between models and Core Data entities
2. Verify parameter ordering in model initializers
3. Ensure proper thread handling with @MainActor
4. Validate optional handling in data mapping
5. Check for proper Core Data setup in mock managers

#### 2. Runtime Crashes
Common crash solutions:
1. Never force unwrap optionals from Core Data
2. Always use @MainActor for Core Data operations
3. Properly initialize in-memory stores for testing
4. Handle Core Data errors appropriately
5. Use proper parameter ordering in initializers

#### 3. Data Inconsistency
When data appears incorrect:
1. Check parameter ordering in model initialization
2. Verify type conversion between models and Core Data
3. Ensure proper error handling in data managers
4. Validate mock manager implementation
5. Check for proper Core Data setup

### Testing Issues

#### 1. Mock Data Manager
Use proper mock manager setup:

```swift
// ❌ Don't use production manager in tests
let manager = CoreDataManager.shared

// ✅ Do use properly initialized mock manager
let manager = MockCDManager()  // Includes in-memory store setup
```

#### 2. Data Persistence
Handle test data appropriately:

```swift
// ❌ Don't leave test data in persistent store
func testOperation() {
    // Test operations
    // Missing cleanup
}

// ✅ Do clean up after tests
func testOperation() {
    // Test operations
    manager.reset()  // Clean up test data
}
```

### Debugging Tips

1. **Type Issues**
   - Use Xcode's Quick Look feature to verify types
   - Add print statements for type information
   - Check Core Data model configuration

2. **Parameter Ordering**
   - Reference the standard parameter order in documentation
   - Use code completion to verify order
   - Check model initializer definitions

3. **Core Data Operations**
   - Enable Core Data debug logging
   - Verify thread handling
   - Check error handling

4. **Mock Manager**
   - Verify in-memory store setup
   - Check entity initialization
   - Validate data persistence

### Recent Troubleshooting Patterns

#### 1. Type Consistency in Craving Duration
When implementing duration handling:

```swift
// ❌ Don't mix TimeInterval and Int
func createCraving(duration: Int) // In protocol
func createCraving(duration: TimeInterval) // In implementation

// ✅ Do use consistent types
func createCraving(duration: TimeInterval) // In protocol
func createCraving(duration: TimeInterval) // In implementation
// Convert to Int32 only when storing in Core Data
```

#### 2. UserProfile Parameter Ordering
Standard parameter ordering for all UserProfile initialization:

```swift
// ❌ Don't use arbitrary ordering
UserProfile(
    streak: streak,
    dailyLimit: limit,
    name: name,
    email: email
)

// ✅ Do follow standard order
UserProfile(
    name: name,        // 1. name (String)
    email: email,      // 2. email (String?)
    streak: streak,    // 3. streak (Int)
    totalSavings: savings, // 4. totalSavings (Double)
    dailyLimit: limit, // 5. dailyLimit (Double)
    lastCheckIn: date  // 6. lastCheckIn (Date?)
)
```

#### 3. Transaction Mapping in Dashboard
When mapping transactions in views:

```swift
// ❌ Don't map transactions unnecessarily
transactions = manager.getAllTransactions().map(\.transaction)

// ✅ Do use direct assignment when types match
transactions = manager.getAllTransactions()
```

#### 4. Mock Manager Implementation
Proper mock manager setup:

```swift
// ❌ Don't skip proper initialization
class MockManager {
    var context: NSManagedObjectContext!
}

// ✅ Do initialize in-memory store
class MockManager {
    let context: NSManagedObjectContext
    
    init() {
        let container = NSPersistentContainer(name: "BetFreeModel")
        container.persistentStoreDescriptions = [
            {
                let description = NSPersistentStoreDescription()
                description.type = NSInMemoryStoreType
                return description
            }()
        ]
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
        
        self.context = container.viewContext
        self.context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
```

### Quick Resolution Steps

1. **Type Mismatch Issues**
   - Check protocol definitions
   - Verify model property types
   - Ensure consistent type usage
   - Use proper type conversion

2. **Parameter Ordering**
   - Follow standard parameter order
   - Update all initializer calls
   - Fix compilation errors
   - Verify in tests

3. **Transaction Handling**
   - Remove unnecessary mapping
   - Use direct assignments
   - Update view models
   - Test data flow

4. **Mock Implementation**
   - Use in-memory store
   - Initialize properly
   - Handle errors
   - Clean up after tests

// ... existing code ...