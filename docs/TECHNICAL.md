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

## Testing
- Use `MockCDManager` for Core Data testing
- In-memory store prevents persistence between test runs
- Reset store using `reset()` method
- Inject mock manager through dependency injection