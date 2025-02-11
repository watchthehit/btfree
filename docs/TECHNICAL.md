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
- Persistent storage through UserDefaults

### Features
- Onboarding
- Dashboard
- Resources
- Profile

## Building the Project

### Prerequisites
1. Xcode 14.0+
2. iOS 16.0+ Simulator or device
3. Swift 5.9+

### Setup Steps
1. Open `BetFreeApp/BetFreeApp.xcodeproj`
2. Wait for package resolution
3. Build and run

### Important Notes
- Package uses local dependencies
- Resources are processed during build
- Requires macOS 13+ for development due to TCA requirements

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
│       │   ├── Design/
│       │   │   └── BFDesignSystem.swift
│       │   └── State/
│       │       └── AppState.swift
│       └── Features/
│           ├── Dashboard/
│           ├── Resources/
│           └── Profile/
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
    products: [
        .library(
            name: "BetFree",
            targets: ["BetFree"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.7.0")
    ],
    targets: [
        .target(
            name: "BetFree",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/BetFree",
            resources: [
                .process("Resources")
            ])
    ]
)
```

## Architecture Overview

### Design System
The application uses a unified design system (`BFDesignSystem`) that provides:
- Color tokens
- Typography scale
- Spacing system
- Corner radius definitions
- Shadow styles
- Animation presets
- Layout constants
- Common view modifiers

### Core Components

#### State Management
- Uses The Composable Architecture (TCA)
- Features are defined as reducers
- State is immutable and predictable
- Actions define all possible state mutations
- Effects handle side effects

#### Navigation
- Tab-based main navigation
- Coordinator pattern for complex flows
- Deep linking support
- State-driven navigation

#### Data Layer
- UserDefaults for simple persistence
- Secure storage for sensitive data
- Offline-first architecture
- Data synchronization

### Feature Modules

#### Onboarding
- Multi-step flow with progress tracking
- Feature introduction:
  1. Welcome & Overview
  2. Progress Tracking
  3. 24/7 Support
  4. Personalization
- Profile setup:
  - Username collection
  - Daily limit setting
- Paywall integration:
  - 7-day free trial
  - Monthly subscription
  - Feature highlights
  - Purchase restoration

#### Dashboard
- Progress overview
- Quick actions
- Statistics
- Achievements

#### Resources
- Support materials
- Emergency contacts
- Educational content
- Success stories

#### Profile
- User settings
- Privacy controls
- Data management
- Support access

### Best Practices

#### Accessibility
- VoiceOver support
- Dynamic Type
- Color contrast
- Semantic structure

#### Performance
- Lazy loading
- Memory management
- Background operations
- Caching strategy

#### Security
- Data encryption
- Secure storage
- Privacy protection
- Authentication

#### Testing
- Unit tests
- Integration tests
- UI tests
- Performance tests

## Implementation Guidelines

### View Implementation
```swift
struct FeatureView: View {
    let store: StoreOf<FeatureReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            // View implementation
        }
    }
}
```

### Reducer Implementation
```swift
struct FeatureReducer: Reducer {
    struct State: Equatable {
        // State properties
    }
    
    enum Action {
        // Actions
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            // State mutations and effects
        }
    }
}
```

### Design System Usage
```swift
Text("Title")
    .font(BFDesignSystem.Typography.title)
    .foregroundColor(BFDesignSystem.Colors.textPrimary)
    .padding(BFDesignSystem.Spacing.md)
```

## Deployment

### Requirements
- Xcode 14.0+
- Swift 5.9+
- macOS 11.0+ / iOS 15.0+

### Dependencies
- ComposableArchitecture: 1.0.0+
- Firebase iOS SDK: 10.0.0+
- Lottie iOS: 4.0.0+
- Kingfisher: 7.0.0+

### Build Configuration
- Debug configuration
- Release configuration
- TestFlight distribution
- App Store distribution

## Maintenance

### Version Control
- Feature branching
- Pull request workflow
- Code review process
- Release tagging

### Quality Assurance
- Automated testing
- Code coverage
- Performance monitoring
- Crash reporting

### Documentation
- Code documentation
- API documentation
- User guides
- Release notes

## Error Handling

### Error Types
```swift
enum AppError: Error {
    case networkError(Error)
    case dataError(String)
    case authenticationError
    case validationError([String])
}
```

### Error Presentation
```swift
struct ErrorView: View {
    let error: AppError
    let retry: () -> Void
    
    var body: some View {
        VStack {
            // Error presentation
        }
    }
}
```

## Security

### Data Protection
- Encryption at rest
- Secure networking
- Authentication
- Authorization

### Privacy
- Data minimization
- User consent
- Data deletion
- Privacy policy

## Performance

### Optimization Techniques
- View optimization
- Memory management
- Network caching
- Background processing

### Monitoring
- Performance metrics
- Usage analytics
- Error tracking
- User feedback

## Support

### Resources
- Developer documentation
- User documentation
- Support channels
- Feedback system

### State Management
```swift
// Force onboarding for testing
UserDefaults.standard.set(false, forKey: "isOnboarded")

// Check onboarding status
if !appState.isOnboarded {
    OnboardingView()
} else {
    MainTabView()
}
```

### UI Components

#### Progress Tracking
- Circular progress indicators
- Progress bars for onboarding
- Achievement badges (planned)

#### Navigation
- Tab-based main navigation
- Linear onboarding flow
- Modal paywall presentation 