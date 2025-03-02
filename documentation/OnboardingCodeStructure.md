# BetFree App - Onboarding Code Structure

This document outlines the code structure and implementation details of the enhanced onboarding flow in `EnhancedOnboardingView.swift`.

## Main Components

The onboarding flow is composed of several SwiftUI views that are presented in sequence:

1. `ValuePropositionView1`, `ValuePropositionView2`, `ValuePropositionView3`: Initial value proposition screens
2. `SignInView`: Account creation/login screen
3. `PersonalSetupView`: User preferences and goal setting
4. `NotificationsView`: Notification preferences
5. `PaywallView`: Subscription options
6. `CompletionView`: Onboarding completion screen

## View Structure

### EnhancedOnboardingView

The main container view that manages the flow between different onboarding screens.

```swift
struct EnhancedOnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var currentScreen: OnboardingScreen = .valueProposition1
    
    // Navigation logic and screen transitions
}
```

### Common UI Components

Several reusable components are used throughout the flow:

- **Background**: Consistent wave pattern with gradient (`BFColors.brandGradient()`)
- **Buttons**: Standardized button style with accent color gradient
- **Cards**: Semi-transparent white background cards
- **Icon Animations**: Consistent animation patterns for icons

### View-Specific Components

#### ValuePropositionViews

Simple screens with an animated icon, title, description, and continue button.

```swift
struct ValuePropositionView1: View {
    @Binding var currentScreen: OnboardingScreen
    @State private var animateIcon = false
    @State private var animateText = false
    
    // UI implementation with animations
}
```

#### SignInView

Form-based view with email/password fields, validation, and alternative sign-in options.

```swift
struct SignInView: View {
    @Binding var currentScreen: OnboardingScreen
    @State private var email = ""
    @State private var password = ""
    @State private var emailErrorMessage: String? = nil
    @State private var passwordErrorMessage: String? = nil
    
    // Form validation logic and UI
}
```

#### PersonalSetupView

User personalization screen with name input and goal selection using presets and a slider.

```swift
struct PersonalSetupView: View {
    @Binding var currentScreen: OnboardingScreen
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var username = ""
    @State private var dailyGoalMinutes = 20
    @State private var selectedGoalPreset: Int? = nil
    
    // Goal presets and selection UI
}
```

#### NotificationsView

Toggle options for different notification types with privacy information.

```swift
struct NotificationsView: View {
    @Binding var currentScreen: OnboardingScreen
    @State private var reminderEnabled = true
    @State private var streakEnabled = true
    @State private var tipsEnabled = true
    
    // Notification toggles and descriptions
}
```

#### PaywallView

Subscription options with feature highlights and plan selection.

```swift
struct PaywallView: View {
    @Binding var currentScreen: OnboardingScreen
    @State private var selectedPlan: SubscriptionPlan = .monthly
    @State private var animateFeatures = false
    
    // Subscription plans, feature rows, and selection UI
}
```

#### CompletionView

Final screen with celebration animations and next steps.

```swift
struct CompletionView: View {
    @Binding var currentScreen: OnboardingScreen
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var showConfetti = false
    @State private var animateIcon = false
    @State private var showNextSteps = false
    
    // Completion animations and next steps cards
}
```

## Animation Implementation

Animations are implemented using SwiftUI's native animation system:

```swift
.onAppear {
    withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
        animateIcon = true
    }
    withAnimation(.easeOut.delay(0.6)) {
        animateText = true
    }
}
```

Key animation techniques include:
- Sequenced animations with delays
- Spring animations for natural movement
- Rotation and scaling effects
- Opacity transitions

## Data Handling

User preferences and selections are stored in the `OnboardingViewModel`:

```swift
class OnboardingViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var dailyGoalMinutes: Int = 20
    @Published var notificationsEnabled: Bool = true
    @Published var selectedPlan: SubscriptionPlan = .monthly
    
    // Methods for saving user preferences
}
```

## Color and Style Definitions

Consistent colors are used throughout the flow:

- `BFColors.accent`: Primary accent color for interactive elements
- `BFColors.brandGradient()`: Background gradient
- `Color.white.opacity(0.15)`: Card backgrounds
- `Color.white.opacity(0.8)`: Secondary text

## Best Practices Applied

1. **State Management**: Proper use of `@State`, `@Binding`, and `@ObservedObject`
2. **Reusable Components**: Modular design with reusable UI elements
3. **Progressive Disclosure**: Information presented in logical, digestible chunks
4. **Visual Consistency**: Standardized styling across all screens
5. **Accessibility**: Sufficient contrast and properly sized touch targets 