# UI Standardization Guidelines

## Overview

This document outlines the standardization approach for the BetFree app's user interface. Consistent UI across all screens ensures a cohesive user experience, reinforces our brand identity, and simplifies future maintenance.

## Unified Design System

The BetFree app now uses a unified design system implemented through the following core files:

1. **BFDesignSystem.swift**: Central repository for all design tokens
2. **BFComponents.swift**: Reusable UI components built with the design tokens
3. **BFViewModifiers.swift**: Consistent modifiers for styling and animations
4. **BFStandardComponents.swift**: Extended components with standardized styling

For detailed documentation on the design system, see `DesignSystem.md`.

## Color System

All colors in the app should use the `BFDesignSystem.Colors` enum or the standardized color extensions.

### Primary Color Usage

- **Primary Brand Color**: `BFDesignSystem.Colors.primary` - Deep blue (#102A43)
- **Secondary Brand Color**: `BFDesignSystem.Colors.secondary` - Teal (#35B0AB)
- **Accent Color**: `BFDesignSystem.Colors.accent` - Vibrant purple (#8A4FFF)

### Text Colors

- **Primary Text**: `BFDesignSystem.Colors.textPrimary` - Main text content
- **Secondary Text**: `BFDesignSystem.Colors.textSecondary` - Supporting text
- **Tertiary Text**: `BFDesignSystem.Colors.textTertiary` - Subtle or hint text

### Background Colors

- **Primary Background**: `BFDesignSystem.Colors.background` - Main screen background
- **Card Background**: `BFDesignSystem.Colors.cardBackground` - Card and raised element backgrounds
- **Divider Color**: `BFDesignSystem.Colors.divider` - Separator lines and borders

### Standardized Color Extensions

Use these standard color extensions for easy access to design system colors:

```swift
Color.bfPrimary       // BFDesignSystem.Colors.primary
Color.bfSecondary     // BFDesignSystem.Colors.secondary
Color.bfAccent        // BFDesignSystem.Colors.accent
Color.bfBackground    // BFDesignSystem.Colors.background
Color.bfTextPrimary   // BFDesignSystem.Colors.textPrimary
Color.bfTextSecondary // BFDesignSystem.Colors.textSecondary
Color.bfTextTertiary  // BFDesignSystem.Colors.textTertiary
Color.bfCardBackground // BFDesignSystem.Colors.cardBackground
Color.bfDivider       // BFDesignSystem.Colors.divider
```

## Typography System

All text in the app should use the `BFDesignSystem.Typography` system or the font extensions.

### Text Styles

- `BFDesignSystem.Typography.largeTitle()` - Main titles (34pt)
- `BFDesignSystem.Typography.title1()` - Primary headings (28pt bold)
- `BFDesignSystem.Typography.title2()` - Secondary headings (22pt bold)
- `BFDesignSystem.Typography.title3()` - Tertiary headings (20pt semibold)
- `BFDesignSystem.Typography.headline()` - Featured text (18pt semibold)
- `BFDesignSystem.Typography.body()` - Standard body text (16pt regular)
- `BFDesignSystem.Typography.callout()` - Emphasized body text (16pt medium)
- `BFDesignSystem.Typography.subheadline()` - Secondary body text (14pt medium)
- `BFDesignSystem.Typography.footnote()` - Small text (13pt regular)
- `BFDesignSystem.Typography.caption()` - Very small text (12pt regular)

### Font Extensions

Use these standard font extensions for easy access:

```swift
Font.heading1    // BFDesignSystem.Fonts.heading1
Font.heading2    // BFDesignSystem.Fonts.heading2
Font.heading3    // BFDesignSystem.Fonts.heading3
Font.heading4    // BFDesignSystem.Fonts.heading4
Font.bodyMedium  // BFDesignSystem.Fonts.bodyMedium
Font.bodySmall   // BFDesignSystem.Fonts.bodySmall
Font.bodyLarge   // BFDesignSystem.Fonts.bodyLarge
Font.caption     // BFDesignSystem.Fonts.caption
Font.button      // BFDesignSystem.Fonts.button
```

## Spacing System

All spacing in the app should use the `BFDesignSystem.Spacing` enum to ensure consistent layout.

### Standard Spacing Values

- `BFDesignSystem.Spacing.tiny` - 4pt (minimal spacing)
- `BFDesignSystem.Spacing.small` - 8pt (closely related elements)
- `BFDesignSystem.Spacing.medium` - 16pt (standard spacing)
- `BFDesignSystem.Spacing.large` - 24pt (section separation)
- `BFDesignSystem.Spacing.extraLarge` - 32pt (major section breaks)
- `BFDesignSystem.Spacing.huge` - 48pt (very significant separations)

### Screen and Component Padding

- `BFDesignSystem.Spacing.screenHorizontal` - Standard horizontal screen padding
- `BFDesignSystem.Spacing.screenVertical` - Standard vertical screen padding
- `BFDesignSystem.Spacing.cardPadding` - Standard padding for card components

## Corner Radius System

Use `BFDesignSystem.Radius` enum for consistent corner radii across the app:

- `BFDesignSystem.Radius.small` - 8pt (subtle rounding)
- `BFDesignSystem.Radius.medium` - 12pt (standard rounding)
- `BFDesignSystem.Radius.large` - 16pt (prominent rounding)
- `BFDesignSystem.Radius.extraLarge` - 24pt (very prominent rounding)

Component-specific radii:
- `BFDesignSystem.Radius.button` - Standard button corner radius
- `BFDesignSystem.Radius.card` - Standard card corner radius
- `BFDesignSystem.Radius.input` - Standard input field corner radius

## Standard View Modifiers

Use these standard view modifiers to ensure consistency:

### Card Styling

```swift
.bfCardStyle()
```
Applies standard card styling with appropriate background, corner radius, and shadow.

### Screen Padding

```swift
.bfScreenPadding()
```
Applies standard horizontal padding for screen content.

### Animation Modifiers

```swift
.withBFEntranceAnimation(delay: 0.3)
```
Applies standard entrance animation with configurable delay.

```swift
.withBFPulseAnimation()
```
Applies subtle pulsing animation to draw attention.

### Shadow Modifiers

```swift
.subtleShadow()
.mediumShadow()
.emphasizedShadow()
.accentShadow()
```
Apply consistent shadow styles across the app.

## Animation System

Use `BFDesignSystem.Animation` presets for consistent animations:

- `BFDesignSystem.Animation.default` - Standard easing (0.3s)
- `BFDesignSystem.Animation.fast` - Quick animation (0.2s)
- `BFDesignSystem.Animation.slow` - Slower animation (0.6s)
- `BFDesignSystem.Animation.spring` - Standard spring animation
- `BFDesignSystem.Animation.bouncy` - More pronounced bounce
- `BFDesignSystem.Animation.entrance` - For elements entering the screen
- `BFDesignSystem.Animation.buttonPress` - For responsive button feedback

## UI Components

The following standardized components should be used across the app:

### Cards
- `BFComponents.Card` - Standard content card
- `BFComponents.FeatureCard` - Highlighted feature card with gradient

### Buttons
- `BFComponents.PrimaryButton` - Primary action button
- `BFComponents.SecondaryButton` - Secondary action button
- `BFComponents.IconButton` - Circular icon button

### Stats & Metrics
- `BFComponents.MetricCard` - For displaying statistics

### Screens
- `BFComponents.ScreenBackground` - Standard screen background

## Implementation Process

To standardize UI across the app, follow these steps:

1. **Replace Legacy Components**:
   - Replace direct color usage with `BFDesignSystem.Colors` or extensions
   - Replace direct font usage with `BFDesignSystem.Typography` or extensions
   - Replace spacing values with `BFDesignSystem.Spacing`
   - Replace corner radius values with `BFDesignSystem.Radius`

2. **Apply Standard Modifiers**:
   - Replace custom card styling with `.bfCardStyle()`
   - Replace custom screen padding with `.bfScreenPadding()`
   - Add entrance animations with `.withBFEntranceAnimation()`

3. **Use Standardized Components**:
   - Replace custom cards with `BFComponents.Card`
   - Replace custom buttons with `BFComponents.PrimaryButton`, etc.
   - Use `BFComponents.ScreenBackground` for consistent backgrounds

4. **Test Across Screens**:
   - Verify consistent appearance across all screens
   - Check animations and transitions for smoothness
   - Verify dark mode compatibility

## Checklist for New UI Components

- [ ] Uses `BFDesignSystem.Colors` or color extensions for all colors
- [ ] Uses `BFDesignSystem.Typography` or font extensions for all text
- [ ] Uses `BFDesignSystem.Spacing` for all spacing and padding
- [ ] Uses `BFDesignSystem.Radius` for all corner radii
- [ ] Uses standard view modifiers for common styling
- [ ] Uses standard components when applicable
- [ ] Implements entrance animations consistently
- [ ] Works correctly in dark mode
- [ ] Follows accessibility guidelines

## Migration Guide

For detailed instructions on migrating existing screens to the new design system, see `UIStandardizationMigrationGuide.md`. 