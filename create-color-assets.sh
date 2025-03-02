#!/bin/bash
# Simple script to create color assets for Xcode

# Ensure the directory exists
mkdir -p BetFreeApp/BetFreeApp/Assets.xcassets/Colors

# Create Contents.json for the Colors folder
cat > BetFreeApp/BetFreeApp/Assets.xcassets/Colors/Contents.json << EOF
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Function to create a color asset
create_color_asset() {
  local name=$1
  local light_r=$2
  local light_g=$3
  local light_b=$4
  local dark_r=$5
  local dark_g=$6
  local dark_b=$7
  
  # Create directory for the color asset
  local asset_dir="BetFreeApp/BetFreeApp/Assets.xcassets/Colors/${name}.colorset"
  mkdir -p "$asset_dir"
  
  # Create Contents.json
  cat > "$asset_dir/Contents.json" << EOF
{
  "colors" : [
    {
      "idiom" : "universal",
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "red" : "${light_r}",
          "green" : "${light_g}",
          "blue" : "${light_b}",
          "alpha" : "1.000"
        }
      }
    },
    {
      "idiom" : "universal",
      "appearances" : [
        {
          "appearance" : "luminosity",
          "value" : "dark"
        }
      ],
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "red" : "${dark_r}",
          "green" : "${dark_g}",
          "blue" : "${dark_b}",
          "alpha" : "1.000"
        }
      }
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

  echo "Created color asset: ${name}.colorset"
}

echo "Creating color assets for Serene Recovery color scheme..."

# Primary Colors
create_color_asset "Primary" "0.165" "0.420" "0.486" "0.227" "0.490" "0.557"
create_color_asset "Secondary" "0.537" "0.702" "0.600" "0.478" "0.639" "0.541"
create_color_asset "Accent" "0.902" "0.494" "0.325" "0.949" "0.541" "0.373"

# Theme Colors
create_color_asset "Calm" "0.290" "0.553" "0.616" "0.353" "0.620" "0.682"
create_color_asset "Focus" "0.463" "0.612" "0.525" "0.525" "0.678" "0.588"
create_color_asset "Hope" "0.902" "0.788" "0.659" "0.969" "0.855" "0.725"

# Neutral Colors
create_color_asset "Background" "0.969" "0.953" "0.922" "0.110" "0.122" "0.180"
create_color_asset "CardBackground" "1.000" "1.000" "1.000" "0.176" "0.192" "0.259"
create_color_asset "TextPrimary" "0.176" "0.192" "0.259" "0.969" "0.953" "0.922"
create_color_asset "TextSecondary" "0.361" "0.376" "0.475" "0.710" "0.729" "0.788"
create_color_asset "TextTertiary" "0.463" "0.482" "0.569" "0.616" "0.639" "0.718"
create_color_asset "Divider" "0.882" "0.886" "0.910" "0.239" "0.259" "0.349"

# Functional Colors
create_color_asset "Success" "0.298" "0.686" "0.314" "0.365" "0.749" "0.380"
create_color_asset "Warning" "1.000" "0.596" "0.000" "1.000" "0.718" "0.302"
create_color_asset "Error" "0.957" "0.263" "0.212" "1.000" "0.322" "0.322"

echo "Color assets creation completed!"
echo "Total assets created: 15"
echo "Assets available in: BetFreeApp/BetFreeApp/Assets.xcassets/Colors/" 