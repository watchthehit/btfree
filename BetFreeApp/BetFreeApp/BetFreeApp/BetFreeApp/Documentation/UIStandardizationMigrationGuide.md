# UI Standardization Migration Guide

## Overview

This guide provides step-by-step instructions for migrating existing screens and components in the BetFree app to the new unified design system. The goal is to ensure visual consistency across the entire app while making the codebase more maintainable.

## Migration Approach

Migration will follow a feature-by-feature approach, starting with the most visible screens. The recommended order is:

1. Main counter screen
2. Profile view
3. Dashboard
4. Statistics screens
5. Settings
6. Goals section
7. Auxiliary screens

## Migration Steps

### Step 1: Update Imports

Ensure each file has the necessary imports to access the design system:

```swift
import SwiftUI

// If needed for specific components or utilities
import Foundation
#if canImport(UIKit)
import UIKit
#endif
```

### Step 2: Migrate Colors

Replace all hardcoded colors and old color references with the new design system:

#### Before:
```swift
Text("Hello")
    .foregroundColor(Color.white)
    .background(Color.black.opacity(0.7))
```

or 

```swift
Text("Hello")
    .foregroundColor(BFColors.textPrimary)
    .background(BFColors.cardBackground)
```

#### After:
```swift
Text("Hello")
    .foregroundColor(BFDesignSystem.Colors.textPrimary)
    .background(BFDesignSystem.Colors.cardBackground)
```

or using extensions:

```swift
Text("Hello")
    .foregroundColor(.bfTextPrimary)
    .background(.bfCardBackground)
```

### Step 3: Migrate Typography

Replace all font definitions with the design system typography:

#### Before:
```swift
Text("Title")
    .font(.system(size: 24, weight: .bold))
```

or

```swift
Text("Title")
    .font(BFTypography.heading2)
```

#### After:
```swift
Text("Title")
    .font(BFDesignSystem.Typography.title2())
```

or using extensions:

```swift
Text("Title")
    .font(.heading2)
```

### Step 4: Migrate Spacing and Layout

Replace all hardcoded spacing values:

#### Before:
```swift
VStack(spacing: 16) {
    // Content
}
.padding(.horizontal, 20)
```

or

```swift
VStack(spacing: BFSpacing.medium) {
    // Content
}
.padding(.horizontal, BFSpacing.screenHorizontal)
```

#### After:
```swift
VStack(spacing: BFDesignSystem.Spacing.medium) {
    // Content
}
.bfScreenPadding()
```

### Step 5: Migrate View Modifiers

Replace custom view modifiers with standardized ones:

#### Before:
```swift
VStack {
    // Content
}
.padding(16)
.background(
    RoundedRectangle(cornerRadius: 12)
        .fill(BFColors.cardBackground)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
)
```

#### After:
```swift
VStack {
    // Content
}
.bfCardStyle()
```

### Step 6: Add Animation

Add entrance and interaction animations:

```swift
VStack {
    // Content
}
.bfCardStyle()
.withBFEntranceAnimation(delay: 0.2)
```

For interactive elements:

```swift
Button {
    // Action
} label: {
    Text("Tap Me")
}
.scaleEffect(isPressed ? 0.95 : 1.0)
.animation(BFDesignSystem.Animation.buttonPress, value: isPressed)
```

### Step 7: Replace Components

Replace custom component implementations with standardized components:

#### Before:
```swift
// Custom card implementation
VStack(alignment: .leading, spacing: 12) {
    Text("Card Title")
        .font(.system(size: 18, weight: .semibold))
    
    Divider()
    
    Text("Card content")
        .font(.system(size: 16))
}
.padding(16)
.background(
    RoundedRectangle(cornerRadius: 12)
        .fill(Color(.systemBackground))
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
)
```

#### After:
```swift
BFComponents.Card(title: "Card Title") {
    Text("Card content")
        .font(BFDesignSystem.Typography.body())
}
```

