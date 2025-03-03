# Color Extension Refactoring Plan

## Current Problem

The codebase has multiple implementations of the `Color(hex:)` initializer across at least three files:
1. `./BetFreeApp/BetFreeApp/ColorExtensions.swift`
2. `./BetFreeApp/BetFreeApp/BetFreeApp/BetFreeApp/ColorExtensions.swift`
3. `./BetFreeApp/Assets/ColorExtension.swift`

This duplication causes compiler errors when multiple implementations are imported, resulting in "invalid redeclaration" errors.

## Solution

### Step 1: Consolidate Color Extensions

Create a single source of truth for all Color extensions in `./BetFreeApp/BetFreeApp/BetFreeApp/BetFreeApp/BFColorUtilities.swift`:

```swift
import SwiftUI

// MARK: - Color Hex Initializer
public extension Color {
    /// Initializes a Color with a hex string (e.g., "#FF5500")
    /// - Parameter hex: Hex string in format "#RRGGBB" or "#RRGGBBAA"
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// Converts a Color to a hex string
    func toHex() -> String {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return "#000000"
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if a != Float(1.0) {
            return String(format: "#%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
    // Additional color utility methods can be added here
}

// MARK: - ShapeStyle Extension
public extension ShapeStyle where Self == Color {
    /// Creates a Color from a hex string
    static func hex(_ hex: String) -> Color {
        Color(hex: hex)
    }
}
```

### Step 2: Remove Duplicate Implementations

1. Add comments to the old files pointing to the new consolidated file:

```swift
// DEPRECATED: Please use BFColorUtilities.swift instead
// This file will be removed in a future update
import SwiftUI

// Forwarding to the new implementation
extension Color {
    @available(*, deprecated, message: "Please use the implementation in BFColorUtilities.swift")
    init(hex: String) {
        self = Color(hex: hex)
    }
}
```

2. Update imports across the project to reference the new utilities file.

### Step 3: Update BFColors.swift

Ensure that `BFColors.swift` uses the color extensions from the new consolidated file:

```swift
import SwiftUI
import BFColorUtilities  // New import
```

### Step 4: Globally Implement Color Best Practices

1. Add documentation in the project README about color usage
2. Set up lint rules to prevent direct color instantiation in views
3. Create a CONTRIBUTING.md guide explaining the color system

## Implementation Timeline

1. Create the consolidated utilities file
2. Fix immediate compiler errors in `BFPaywallScreens.swift`
3. Gradually update imports in the codebase
4. Set up deprecation warnings for old utilities
5. Remove duplicates after ensuring all code references the new utility 