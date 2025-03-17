# BetFreeApp Development Guide

## Code Organization

### View Components

The BetFreeApp is built using a component-based architecture with SwiftUI. Key view components are:

- **Screen Views** - Main screens such as `DashboardView`, `EnhancedMotivationScreen`, etc.
- **Component Views** - Reusable views such as cards, buttons, and other UI elements
- **Helper Views** - Utility views like `FloatingShapes` and `ConfettiView`

### Best Practices

#### Managing Complex Views

SwiftUI can have type-checking performance issues with complex expressions. To prevent this:

1. Break large views into smaller components using:
   - Separate struct views
   - Computed properties for view sections
   - ViewBuilder methods
   
Example:
```swift
// Instead of having this directly in body:
var body: some View {
    VStack {
        // 50+ lines of nested view code
    }
}

// Do this:
var body: some View {
    VStack {
        headerView
        contentSection
        footerButtons
    }
}

private var headerView: some View {
    // Implementation
}

private var contentSection: some View {
    // Implementation
}

private var footerButtons: some View {
    // Implementation
}
```

#### State Management

When accessing app state properties:

1. Always check if properties exist in the state object before using them
2. Use UserDefaults for properties that don't exist in the state model
3. Document property migrations and changes

Example:
```swift
// Properly handling app state access
if let appState = viewModel.appState {
    // Properties that exist in the model
    appState.userName = viewModel.userName
    appState.dailyMindfulnessGoal = viewModel.dailyMindfulnessGoal
    
    // Store other values in UserDefaults
    UserDefaults.standard.set(viewModel.isProUser, forKey: "isProUser")
}
```

#### Component Naming

To avoid naming conflicts:

1. Use unique prefixes or suffixes for similar components
2. Use module qualifiers when referencing types (`BetFreeApp.FloatingShapes()`)
3. Keep component names descriptive and specific

#### Animation Management

For clean animations:

1. Use ViewModifiers for reusable animations
2. Separate animation logic from view structure
3. Use state variables to control animations rather than inline values

Example:
```swift
// Good pattern
struct EntranceAnimationModifier: ViewModifier {
    let delay: Double
    @State private var opacity: Double = 0
    @State private var yOffset: CGFloat = 20
    
    func body(content: Content) -> some View {
        content
            .offset(y: yOffset)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 0.4).delay(delay)) {
                    opacity = 1
                    yOffset = 0
                }
            }
    }
}
```

## Common Issues and Solutions

### Type-Checking Timeout

When encountering "compiler is unable to type-check this expression in reasonable time", try:

1. Break the view into smaller sub-views
2. Extract logical sections into computed properties
3. Simplify complex conditional logic

### Ambiguous Initializers

When seeing "Ambiguous use of 'init()'":

1. Use fully qualified type names: `ModuleName.TypeName()`
2. Explicitly provide type information: `let value: SpecificType = ...`
3. Check for duplicate type definitions in the codebase

### Property Access Issues

For "Value of type has no member" errors:

1. Check the actual type definition to confirm property existence
2. Use UserDefaults as a fallback for properties not in the model
 