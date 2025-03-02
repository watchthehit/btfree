#!/bin/bash
# update-bfcolors.sh
#
# This script updates the BFColors.swift file to use the new Serene Recovery color scheme
# defined in our documentation and color assets. It maintains custom functions while
# updating the color definitions.

# Configuration
BFCOLORS_FILE="BetFreeApp/BetFreeApp/BFColors.swift"
BACKUP_FILE="${BFCOLORS_FILE}.bak"
DOCS_FILE="documentation/ColorScheme.md"

# Create backup of original file
echo "Creating backup of BFColors.swift..."
cp "$BFCOLORS_FILE" "$BACKUP_FILE"

# Extract color names from Assets.xcassets
echo "Finding color assets..."
COLOR_ASSETS=$(find "BetFreeApp/BetFreeApp/Assets.xcassets/Colors" -name "*.colorset" | sort)

if [ -z "$COLOR_ASSETS" ]; then
  echo "No color assets found. Please run generate-color-assets.sh first."
  exit 1
fi

# Generate new file header
echo "Generating new BFColors.swift file..."
cat > "$BFCOLORS_FILE" << EOL
//
//  BFColors.swift
//  BetFreeApp
//
//  Generated by update-bfcolors.sh - DO NOT EDIT DIRECTLY
//  Color scheme: "Serene Recovery"
//

import SwiftUI

/// BFColors provides a centralized access point for all color values in the app.
/// The color scheme is based on the "Serene Recovery" palette, designed to create
/// a calming, supportive environment for users on their recovery journey.
public struct BFColors {
    
    // MARK: - Primary Colors
    
    /// Deep Teal - A calming, deep teal that conveys stability and trust
    public static var primary: Color {
        Color("Primary")
    }
    
    /// Soft Sage - A gentle, natural green representing growth and healing
    public static var secondary: Color {
        Color("Secondary")
    }
    
    /// Sunset Orange - A warm, energetic accent
    public static var accent: Color {
        Color("Accent")
    }
    
    // MARK: - Theme Colors
    
    /// Calm Teal - Lighter teal for calm states
    public static var calm: Color {
        Color("Calm")
    }
    
    /// Focus Sage - Muted sage for focus states
    public static var focus: Color {
        Color("Focus")
    }
    
    /// Warm Sand - Warm, grounding neutral
    public static var hope: Color {
        Color("Hope")
    }
    
    // MARK: - Functional Colors
    
    /// Success Green - Sage-tinted green for success states
    public static var success: Color {
        Color("Success")
    }
    
    /// Warning Amber - Warm amber that complements the palette
    public static var warning: Color {
        Color("Warning")
    }
    
    /// Error Red - Muted red that fits with overall palette
    public static var error: Color {
        Color("Error")
    }
    
    // MARK: - Neutral Colors
    
    /// Main app background - Sand in light mode, Dark Charcoal in dark mode
    public static var background: Color {
        Color("Background")
    }
    
    /// Card backgrounds - White in light mode, Charcoal in dark mode
    public static var cardBackground: Color {
        Color("CardBackground")
    }
    
    /// Primary text - Dark Charcoal in light mode, Sand in dark mode
    public static var textPrimary: Color {
        Color("TextPrimary")
    }
    
    /// Secondary text - Medium Gray with blue undertones
    public static var textSecondary: Color {
        Color("TextSecondary")
    }
    
    /// Tertiary text - Light Gray with blue undertones
    public static var textTertiary: Color {
        Color("TextTertiary")
    }
    
    /// Dividers and borders
    public static var divider: Color {
        Color("Divider")
    }
    
    // MARK: - Gradients
    
    /// Progress Gradient - Deep Teal to Soft Sage
    public static func progressGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [BFColors.primary, BFColors.secondary.opacity(0.8)]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    /// Calming Gradient - Calm Teal variations
    public static func calmingGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [BFColors.calm.opacity(0.6), BFColors.calm]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// Accent Gradient - Sunset Orange variations
    public static func accentGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [BFColors.accent.opacity(0.9), BFColors.accent]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Focus Gradient - Focus Sage variations
    public static func focusGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [BFColors.focus.opacity(0.7), BFColors.focus]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// Hope Gradient - Warm Sand variations
    public static func hopeGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [BFColors.hope.opacity(0.6), BFColors.hope]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// Returns a gradient based on the app theme
    public static func themeGradient(for theme: AppState.AppTheme) -> LinearGradient {
        switch theme {
        case .standard:
            return progressGradient()
        case .calm:
            return calmingGradient()
        case .focus:
            return focusGradient()
        case .hope:
            return hopeGradient()
        }
    }
    
    // MARK: - Helpers
    
    /// Creates a gradient with specified colors
    public static func gradient(colors: [Color], startPoint: UnitPoint = .leading, endPoint: UnitPoint = .trailing) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
    
    /// Returns a dynamic color that responds to light/dark mode changes
    public static func dynamicColor(light: Color, dark: Color) -> Color {
        Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
EOL

# Check if the original file has custom extensions or initializers
# Extract anything after the last static property or method
CUSTOM_EXTENSIONS=$(awk '/\/\/ MARK: - Helpers/,/^}/' "$BACKUP_FILE" | tail -n +2)

# Check if there's any custom code in the original file we should preserve
if grep -q "init(hex:" "$BACKUP_FILE"; then
    # Extract the hex initializer and append to the file
    echo "Preserving hex initializer..."
    cat >> "$BFCOLORS_FILE" << EOL
    
    // MARK: - Color Extensions
    
EOL

    # Extract the hex initializer
    awk '/extension Color/,/^}/' "$BACKUP_FILE" >> "$BFCOLORS_FILE"
else
    # Add a default hex initializer
    cat >> "$BFCOLORS_FILE" << EOL
    
    // MARK: - Color Extensions
    
    /// Extension to create colors from hex values
    extension Color {
        /// Initialize a Color from a hex string
        /// - Parameter hex: A hex string in the format "#RRGGBB" or "RRGGBB"
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
                (a, r, g, b) = (1, 1, 1, 0)
            }
            self.init(
                .sRGB,
                red: Double(r) / 255,
                green: Double(g) / 255,
                blue: Double(b) / 255,
                opacity: Double(a) / 255
            )
        }
    }
EOL
fi

# Close the struct
echo "}" >> "$BFCOLORS_FILE"

echo "BFColors.swift has been updated successfully."
echo "Original file backed up to $BACKUP_FILE" 