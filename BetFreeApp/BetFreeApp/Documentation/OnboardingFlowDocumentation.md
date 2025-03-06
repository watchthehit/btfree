# BetFree App Onboarding Flow Documentation

## Overview

The BetFree app implements a modern, engaging onboarding flow designed to introduce users to the app's mindfulness-focused approach to managing gambling behavior. The onboarding experience follows best practices from popular mindfulness and health apps, featuring:

- Streamlined question format with essential screens only
- Modern UI elements including circular progress indicators and animations
- Motivation-based personalization
- Strategic hard paywall with clear value proposition

This document serves as a comprehensive reference for the entire onboarding flow architecture, UI components, animations, and implementation details.

## Flow Architecture

The onboarding consists of the following screens in sequence:

1. **Welcome Screen** - First impression and app introduction
2. **Motivation Screen** - User selects their primary reason for using the app
3. **Name Input Screen** - Collects user's name for personalization
4. **Goal Setting Screen** - User selects daily mindfulness goal 
5. **Paywall Screen** - Subscription options with premium features

## Onboarding View Model

The `EnhancedOnboardingViewModel` manages the state for the entire onboarding flow:

```swift
class EnhancedOnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    @Published var userName: String = ""
    @Published var userMotivation: String = ""
    @Published var dailyMindfulnessGoal: Int = 10
    @Published var isProUser: Bool = false
    
    // Navigation methods
    func nextPage() {
        withAnimation {
            currentPage += 1
        }
    }
    
    func previousPage() {
        withAnimation {
            currentPage = max(0, currentPage - 1)
        }
    }
    
    func skipSubscription() {
        // Logic for users who skip the paywall
        completeOnboarding {}
    }
    
    func completeOnboarding(completion: @escaping () -> Void) {
        // Save user preferences and complete onboarding
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        UserDefaults.standard.set(userName, forKey: "userName")
        UserDefaults.standard.set(dailyMindfulnessGoal, forKey: "dailyMindfulnessGoal")
        UserDefaults.standard.set(userMotivation, forKey: "userMotivation")
        UserDefaults.standard.set(isProUser, forKey: "isProUser")
        
        completion()
    }
}
```

## Screen-by-Screen Documentation

### 1. Welcome Screen (EnhancedWelcomeScreen.swift)

**Purpose:** Introduce the app with a visually engaging first impression.

**Key UI Elements:**
- Gradient background with floating animated shapes
- Animated app logo
- Welcome title and descriptive text
- Primary "Get Started" button
- Secondary "Skip" option for returning users

**Animations:**
- Staggered entrance for background, logo, text, and buttons
- Logo scales up from 0.6 to 1.0 over 0.8 seconds
- Text fades in with slight upward movement

**Implementation Notes:**
- Uses ZStack for layered visual elements
- Animation timing is carefully sequenced using delay values
- Haptic feedback on button press enhances tactile experience

### 2. Motivation Screen (EnhancedMotivationScreen.swift)

**Purpose:** Personalize the user experience by understanding primary motivation.

**Key UI Elements:**
- "What brings you to BetFree?" header
- Grid of circular motivation options:
  - Take Control
  - Reduce Gambling
  - Reduce Anxiety
  - Improve Finances
  - Better Relationships
- Each option has a unique icon and color theme
- Continue button enabled only after selection

**Animations:**
- Grid items appear with staggered animation
- Selected item has scale effect and border highlight
- Non-selected items reduce in opacity

**Implementation Notes:**
- Uses LazyVGrid for responsive layout across devices
- MotivationOption model for structured data
- MotivationCard component encapsulates selection visual feedback

### 3. Name Input Screen (EnhancedNameInputScreen.swift)

**Purpose:** Collect user's name for personalization throughout the app.

**Key UI Elements:**
- Clear instructional header explaining purpose
- Modern styled text field with focus state
- Helper text for validation feedback
- Continue button with contextual enabling

**Animations:**
- Staggered entrance for header, input field, and button
- Text field scales slightly when focused
- Error state with subtle shake animation if validation fails

