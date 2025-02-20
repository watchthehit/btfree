# BetFree

A comprehensive iOS application focused on gambling addiction recovery through personalized behavior tracking, progress visualization, and professional resources.

## Features

### Core Features
- Personalized onboarding with free trial
- Progress tracking dashboard
- Professional resources
- Profile management
- Transaction tracking
- Achievement system
- Craving management

### Technical Features
- SwiftUI-based UI
- Core Data persistence
- Composable Architecture integration
- Cross-platform support (iOS/macOS)
- Modular architecture
- Comprehensive test coverage

## Requirements

- iOS 16.0+
- macOS 13.0+
- Xcode 14.0+
- Swift 5.9+

## Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/BetFree.git
cd BetFree
```

2. Open the project
```bash
open Package.swift
```

3. Build and run

## Architecture

The project follows a modular architecture with the following main components:

- `BetFree`: Main application module
- `BetFreeUI`: UI components and design system
- `BetFreeModels`: Shared models and business logic

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

## Contributing

1. Create a feature branch
2. Commit your changes
3. Push to the branch
4. Create a Pull Request

## License

This project is private and confidential. All rights reserved.