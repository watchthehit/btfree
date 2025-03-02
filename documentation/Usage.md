# Documentation Automation System: Usage Guide

This guide explains how to use the documentation automation system for the BetFree app with SwiftShip integration and the "Serene Recovery" color scheme.

## Quick Start

The easiest way to use the system is to run the master update script:

```bash
./documentation/scripts/update-all-docs.sh
```

This script will:
1. Generate color assets from documentation
2. Update BFColors.swift to use the named color assets
3. Validate code examples in documentation
4. Generate visual aids for the color scheme
5. Check documentation comments in Swift files
6. Generate technical documentation

## Individual Scripts

If you need to run a specific part of the automation, you can use the individual scripts:

### 1. Generate Color Assets

```bash
./documentation/scripts/generate-color-assets.sh
```

This script reads the color definitions from `documentation/ColorScheme.md` and creates corresponding color assets in `BetFreeApp/BetFreeApp/Assets.xcassets/Colors/`. Each color includes light and dark mode variants.

### 2. Update BFColors.swift

```bash
./documentation/scripts/update-bfcolors.sh
```

This script updates the `BFColors.swift` file to use the named color assets instead of hard-coded hex values. It preserves any custom functions and extensions while updating the color definitions.

### 3. Validate Code Examples

```bash
./documentation/scripts/validate-code-examples.sh
```

This script extracts Swift code examples from markdown documentation files and validates that they compile correctly. This ensures that your documentation always contains valid, up-to-date code examples.

### 4. Generate Visual Aids

```bash
./documentation/scripts/generate-visuals.sh
```

This script creates visual representations of the color scheme, including HTML pages and PNG images showing the color palette in both light and dark modes.

### 5. Update Swift Documentation Comments

```bash
./documentation/scripts/update-swift-docs.sh
```

This script checks Swift files for proper documentation comments and identifies any missing or incomplete documentation.

### 6. Generate Technical Documentation

```bash
./documentation/scripts/generate-technical-docs.sh
```

This script generates technical API documentation for the project, creating a comprehensive reference guide for developers.

## Customizing the System

### Adding New Colors

1. Update `documentation/ColorScheme.md` with the new color definition
2. Run the update script:
   ```bash
   ./documentation/scripts/update-all-docs.sh
   ```

### Changing Color Values

1. Modify the hex values in `documentation/ColorScheme.md`
2. Run the update script:
   ```bash
   ./documentation/scripts/update-all-docs.sh
   ```

### Adding New Components

1. Create the component in your codebase
2. Add documentation comments to the component file
3. Add example usage in your documentation
4. Run the update script:
   ```bash
   ./documentation/scripts/update-all-docs.sh
   ```

## Integration with Development Workflow

### Git Hooks

You can set up Git hooks to automatically update documentation when relevant files are changed:

1. Create a pre-commit hook:
   ```bash
   mkdir -p .git/hooks
   touch .git/hooks/pre-commit
   chmod +x .git/hooks/pre-commit
   ```

2. Add the following to the pre-commit hook:
   ```bash
   #!/bin/bash
   
   # Check if BFColors.swift was modified
   if git diff --cached --name-only | grep -q "BFColors.swift"; then
     echo "Updating color documentation..."
     ./documentation/scripts/update-all-docs.sh
   fi
   ```

### CI/CD Integration

In your CI/CD pipeline, you can add a step to verify documentation:

```yaml
- name: Validate Documentation
  run: |
    ./documentation/scripts/validate-code-examples.sh
```

## Troubleshooting

### Missing Color Assets

If color assets are missing, check:
1. The ColorScheme.md file for proper formatting
2. That the generate-color-assets.sh script is executable
3. That the Assets.xcassets directory exists

### Script Permission Issues

If you encounter permission issues, ensure all scripts are executable:

```bash
chmod +x documentation/scripts/*.sh
```

### Documentation Validation Errors

If code example validation fails:
1. Check the error message for the specific file and issue
2. Update the code example in the documentation
3. Run the validation script again to verify the fix

## Best Practices

1. **Documentation-First Approach**: Update documentation before implementing code changes
2. **Single Source of Truth**: Keep the ColorScheme.md file as the definitive reference for color definitions
3. **Regular Validation**: Run the validation scripts frequently to catch issues early
4. **Visual Verification**: Use the generated visual aids to verify color combinations and contrast ratios
5. **Comprehensive Documentation**: Document not just color values, but usage guidelines, accessibility considerations, and examples

## Extending the System

This automation system can be extended in several ways:

1. Add new scripts for additional documentation tasks
2. Integrate with design tools to export color schemes directly
3. Add support for typography and spacing documentation
4. Create documentation for animations and transitions
5. Generate interactive component galleries for visual testing

For more information, see the `documentation/DocumentationAutomation.md` file for the complete automation plan.

## Conclusion

The documentation automation system ensures that your code and documentation stay in sync, making it easier to maintain a consistent design system and improve collaboration across teams. 