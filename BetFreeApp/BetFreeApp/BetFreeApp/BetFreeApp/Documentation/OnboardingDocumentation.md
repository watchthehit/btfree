# Enhanced Onboarding Documentation

## Overview
The Enhanced Onboarding system provides a comprehensive, user-friendly introduction to the BetFree app. It guides users through setting up their profile, understanding the app's features, and customizing their experience.

## Project Structure
The onboarding implementation is integrated into the BetFreeApp Xcode project with the following components:
- `BetFreeApp.swift` - Main app entry point with @main attribute
- `ContentView.swift` - Initial view that displays BetFreeRootView
- `BetFreeRootView.swift` - Root view that conditionally shows onboarding or main content
- `EnhancedOnboardingView.swift` - Complete 8-screen onboarding implementation
- `AppState.swift` - Central state management with @MainActor attribute
- `Models.swift` - Data models for the application
- `BFColors.swift` - Color utilities for consistent UI design

## Components

### OnboardingViewModel

The `OnboardingViewModel` class manages all state and logic for the onboarding process:

- Tracks current page (0-7)
- Stores user inputs (name, goals, triggers, notification preferences)
- Provides methods for navigation and data manipulation
- Includes the `@MainActor` attribute to ensure UI updates happen on the main thread

Key methods:
- `nextPage()` / `previousPage()` - Handle navigation between screens
- `addTrigger()` / `removeTrigger()` - Manage user-selected triggers
- `saveToAppState()` - Transfers onboarding data to the app's persistent state

### EnhancedOnboardingView

This is the primary container view that:
- Manages the TabView for page switching
- Displays navigation controls (back/skip buttons)
- Shows progress indicators
- Hosts the individual content screens

### Individual Screen Views

Each onboarding step is implemented as a separate view:

1. **WelcomeScreen**: Introduction to the app's purpose
2. **NameInputScreen**: Collects the user's name
3. **GoalSettingScreen**: Sets daily mindfulness goal (in minutes)
4. **TriggerSelectionScreen**: Helps identify gambling triggers
5. **NotificationSetupScreen**: Configures notification preferences
6. **FeatureOverviewScreen**: Highlights key app features
7. **PrivacyScreen**: Explains privacy policies
8. **CompletionScreen**: Confirms setup and transitions to main app

## Flow Control

The onboarding process proceeds linearly but offers flexibility:
- Users can move forward with the "Continue" button
- Users can skip steps with the "Skip" button
- Users can go back to previous steps with the back button
- The final "Get Started" button completes onboarding and transitions to the main app

## Data Persistence

When onboarding completes:
1. All user preferences are transferred to the AppState
2. The `hasCompletedOnboarding` flag is set to true
3. Data is saved to UserDefaults for persistence across app launches

## UI Design Principles

The onboarding UI follows these key principles:
- Consistent visual language across all screens
- Clear, actionable headers and instructions
- Visual progress indicators (page dots)
- Accessibility considerations (readable text sizes, sufficient contrast)
- Responsive layout that works across device sizes

## Customization

The onboarding system can be easily extended:
- New screens can be added by creating a new view and adding it to the TabView
- The page count and indicators will automatically update
- Additional data collection can be added to the view model

## Testing

When testing the onboarding flow:
1. Verify that navigation works correctly in all directions
2. Confirm that user input is properly saved to AppState
3. Test that the "Skip" functionality properly bypasses screens
4. Ensure that returning users don't see the onboarding again

## Implementation Notes
- The @MainActor attribute on both AppState and OnboardingViewModel ensures thread safety
- Integration with ContentView ensures proper initialization in the app lifecycle
- Color utilities in BFColors provide consistent styling across the app 

## Common Issues and Troubleshooting

### Duplicate File References
If you encounter a build error with a message like "Multiple commands produce" or "duplicate output file" for documentation files or other resources, check the "Copy Bundle Resources" build phase in your target settings:

1. Open the project file in Xcode
2. Select the BetFreeApp target
3. Go to the "Build Phases" tab
4. Expand the "Copy Bundle Resources" section
5. Look for duplicate entries of the same file
6. Remove duplicates by selecting them and clicking the "-" button

This issue commonly occurs when the same file is added to multiple locations in the project, or when documentation files are both in the project folder and in specialized folders like "Documentation" or "Preview Content".

### Thread Safety Issues
If you encounter runtime warnings about thread safety or main actor isolation:

1. Ensure all UI updates happen on the main thread
2. Check that the `@MainActor` attribute is applied to the AppState and OnboardingViewModel classes
3. Use `await` when calling methods that require main actor isolation

### Navigation Issues
If navigation between onboarding screens is not working correctly:

1. Verify that the TabView's selection binding is properly connected to the currentPage property
2. Check that the nextPage() and previousPage() methods are properly constraining the page index
3. Ensure that each view has the correct tag value matching its expected position 