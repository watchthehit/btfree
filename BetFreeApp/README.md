# BetFree App - "Serene Recovery" Theme

A recovery-focused mobile application designed to help users overcome gambling addiction through mindfulness, goal tracking, and community support, featuring the "Serene Recovery" color scheme.

## Color Scheme

The app uses the "Serene Recovery" color scheme, which features calming natural colors designed to create a supportive environment for users on their recovery journey.

### Primary Colors

- **Deep Teal (#2A6B7C)**: Primary brand color representing stability and calm
- **Soft Sage (#89B399)**: Secondary color representing growth and healing
- **Sunset Orange (#E67E53)**: Accent color providing warm energy and encouragement

### Theme Colors

- **Calm Teal (#4A8D9D)**: Used in relaxation-focused features
- **Focus Sage (#769C86)**: Used in concentration and mindfulness features
- **Warm Sand (#E6C9A8)**: Used in supportive content areas

### Functional Colors

- **Success Green (#4CAF50)**: Indicates successful actions and achievements
- **Warning Amber (#FF9800)**: Used for cautionary messages requiring attention
- **Error Red (#F44336)**: Signals error states and critical alerts

### Neutral Colors

- **Background**: Light Sand (#F7F3EB) in light mode, Dark Charcoal (#1C1F2E) in dark mode
- **Card Background**: White (#FFFFFF) in light mode, Charcoal (#2D3142) in dark mode
- **Text Primary**: Dark Charcoal (#2D3142) in light mode, Light Sand (#F7F3EB) in dark mode
- **Text Secondary**: Medium Charcoal (#5C6079) in light mode, Light Gray (#B5BAC9) in dark mode
- **Text Tertiary**: Medium Gray (#767B91) in both modes
- **Divider**: Light Gray (#E1E2E8) in light mode, Dark Gray (#3D4259) in dark mode

## Project Structure

The project is structured as a Swift Package that can be easily integrated into your Xcode project:

```
BetFreeApp/
├── Sources/
│   └── BetFreeApp/
│       ├── BFColors.swift        # Color definitions and utilities
│       ├── BetFreeApp.swift      # Main app entry point
│       ├── Components/           # Reusable UI components
│       │   ├── BFButton.swift    # Custom button component
│       │   └── BFCard.swift      # Custom card component
│       └── Screens/              # App screens
│           └── SereneSampleView.swift  # Sample view showcasing components
└── Tests/
    └── BetFreeAppTests/          # Tests for the package
```

## Components

### BFButton

A customizable button component with support for different styles:
- Primary (Deep Teal background)
- Secondary (Soft Sage background)
- Tertiary (Text-only with Deep Teal color)
- Destructive (Error Red background)

### BFCard

A card container component with support for:
- Optional title and subtitle
- Optional footer
- Optional accent color bar
- Selectable cards with tap actions

## Screens

### RecoveryDashboardView

The main dashboard screen showcasing:
- User's recovery progress
- Daily goals tracking
- Mindfulness exercises
- Support resources

## Implementation

The color scheme is implemented using Xcode color assets with light and dark mode variants. The `BFColors` struct provides programmatic access to all colors in the palette, along with utility functions for dynamic colors and gradients.

## Getting Started

### Opening the Project in Xcode

1. Clone the repository
2. Open the `Package.swift` file in Xcode
3. Xcode will automatically set up the Swift Package
4. Run the `BetFreeApp` scheme to see the sample app

### Using in Your Project

To use this package in your project:

1. In Xcode, select File > Add Packages...
2. Enter the repository URL
3. Select the version you want to use
4. Add the package to your target

## Usage

```swift
import BetFreeApp
import SwiftUI

struct MyView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
                .foregroundColor(BFColors.textPrimary)
            
            BFButton("Tap Me", style: .primary) {
                print("Button tapped!")
            }
            
            BFCard(title: "Example Card") {
                Text("Card content goes here")
                    .foregroundColor(BFColors.textSecondary)
            }
        }
        .background(BFColors.background)
    }
}
```

## Accessibility

The "Serene Recovery" color scheme has been tested to ensure all color combinations meet WCAG 2.1 AA standards for contrast. This ensures that text remains readable for users with various visual abilities.

## Features
- Enhanced onboarding flow with 8 comprehensive screens
- Personal goal setting and tracking
- Trigger identification and management
- Craving reporting and analysis
- Customizable notification preferences
- Privacy-focused design with local data storage
- Optimized performance with efficient resource usage

## Technical Details
- Built with SwiftUI
- MVVM architecture
- Supports iOS 15.0 and above
- Uses @MainActor for thread safety
- Static UI elements for improved performance and stability
- Consistent color theme using navy blue (#2C3550) and green accent (#4CAF50)

## Onboarding Flow
The app includes an optimized onboarding flow with a value-first approach:
1. Welcome (with resume capability)
2. Value Proposition Screens (3)
3. Goal Selection (simplified options)
4. Combined Profile Setup (streamlined data collection)
5. Notification Setup
6. Completion

## Deferred Paywall Strategy
The app implements a strategic deferred paywall approach:
- Enhanced subscription screen shown after users experience app value
- Multiple contextual triggers based on user engagement
- Smart frequency controls to prevent subscription fatigue
- Clear value proposition for premium features
- A/B testing ready implementation

## Performance Optimizations
- Static backgrounds instead of animated waves to prevent memory issues
- Simplified UI animations to avoid performance bottlenecks
- Proper memory management with resource release on backgrounding
- Use of PlainButtonStyle() to ensure reliable touch interactions
- Optimized text field interactions with @FocusState
- Progress persistence for interrupted sessions
- Lazy loading of view components

## UI Design
- Consistent navy blue background across all screens
- Green accent color for interactive elements
- Clear visual hierarchy with proper contrast
- Responsive buttons with visual feedback
- Well-defined text styles for readability

## State Management
The app uses a central AppState object as the single source of truth, which is passed through the view hierarchy using the @EnvironmentObject property wrapper.

## Future Enhancements
- Data visualization for craving patterns
- Expanded mindfulness exercises
- Community support features
- Achievement badges and rewards system 