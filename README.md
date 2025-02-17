# BetFree

A comprehensive iOS application focused on gambling addiction recovery through personalized behavior tracking, progress visualization, and professional resources.

## Quick Start

1. Clone the repository
2. Open `BetFree.xcworkspace` in Xcode
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
- Transaction tracking
- Achievement system

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
- Transaction history
- Achievement tracking

## Development

See [Technical Documentation](docs/TECHNICAL.md) for detailed development information.

### Core Data Model
The app uses Core Data for persistent storage with three main entities:

#### UserProfile Entity
- `id`: UUID (required)
- `name`: String (required)
- `email`: String (optional)
- `streak`: Int32 (required)
- `totalSavings`: Double (required)
- `dailyLimit`: Double (required)
- `lastCheckIn`: Date (optional)

#### Transaction Entity
- `id`: UUID (required)
- `amount`: Double (required)
- `date`: Date (required)
- `note`: String (optional)
- `category`: String (optional)

#### Craving Entity
- `id`: UUID (required)
- `intensity`: Int32 (required)
- `triggers`: String (optional)
- `strategies`: String (optional)
- `timestamp`: Date (required)
- `duration`: Int32 (required)

### Testing Onboarding
To force the onboarding flow for testing:
```swift
UserDefaults.standard.set(false, forKey: "isOnboarded")
```

## Current Status

 Working Features:
- Project structure
- Package dependencies
- Enhanced onboarding flow
- Dashboard UI
- Cross-platform compatibility (iOS/macOS)
- Standard SwiftUI styling
- Core Data integration
- Transaction tracking
- Achievement system
- Craving management system
- User profile management
- Consistent data type handling

 In Progress:
- Subscription integration
- Resource content
- Analytics integration
- Accessibility improvements

## Version History

### v0.1.8 (Current)
- Fixed Core Data model registration and initialization
- Standardized Core Data model naming across app
- Improved Core Data error handling and logging
- Enhanced model bundle loading mechanism
- Fixed CravingEntity persistence issues
- Updated technical documentation

### v0.1.7
- Fixed type consistency in Craving duration handling
- Standardized UserProfile parameter ordering
- Enhanced MockCDManager implementation
- Improved Core Data manager consistency
- Added comprehensive craving management
- Fixed transaction mapping in dashboard

### v0.1.6
- Resolved ResourcesView redeclaration issue
- Enhanced Settings module documentation
- Improved crisis support accessibility
- Standardized email handling in ContactView
- Updated technical documentation

### v0.1.5
- Improved cross-platform compatibility
- Migrated to standard SwiftUI styling
- Fixed sheet presentation on macOS
- Enhanced form handling
- Improved progress indicators
- Fixed compilation issues

### v0.1.4
- Fixed Core Data entity initialization
- Added transaction tracking
- Implemented achievement system
- Improved data persistence

### v0.1.3
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