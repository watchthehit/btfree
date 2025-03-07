# BetFree Design System Documentation

## Overview

The BetFree Design System is a comprehensive collection of UI components, styles, and guidelines that ensure a consistent and cohesive user experience across the BetFree app. This design system is implemented through a set of Swift files that work together to provide a unified visual language.

## Core Components

The design system is built on three primary files:

1. **BFDesignSystem.swift**: Defines the core design tokens such as colors, typography, spacing, animations, and more.
2. **BFComponents.swift**: Contains reusable UI components built using the design tokens.
3. **BFViewModifiers.swift**: Provides view modifiers for consistent styling and behavior.

## Design Tokens

### Colors

The `BFDesignSystem.Colors` enum contains all color definitions used throughout the app:

- **Brand Colors**:
  - `primary`: Deep blue (#102A43)
  - `secondary`: Teal (#35B0AB)
  - `accent`: Vibrant purple (#8A4FFF)

- **Semantic Colors**:
  - `success`: Green (#33CC95)
  - `warning`: Orange (#FFB020)
  - `error`: Red (#F44336)

- **UI Colors**:
  - `background`: Dark background (#121212)
  - `cardBackground`: Slightly lighter (#1E1E1E)
  - `divider`: Subtle separator (#2D2D2D)

- **Text Colors**:
  - `textPrimary`: White/near-white
  - `textSecondary`: Light gray (#AAAAAA)
  - `textTertiary`: Even lighter gray (#777777)

- **Gradient Presets**:
  - `primaryGradient()`
  - `accentGradient()`
  - `premiumGradient`

### Typography

The `BFDesignSystem.Typography` enum provides consistent font styles:

- Text styles: `largeTitle()`, `title1()`, `title2()`, `title3()`, `headline()`, `body()`, `callout()`, `subheadline()`, `footnote()`, `caption()`
- Special display sizes: `counterDisplay()`

### Spacing

The `BFDesignSystem.Spacing` enum defines consistent spacing values:

- `tiny`: 4 points
- `small`: 8 points
- `medium`: 16 points
- `large`: 24 points
- `extraLarge`: 32 points
- `huge`: 48 points
- Standard spacing for various contexts (e.g., `standardHorizontal`, `cardPadding`)

### Radius

The `BFDesignSystem.Radius` enum provides corner radius values:

- `small`: 8 points
- `medium`: 12 points
- `large`: 16 points
- `extraLarge`: 24 points
- Standard radius values for components (e.g., `button`, `card`, `input`)

### Animation

The `BFDesignSystem.Animation` enum contains animation presets:

- `default`: Standard easing (0.3s)
- `fast`: Quick animation (0.2s)
- `slow`: Slower animation (0.6s)
- `spring`: Standard spring animation
- `bouncy`: More pronounced bounce
- `entrance`: For elements entering the screen
- `buttonPress`: For responsive button feedback
- `subtle`: For subtle continuous animations

## UI Components

### Card Components

- **`BFComponents.Card`**: Standard card with title, icon, and content area
- **`BFComponents.FeatureCard`**: Card with gradient background for featured content

### Button Components

- **`BFComponents.PrimaryButton`**: Main action button with gradient background
- **`BFComponents.SecondaryButton`**: Alternative action button with lighter styling
- **`BFComponents.IconButton`**: Circular button with icon

### Stats & Metrics

- **`BFComponents.MetricCard`**: Card for displaying statistical information

### Screen Components

- **`BFComponents.ScreenBackground`**: Standard background for screens

### Button Styles

- **`BFPrimaryButtonStyle`**: Primary button style with customizable size
- **`BFSecondaryButtonStyle`**: Secondary button style with customizable size
- **`BFTextButtonStyle`**: Text-only button style

## View Modifiers

The `BFViewModifiers.swift` file provides consistent styling modifiers:

### Card Styling

```swift
func bfCardStyle() -> some View
```
Applies standard card styling to any view.

### Screen Padding

```swift
func bfScreenPadding() -> some View
```
Applies standard horizontal padding for screen content.

### Animation Modifiers

```swift
func withBFEntranceAnimation(delay: Double = 0, offset: CGFloat = 20, shouldAnimate: Bool = true) -> some View
```
Applies a standard entrance animation with fade and slide effects.

```swift
func withBFPulseAnimation(intensity: CGFloat = 1.0) -> some View
```
Applies a subtle pulsing animation to draw attention to a view.

## Shadow Styles

The `BFShadow` enum in `BFDesignSystem.swift` provides consistent shadow styles:

- `subtle()`: Light shadow for slight elevation
- `medium()`: Medium shadow for cards and interactive elements
- `emphasized()`: Stronger shadow for elevated elements
- `accent()`: Colorized shadow for accent elements

## Usage Examples

### Creating a Card

```swift
BFComponents.Card(title: "Statistics", icon: "chart.bar.fill", iconColor: .blue) {
    Text("Content goes here")
        .foregroundColor(BFDesignSystem.Colors.textPrimary)
}
```

### Using a Primary Button

```swift
BFComponents.PrimaryButton(title: "Save Changes", icon: "checkmark") {
    // Action here
}
```

### Applying Standard Styling

```swift
VStack {
    // Content
}
.bfCardStyle()
.withBFEntranceAnimation(delay: 0.3)
```

## Best Practices

1. Always use the design system components and tokens instead of hardcoded values.
2. Maintain consistent spacing by using the `Spacing` enum values.
3. Use the predefined animations for a cohesive feel.
4. Apply entrance animations consistently across similar elements.
5. Use color extensions (`bfPrimary`, `bfAccent`, etc.) for standard colors.

## Accessibility Considerations

The design system is built with accessibility in mind:

- Text sizes are defined in a way that respects Dynamic Type when implemented correctly
- Color contrast follows accessibility guidelines
- Interactive elements have appropriate sizing for touch targets

For more detailed accessibility guidelines, see `AccessibilityGuidelines.md`. 