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

The app uses a hierarchical typography system defined in `BFDesignSystem.Typography`:

```swift
// Display - Large headlines and hero text
displayLarge   // 34pt bold
displayMedium  // 28pt semibold
displaySmall   // 24pt semibold

// Title - Section headers and important text
titleLarge    // 22pt semibold
titleMedium   // 20pt semibold
titleSmall    // 18pt medium

// Body - Primary content text
bodyLarge     // 17pt regular
bodyMedium    // 15pt regular
bodySmall     // 13pt regular

// Label - Supporting text and annotations
labelLarge    // 14pt medium
labelMedium   // 12pt medium
labelSmall    // 11pt medium
```

#### Legacy Support
For backward compatibility, the following styles are maintained:
```swift
caption         // 13pt regular (equivalent to bodySmall)
button         // 17pt semibold (equivalent to bodyLarge with semibold)
body           // 15pt regular (equivalent to bodyMedium)
display        // 34pt bold (equivalent to displayLarge)
bodyLargeMedium // 17pt medium (equivalent to bodyLarge with medium weight)
```

#### Accessibility
For dynamic type support, use the scaling helpers:
```swift
Typography.scaledDisplay(size: CGFloat, weight: .bold)
Typography.scaledBody(size: CGFloat, weight: .regular)
```

#### Usage Example
```swift
Text("Header")
    .font(BFDesignSystem.Typography.titleLarge)
    
Text("Body text")
    .font(BFDesignSystem.Typography.bodyMedium)
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
│           └── Achievements/
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