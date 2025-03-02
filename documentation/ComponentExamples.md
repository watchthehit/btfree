# SwiftShip Component Adaptation Examples

This document provides practical examples of how to adapt SwiftShip components using the new "Serene Recovery" color scheme. These examples can be used as a reference when implementing the integration plan.

## Authentication Screen Example

### Original SwiftShip Login Screen

Here's a simplified version of SwiftShip's login screen:

```swift
import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Welcome Back")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color.appTheme.textColor)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color.appTheme.bgColor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.appTheme.primaryColor, lineWidth: 1)
                )
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.appTheme.bgColor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.appTheme.primaryColor, lineWidth: 1)
                )
            
            Button(action: {
                viewModel.login(email: email, password: password)
            }) {
                Text("Log In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.appTheme.primaryColor)
                    .cornerRadius(10)
            }
            
            Button(action: {
                // Handle password reset
            }) {
                Text("Forgot Password?")
                    .foregroundColor(Color.appTheme.primaryColor)
            }
            .padding(.top, 10)
        }
        .padding(.horizontal, 30)
    }
}
```

### Adapted BetFree Login Screen

Here's how we adapt it using our "Serene Recovery" color scheme:

```swift
import SwiftUI

struct BFLoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 25) {
            // Header with Deep Teal text
            Text("Welcome Back")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(BFColors.textPrimary)
            
            // Supportive message for recovery context
            Text("Continue your recovery journey")
                .font(.subheadline)
                .foregroundColor(BFColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
            // Email field with new styling
            TextField("Email", text: $email)
                .padding()
                .background(BFColors.cardBackground)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(BFColors.divider, lineWidth: 1)
                )
                .foregroundColor(BFColors.textPrimary)
            
            // Password field with new styling
            SecureField("Password", text: $password)
                .padding()
                .background(BFColors.cardBackground)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(BFColors.divider, lineWidth: 1)
                )
                .foregroundColor(BFColors.textPrimary)
            
            // Primary button with Sunset Orange
            Button(action: {
                viewModel.login(email: email, password: password)
            }) {
                Text("Log In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(BFColors.accentGradient())
                    .cornerRadius(10)
                    .shadow(color: BFColors.accent.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            
            // Secondary action with Deep Teal
            Button(action: {
                // Handle password reset
            }) {
                Text("Forgot Password?")
                    .foregroundColor(BFColors.primary)
            }
            .padding(.top, 10)
            
            // Additional recovery-focused option
            Button(action: {
                // Navigate to help resources
            }) {
                HStack {
                    Image(systemName: "hand.raised.fill")
                        .font(.system(size: 14))
                    Text("Need immediate support?")
                        .font(.system(size: 14))
                }
                .foregroundColor(BFColors.secondary)
                .padding(.top, 20)
            }
        }
        .padding(.horizontal, 30)
        .background(BFColors.background)
    }
}
```

## Onboarding Screen Example

### Original SwiftShip Onboarding

Simplified version of a SwiftShip onboarding screen:

```swift
struct OnboardingPageView: View {
    let title: String
    let description: String
    let imageName: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding(.bottom, 50)
            
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color.appTheme.textColor)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
            Text(description)
                .font(.system(size: 17))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding(.top, 100)
    }
}
```

### Adapted BetFree Onboarding

Adapted to our new color scheme and recovery focus:

```swift
struct BFOnboardingPageView: View {
    let title: String
    let description: String
    let imageName: String
    let theme: AppState.AppTheme
    
    var body: some View {
        VStack {
            // Image with subtle animation
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding(.bottom, 30)
                .shadow(color: BFColors.primary.opacity(0.2), radius: 10, x: 0, y: 5)
            
            // Title with Deep Teal text
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(BFColors.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
            // Description with calming sage undertones
            Text(description)
                .font(.system(size: 17))
                .foregroundColor(BFColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .lineSpacing(5)
            
            // Add a subtle themed element based on content
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(BFColors.themeGradient(for: theme).opacity(0.15))
                    .frame(height: 60)
                    .padding(.horizontal, 40)
                    .padding(.top, 30)
                
                Text(themeMessage(for: theme))
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(themeColor(for: theme))
                    .padding(.top, 30)
            }
            
            Spacer()
        }
        .padding(.top, 80)
        .background(BFColors.background)
    }
    
    // Helper functions for themed elements
    private func themeMessage(for theme: AppState.AppTheme) -> String {
        switch theme {
        case .standard:
            return "Take each day as it comes"
        case .calm:
            return "Find peace in the present moment"
        case .focus:
            return "Stay focused on your recovery goals"
        case .hope:
            return "Every step forward is progress"
        }
    }
    
    private func themeColor(for theme: AppState.AppTheme) -> Color {
        switch theme {
        case .standard:
            return BFColors.primary
        case .calm:
            return BFColors.calm
        case .focus:
            return BFColors.focus
        case .hope:
            return BFColors.hope
        }
    }
}
```

## Settings Component Example

### Original SwiftShip Settings Component

Simplified version of a SwiftShip settings menu element:

