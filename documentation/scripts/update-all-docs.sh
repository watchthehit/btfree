#!/bin/bash
# update-all-docs.sh
#
# Main script to update all documentation and keep implementation files in sync.
# This script coordinates the execution of various documentation and implementation scripts.

set -e # Exit on any error

# Configuration
SCRIPTS_DIR="$(dirname "$0")"
DOC_DIR="documentation"
PROJECT_ROOT="BetFreeApp"

# Make sure all scripts are executable
chmod +x "$SCRIPTS_DIR"/*.sh

# Start with a message
echo "=========================================="
echo "Starting comprehensive documentation update"
echo "=========================================="
echo ""

# Step 1: Generate color assets from documentation
echo "[1/6] Generating color assets from documentation..."
"$SCRIPTS_DIR/generate-color-assets.sh"
echo "Color assets generation complete"
echo ""

# Step 2: Update BFColors.swift to use the color assets
echo "[2/6] Updating BFColors.swift with new color references..."
"$SCRIPTS_DIR/update-bfcolors.sh"
echo "BFColors.swift update complete"
echo ""

# Step 3: Validate documentation examples
echo "[3/6] Validating code examples in documentation..."
if [ -f "$SCRIPTS_DIR/validate-code-examples.sh" ]; then
    "$SCRIPTS_DIR/validate-code-examples.sh"
else
    echo "Creating validate-code-examples.sh script..."
    cat > "$SCRIPTS_DIR/validate-code-examples.sh" << 'EOL'
#!/bin/bash
# validate-code-examples.sh
#
# This script validates that Swift code examples in documentation files are valid and compile.

set -e

echo "Finding Swift code examples in documentation..."
find documentation -name "*.md" -type f | while read -r doc_file; do
    echo "Checking $doc_file..."
    
    # Create a temporary Swift file with all code examples
    TMP_FILE=$(mktemp /tmp/swift-doc-XXXXXX.swift)
    
    # Add import statements to the top of the file
    echo "import SwiftUI" > "$TMP_FILE"
    echo "import Foundation" >> "$TMP_FILE"
    echo "" >> "$TMP_FILE"
    
    # Define a mock AppState for validating code that uses it
    echo "enum AppState { enum AppTheme { case standard, calm, focus, hope } }" >> "$TMP_FILE"
    echo "" >> "$TMP_FILE"
    
    # Extract Swift code blocks
    CODE_BLOCKS=$(awk '/```swift/{flag=1;next}/```/{flag=0}flag' "$doc_file")
    
    if [ -n "$CODE_BLOCKS" ]; then
        # Wrap each code block in a function to avoid name conflicts
        BLOCK_COUNT=1
        echo "$CODE_BLOCKS" | while read -r line; do
            if [[ $line == struct* || $line == class* || $line == enum* || $line == extension* ]]; then
                echo "$line" >> "$TMP_FILE"
            else
                echo "func _exampleCode$BLOCK_COUNT() {" >> "$TMP_FILE"
                echo "    $line" >> "$TMP_FILE"
                echo "}" >> "$TMP_FILE"
                BLOCK_COUNT=$((BLOCK_COUNT + 1))
            fi
        done
        
        # Try to compile the Swift file
        if swift -syntax-only "$TMP_FILE" 2>/dev/null; then
            echo "✅ All code examples in $doc_file are valid Swift code"
        else
            echo "❌ Code examples in $doc_file contain syntax errors"
            echo "Details:"
            swift -syntax-only "$TMP_FILE"
            exit 1
        fi
    else
        echo "No Swift code examples found in $doc_file"
    fi
    
    rm "$TMP_FILE"
done

echo "All code examples validated successfully"
EOL
    chmod +x "$SCRIPTS_DIR/validate-code-examples.sh"
    "$SCRIPTS_DIR/validate-code-examples.sh"
fi
echo "Code example validation complete"
echo ""

# Step 4: Generate visual aids for documentation
echo "[4/6] Generating visual aids for documentation..."
if [ -f "$SCRIPTS_DIR/generate-visuals.sh" ]; then
    "$SCRIPTS_DIR/generate-visuals.sh"
else
    echo "Creating generate-visuals.sh script..."
    mkdir -p "$DOC_DIR/Resources/Images"
    
    cat > "$SCRIPTS_DIR/generate-visuals.sh" << 'EOL'
#!/bin/bash
# generate-visuals.sh
#
# This script generates visual aids for documentation, including color palette visualizations.

set -e

DOC_RESOURCES="documentation/Resources/Images"
mkdir -p "$DOC_RESOURCES"

echo "Generating color palette visualization..."

# Create a color palette HTML file
HTML_FILE="$DOC_RESOURCES/color-palette.html"

cat > "$HTML_FILE" << HTML
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Serene Recovery Color Palette</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        h1 {
            color: #2A6B7C;
            text-align: center;
        }
        .color-section {
            margin-bottom: 40px;
        }
        .color-row {
            display: flex;
            margin-bottom: 10px;
        }
        .color-cell {
            flex: 1;
            height: 80px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: white;
            text-shadow: 0 0 2px rgba(0,0,0,0.5);
            border-radius: 5px;
            margin: 0 5px;
        }
        .dark-cell {
            color: #FFFFFF;
        }
        .light-cell {
            color: #2D3142;
            text-shadow: none;
        }
        .color-name {
            font-weight: bold;
        }
        .color-hex {
            font-family: monospace;
            font-size: 12px;
        }
        .modes {
            display: flex;
            margin-bottom: 20px;
        }
        .mode {
            flex: 1;
            text-align: center;
            padding: 10px;
            border-radius: 5px;
            margin: 0 5px;
            cursor: pointer;
        }
        .mode.active {
            background-color: #2A6B7C;
            color: white;
        }
        .mode:not(.active) {
            background-color: #F7F3EB;
            color: #2D3142;
        }
        #dark-mode-palette {
            display: none;
        }
    </style>
</head>
<body>
    <h1>Serene Recovery Color Palette</h1>
    
    <div class="modes">
        <div class="mode active" onclick="showMode('light')">Light Mode</div>
        <div class="mode" onclick="showMode('dark')">Dark Mode</div>
    </div>
    
    <div id="light-mode-palette">
        <div class="color-section">
            <h2>Primary Colors</h2>
            <div class="color-row">
                <div class="color-cell" style="background-color: #2A6B7C;">
                    <div class="color-name">Deep Teal</div>
                    <div class="color-hex">#2A6B7C</div>
                </div>
                <div class="color-cell" style="background-color: #89B399;">
                    <div class="color-name">Soft Sage</div>
                    <div class="color-hex">#89B399</div>
                </div>
                <div class="color-cell" style="background-color: #E67E53;">
                    <div class="color-name">Sunset Orange</div>
                    <div class="color-hex">#E67E53</div>
                </div>
            </div>
        </div>
        
        <div class="color-section">
            <h2>Theme Colors</h2>
            <div class="color-row">
                <div class="color-cell" style="background-color: #4A8D9D;">
                    <div class="color-name">Calm Teal</div>
                    <div class="color-hex">#4A8D9D</div>
                </div>
                <div class="color-cell" style="background-color: #769C86;">
                    <div class="color-name">Focus Sage</div>
                    <div class="color-hex">#769C86</div>
                </div>
                <div class="color-cell" style="background-color: #E6C9A8;">
                    <div class="color-name light-cell">Warm Sand</div>
                    <div class="color-hex light-cell">#E6C9A8</div>
                </div>
            </div>
        </div>
        
        <div class="color-section">
            <h2>Functional Colors</h2>
            <div class="color-row">
                <div class="color-cell" style="background-color: #4CAF50;">
                    <div class="color-name">Success</div>
                    <div class="color-hex">#4CAF50</div>
                </div>
                <div class="color-cell" style="background-color: #FF9800;">
                    <div class="color-name">Warning</div>
                    <div class="color-hex">#FF9800</div>
                </div>
                <div class="color-cell" style="background-color: #F44336;">
                    <div class="color-name">Error</div>
                    <div class="color-hex">#F44336</div>
                </div>
            </div>
        </div>
        
        <div class="color-section">
            <h2>Neutral Colors</h2>
            <div class="color-row">
                <div class="color-cell light-cell" style="background-color: #F7F3EB;">
                    <div class="color-name">Background</div>
                    <div class="color-hex">#F7F3EB</div>
                </div>
                <div class="color-cell light-cell" style="background-color: #FFFFFF; border: 1px solid #E5E7EB;">
                    <div class="color-name">Card Background</div>
                    <div class="color-hex">#FFFFFF</div>
                </div>
                <div class="color-cell" style="background-color: #2D3142;">
                    <div class="color-name">Text Primary</div>
                    <div class="color-hex">#2D3142</div>
                </div>
                <div class="color-cell" style="background-color: #5C6079;">
                    <div class="color-name">Text Secondary</div>
                    <div class="color-hex">#5C6079</div>
                </div>
                <div class="color-cell light-cell" style="background-color: #E5E7EB;">
                    <div class="color-name">Divider</div>
                    <div class="color-hex">#E5E7EB</div>
                </div>
            </div>
        </div>
    </div>
    
    <div id="dark-mode-palette">
        <div class="color-section">
            <h2>Primary Colors</h2>
            <div class="color-row">
                <div class="color-cell" style="background-color: #3A7D8E;">
                    <div class="color-name">Deep Teal</div>
                    <div class="color-hex">#3A7D8E</div>
                </div>
                <div class="color-cell" style="background-color: #7AA38A;">
                    <div class="color-name">Soft Sage</div>
                    <div class="color-hex">#7AA38A</div>
                </div>
                <div class="color-cell" style="background-color: #F28A5F;">
                    <div class="color-name">Sunset Orange</div>
                    <div class="color-hex">#F28A5F</div>
                </div>
            </div>
        </div>
        
        <div class="color-section">
            <h2>Theme Colors</h2>
            <div class="color-row">
                <div class="color-cell" style="background-color: #5A9EAE;">
                    <div class="color-name">Calm Teal</div>
                    <div class="color-hex">#5A9EAE</div>
                </div>
                <div class="color-cell" style="background-color: #86AD96;">
                    <div class="color-name">Focus Sage</div>
                    <div class="color-hex">#86AD96</div>
                </div>
                <div class="color-cell light-cell" style="background-color: #F7DAB9;">
                    <div class="color-name">Warm Sand</div>
                    <div class="color-hex">#F7DAB9</div>
                </div>
            </div>
        </div>
        
        <div class="color-section">
            <h2>Functional Colors</h2>
            <div class="color-row">
                <div class="color-cell" style="background-color: #5DBF61;">
                    <div class="color-name">Success</div>
                    <div class="color-hex">#5DBF61</div>
                </div>
                <div class="color-cell light-cell" style="background-color: #FFB74D;">
                    <div class="color-name">Warning</div>
                    <div class="color-hex">#FFB74D</div>
                </div>
                <div class="color-cell" style="background-color: #FF5252;">
                    <div class="color-name">Error</div>
                    <div class="color-hex">#FF5252</div>
                </div>
            </div>
        </div>
        
        <div class="color-section">
            <h2>Neutral Colors</h2>
            <div class="color-row">
                <div class="color-cell" style="background-color: #1C1F2E;">
                    <div class="color-name">Background</div>
                    <div class="color-hex">#1C1F2E</div>
                </div>
                <div class="color-cell" style="background-color: #2D3142;">
                    <div class="color-name">Card Background</div>
                    <div class="color-hex">#2D3142</div>
                </div>
                <div class="color-cell light-cell" style="background-color: #F7F3EB;">
                    <div class="color-name">Text Primary</div>
                    <div class="color-hex">#F7F3EB</div>
                </div>
                <div class="color-cell light-cell" style="background-color: #B5BAC9;">
                    <div class="color-name">Text Secondary</div>
                    <div class="color-hex">#B5BAC9</div>
                </div>
                <div class="color-cell" style="background-color: #3D4259;">
                    <div class="color-name">Divider</div>
                    <div class="color-hex">#3D4259</div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function showMode(mode) {
            const lightPalette = document.getElementById('light-mode-palette');
            const darkPalette = document.getElementById('dark-mode-palette');
            const modes = document.querySelectorAll('.mode');
            
            if (mode === 'light') {
                lightPalette.style.display = 'block';
                darkPalette.style.display = 'none';
                modes[0].classList.add('active');
                modes[1].classList.remove('active');
            } else {
                lightPalette.style.display = 'none';
                darkPalette.style.display = 'block';
                modes[0].classList.remove('active');
                modes[1].classList.add('active');
            }
        }
    </script>
</body>
</html>
HTML

echo "Created color palette visualization: $HTML_FILE"
echo "Converting HTML to PNG for documentation embedding..."

if command -v wkhtmltoimage &> /dev/null; then
    wkhtmltoimage "$HTML_FILE" "${DOC_RESOURCES}/color-palette-light.png"
    wkhtmltoimage --javascript-delay 1000 "$HTML_FILE" "${DOC_RESOURCES}/color-palette-dark.png"
    echo "PNG images generated successfully."
else
    echo "wkhtmltoimage not found. Install it to generate PNG images automatically."
    echo "For now, open the HTML file in a browser and take screenshots."
fi

# Update the color scheme document to include the images
COLOR_SCHEME_DOC="documentation/ColorScheme.md"
if [ -f "$COLOR_SCHEME_DOC" ]; then
    if ! grep -q "## Visual Representation" "$COLOR_SCHEME_DOC"; then
        echo "" >> "$COLOR_SCHEME_DOC"
        echo "## Visual Representation" >> "$COLOR_SCHEME_DOC"
        echo "" >> "$COLOR_SCHEME_DOC"
        echo "### Light Mode" >> "$COLOR_SCHEME_DOC"
        echo "" >> "$COLOR_SCHEME_DOC"
        echo "![Light Mode Color Palette](Resources/Images/color-palette-light.png)" >> "$COLOR_SCHEME_DOC"
        echo "" >> "$COLOR_SCHEME_DOC"
        echo "### Dark Mode" >> "$COLOR_SCHEME_DOC"
        echo "" >> "$COLOR_SCHEME_DOC"
        echo "![Dark Mode Color Palette](Resources/Images/color-palette-dark.png)" >> "$COLOR_SCHEME_DOC"
        echo "" >> "$COLOR_SCHEME_DOC"
        echo "Added visual representations to the color scheme documentation."
    fi
fi

echo "Visual aids generation complete"
EOL
    chmod +x "$SCRIPTS_DIR/generate-visuals.sh"
    "$SCRIPTS_DIR/generate-visuals.sh"
fi
echo "Visual aids generation complete"
echo ""

# Step 5: Update Swift documentation comments
echo "[5/6] Updating Swift documentation comments..."
if [ -f "$SCRIPTS_DIR/update-swift-docs.sh" ]; then
    "$SCRIPTS_DIR/update-swift-docs.sh"
else
    echo "Creating update-swift-docs.sh script..."
    cat > "$SCRIPTS_DIR/update-swift-docs.sh" << 'EOL'
#!/bin/bash
# update-swift-docs.sh
#
# This script updates documentation comments in Swift files to ensure they match
# the implementation and follow a consistent format.

set -e

# Find Swift files that might need documentation updates
echo "Finding Swift files to check for documentation updates..."

# Focus on BFColors.swift first since it's the most important for our color scheme
BFCOLORS_FILE="BetFreeApp/BetFreeApp/BFColors.swift"

if [ -f "$BFCOLORS_FILE" ]; then
    echo "Checking $BFCOLORS_FILE for documentation completeness..."
    
    # Count properties and methods
    PROPERTY_COUNT=$(grep -c "public static var" "$BFCOLORS_FILE" || echo 0)
    METHOD_COUNT=$(grep -c "public static func" "$BFCOLORS_FILE" || echo 0)
    
    # Count doc comments
    DOC_COMMENT_COUNT=$(grep -c "///" "$BFCOLORS_FILE" || echo 0)
    
    echo "Found $PROPERTY_COUNT properties and $METHOD_COUNT methods"
    echo "Found $DOC_COMMENT_COUNT documentation comments"
    
    # Simple check - every property and method should have a doc comment
    EXPECTED_DOCS=$((PROPERTY_COUNT + METHOD_COUNT))
    if [ "$DOC_COMMENT_COUNT" -lt "$EXPECTED_DOCS" ]; then
        echo "⚠️ Warning: Some properties or methods may be missing documentation"
        echo "Expected at least $EXPECTED_DOCS doc comments, found $DOC_COMMENT_COUNT"
    else
        echo "✅ Documentation seems complete for BFColors.swift"
    fi
fi

# Check UI components that might need updating based on our new color scheme
COMPONENTS_DIR="BetFreeApp/BetFreeApp/Components"
if [ -d "$COMPONENTS_DIR" ]; then
    echo "Checking UI component files for color usage documentation..."
    
    find "$COMPONENTS_DIR" -name "*.swift" | while read -r component_file; do
        COMPONENT_NAME=$(basename "$component_file" .swift)
        echo "Checking $COMPONENT_NAME..."
        
        # Count BFColors usage
        COLOR_USAGE_COUNT=$(grep -c "BFColors" "$component_file" || echo 0)
        
        # Count color-related doc comments
        COLOR_DOC_COUNT=$(grep -c -E "/// (Color|Theme|Style)" "$component_file" || echo 0)
        
        if [ "$COLOR_USAGE_COUNT" -gt 0 ] && [ "$COLOR_DOC_COUNT" -eq 0 ]; then
            echo "⚠️ Warning: $COMPONENT_NAME uses colors but may lack color documentation"
        elif [ "$COLOR_USAGE_COUNT" -gt 0 ]; then
            echo "✅ $COMPONENT_NAME has color usage and documentation"
        else
            echo "ℹ️ $COMPONENT_NAME doesn't appear to use BFColors"
        fi
    done
fi

echo "Swift documentation check complete"
EOL
    chmod +x "$SCRIPTS_DIR/update-swift-docs.sh"
    "$SCRIPTS_DIR/update-swift-docs.sh"
fi
echo "Swift documentation update complete"
echo ""

# Step 6: Generate technical documentation
echo "[6/6] Generating technical documentation..."
if [ -f "$SCRIPTS_DIR/generate-technical-docs.sh" ]; then
    "$SCRIPTS_DIR/generate-technical-docs.sh"
else
    echo "Creating generate-technical-docs.sh script..."
    cat > "$SCRIPTS_DIR/generate-technical-docs.sh" << 'EOL'
#!/bin/bash
# generate-technical-docs.sh
#
# This script generates technical documentation from Swift source files.

set -e

# Check if jazzy or swift-doc is installed
if command -v jazzy &> /dev/null; then
    echo "Using jazzy to generate API documentation..."
    mkdir -p documentation/API
    
    # Run jazzy on the project
    cd BetFreeApp
    jazzy \
        --output ../documentation/API \
        --min-acl public \
        --swift-build-tool xcodebuild \
        --clean
    cd ..
    
    echo "API documentation generated in documentation/API"
elif command -v swift-doc &> /dev/null; then
    echo "Using swift-doc to generate API documentation..."
    mkdir -p documentation/API
    
    # Run swift-doc on the project
    swift-doc generate BetFreeApp --output documentation/API --format html
    
    echo "API documentation generated in documentation/API"
else
    echo "Neither jazzy nor swift-doc found. Please install one of them to generate API documentation."
    echo "  To install jazzy: gem install jazzy"
    echo "  To install swift-doc: brew install swiftdocorg/formulae/swift-doc"
    
    # Create a placeholder documentation file
    mkdir -p documentation/API
    cat > documentation/API/index.html << HTML
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>BetFree API Documentation</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        h1 {
            color: #2A6B7C;
        }
        .notice {
            background-color: #f8f9fa;
            border-left: 4px solid #2A6B7C;
            padding: 15px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <h1>BetFree API Documentation</h1>
    
    <div class="notice">
        <p><strong>Notice:</strong> Automated API documentation is not available.</p>
        <p>To generate complete API documentation, please install either:</p>
        <ul>
            <li>jazzy: <code>gem install jazzy</code></li>
            <li>swift-doc: <code>brew install swiftdocorg/formulae/swift-doc</code></li>
        </ul>
        <p>Then run the documentation generation script again.</p>
    </div>
    
    <h2>Manual API Overview</h2>
    
    <h3>Core Color Utilities</h3>
    <ul>
        <li><strong>BFColors</strong>: Central color management</li>
    </ul>
    
    <h3>UI Components</h3>
    <ul>
        <li><strong>Buttons</strong>: Styled button components</li>
        <li><strong>Cards</strong>: Card UI components</li>
        <li><strong>Text Styles</strong>: Typography components</li>
    </ul>
</body>
</html>
HTML

    echo "Created placeholder API documentation in documentation/API"
fi

# Generate component list documentation
COMPONENTS_DIR="BetFreeApp/BetFreeApp/Components"
COMPONENT_DOC="documentation/Components.md"

if [ -d "$COMPONENTS_DIR" ]; then
    echo "Generating component list documentation..."
    
    # Create component documentation file header
    cat > "$COMPONENT_DOC" << 'MD'
# BetFree UI Components

This document provides an overview of the available UI components in the BetFree app, highlighting their usage with the "Serene Recovery" color scheme.

## Table of Contents

MD
    
    # Add each component to the Table of Contents
    find "$COMPONENTS_DIR" -name "*.swift" | sort | while read -r component_file; do
        COMPONENT_NAME=$(basename "$component_file" .swift)
        echo "- [${COMPONENT_NAME}](#${COMPONENT_NAME})" >> "$COMPONENT_DOC"
    done
    
    echo "" >> "$COMPONENT_DOC"
    
    # Add each component section
    find "$COMPONENTS_DIR" -name "*.swift" | sort | while read -r component_file; do
        COMPONENT_NAME=$(basename "$component_file" .swift)
        echo "## ${COMPONENT_NAME}" >> "$COMPONENT_DOC"
        echo "" >> "$COMPONENT_DOC"
        
        # Extract component description from doc comments
        DESCRIPTION=$(grep -A 3 "///" "$component_file" | head -1 | sed 's/\/\/\/ //')
        if [ -n "$DESCRIPTION" ]; then
            echo "$DESCRIPTION" >> "$COMPONENT_DOC"
        else
            echo "A UI component for the BetFree app." >> "$COMPONENT_DOC"
        fi
        echo "" >> "$COMPONENT_DOC"
        
        # Check for usage examples or code snippets
        EXAMPLE=$(awk '/Example usage:/{flag=1;next}/```/{flag=0}flag' "$component_file")
        if [ -n "$EXAMPLE" ]; then
            echo "### Usage" >> "$COMPONENT_DOC"
            echo "" >> "$COMPONENT_DOC"
            echo '```swift' >> "$COMPONENT_DOC"
            echo "$EXAMPLE" >> "$COMPONENT_DOC"
            echo '```' >> "$COMPONENT_DOC"
            echo "" >> "$COMPONENT_DOC"
        fi
        
        # Check for color usage
        if grep -q "BFColors" "$component_file"; then
            echo "### Color Scheme Integration" >> "$COMPONENT_DOC"
            echo "" >> "$COMPONENT_DOC"
            echo "This component uses the following colors from the \"Serene Recovery\" palette:" >> "$COMPONENT_DOC"
            echo "" >> "$COMPONENT_DOC"
            
            # Extract color usage
            grep -o "BFColors\.[a-zA-Z]*" "$component_file" | sort | uniq | while read -r color; do
                COLOR_NAME=$(echo "$color" | sed 's/BFColors\.//')
                echo "- **$COLOR_NAME**" >> "$COMPONENT_DOC"
            done
            echo "" >> "$COMPONENT_DOC"
        fi
        
        # Add a horizontal rule between components
        echo "---" >> "$COMPONENT_DOC"
        echo "" >> "$COMPONENT_DOC"
    done
    
    echo "Component list documentation generated in $COMPONENT_DOC"
fi

echo "Technical documentation generation complete"
EOL
    chmod +x "$SCRIPTS_DIR/generate-technical-docs.sh"
    "$SCRIPTS_DIR/generate-technical-docs.sh"
fi
echo "Technical documentation generation complete"
echo ""

echo "=========================================="
echo "Documentation and implementation update complete!"
echo "=========================================="
echo ""
echo "The following files have been updated:"
echo "- Color assets in Assets.xcassets/Colors"
echo "- BFColors.swift with the Serene Recovery palette"
echo "- Documentation files in the documentation directory"
echo ""
echo "Next steps:"
echo "1. Review the updated documentation"
echo "2. Check the color assets in Xcode"
echo "3. Test the updated BFColors implementation"
echo "4. Commit the changes to your repository"
echo ""
echo "To run this update process again, execute:"
echo "./documentation/scripts/update-all-docs.sh" 