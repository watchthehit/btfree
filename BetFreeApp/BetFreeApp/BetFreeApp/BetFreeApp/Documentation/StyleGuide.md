# BetFree App Style Guide

This style guide provides comprehensive guidance on visual design, component usage, and layout standards for the BetFree app. Following these guidelines ensures a consistent user experience across all screens.

## Table of Contents

1. [Typography](#typography)
2. [Colors](#colors)
3. [Spacing](#spacing)
4. [Components](#components)
5. [Animations](#animations)
6. [Screen Structure](#screen-structure)
7. [Best Practices](#best-practices)

## Typography

All text in the app should use the `BFTypography` system, which provides consistent text styles for all contexts.

### Text Styles

* **Headings**
  * `.heading1()` - Main screen titles (32pt, bold)
  * `.heading2()` - Section headings (24pt, semibold)
  * `.heading3()` - Sub-section headings (20pt, medium)

* **Body Text**
  * `.bodyLarge()` - Featured content (18pt, regular)
  * `.bodyMedium()` - Standard content (16pt, regular)
  * `.bodySmall()` - Supporting content (14pt, regular)
  * `.caption()` - Supplementary information (12pt, regular)

### Usage Example

```swift
Text("Screen Title")
    .heading1()

Text("Section Heading")
    .heading2()

Text("Regular content text")
    .bodyMedium()
```

## Colors

All colors should be referenced through the `BFColors` structure, which provides semantic color names and handles light/dark mode adaptations.

### Primary Colors

* `BFColors.primary` - Deep Space Blue (primary brand color)
* `BFColors.secondary` - Vibrant Teal (secondary brand color)
* `BFColors.accent` - Coral Accent (for interactive elements and emphasis)

### Functional Colors

* `BFColors.success` - Green (positive outcomes)
* `BFColors.warning` - Amber (cautionary states)
* `BFColors.error` - Red (error states)

### Theme Colors

* `BFColors.calm` - Ocean Blue (relaxation features)
* `BFColors.focus` - Aquamarine (mindfulness features)
* `BFColors.hope` - Warm Sand (supportive content)

### Usage Example

```swift
Text("Interactive element")
    .foregroundColor(BFColors.accent)

Rectangle()
    .fill(BFColors.background)
```

### Gradients

* `BFColors.brandGradient()` - Primary brand gradient
* `BFColors.primaryGradient()` - Deep Space to Oxford Blue
* `BFColors.energyGradient()` - Ocean Blue to Coral

## Spacing

Use the `BFSpacing` system for consistent spacing values throughout the app.

### Standard Spacing Values

* `BFSpacing.tiny` - 4pt (minimal spacing)
* `BFSpacing.small` - 8pt (closely related elements)
* `BFSpacing.medium` - 16pt (standard spacing)
* `BFSpacing.large` - 24pt (section separation)
* `BFSpacing.xlarge` - 32pt (major section breaks)
* `BFSpacing.xxlarge` - 48pt (very significant separations)

### Screen Padding

* `BFSpacing.screenHorizontal` - 20pt (standard horizontal screen padding)
* `BFSpacing.screenVertical` - 24pt (standard vertical screen padding)

### Usage Example

```swift
VStack(spacing: BFSpacing.medium) {
    // Content here
}
.padding(.horizontal, BFSpacing.screenHorizontal)

// Or using the extension
.screenPadding()
```

## Components

Use standardized components for consistent UI elements across screens.

### Buttons

* `BFPrimaryButton` - Primary action button
* `BFSecondaryButton` - Secondary action button
* `BFTextButton` - Minimal text-only button

### Example

```swift
BFPrimaryButton(
    text: "Continue",
    icon: "arrow.right",
    action: { /* action here */ }
)

BFSecondaryButton(
    text: "Cancel",
    action: { /* action here */ }
)

BFTextButton(
    text: "Skip this step",
    action: { /* action here */ }
)
```

### Text Fields

```swift
// Basic usage
BFTextField(
    title: "Email Address",
    placeholder: "you@example.com",
    text: $email,
    icon: "envelope",
    keyboardType: .emailAddress
)

// With enhanced styling and focus state
@FocusState private var emailFocused: Bool

BFTextField(
    title: "Email Address",
    placeholder: "you@example.com",
    text: $email,
    icon: "envelope",
    keyboardType: .emailAddress
)
.enhanced(isFocused: $emailFocused, errorMessage: emailError)
```

### Card Component

```swift
// Basic usage
BFCard {
    VStack {
        // Card content here
    }
}

// With standardized styling using styledBody
BFCard {
    VStack {
        // Card content here
    }
}
.styledBody()

// With custom opacity
BFCard {
    VStack {
        // Card content here
    }
}
.styledBody(opacity: 0.2)

// With custom padding
BFCard {
    VStack {
        // Card content here
    }
}
.styledBody(padding: BFSpacing.large)
```

### Selection Options

```swift
BFOptionButton(
    text: "Option text",
    isSelected: selectedOption == "Option text",
    allowsMultiple: false,
    action: { /* selection action */ }
)
```

### Progress Indicator

```swift
BFProgressBar(progress: 0.75)
    .frame(height: 4)
```

## Animations

Use the `BFAnimations` system for consistent animation timing and styles.

### Duration Constants

* `BFAnimations.quickDuration` - 0.2s (immediate feedback)
* `BFAnimations.standardDuration` - 0.4s (most transitions)
* `BFAnimations.slowDuration` - 0.6s (emphasis)

### Standard Animations

* `BFAnimations.standardAppear` - For appearing elements
* `BFAnimations.standardDisappear` - For disappearing elements
* `BFAnimations.emphasis` - For emphasis (spring animation)
* `BFAnimations.subtle` - For subtle animations

### Usage Example

```swift
.opacity(isVisible ? 1 : 0)
.animation(BFAnimations.standardAppear, value: isVisible)

// For staggered animations
.animation(.easeOut.delay(
    BFAnimations.staggeredDelay(baseDelay: 0.1, itemIndex: index)
), value: isVisible)
```

## Screen Structure

Standard screen structure for consistency:

```swift
struct ExampleScreen: View {
    var body: some View {
        ZStack {
            // 1. Background
            BFScreenBackground()
            
            // 2. Main content
            VStack(spacing: BFSpacing.large) {
                // Header section
                VStack(spacing: BFSpacing.small) {
                    Text("Screen Title")
                        .heading1()
                    
                    Text("Supporting description text")
                        .bodyMedium()
                }
                
                // Content sections
                ScrollView {
                    VStack(spacing: BFSpacing.large) {
                        // Screen content here
                    }
                    .screenPadding()
                }
                
                // Bottom buttons
                VStack(spacing: BFSpacing.medium) {
                    BFPrimaryButton(
                        text: "Primary Action",
                        action: { /* action */ }
                    )
                    
                    BFTextButton(
                        text: "Secondary Action",
                        action: { /* action */ }
                    )
                }
                .padding(.horizontal, BFSpacing.screenHorizontal)
                .padding(.bottom, BFSpacing.large)
            }
        }
    }
}
```

## Best Practices

1. **Always use design system components** instead of creating custom implementations.

2. **Reference color values semantically** through `BFColors` rather than using direct color values.

3. **Apply consistent spacing** using the `BFSpacing` constants.

4. **Maintain typography hierarchy** using the appropriate text styles for each context.

5. **Use standard animations** to maintain consistent motion design.

6. **Follow the core layout patterns** for screen structure.

7. **Ensure all interactive elements** have appropriate feedback states.

8. **Use proper shadows and elevation** to establish visual hierarchy.

9. **Implement proper error handling** with clear, helpful error messages.

10. **Maintain accessibility** by using appropriate font sizes, contrast, and hit targets. 