**Implementation Notes:**
- Uses FocusState for managing input focus
- Input validation ensures meaningful personalization
- Keyboard avoidance for better mobile experience

### 4. Goal Setting Screen (EnhancedGoalSettingScreen.swift)

**Purpose:** Help users set meaningful mindfulness goals.

**Key UI Elements:**
- Circular progress indicator showing selected goal
- Slider for intuitive goal selection (1-20 sessions)
- Session visualization with small circles
- Dynamic time per session calculation
- Personalized recommendation based on selection

**Animations:**
- Progress ring animates with spring effect when value changes
- Staggered entrance for all UI elements
- Session circles update dynamically with selection

**Implementation Notes:**
- Uses custom circular progress indicator with gradient stroke
- Recommendations adapt based on selected goal range
- Goal values affect future app behavior and reminders

**Visual Specifications:**
- Circle size: 250pt diameter
- Progress line width: 12pt
- Selected goal uses 90pt bold rounded font
- Sessions visualized as 12pt blue circles (active) and 10pt dim circles (inactive)

### 5. Paywall Screen (EnhancedPaywallScreen.swift)

**Purpose:** Convert users to premium with compelling value proposition.

**Key UI Elements:**
- Premium star badge with sparkle animations
- Personalized message using user's name and goal
- Three subscription options with unmistakable selection indicators:
  - Monthly ($9.99/month)
  - Yearly ($59.99/year) - default selected, shows "Popular" tag
  - Lifetime ($149.99 one-time)
- Expandable feature sections for premium benefits
- Prominent "Subscribe Now" button
- "Continue with Limited Version" option

**Selection Indicators:**
- Selected plans show a filled circle with checkmark icon (32pt)
- Gradient background for selected plan ([accent.opacity(0.3), white.opacity(0.12)])
- 2pt accent-colored border vs 1pt subtle border for unselected
- Scale effect (1.03x) with drop shadow
- Higher opacity (100% vs 80%) for selected plan text

**Animations:**
- Staggered entrance for all UI elements
- Premium badge has sparkle effects radiating outward
- Plan cards animate on selection with spring response
- Feature cards expand/collapse with smooth transitions

**Implementation Notes:**
- Features four benefit categories with expanding detail cards
- Default selection is yearly plan (best value proposition)
- Subscription handling via BFPaywallManager
- Clear visual hierarchy directs attention to primary action

## Common UI Elements

### Floating Shapes Background

Used across screens for visual interest and modern feel:

```swift
struct FloatingShape: View {
    let index: Int
    
    @State private var offset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.0
    @State private var rotation: Double = 0.0
    
    var body: some View {
        customShape
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#4E76F7").opacity(0.7),
                        Color(hex: "#42f5d1").opacity(0.5)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: size.width, height: size.height)
            .offset(offset)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: duration)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.4)
                ) {
                    offset = targetOffset
                    scale = targetScale
                    opacity = targetOpacity
                    rotation = targetRotation
                }
            }
    }
    
    // Shape, size, animation parameters vary by index
}
```

### Haptic Feedback Manager

Used throughout the app for tactile feedback:

```swift
class HapticManager {
    static let shared = HapticManager()
    
    func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func notificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
```

### Color Scheme

App uses a consistent color palette:

```swift
struct BFColors {
    static let background = Color(hex: "#10172A")
    static let backgroundSecondary = Color(hex: "#1c2b4b")
    static let accent = Color(hex: "#4E76F7") 
    static let accentSecondary = Color(hex: "#42f5d1")
    static let text = Color.white
    static let textSecondary = Color.white.opacity(0.7)
}
```

### Button Styles

Consistent button styling across screens:

```swift
// Primary button style
Text("Continue")
    .font(.system(size: 18, weight: .bold, design: .rounded))
    .foregroundColor(.white)
    .frame(maxWidth: .infinity)
    .padding(.vertical, 20)
    .background(
        LinearGradient(
            colors: [Color(hex: "#4E76F7"), Color(hex: "#3D63D2")],
            startPoint: .leading,
            endPoint: .trailing
        )
    )
    .cornerRadius(30)
    .shadow(color: Color(hex: "#4E76F7").opacity(0.4), radius: 8, x: 0, y: 4)
```

