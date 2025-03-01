import Foundation
import SwiftUI

// Color definitions for our design system
struct ColorDefinition {
    let name: String
    let lightModeHex: String
    let darkModeHex: String
    let description: String
}

// This is a utility to help create the color asset files
// To use it, copy the JSON output and create the .colorset files manually
struct ColorAssetGenerator {
    static let colors: [ColorDefinition] = [
        // Primary Colors
        ColorDefinition(
            name: "PrimaryColor",
            lightModeHex: "#3B82F6", // Blue
            darkModeHex: "#60A5FA",
            description: "Primary app color for main actions and navigation"
        ),
        ColorDefinition(
            name: "SecondaryColor",
            lightModeHex: "#10B981", // Green
            darkModeHex: "#34D399",
            description: "Secondary color for supporting elements"
        ),
        ColorDefinition(
            name: "AccentColor",
            lightModeHex: "#8B5CF6", // Purple
            darkModeHex: "#A78BFA",
            description: "Accent color for highlights and special elements"
        ),
        
        // Functional Colors
        ColorDefinition(
            name: "SuccessColor",
            lightModeHex: "#10B981", // Green
            darkModeHex: "#34D399",
            description: "Success state color"
        ),
        ColorDefinition(
            name: "WarningColor",
            lightModeHex: "#F59E0B", // Amber
            darkModeHex: "#FBBF24",
            description: "Warning state color"
        ),
        ColorDefinition(
            name: "ErrorColor",
            lightModeHex: "#EF4444", // Red
            darkModeHex: "#F87171",
            description: "Error state color"
        ),
        
        // Theme Colors
        ColorDefinition(
            name: "CalmColor",
            lightModeHex: "#67E8F9", // Cyan
            darkModeHex: "#22D3EE",
            description: "Calming color for relaxation features"
        ),
        ColorDefinition(
            name: "FocusColor",
            lightModeHex: "#A78BFA", // Lavender
            darkModeHex: "#8B5CF6",
            description: "Focus color for concentration features"
        ),
        ColorDefinition(
            name: "HopeColor",
            lightModeHex: "#34D399", // Teal
            darkModeHex: "#10B981",
            description: "Hope color for positive reinforcement"
        ),
        
        // Neutral Colors
        ColorDefinition(
            name: "BackgroundColor",
            lightModeHex: "#FFFFFF", // White
            darkModeHex: "#1F2937",
            description: "Main background color"
        ),
        ColorDefinition(
            name: "CardBackgroundColor",
            lightModeHex: "#F9FAFB", // Off-white
            darkModeHex: "#374151",
            description: "Card and section background color"
        ),
        ColorDefinition(
            name: "TextPrimaryColor",
            lightModeHex: "#1F2937", // Dark gray
            darkModeHex: "#F9FAFB",
            description: "Primary text color"
        ),
        ColorDefinition(
            name: "TextSecondaryColor",
            lightModeHex: "#6B7280", // Medium gray
            darkModeHex: "#D1D5DB",
            description: "Secondary text color"
        ),
        ColorDefinition(
            name: "TextTertiaryColor",
            lightModeHex: "#9CA3AF", // Light gray
            darkModeHex: "#9CA3AF",
            description: "Tertiary text color"
        ),
        ColorDefinition(
            name: "DividerColor",
            lightModeHex: "#E5E7EB", // Very light gray
            darkModeHex: "#4B5563",
            description: "Divider and separator color"
        )
    ]
    
    // Generate the JSON structure for an individual color asset
    static func generateColorAssetJSON(for color: ColorDefinition) -> String {
        """
        {
          "colors" : [
            {
              "color" : {
                "color-space" : "srgb",
                "components" : {
                  "alpha" : "1.000",
                  "blue" : "\(hexToRGB(color.lightModeHex).blue)",
                  "green" : "\(hexToRGB(color.lightModeHex).green)",
                  "red" : "\(hexToRGB(color.lightModeHex).red)"
                }
              },
              "idiom" : "universal",
              "appearances" : [ { "appearance" : "luminosity", "value" : "light" } ]
            },
            {
              "color" : {
                "color-space" : "srgb",
                "components" : {
                  "alpha" : "1.000",
                  "blue" : "\(hexToRGB(color.darkModeHex).blue)",
                  "green" : "\(hexToRGB(color.darkModeHex).green)",
                  "red" : "\(hexToRGB(color.darkModeHex).red)"
                }
              },
              "idiom" : "universal",
              "appearances" : [ { "appearance" : "luminosity", "value" : "dark" } ]
            }
          ],
          "info" : {
            "author" : "xcode",
            "version" : 1
          },
          "properties" : {
            "localizable" : true
          }
        }
        """
    }
    
    // Convert hex string to RGB components
    static func hexToRGB(_ hex: String) -> (red: String, green: String, blue: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        return (
            red: String(format: "%.3f", red),
            green: String(format: "%.3f", green),
            blue: String(format: "%.3f", blue)
        )
    }
    
    // Print instructions for creating all color assets
    static func generateAllColorAssets() {
        for color in colors {
            print("Color: \(color.name)")
            print("Description: \(color.description)")
            print("JSON Content:")
            print(generateColorAssetJSON(for: color))
            print("\n")
        }
    }
}

// Uncomment this line to run the generator in a playground or Xcode preview
// ColorAssetGenerator.generateAllColorAssets() 