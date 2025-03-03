# BetFree App Accessibility Guidelines

## Color Contrast Standards

### WCAG Compliance Targets
- **AA Level Compliance (Minimum)**
  - Regular text: 4.5:1 contrast ratio minimum
  - Large text (18pt+ or 14pt+ bold): 3:1 contrast ratio minimum
  - UI components and graphical objects: 3:1 contrast ratio minimum

- **AAA Level Compliance (Enhanced)**
  - Regular text: 7:1 contrast ratio minimum
  - Large text (18pt+ or 14pt+ bold): 4.5:1 contrast ratio minimum

### Color Palette Guidelines
- Primary color palettes have been updated to ensure sufficient contrast:
  - Primary blue now uses: `#0D1B2A` (light mode), `#1B263B` (dark mode)
  - Secondary teal now uses: `#00B2A9` (light mode), `#00A896` (dark mode)
  - Accent coral now uses: `#E94E34` (light mode), `#E74C3C` (dark mode)

- Text colors have been optimized:
  - Primary text: `#0D1B2A` (light), `#FFFFFF` (dark)
  - Secondary text: `#1B263B` (light), `#E0E0E0` (dark)
  - Tertiary text: `#505F79` (light), `#BDBDBD` (dark)

### Best Practices Implemented
1. **Avoid Transparency for Text**: Reduced or eliminated opacity values in text that reduce contrast
2. **Text On Gradients**: Added semi-transparent backgrounds behind text on gradient backgrounds
3. **Button States**: Ensured disabled states maintain sufficient contrast
4. **Interactive Elements**: All interactive elements maintain a minimum 3:1 contrast ratio

## Typography Best Practices

### Dynamic Type Support
- Replaced hardcoded font sizes with SwiftUI's dynamic type:
  - `.largeTitle` instead of `.system(size: 30, weight: .bold)`
  - `.headline` instead of `.system(size: 18, weight: .semibold)`
  - `.subheadline` instead of `.system(size: 16, weight: .medium)`

### Text Styling Guidelines
- Use a limited set of text styles for consistency
- Maintain proper hierarchy through font weights rather than size alone
- Avoid all-caps text except for very short labels
- Ensure line height (leading) is at least 1.5x the font size

## General Accessibility Improvements

### Semantic Elements
- Added proper accessibility traits:
  - `.accessibilityAddTraits(.isHeader)` for headings
  - `.accessibilityLabel()` for buttons with icons

### Motion & Animation
- Respect reduced motion preferences:
  - Check `@Environment(\.accessibilityReduceMotion)` before animations
  - Provide static alternatives to animations

### Focus States
- Ensure all interactive elements have clear focus states

## Testing Protocol

### Manual Testing
1. Test with system text size increased to largest setting
2. Enable VoiceOver and navigate all screens
3. Enable Reduced Motion and verify animations are appropriate

### Automated Testing
1. Use Accessibility Inspector in Xcode
2. Verify color contrast with digital color meter
3. Run accessibility audit with WAVE or similar tools for web components

## Future Improvements

1. Implement Voice Control compatibility
2. Add alternative text for all images and icons
3. Ensure all animations can be paused
4. Create high contrast theme option

## Resources

- [Apple Accessibility Guidelines](https://developer.apple.com/design/human-interface-guidelines/accessibility)
- [WCAG 2.1 Guidelines](https://www.w3.org/TR/WCAG21/)
- [Color Contrast Checker](https://webaim.org/resources/contrastchecker/) 