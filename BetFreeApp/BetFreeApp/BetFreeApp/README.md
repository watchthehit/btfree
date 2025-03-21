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
- **BFDesignSystem.swift**: Unified design system with colors, typography, and spacing
- **BFComponents.swift**: Reusable UI components based on the design system
- **BFViewModifiers.swift**: Custom view modifiers for consistent styling
- **CravingReportView.swift**: Interface for logging cravings

## Features
- Enhanced onboarding flow with 8 comprehensive screens
- Personal goal setting and tracking
- Trigger identification and management
- Craving reporting and analysis
- Customizable notification preferences
- Privacy-focused design with local data storage
- Unified UI/UX system with consistent components and animations

## Technical Details
- Built with SwiftUI
- MVVM architecture
- Unified design system for consistent UX
- Supports iOS 15.0 and above
- Uses @MainActor for thread safety

## Setup and Running
1. Open the BetFreeApp.xcodeproj file in Xcode
2. Select your target device or simulator
3. Build and run the app (⌘R)

## Unified Design System
The app implements a comprehensive design system architecture:

- **Design Tokens**: Centralized definitions for colors, typography, spacing, and animations
- **Component Library**: Reusable UI components built using the design tokens
- **View Modifiers**: Custom modifiers for consistent styling and animations
- **Extension Methods**: Convenience extensions for SwiftUI's native types

Key files:
- `BFDesignSystem.swift`: Core design tokens and constants
- `BFComponents.swift`: Reusable UI components
- `BFViewModifiers.swift`: Consistent styling modifiers
- `BFStandardComponents.swift`: Extended component variations

For detailed documentation on the design system, see the Documentation folder.

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
- **DesignSystem.md**: Comprehensive guide to the unified design system
- **UIStandardization.md**: Guidelines for maintaining UI consistency
- **UIStandardizationMigrationGuide.md**: How to migrate to the design system
- **OnboardingDocumentation.md**: Detailed explanation of the onboarding system
- **AccessibilityGuidelines.md**: Ensuring the app is accessible to all users

## Troubleshooting

### Build Errors
- **Duplicate file references**: If you encounter "Multiple commands produce" or "duplicate output file" errors, check the "Copy Bundle Resources" build phase for duplicate entries and remove them.
- **Compilation errors**: Make sure all Swift files are properly added to the target's "Compile Sources" build phase.
- **Missing files**: Verify that all required files are included in the project and that their file paths are correct.

### Runtime Issues
- **Thread-related warnings**: Ensure all UI updates happen on the main thread and that `@MainActor` is properly applied where needed.
- **Navigation problems**: Check the state management for the onboarding flow, particularly the page transitions and bindings.
- **Data persistence issues**: Verify that UserDefaults is being used correctly to save and retrieve user settings.

For more detailed troubleshooting information, refer to the OnboardingDocumentation.md file in the Documentation folder.

## Future Enhancements
- Enhanced data visualization for behavior patterns
- Expanded mindfulness exercises
- Community support features
- Achievement badges and rewards system
- Expanded component library for easier feature development 