# BetFree Developer Tools

This directory contains tools and examples to help developers implement UI standardization across the BetFree app.

## Contents

### 1. Component Showcase

`BFComponentShowcase.swift` is an interactive catalog of all standardized UI components available in the BetFree app. It allows developers to:

- Browse all components by category
- See usage examples
- View code snippets
- Understand guidelines for proper usage

To use the showcase:
1. Run the app in development mode
2. Navigate to the Developer Tools section
3. Select "Component Showcase"

### 2. Screen Migration Example

`ScreenMigrationExample.swift` demonstrates how to migrate an existing screen from using direct SwiftUI components to the standardized BetFree design system. It provides:

- Side-by-side before/after comparisons
- Code diffs showing what changed
- Detailed examples of each component type

### 3. UI Audit Script

A shell script located at `../Scripts/ui_audit.sh` that analyzes your codebase for non-standardized UI elements. It identifies:

- Direct color usage
- Direct font sizing
- Hardcoded spacing values
- Non-standardized components
- Files with the most standardization issues

To run the audit:
```bash
cd BetFreeApp/BetFreeApp/BetFreeApp/BetFreeApp/Scripts
chmod +x ui_audit.sh
./ui_audit.sh
```

### 4. CI Integration

A GitHub Actions workflow located at `BetFreeApp/.github/workflows/ui-standardization-check.yml` that automatically runs the UI audit on each pull request. It:

- Checks for UI standardization issues
- Posts a comment with results
- Fails the build if too many issues are found

## Usage Guidelines

### When to Use These Tools

- **During Development**: Use the Component Showcase to understand what components are available
- **During Refactoring**: Use the Screen Migration Example to guide your refactoring efforts
- **During Code Review**: Run the UI Audit Script to check your changes for standardization issues
- **During CI/CD**: Let the GitHub Action automatically check PRs for standardization issues

### Integration with Regular Workflow

These tools are designed to be integrated into your regular development workflow:

1. **Start by Browsing**: Use the Component Showcase to understand what's available
2. **Follow Examples**: Refer to the Screen Migration Example when building new screens
3. **Verify Changes**: Run the UI Audit Script locally before submitting your PR
4. **Review CI Results**: Check the GitHub Action results on your PR

## Important Notes

- These tools are intended for **DEVELOPMENT ONLY** and should not be included in production builds
- The UI standardization system is detailed in the `/Documentation/UIStandardization.md` file
- The migration guide is available at `/Documentation/UIStandardizationMigrationGuide.md`

## Adding New Components

When adding new standardized components:

1. Add them to the `BFStandardizedComponents.swift` file
2. Update the Component Showcase with examples
3. Document usage guidelines
4. Add appropriate test cases

## Questions & Support

Please direct any questions about these tools to the UI/UX team lead. 