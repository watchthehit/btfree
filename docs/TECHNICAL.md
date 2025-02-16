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
  - Colors
  - Typography
  - Spacing
  - Corner Radius

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
     - `id`: UUID
     - `amount`: Double
     - `date`: Date
   - Optional Fields:
     - `note`: String
     - `category`: String

#### Core Data Managers
- `CoreDataManager`: Main persistence manager
- `MockCDManager`: In-memory store for testing
- Both conform to `BetFreeDataManager` protocol

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

### SwiftUI ProgressView Naming Conflict
When using SwiftUI's ProgressView, you must use the explicit namespace `SwiftUI.ProgressView` due to a naming conflict with our custom ProgressView component:

```swift
// ❌ Will not compile - naming conflict with custom ProgressView
ProgressView(value: progressValue)

// ✅ Correct usage with explicit namespace
SwiftUI.ProgressView(value: progressValue)
```

This is necessary because we have a custom `ProgressView` component in `/Sources/BetFree/Features/Progress/ProgressView.swift`.

Examples of correct usage in our codebase:
```swift
// Basic usage
SwiftUI.ProgressView(value: progressValue)

// With styling
SwiftUI.ProgressView()
    .progressViewStyle(CircularProgressViewStyle())
```

## Testing
- Use `MockCDManager` for Core Data testing
- In-memory store prevents persistence between test runs
- Reset store using `reset()` method
- Inject mock manager through dependency injection

### Progress Indicators
When using progress indicators, always use the SwiftUI namespace to avoid conflicts:

```swift
// ❌ Don't use:
ProgressView(value: progressValue)

// ✅ Do use:
SwiftUI.ProgressView(value: progressValue)
```

Example with accessibility:
```swift
SwiftUI.ProgressView(value: progress)
    .tint(progress >= 1.0 ? BFDesignSystem.Colors.error : BFDesignSystem.Colors.primary)
    .semanticValue("\(Int(progress * 100))% complete")
    .semanticHint("Shows your daily spending progress")
    .respectIncreaseContrast()
```

### Component Integration

#### 1. Cards
Cards should implement all accessibility features:

```swift
BFCard(style: .default) {
    content
}
.semanticMeaning("Statistics Card")
.semanticValue("$100 saved this month")
.semanticHint("Double tap to view details")
.respectReducedMotion()
.respectIncreaseContrast()
```

#### 2. Progress Sections
Progress sections should be fully accessible:

```swift
VStack {
    Text("Daily Progress")
        .font(BFDesignSystem.Typography.titleMedium)
    
    SwiftUI.ProgressView(value: progress)
        .tint(getProgressColor(progress))
}
.semanticGroup("Daily Progress Section")
.semanticValue("\(Int(progress * 100))% of daily limit")
.semanticHint("Shows your spending progress for today")
.respectReducedMotion()
.respectIncreaseContrast()
```

#### 3. Interactive Elements
All interactive elements should include:
- Clear semantic meaning
- Appropriate haptic feedback
- Motion respect
- High contrast support

```swift
Button(action: handleTap) {
    Text("Add Transaction")
}
.withHaptics(style: .medium)
.semanticMeaning("Add Transaction Button")
.semanticHint("Double tap to add a new transaction")
.respectReducedMotion()
.respectIncreaseContrast()
```

### Testing Guidelines

#### 1. Accessibility Testing
Test your components with:
- VoiceOver enabled
- Increased contrast mode
- Reduced motion enabled
- Different text sizes
- Different color schemes

#### 2. Haptic Testing
Verify haptic feedback:
- Success/error states
- Progress updates
- Interactive elements
- Custom patterns

#### 3. Motion Testing
Check animations with:
- Default settings
- Reduced motion enabled
- Different device speeds
- Different animation states

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