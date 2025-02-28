# BetFree App

## Overview
BetFree is a SwiftUI app designed to help users develop a healthier relationship with gambling by tracking triggers, managing cravings, and building positive habits.

## Features
- Enhanced onboarding flow with 8 comprehensive screens
- Personal goal setting and tracking
- Trigger identification and management
- Craving reporting and analysis
- Customizable notification preferences
- Privacy-focused design with local data storage

## Technical Details
- Built with SwiftUI
- MVVM architecture
- Supports iOS 15.0 and above
- Uses @MainActor for thread safety

## Getting Started
1. Clone the repository
2. Open the BetFreeApp.xcodeproj file in Xcode
3. Build and run the app on a simulator or device

## Onboarding Flow
The app includes a comprehensive onboarding flow with the following screens:
1. Welcome
2. Name Input
3. Goal Setting
4. Trigger Selection
5. Notification Setup
6. Feature Overview
7. Privacy Information
8. Completion

## State Management
The app uses a central AppState object as the single source of truth, which is passed through the view hierarchy using the @EnvironmentObject property wrapper.

## Future Enhancements
- Data visualization for craving patterns
- Expanded mindfulness exercises
- Community support features
- Achievement badges and rewards system 