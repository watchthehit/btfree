# BetFreeApp Developer Guide

## Project Structure

The BetFreeApp project has a somewhat complex directory structure with nested folders. Always ensure you're working with the correct files to avoid confusion.

### Key File Paths

#### Core Files

- **Project Location**: `/Users/bh/Desktop/project/BetFreeApp/BetFreeApp/BetFreeApp.xcodeproj`
- **Main App Directory**: `/Users/bh/Desktop/project/BetFreeApp/BetFreeApp/BetFreeApp/BetFreeApp/`

#### UI Components

- **Enhanced Onboarding**: `BetFreeApp/BetFreeApp/BetFreeApp/BetFreeApp/EnhancedOnboardingView.swift`
  - ✅ UPDATED: Duplicate files have been removed from the project

#### Style and Color Files

- **BFColors**: `BetFreeApp/BetFreeApp/BetFreeApp/BetFreeApp/BFColors.swift`
  - ✅ UPDATED: Duplicate files have been removed from the project
- **Color Assets**: `BetFreeApp/BetFreeApp/Assets.xcassets/Colors/`

#### Documentation and Scripts

- **Documentation**: `documentation/`
- **Color Scheme Documentation**: `documentation/ColorScheme.md`
- **Color Generation Script**: `documentation/scripts/generate-color-assets.sh`

## Clean Project Structure

On March 2, 2024, we cleaned up the project structure by removing duplicate files:
- Removed: `BetFreeApp/BetFreeApp/EnhancedOnboardingView.swift`
- Removed: `BetFreeApp/BetFreeApp/BFColors.swift`
- Removed: `BetFreeApp/Sources/BetFreeApp/BFColors.swift`

This ensures that there is only one copy of each file in the project, reducing confusion and making it easier to maintain the codebase.

## Building the App

### From Command Line

```bash
cd /Users/bh/Desktop/project/BetFreeApp/BetFreeApp/BetFreeApp
xcodebuild -scheme BetFreeApp -destination "platform=iOS Simulator,name=iPhone 16" clean build
```

### From Xcode

1. Open `/Users/bh/Desktop/project/BetFreeApp/BetFreeApp/BetFreeApp.xcodeproj`
2. Select the iPhone 16 simulator (or other available device)
3. Build with Cmd+B or Run with Cmd+R

## Working with Colors

The app uses the "Serene Recovery" color scheme as defined in `documentation/ColorScheme.md`. 

### Color System

The application currently uses two color systems:

1. **BFColors** (`BetFreeApp/Assets/BFColors.swift`): The primary color system with full light/dark mode support.
2. **BFTheme** (`BetFreeApp/BetFreeApp/BetFreeApp/BetFreeApp/BFTheme.swift`): A compatibility layer that provides a bridge to the BFColors system.

#### Migration Strategy

We are gradually migrating all code to use the BFColors system directly. The BFTheme system provides a compatibility layer during this transition.

- **New components** should use `BFColors` directly.
- **Existing components** can continue to use `BFTheme` until they are refactored.

### Updating Colors

1. Edit color definitions in `documentation/ColorScheme.md`
2. Run the color asset generation script:
   ```bash
   cd /Users/bh/Desktop/project
   ./documentation/scripts/generate-color-assets.sh
   ```
3. Edit the color definitions in `BetFreeApp/Assets/BFColors.swift` to match
4. Clear Xcode's DerivedData:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
5. Rebuild and test the app

### Using Colors in Swift

```swift
// UIKit
view.backgroundColor = BFTheme.background

// SwiftUI with BFTheme (legacy components)
Text("Hello")
    .foregroundColor(BFTheme.neutralLight)
    .background(BFTheme.cardBackground)

// SwiftUI with BFColors (preferred for new components)
Text("Hello")
    .foregroundColor(BFColors.textPrimary)
    .background(BFColors.cardBackground)
```

## Troubleshooting

### Wrong File Edits Not Showing Up

If your edits don't appear in the app:

1. Ensure you're editing the correct file path (refer to Key File Paths section)
2. Clear DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData`
3. Clean the build: In Xcode, use Shift+Cmd+K or `xcodebuild clean`
4. Restart Xcode
5. Rebuild the app

### No More Duplicate Files

The duplicate files issue has been resolved. The project now has only one copy of each source file, located in the paths specified in this guide.

## Best Practices

1. **Always reference this guide** before making changes
2. **Document your changes** in the appropriate documentation file
3. **Use BFColors** rather than hardcoded color values
4. **Test in both light and dark mode**
5. **Clear DerivedData** when facing caching issues
6. **Commit both code and documentation** changes together
7. **Avoid creating duplicate files** in the project 