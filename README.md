# BetFree

A comprehensive iOS application focused on gambling addiction recovery through personalized behavior tracking, progress visualization, and professional resources.

## Quick Start

1. Clone the repository
2. Open `BetFreeApp/BetFreeApp.xcodeproj` in Xcode
3. Wait for package dependencies to resolve
4. Build and run (⌘ + R)

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.9+
- macOS 13.0+ (for development)

## Features

### Core Features
- Personalized onboarding with free trial
- Progress tracking dashboard
- Professional resources
- Profile management

### Onboarding Experience
- Multi-step feature introduction
- Profile personalization
- Goal setting
- 7-day free trial
- Subscription management

### Dashboard Features
- Emergency help access
- Progress visualization
- Daily goals tracking
- Quick action grid
- Motivational messages

## Development

See [Technical Documentation](docs/TECHNICAL.md) for detailed development information.

### Testing Onboarding
To force the onboarding flow for testing:
```swift
UserDefaults.standard.set(false, forKey: "isOnboarded")
```

## Current Status

✅ Working Features:
- Project structure
- Package dependencies
- Enhanced onboarding flow
- Dashboard UI
- Design system

🚧 In Progress:
- Subscription integration
- Resource content
- Profile features

## Version History

### v0.1.3 (Current)
- Enhanced onboarding with feature showcase
- Added free trial and subscription flow
- Improved dashboard UI/UX

### v0.1.2
- Enhanced Dashboard UI with progress tracking
- Added emergency help button
- Implemented quick actions

### v0.1.1
- Fixed navigation and state initialization
- Improved app architecture

### v0.1.0
- Initial project setup
- Basic navigation structure
- Design system implementation 