### Step 8: Migrate Buttons

Replace custom buttons with standardized button components:

#### Before:
```swift
Button(action: {
    // Action here
}) {
    Text("Primary Action")
        .font(.system(size: 16, weight: .semibold))
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .cornerRadius(10)
}
```

#### After:
```swift
BFComponents.PrimaryButton(title: "Primary Action") {
    // Action here
}
```

## ProfileView Migration Example

Here's a comprehensive example of migrating the ProfileView:

### Before:
```swift
// Header section
VStack {
    Image(systemName: "person.circle.fill")
        .font(.system(size: 60))
        .foregroundColor(BFColors.accent)
    
    Text(username)
        .font(.system(size: 24, weight: .bold))
        .foregroundColor(BFColors.textPrimary)
}
.padding()
.background(
    RoundedRectangle(cornerRadius: 12)
    .fill(BFColors.cardBackground)
    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
)
.padding(.horizontal, 20)
```

### After:
```swift
// Header section
VStack {
    Image(systemName: "person.circle.fill")
        .font(BFDesignSystem.Typography.largeTitle())
        .foregroundColor(BFDesignSystem.Colors.accent)
    
    Text(username)
        .font(BFDesignSystem.Typography.title2())
        .foregroundColor(BFDesignSystem.Colors.textPrimary)
}
.bfCardStyle()
.bfScreenPadding()
.withBFEntranceAnimation(delay: 0.2)
```

## Testing Your Migration

After migrating each screen, perform the following tests:

1. **Visual Inspection**: Compare the migrated screen to the design references.
2. **Dark Mode Testing**: Verify the screen looks correct in dark mode.
3. **Animation Testing**: Check that all animations work smoothly.
4. **Performance Testing**: Ensure the screen performs well with no lag.
5. **Accessibility Testing**: Verify screen works with accessibility features.

## Common Migration Issues

### 1. Color Conflicts

**Problem**: Colors don't match design expectations.

**Solution**: Double check color definitions and ensure you're using the correct color from `BFDesignSystem.Colors`.

### 2. Layout Shifts

**Problem**: Layout changes after migration.

**Solution**: Check padding and spacing values, and ensure you're using the correct `Spacing` constants.

### 3. Animation Issues

**Problem**: Animations don't play properly or cause layout issues.

**Solution**: Ensure animations are tied to state changes with the `value:` parameter, and check for conflicting animations.

### 4. Component Adaptability 

**Problem**: Components don't adapt to different screen sizes.

**Solution**: Make sure components use flexible sizing (e.g., `.frame(maxWidth: .infinity)` where appropriate).

## Progressive Enhancement

After the basic migration is complete, consider these enhancements:

1. **Add Entrance Animations**: Apply `.withBFEntranceAnimation()` with staggered delays for a polished feel.
2. **Improve Button Feedback**: Add haptic feedback with `HapticManager.shared.playLightFeedback()`.
3. **Enhance Visual Hierarchy**: Use accentShadow() for important actions.
4. **Add Response Animations**: Use `.scaleAnimation(isActive:)` for state changes.

## Example Migration Workflow

Here's a practical example workflow for migrating a screen:

1. Create a new branch: `git checkout -b migrate-profile-screen`
2. Open the target file (e.g., `ProfileView.swift`)
3. Start with imports and then follow the migration steps
4. Test the migrated screen
5. Commit changes: `git commit -m "Migrate ProfileView to unified design system"`
6. Create a PR for review

## Timeline Expectations

Each screen should take approximately:

- Simple screens: 1-2 hours
- Complex screens: 3-4 hours
- Highly interactive screens: 4-8 hours

The entire app migration is expected to take approximately 1-2 weeks.

## Additional Resources

- `DesignSystem.md`: Comprehensive documentation of the design system
- `UIStandardization.md`: Overall standardization guidelines
- `AccessibilityGuidelines.md`: Ensuring your migrated UI is accessible 