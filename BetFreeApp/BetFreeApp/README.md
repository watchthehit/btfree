# BetFree App

## Overview
BetFree is a SwiftUI app designed to help users develop a healthier relationship with gambling by tracking triggers, managing cravings, and building positive habits.

## Project Structure
The app is built with an Xcode project using Swift and SwiftUI, with the following key components:

- **BetFreeApp.swift**: Main entry point
- **ContentView.swift**: Root view container
- **BetFreeRootView.swift**: Conditional routing between onboarding and main content
- **EnhancedOnboardingView.swift**: 8-screen onboarding flow
- **AppState.swift**: Central state management with @MainActor
- **Models.swift**: Data structures for app functionality
- **BFColors.swift**: Color utilities and design system
- **CravingReportView.swift**: Interface for logging cravings

## Features
- Enhanced onboarding flow with 8 comprehensive screens
- Personal goal setting and tracking
- Trigger identification and management
- Craving reporting and analysis
- Customizable notification preferences
- Privacy-focused design with local data storage

## Technical Details
- Built with SwiftUI
- MVVM architecture
- Supports iOS 15.0 and above
- Uses @MainActor for thread safety

## Setup and Running
1. Open the BetFreeApp.xcodeproj file in Xcode
2. Select your target device or simulator
3. Build and run the app (⌘R)

## Onboarding Flow
The app includes a comprehensive onboarding flow with the following screens:
1. Welcome
2. Name Input
3. Goal Setting
4. Trigger Selection
5. Notification Setup
6. Feature Overview
7. Privacy Information
8. Completion

## State Management
The app uses a central AppState object as the single source of truth, which is passed through the view hierarchy using the @EnvironmentObject property wrapper.

## Documentation
More detailed documentation can be found in the Documentation folder:
- OnboardingDocumentation.md: Detailed explanation of the onboarding system

## Future Enhancements
- Data visualization for craving patterns
- Expanded mindfulness exercises
- Community support features
- Achievement badges and rewards system

## Recent Updates

### Bug Fixes (July 2023)

- Fixed type-checking issues in `EnhancedMotivationScreen.swift` by breaking complex expressions into smaller, more manageable components
- Resolved duplicate struct declarations for `FloatingShapes` by ensuring only one implementation exists
- Fixed ambiguous init() in `DashboardView.swift` by using fully qualified type paths
- Fixed property references in `EnhancedBreathingExerciseView.swift` and `EnhancedOnboardingView.swift` to properly use UserDefaults for missing properties
- Implemented proper animations in `ProfileView.swift` using ViewModifiers pattern

## Architecture

### Design Tokens

The app uses a comprehensive design token system defined in `BFDesignTokens.swift` that includes:

- Colors
- Typography
- Spacing
- Border Radius
- Shadows
- Animations

### App State Management

The app uses:
- `EnhancedAppState` as the main state container
- UserDefaults for persistence of user settings
- Environment Objects for state sharing across the view hierarchy

### Components

Key reusable components include:
- `FloatingShapes` - Visual background elements
- `ConfettiView` - Celebration animations
- Various card views and buttons with consistent styling

## Development

### Building the Project

```bash
cd /path/to/BetFreeApp
swift build
```

### Common Issues

- If experiencing type-checking timeout errors, break complex SwiftUI views into smaller components
- When adding new visual components, check for potential naming conflicts with existing views 