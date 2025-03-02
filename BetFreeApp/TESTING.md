# Testing the "Serene Recovery" Color Scheme

This document provides instructions for testing the "Serene Recovery" color scheme in Xcode and the simulator.

## Prerequisites

- Xcode 14.0 or later
- iOS 15.0 or later simulator
- macOS 12.0 or later

## Opening the Project

1. Navigate to the BetFreeApp directory
2. Open the `Package.swift` file in Xcode:
   ```bash
   cd BetFreeApp
   xed .
   ```
   Alternatively, you can open Xcode, select "Open..." from the File menu, and navigate to the `Package.swift` file.

## Running the Sample App

1. Once Xcode opens the package, select the "BetFreeApp" scheme from the scheme selector
2. Choose an iOS simulator (e.g., iPhone 13)
3. Click the Run button or press Cmd+R

The sample app will launch in the simulator, showcasing the "Serene Recovery" color scheme components.

## Testing in Dark Mode

To test the color scheme in dark mode:

1. While the simulator is running, go to Settings > Display & Brightness
2. Select "Dark" mode
3. Return to the app to see how the colors adapt to dark mode

## Testing Components

The sample app includes the following sections for testing:

### Color Palette

View all the colors in the "Serene Recovery" color scheme, including:
- Primary colors (Deep Teal, Soft Sage, Sunset Orange)
- Theme colors (Calm Teal, Focus Sage, Warm Sand)
- Functional colors (Success Green, Warning Amber, Error Red)

### Buttons

Test different button styles:
- Primary (Deep Teal background)
- Secondary (Soft Sage background)
- Tertiary (Text-only with Deep Teal color)
- Destructive (Error Red background)
- Buttons with icons in leading and trailing positions

### Cards

Test different card configurations:
- Standard card with title and subtitle
- Card with accent color
- Selectable card with tap action
- Card with footer

## Next Steps

After testing the components, you can:

1. Integrate the package into your existing project
2. Modify the components to better fit your needs
3. Extend the color scheme with additional colors if needed

## Troubleshooting

If you encounter issues:

- **Colors not showing correctly**: Check that the color definitions in `BFColors.swift` are correct
- **Components not displaying**: Verify that you're importing the `BetFreeApp` module
- **Build errors**: Ensure you're using a compatible version of Xcode and Swift 