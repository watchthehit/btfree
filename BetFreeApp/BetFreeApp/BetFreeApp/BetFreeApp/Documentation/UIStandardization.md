# UI Standardization Guidelines

## Overview

This document outlines the standardization approach for the BetFree app's user interface. Consistent UI across all screens ensures a cohesive user experience, reinforces our brand identity, and simplifies future maintenance.

## Color System

All colors in the app should use the `BFColors` system or the standardized extensions in `BFUIStandardization.swift`.

### Primary Color Usage

- **Primary Brand Color**: `BFColors.primary` - Deep Space Blue (#0D1B2A in light mode)
- **Secondary Brand Color**: `BFColors.secondary` - Vibrant Teal (#00B2A9 in light mode)
- **Accent Color**: `BFColors.accent` - Coral (#E94E34 in light mode)

### Text Colors

- **Primary Text**: `BFColors.textPrimary` - Main text content
- **Secondary Text**: `BFColors.textSecondary` - Supporting text
- **Tertiary Text**: `BFColors.textTertiary` - Subtle or hint text

### Background Colors

- **Primary Background**: `BFColors.background` - Main screen background
- **Secondary Background**: `BFColors.secondaryBackground` - Secondary areas
- **Card Background**: `BFColors.cardBackground` - Card and raised element backgrounds

### Standardized Replacement Colors

Always use these standard color replacements instead of SwiftUI's default colors:

| Original | Replacement | Purpose |
|----------|-------------|---------|
| `Color.white` | `Color.bfWhite` | White that adapts to dark mode |
| `Color.black` | `Color.bfBlack` | Black that adapts to dark mode |
| `Color.gray` | `Color.bfGray()` | Gray that follows app styling |
| `Color.red` | `Color.bfRed` | Standard error/warning red |
| `Color.green` | `Color.bfGreen` | Standard success green |
| `Color.black.opacity()` | `Color.bfShadow(opacity:)` | Shadows that adapt to mode |
| `Color.white.opacity()` | `Color.bfOverlay(opacity:)` | Overlays that adapt to mode |

## Typography System

All text in the app should use the `BFTypography` system to ensure consistent text styling.

### Heading Styles

- `BFTypography.heading1` - Main screen titles (32pt bold)
- `BFTypography.heading2` - Section headers (24pt semibold)
- `BFTypography.heading3` - Sub-section headers (20pt medium)

### Body Text Styles

- `BFTypography.bodyLarge` - Prominent body text (18pt)
- `BFTypography.bodyMedium` - Standard body text (16pt)
- `BFTypography.bodySmall` - Supporting text (14pt)

### UI Element Text

- `BFTypography.button` - Button labels (16pt medium)
- `BFTypography.caption` - Captions and small labels (12pt)
- `BFTypography.overline` - Small uppercase labels (10pt medium)

## Spacing System

All spacing in the app should use the `BFSpacing` constants to ensure consistent layout.

### Standard Spacing Values

- `BFSpacing.tiny` - 4pt (minimal spacing)
- `BFSpacing.small` - 8pt (closely related elements)
- `BFSpacing.medium` - 16pt (standard spacing)
- `BFSpacing.large` - 24pt (section separation)
- `BFSpacing.xlarge` - 32pt (major section breaks)
- `BFSpacing.xxlarge` - 48pt (very significant separations)

### Screen Padding

- `BFSpacing.screenHorizontal` - 20pt (standard horizontal screen padding)
- `BFSpacing.screenVertical` - 24pt (standard vertical screen padding)

## Standard View Modifiers

Use these standard view modifiers to ensure consistency:

### Backgrounds

- `.standardCardBackground()` - Standard card styling with shadow
- `.standardOverlay(opacity:)` - Standard overlay with appropriate opacity
- `.standardSelectionBackground(isSelected:)` - Standard selection state

### Spacing

- `.standardContentSpacing()` - Standard content container padding
- `.standardSectionSpacing()` - Standard section spacing

## Implementation Process

To standardize UI across the app, follow these steps:

1. **Identify Non-Standard Elements**:
   - Use grep to search for direct color usage (`Color.white`, `Color.black`, etc.)
   - Look for hard-coded spacing values
   - Find direct font usage without BFTypography

2. **Replace with Standard Elements**:
   - Replace direct colors with BFColors or standardized extensions
   - Replace direct spacing with BFSpacing constants
   - Replace direct fonts with BFTypography

3. **Apply Standard Modifiers**:
   - Replace custom backgrounds with standard modifiers
   - Replace custom padding with standard spacing modifiers

4. **Test Across Modes**:
   - Verify appearance in both light and dark modes
   - Check responsiveness on different device sizes

## Checklist for New UI Components

- [ ] Uses `BFColors` or standardized color extensions for all colors
- [ ] Uses `BFTypography` for all text elements
- [ ] Uses `BFSpacing` for all spacing and padding
- [ ] Uses standard view modifiers for common styling
- [ ] Adapts properly to both light and dark modes
- [ ] Follows accessibility guidelines for contrast and sizing 