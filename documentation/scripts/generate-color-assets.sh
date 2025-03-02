#!/bin/bash

# ==========================================
# Color Asset Generator for BetFree App
# ==========================================
# 
# This script generates Xcode color assets based on the color definitions
# in the ColorScheme.md documentation file.
#
# USAGE:
#   cd /Users/bh/Desktop/project
#   ./documentation/scripts/generate-color-assets.sh
#
# IMPORTANT FILE PATHS:
# - Color definitions source: documentation/ColorScheme.md
# - Output directory: BetFreeApp/BetFreeApp/Assets.xcassets/Colors
# - Swift color implementation: BetFreeApp/BetFreeApp/BetFreeApp/BetFreeApp/BFColors.swift
#
# After running this script:
# 1. Check the generated assets in Xcode
# 2. Consider clearing DerivedData with: rm -rf ~/Library/Developer/Xcode/DerivedData
# 3. Build and test the app to ensure colors appear correctly
#
# ==========================================

# Set directories
COLOR_ASSETS_DIR="BetFreeApp/BetFreeApp/Assets.xcassets/Colors"
DOCS_FILE="documentation/ColorScheme.md"

# Create directories if they don't exist
mkdir -p "$COLOR_ASSETS_DIR"

# Create Contents.json for the Colors folder if it doesn't exist
if [ ! -f "$COLOR_ASSETS_DIR/Contents.json" ]; then
    cat > "$COLOR_ASSETS_DIR/Contents.json" << EOF
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF
    echo "Created Contents.json for Colors folder"
fi

# Create a template for colorset Contents.json
create_colorset_template() {
    local name=$1
    local light_hex=$2
    local dark_hex=$3
    local dir="$COLOR_ASSETS_DIR/$name.colorset"
    
    # Default to light hex if dark not provided
    if [ -z "$dark_hex" ]; then
        dark_hex=$light_hex
    fi
    
    # Convert hex to RGB
    local light_r=$(hex_to_rgb $light_hex "r")
    local light_g=$(hex_to_rgb $light_hex "g")
    local light_b=$(hex_to_rgb $light_hex "b")
    
    local dark_r=$(hex_to_rgb $dark_hex "r")
    local dark_g=$(hex_to_rgb $dark_hex "g")
    local dark_b=$(hex_to_rgb $dark_hex "b")
    
    mkdir -p "$dir"
    
    cat > "$dir/Contents.json" << EOF
{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "$light_b",
          "green" : "$light_g",
          "red" : "$light_r"
        }
      },
      "idiom" : "universal"
    },
    {
      "appearances" : [
        {
          "appearance" : "luminosity",
          "value" : "dark"
        }
      ],
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "$dark_b",
          "green" : "$dark_g",
          "red" : "$dark_r"
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

    echo "Created $name.colorset"
}

# Function to convert hex to RGB decimal (0-1 range)
hex_to_rgb() {
    local hex=$1
    local component=$2
    
    # Remove # if present
    hex=${hex/#\#/}
    
    # Extract r, g, b components
    local r=${hex:0:2}
    local g=${hex:2:2}
    local b=${hex:4:2}
    
    # Convert hex to decimal (0-255)
    r=$((16#$r))
    g=$((16#$g))
    b=$((16#$b))
    
    # Convert to 0-1 range and round to 3 decimal places
    local r_decimal=$(printf "%.3f" $(echo "$r/255" | bc -l))
    local g_decimal=$(printf "%.3f" $(echo "$g/255" | bc -l))
    local b_decimal=$(printf "%.3f" $(echo "$b/255" | bc -l))
    
    # Return requested component
    case $component in
        "r") echo $r_decimal ;;
        "g") echo $g_decimal ;;
        "b") echo $b_decimal ;;
    esac
}

# Process color definitions from the documentation
process_color_section() {
    local section_name=$1
    local color_name
    local light_hex
    local dark_hex
    
    # Process primary palette
    echo "Processing $section_name colors..."
    local in_section=0
    
    # Read the documentation file line by line
    while IFS= read -r line; do
        # Check if we're in the target section
        if [[ $line == "## $section_name" ]]; then
            in_section=1
            continue
        fi
        
        # Check if we've moved to another section
        if [[ $in_section -eq 1 && $line == "## "* ]]; then
            in_section=0
            break
        fi
        
        # Process color definitions within the section
        if [[ $in_section -eq 1 && $line == "### "* ]]; then
            # Extract color name and hex code
            color_name=$(echo "$line" | sed -E 's/### ([^(]+).*/\1/' | sed 's/ //g')
            light_hex=$(echo "$line" | grep -o '#[0-9A-Fa-f]\{6\}')
            
            # Reset dark_hex for new color
            dark_hex=""
            
            echo "Found color: $color_name with light mode: $light_hex"
        fi
        
        # Look for light/dark mode specific colors
        if [[ $in_section -eq 1 && -n "$color_name" && $line == "- Light Mode: "* ]]; then
            light_hex=$(echo "$line" | grep -o '#[0-9A-Fa-f]\{6\}')
            echo "  Light mode: $light_hex"
        fi
        
        if [[ $in_section -eq 1 && -n "$color_name" && $line == "- Dark Mode: "* ]]; then
            dark_hex=$(echo "$line" | grep -o '#[0-9A-Fa-f]\{6\}')
            echo "  Dark mode: $dark_hex"
            
            # Create the colorset after we have both light and dark values
            if [[ -n "$color_name" && -n "$light_hex" ]]; then
                create_colorset_template "$color_name" "$light_hex" "$dark_hex"
                color_name=""
                light_hex=""
                dark_hex=""
            fi
        fi
        
        # If we have a color name and light hex but no explicit dark mode defined
        # Create the colorset with light hex for both modes (when section changes)
        if [[ $in_section -eq 0 && -n "$color_name" && -n "$light_hex" ]]; then
            create_colorset_template "$color_name" "$light_hex" "$dark_hex"
            color_name=""
            light_hex=""
        fi
        
    done < "$DOCS_FILE"
    
    # Create color asset for any remaining color at the end of the section
    if [[ -n "$color_name" && -n "$light_hex" ]]; then
        create_colorset_template "$color_name" "$light_hex" "$dark_hex"
    fi
}

echo "Generating color assets based on documentation..."

# Process each color section
process_color_section "Primary Palette"
process_color_section "Functional Colors"
process_color_section "Theme Colors"
process_color_section "Neutral Colors"

echo "Color asset generation complete!"
echo "Generated color assets can be found in: $COLOR_ASSETS_DIR"
echo "Remember to refresh Xcode and clear DerivedData for changes to take effect"
echo "Implement these colors in BetFreeApp/BetFreeApp/BetFreeApp/BetFreeApp/BFColors.swift" 