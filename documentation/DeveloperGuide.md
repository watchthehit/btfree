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

## Color Systems

The BetFree app uses a modern, semantic color system called `BFColors` that provides:

- ✅ Semantic and functional color naming (e.g., `textPrimary`, `background`, `success`)
- ✅ Automatic light/dark mode adaptation
- ✅ Consistent color palette across the entire app
- ✅ Gradient generators for common UI patterns
- ✅ Opacity and tint variations

### Migration Status

The migration from the legacy `BFTheme` system to `BFColors` is now complete:

- ✅ All Priority 1, 2, and 3 components have been migrated
- ✅ All typography has been migrated to the new `BFTypography` system
- ✅ The legacy `BFTheme` system has been removed

### Typography System

The app uses a dedicated typography system called `BFTypography` that provides:

- Consistent text styles across the app
- Size variations for different contexts
- Semantic naming (title, headline, body, caption, button)
- Convenience modifiers for SwiftUI Text components

### Updating Colors

If you need to edit color definitions, see `documentation/ColorScheme.md` for details.

## Typography System

The application now uses a dedicated typography system:

**BFTypography** (`BetFreeApp/Assets/BFTypography.swift`): A consistent typography system for all text elements, featuring:
- Standard font styles (title, headline, body, caption, button)
- Size customization for each style
- Rounded design for a friendly user experience
- Convenience SwiftUI text modifiers with appropriate colors

### Using Typography in Swift

```swift
// Basic font usage
Text("Headline")
    .font(BFTypography.headline())
    
// With custom size
Text("Large Title")
    .font(BFTypography.title(32))
    
// Using convenience modifiers (includes appropriate colors)
Text("Body Text").bodyStyle()
Text("Caption").captionStyle()
Text("Button Text").buttonStyle()

// Custom size with convenience modifier
Text("Custom Headline").headlineStyle(22)
```

### Using Colors in Swift

```swift
// UIKit
view.backgroundColor = BFColors.background

// SwiftUI with BFColors
Text("Hello")
    .foregroundColor(BFColors.textPrimary)
    .background(BFColors.cardBackground)

// Using gradients
Rectangle()
    .fill(BFColors.brandGradient())
    
// Using color with opacity
Circle()
    .stroke(BFColors.primary.opacity(0.2))
    
// Using semantic colors for states
Button("Save") {
    // action
}
.foregroundColor(isEnabled ? BFColors.primary : BFColors.textTertiary)
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