## Animation Patterns

### Staggered Entrance Animation

Used on all screens for fluid, engaging appearance:

```swift
private func startEntranceAnimation() {
    // Element 1 animation
    withAnimation(.easeOut(duration: 0.8)) {
        element1Opacity = 1
    }
    
    // Element 2 animation with delay
    withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
        element2Opacity = 1
    }
    
    // Continue with subsequent elements...
}
```

### Interactive Animations

Respond to user input with spring animations:

```swift
.scaleEffect(isSelected ? 1.03 : (isPressed ? 0.98 : 1.0))
.animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
.animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
```

## Technical Implementation Details

### Main Onboarding Coordinator

The `EnhancedOnboardingView` serves as the coordinator for the entire flow:

```swift
struct EnhancedOnboardingView: View {
    @StateObject private var viewModel = EnhancedOnboardingViewModel()
    @EnvironmentObject private var paywallManager: BFPaywallManager
    
    var body: some View {
        ZStack {
            // Current page based on viewModel.currentPage
            switch viewModel.currentPage {
            case 0:
                EnhancedWelcomeScreen(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .opacity,
                        removal: .opacity.combined(with: .move(edge: .leading))
                    ))
            case 1:
                EnhancedMotivationScreen(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .trailing)),
                        removal: .opacity.combined(with: .move(edge: .leading))
                    ))
            case 2:
                EnhancedNameInputScreen(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .trailing)),
                        removal: .opacity.combined(with: .move(edge: .leading))
                    ))
            case 3:
                EnhancedGoalSettingScreen(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .trailing)),
                        removal: .opacity.combined(with: .move(edge: .leading))
                    ))
            case 4:
                EnhancedPaywallScreen(viewModel: viewModel)
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
            default:
                EmptyView()
            }
        }
        .environmentObject(paywallManager)
    }
}
```

### User Data Persistence

User preferences are saved using UserDefaults when onboarding completes:

```swift
func completeOnboarding(completion: @escaping () -> Void) {
    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    UserDefaults.standard.set(userName, forKey: "userName")
    UserDefaults.standard.set(dailyMindfulnessGoal, forKey: "dailyMindfulnessGoal")
    UserDefaults.standard.set(userMotivation, forKey: "userMotivation")
    UserDefaults.standard.set(isProUser, forKey: "isProUser")
    
    completion()
}
```

### Subscription Management

Subscriptions are handled through the `BFPaywallManager`:

```swift
class BFPaywallManager: ObservableObject {
    @Published var hasActiveSubscription: Bool = false
    
    func purchaseSubscription(planId: String, completion: @escaping (Bool) -> Void) {
        // In a production app, this would integrate with StoreKit
        // For demo purposes, we simulate a successful purchase
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.hasActiveSubscription = true
            completion(true)
        }
    }
    
    func restorePurchases(completion: @escaping (Bool) -> Void) {
        // Logic for restoring purchases would go here
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(false) // For demo, assume no purchases to restore
        }
    }
}
```

## Accessibility Considerations

- Color contrast meets WCAG AA standards
- Text sizes are adjustable and use system fonts
- Interactive elements have appropriate hit targets (minimum 44x44pt)
- Haptic feedback provides additional sensory channel
- Animation can be reduced based on system preferences

## Rebuild Instructions

To recreate this onboarding flow:

1. Create the `EnhancedOnboardingViewModel` class
2. Implement each screen as a separate SwiftUI View
3. Create the `EnhancedOnboardingView` coordinator
4. Implement shared UI components (FloatingShapes, HapticManager)
5. Connect screens to the ViewModel
6. Set up transitions and animations
7. Implement data persistence
8. Add subscription management

## Conclusion

The BetFree app onboarding flow implements modern design principles focused on user engagement and conversion. It uses a mindfulness-centric approach that shifts terminology away from gambling-specific language towards more positive, self-improvement framing. The flow collects essential information while maintaining user interest through interactive visual elements and meaningful personalization. 