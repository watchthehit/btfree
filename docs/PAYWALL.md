# PaywallView Documentation

## Overview
The PaywallView is a customizable subscription interface that presents premium features and pricing options to users. It follows modern iOS design patterns and supports both light and dark modes.

## Features
- Clean, modern UI with gradient accents
- Animated feature rows with hover effects
- Dynamic plan selection with monthly and annual options
- Responsive layout with scroll support
- Money-back guarantee and trial information
- Support for both light and dark modes

## Usage

### Basic Implementation
```swift
PaywallView(isPresented: $showPaywall) {
    // Handle subscription
    handleSubscription()
}
```

### Customization
The PaywallView can be customized through the BFDesignSystem:

```swift
// Colors
BFDesignSystem.Colors.calmingGradient // Primary gradient
BFDesignSystem.Colors.cardBackground  // Card backgrounds
BFDesignSystem.Colors.success        // Success indicators

// Typography
BFDesignSystem.Typography.display     // Large titles
BFDesignSystem.Typography.titleSmall  // Subtitles
BFDesignSystem.Typography.bodyLarge   // Feature text
BFDesignSystem.Typography.caption     // Small text
```

## Components

### FeatureRow
Displays individual features with icons and descriptions.

```swift
FeatureRow(
    icon: "chart.line.uptrend.xyaxis",
    text: "Personalized Progress"
)
```

Properties:
- `icon`: SF Symbol name
- `text`: Feature description
- Hover effect with shadow animation

### PaywallPlanView
Displays subscription plan options.

```swift
PaywallPlanView(
    plan: (
        name: "Annual",
        price: "$79.99",
        period: "year",
        savings: "Save 33%"
    ),
    isSelected: true
) {
    // Handle selection
}
```

Properties:
- `plan`: Tuple containing plan details
- `isSelected`: Boolean for selection state
- `action`: Closure for selection handling

## Layout Guidelines

### Spacing
- Use `BFDesignSystem.Layout.Spacing` for consistent spacing
- Large spacing between major sections
- Medium spacing between related elements
- Small spacing within component groups

### Padding
```swift
.padding(.vertical, BFDesignSystem.Layout.Spacing.large)
.padding(.horizontal, BFDesignSystem.Layout.Spacing.medium)
```

## Troubleshooting

### Common Issues

1. **Gradient Type Mismatch**
   ```swift
   // ❌ Wrong
   .fill(isSelected ? BFDesignSystem.Colors.calmingGradient : BFDesignSystem.Colors.cardBackground)
   
   // ✅ Correct
   .fill(isSelected ? BFDesignSystem.Colors.calmingGradient : LinearGradient(
       colors: [BFDesignSystem.Colors.cardBackground, BFDesignSystem.Colors.cardBackground],
       startPoint: .topLeading,
       endPoint: .bottomTrailing
   ))
   ```

2. **Text Truncation**
   ```swift
   // ❌ May truncate
   Text("Long text")
   
   // ✅ Proper wrapping
   Text("Long text")
       .fixedSize(horizontal: false, vertical: true)
   ```

3. **Layout Issues**
   - Ensure ScrollView is used for content that might overflow
   - Use proper padding and spacing constants
   - Test on different device sizes

### Performance Tips
1. Use `@State` for local view state only
2. Implement proper view modifiers for animations
3. Use appropriate shadow depths based on elevation

## Best Practices

### Design
- Maintain consistent spacing using BFDesignSystem constants
- Use gradients for emphasis on important elements
- Implement proper visual hierarchy
- Support both light and dark modes

### Implementation
- Follow SwiftUI view composition patterns
- Use proper type-safe gradients
- Implement proper animation timing
- Handle all user interaction states

### Accessibility
- Provide proper contrast ratios
- Support Dynamic Type
- Include proper VoiceOver labels
- Handle reduced motion preferences

## Testing

### Preview Testing
```swift
struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PaywallView(isPresented: .constant(true)) { }
                .previewDisplayName("Light Mode")
            
            PaywallView(isPresented: .constant(true)) { }
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
            
            PaywallView(isPresented: .constant(true)) { }
                .previewLayout(.fixed(width: 320, height: 800))
                .previewDisplayName("Compact Width")
        }
    }
}
```

### Test Cases
1. Verify plan selection behavior
2. Test animation smoothness
3. Verify proper layout on all device sizes
4. Test accessibility features
5. Verify proper state management

## Version History

### Current Version
- Improved plan selection UI
- Fixed gradient type matching
- Enhanced feature row animations
- Added proper spacing system
- Improved text wrapping

### Planned Improvements
- Enhanced animation system
- Additional plan customization options
- Improved accessibility features
- Extended theming support 