# Serene Recovery Color Scheme

This document provides a comprehensive overview of the "Serene Recovery" color scheme used throughout the BetFree application. The color palette has been carefully selected to create a calming, supportive, and hopeful environment for users on their recovery journey.

## Primary Palette

### Deep Teal (#2A6B7C)
Our primary color represents stability and calm. It's used for primary buttons, navigation elements, and key UI components.
- Light Mode: #2A6B7C
- Dark Mode: #3A7D8E

### Soft Sage (#89B399)
Our secondary color conveys growth and healing. It's used for secondary actions, progress indicators, and supportive elements.
- Light Mode: #89B399
- Dark Mode: #7AA38A

### Sunset Orange (#E67E53)
Our accent color provides warm energy and encouragement. It's used sparingly for highlights, call-to-action elements, and important notifications.
- Light Mode: #E67E53
- Dark Mode: #F28A5F

## Functional Colors

### Success Green (#4CAF50)
Used to indicate successful actions, achievements, and positive progress.
- Light Mode: #4CAF50
- Dark Mode: #5DBF61

### Warning Amber (#FF9800)
Used for cautionary messages, moderate alerts, and actions requiring attention.
- Light Mode: #FF9800
- Dark Mode: #FFB74D

### Error Red (#F44336)
Used for error states, critical alerts, and actions that cannot be completed.
- Light Mode: #F44336
- Dark Mode: #FF5252

## Theme Colors

### Calm Teal (#4A8D9D)
A variation of our primary color used in relaxation-focused features and meditation content.
- Light Mode: #4A8D9D
- Dark Mode: #5A9EAE

### Focus Sage (#769C86)
A variation of our secondary color used in concentration and mindfulness features.
- Light Mode: #769C86
- Dark Mode: #86AD96

### Warm Sand (#E6C9A8)
A neutral warm tone that conveys comfort and safety, used in supportive content areas.
- Light Mode: #E6C9A8
- Dark Mode: #F7DAB9

## Neutral Colors

### Light Mode
- Background: #F7F3EB (Light Sand)
- Card Background: #FFFFFF (White)
- Text Primary: #2D3142 (Dark Charcoal)
- Text Secondary: #5C6079 (Medium Charcoal)
- Text Tertiary: #767B91 (Medium Gray)
- Divider: #E1E2E8 (Light Gray)

### Dark Mode
- Background: #1C1F2E (Dark Charcoal)
- Card Background: #2D3142 (Charcoal)
- Text Primary: #F7F3EB (Light Sand)
- Text Secondary: #B5BAC9 (Light Gray)
- Text Tertiary: #9DA3B7 (Medium Gray)
- Divider: #3D4259 (Dark Gray)

## Gradients

### Primary Gradient
A gradient from Deep Teal to a slightly lighter shade, used for prominent UI elements.
- Start: #2A6B7C
- End: #3A7D8E

### Calm Gradient
A soothing gradient used for meditation and relaxation features.
- Start: #4A8D9D
- End: #89B399

### Sunset Gradient
A warm, energizing gradient used for achievement celebrations.
- Start: #E67E53
- End: #E6C9A8

## Accessibility Considerations

All color combinations in the "Serene Recovery" palette have been tested to ensure they meet WCAG 2.1 AA standards for color contrast. This ensures that text remains readable for users with various visual abilities.

- Primary text on light backgrounds maintains a contrast ratio of at least 4.5:1
- Large text and UI components maintain a contrast ratio of at least 3:1
- Focus indicators use a combination of color and shape changes to accommodate users with color vision deficiencies

## Implementation

### File Paths (Updated March 2, 2024)
The color scheme should be implemented in the following files:

1. **Color Definitions**: `BetFreeApp/BetFreeApp/BetFreeApp/BetFreeApp/BFColors.swift`
   - This file contains all color definitions and provides programmatic access to the palette
   - Changes to color values must be made here to ensure consistency
   - ✅ UPDATED: Duplicate BFColors.swift files have been removed from the project

2. **UI Implementation**: `BetFreeApp/BetFreeApp/BetFreeApp/BetFreeApp/EnhancedOnboardingView.swift`
   - This file is the main onboarding view where colors are applied
   - ✅ UPDATED: Duplicate EnhancedOnboardingView.swift files have been removed from the project

3. **Code Generation**: `documentation/scripts/generate-color-assets.sh`
   - This script generates color assets for Xcode based on this document
   - The output directory is set to `BetFreeApp/BetFreeApp/Assets.xcassets/Colors`

For more details on the project structure, refer to `documentation/ProjectStructure.md`.

## Usage Guidelines

- Primary buttons should use Deep Teal with white text
- Secondary buttons should use Soft Sage with dark text
- Use Sunset Orange sparingly to highlight the most important actions
- Background elements should use the neutral palette to maintain visual calm
- Error states should always use Error Red combined with a descriptive message
- Success states should use Success Green with supportive messaging

## Testing Colors

When making color changes, always:
1. Update the color definitions in `BFColors.swift`
2. Clear DerivedData with `rm -rf ~/Library/Developer/Xcode/DerivedData`
3. Rebuild the project
4. Test on both light and dark mode to ensure proper implementation 