```swift
struct MenuElement: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color.appTheme.primaryColor)
                    .frame(width: 30, height: 30)
                
                Text(title)
                    .foregroundColor(Color.appTheme.textColor)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 12)
        }
    }
}
```

### Adapted BetFree Settings Component

Adapted to our new color scheme:

```swift
struct BFMenuElement: View {
    let title: String
    let icon: String
    let description: String? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                // Icon with more refined styling
                ZStack {
                    Circle()
                        .fill(BFColors.primary.opacity(0.1))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(BFColors.primary)
                }
                
                // Vertical stack for title and optional description
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(BFColors.textPrimary)
                    
                    if let description = description {
                        Text(description)
                            .font(.system(size: 13))
                            .foregroundColor(BFColors.textSecondary)
                    }
                }
                
                Spacer()
                
                // Subtle chevron with new styling
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(BFColors.textTertiary)
            }
            .padding(.vertical, 10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Example of a recovery-specific setting component
struct BFGoalSettingElement: View {
    @Binding var dailyGoal: Int
    let minimum: Int = 5
    let maximum: Int = 60
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Daily Mindfulness Goal")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(BFColors.textPrimary)
            
            Text("Set a realistic daily goal for mindfulness practice")
                .font(.system(size: 13))
                .foregroundColor(BFColors.textSecondary)
            
            // Custom slider using the adapted SwiftShip slider component
            HStack {
                Text("\(minimum) min")
                    .font(.system(size: 12))
                    .foregroundColor(BFColors.textTertiary)
                
                Slider(value: Binding(
                    get: { Double(dailyGoal) },
                    set: { dailyGoal = Int($0) }
                ), in: Double(minimum)...Double(maximum), step: 5)
                .accentColor(BFColors.secondary)
                
                Text("\(maximum) min")
                    .font(.system(size: 12))
                    .foregroundColor(BFColors.textTertiary)
            }
            
            // Selected value indicator
            Text("\(dailyGoal) minutes per day")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(BFColors.primary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 5)
        }
        .padding()
        .background(BFColors.cardBackground)
        .cornerRadius(12)
    }
}
```

## Button Component Example

### Original SwiftShip Button Style

Simplified version of SwiftShip's default button:

```swift
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? Color.appTheme.primaryColor.opacity(0.8) : Color.appTheme.primaryColor)
            .cornerRadius(10)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
```

### Adapted BetFree Button Styles

Adapted using our "Serene Recovery" color scheme:

```swift
struct BFPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                configuration.isPressed ? 
                    BFColors.accent.opacity(0.8) : 
                    BFColors.accentGradient()
            )
            .cornerRadius(10)
            .shadow(
                color: BFColors.accent.opacity(configuration.isPressed ? 0.1 : 0.3), 
                radius: configuration.isPressed ? 2 : 5, 
                x: 0, 
                y: configuration.isPressed ? 1 : 3
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct BFSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(BFColors.primary)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(BFColors.background)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(BFColors.primary, lineWidth: 1.5)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct BFTertiaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(BFColors.primary)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(
                configuration.isPressed ? 
                    BFColors.primary.opacity(0.1) : 
                    Color.clear
            )
            .cornerRadius(8)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// Button usage examples
struct BFButtonExamples: View {
    var body: some View {
        VStack(spacing: 20) {
            Button("Continue") {
                print("Primary action")
            }
            .buttonStyle(BFPrimaryButtonStyle())
            
            Button("Not Now") {
                print("Secondary action")
            }
            .buttonStyle(BFSecondaryButtonStyle())
            
            Button("Learn More") {
                print("Tertiary action")
            }
            .buttonStyle(BFTertiaryButtonStyle())
            
            // Recovery-specific action button
            Button(action: {
                print("Need support")
            }) {
                HStack {
                    Image(systemName: "hand.raised.fill")
                    Text("I Need Support Now")
                }
            }
            .buttonStyle(BFPrimaryButtonStyle())
            
            // Calm-themed button for meditation features
            Button(action: {
                print("Start meditation")
            }) {
                HStack {
                    Image(systemName: "brain.head.profile")
                    Text("Start Meditation")
                }
            }
            .foregroundColor(.white)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(BFColors.calmingGradient())
            .cornerRadius(10)
            .shadow(color: BFColors.calm.opacity(0.3), radius: 5, x: 0, y: 3)
        }
        .padding()
        .background(BFColors.background)
    }
}
```

## Next Steps

These examples demonstrate how to adapt SwiftShip components to use the new "Serene Recovery" color scheme. When implementing the integration plan, follow these patterns to:

1. **Maintain Functionality**: Preserve the core functionality of SwiftShip components
2. **Apply Consistent Styling**: Use BFColors for all visual elements
3. **Enhance for Recovery**: Add recovery-specific content and features
4. **Optimize Interactions**: Refine animations and feedback for a calming experience

The next steps in the implementation process should be:

1. Create the necessary color assets in Assets.xcassets
2. Implement the BFColors extension in the project
3. Begin adapting the highest-priority components (authentication and onboarding)
4. Test each component for visual consistency and proper functionality 