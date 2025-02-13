# BetFree Documentation

## Overview
BetFree is a comprehensive iOS application designed to help users overcome gambling addiction through progress tracking, goal setting, and personalized support.

## Documentation Structure

### Technical Documentation
- [Technical Overview](TECHNICAL.md) - Complete technical implementation details
- [Paywall Implementation](PAYWALL.md) - Subscription and monetization system

### Features
1. **Core Features**
   - Progress Tracking
   - Goal Setting
   - Daily Check-ins
   - Achievement System

2. **User Experience**
   - Onboarding Flow
   - Dashboard Interface
   - Resource Center
   - Profile Management

3. **Monetization**
   - Subscription Plans
   - Feature Gating
   - Trial System
   - Restore Purchases

### Architecture
1. **Design System**
   ```swift
   BFDesignSystem
   ├── Colors
   ├── Typography
   ├── Layout
   └── Components
   ```

2. **Core Architecture**
   ```
   BetFree
   ├── Core
   │   ├── State
   │   ├── Design
   │   └── Services
   └── Features
       ├── Onboarding
       ├── Dashboard
       ├── Progress
       └── Profile
   ```

### Quick Links
- [Getting Started](#getting-started)
- [Installation](#installation)
- [Contributing](#contributing)
- [Support](#support)

## Getting Started

### Prerequisites
- Xcode 14.0+
- iOS 16.0+
- Swift 5.9+
- macOS 13.0+ (for development)

### Installation
1. Clone the repository
2. Open `BetFreeApp/BetFreeApp.xcodeproj`
3. Wait for package resolution
4. Build and run

### Development Setup
```bash
# Clone repository
git clone https://github.com/yourusername/betfree.git

# Navigate to project
cd betfree

# Open in Xcode
xed .
```

## Contributing

### Development Process
1. Fork the repository
2. Create feature branch
3. Implement changes
4. Submit pull request

### Code Style
- Follow SwiftUI best practices
- Use Swift style guide
- Implement proper documentation
- Include unit tests

### Testing
- Run unit tests
- Verify UI on different devices
- Check accessibility support
- Test dark/light modes

## Support

### Resources
- GitHub Issues
- Documentation
- Stack Overflow
- Developer Portal

### Contact
- Technical Support: support@betfree.com
- Bug Reports: bugs@betfree.com
- Feature Requests: features@betfree.com

## Version History

### Current Version (1.0.0)
- Initial release
- Core features implemented
- Basic subscription system
- Achievement tracking

### Planned Updates
- Enhanced analytics
- Additional achievements
- Community features
- Advanced statistics

## License
Copyright © 2024 BetFree. All rights reserved. 