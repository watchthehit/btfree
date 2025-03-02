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

# Function to create a color asset with light and dark mode variants
create_color_asset() {
  local name=$1
  local light_hex=$2
  local dark_hex=$3
  local light_r=$4
  local light_g=$5
  local light_b=$6
  local dark_r=$7
  local dark_g=$8
  local dark_b=$9
  
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

# Function to convert hex color to RGB values (0-1 range)
hex_to_rgb() {
  local hex=$1
  # Remove # if present
  hex="${hex#\#}"
  
  # Convert hex to RGB (0-255)
  local r=$((16#${hex:0:2}))
  local g=$((16#${hex:2:2}))
  local b=$((16#${hex:4:2}))
  
  # Convert to 0-1 range (rounded to 3 decimal places)
  # Use awk instead of bc for better compatibility
  local r_norm=$(awk "BEGIN { printf \"%.3f\", $r/255 }")
  local g_norm=$(awk "BEGIN { printf \"%.3f\", $g/255 }")
  local b_norm=$(awk "BEGIN { printf \"%.3f\", $b/255 }")
  
  echo "$r_norm $g_norm $b_norm"
}

echo "Creating color assets for Serene Recovery color scheme..."

# Primary Colors
primary_light="#2A6B7C"
primary_dark="#3A7D8E"
primary_light_rgb=$(hex_to_rgb "$primary_light")
primary_dark_rgb=$(hex_to_rgb "$primary_dark")
create_color_asset "Primary" "$primary_light" "$primary_dark" \
  $(echo $primary_light_rgb | awk '{print $1}') \
  $(echo $primary_light_rgb | awk '{print $2}') \
  $(echo $primary_light_rgb | awk '{print $3}') \
  $(echo $primary_dark_rgb | awk '{print $1}') \
  $(echo $primary_dark_rgb | awk '{print $2}') \
  $(echo $primary_dark_rgb | awk '{print $3}')

# Secondary Colors
secondary_light="#89B399"
secondary_dark="#7AA38A"
secondary_light_rgb=$(hex_to_rgb "$secondary_light")
secondary_dark_rgb=$(hex_to_rgb "$secondary_dark")
create_color_asset "Secondary" "$secondary_light" "$secondary_dark" \
  $(echo $secondary_light_rgb | awk '{print $1}') \
  $(echo $secondary_light_rgb | awk '{print $2}') \
  $(echo $secondary_light_rgb | awk '{print $3}') \
  $(echo $secondary_dark_rgb | awk '{print $1}') \
  $(echo $secondary_dark_rgb | awk '{print $2}') \
  $(echo $secondary_dark_rgb | awk '{print $3}')

# Accent Color
accent_light="#E67E53"
accent_dark="#F28A5F"
accent_light_rgb=$(hex_to_rgb "$accent_light")
accent_dark_rgb=$(hex_to_rgb "$accent_dark")
create_color_asset "Accent" "$accent_light" "$accent_dark" \
  $(echo $accent_light_rgb | awk '{print $1}') \
  $(echo $accent_light_rgb | awk '{print $2}') \
  $(echo $accent_light_rgb | awk '{print $3}') \
  $(echo $accent_dark_rgb | awk '{print $1}') \
  $(echo $accent_dark_rgb | awk '{print $2}') \
  $(echo $accent_dark_rgb | awk '{print $3}')

# Theme Colors - Calm
calm_light="#4A8D9D"
calm_dark="#5A9EAE"
calm_light_rgb=$(hex_to_rgb "$calm_light")
calm_dark_rgb=$(hex_to_rgb "$calm_dark")
create_color_asset "Calm" "$calm_light" "$calm_dark" \
  $(echo $calm_light_rgb | awk '{print $1}') \
  $(echo $calm_light_rgb | awk '{print $2}') \
  $(echo $calm_light_rgb | awk '{print $3}') \
  $(echo $calm_dark_rgb | awk '{print $1}') \
  $(echo $calm_dark_rgb | awk '{print $2}') \
  $(echo $calm_dark_rgb | awk '{print $3}')

# Theme Colors - Focus
focus_light="#769C86"
focus_dark="#86AD96"
focus_light_rgb=$(hex_to_rgb "$focus_light")
focus_dark_rgb=$(hex_to_rgb "$focus_dark")
create_color_asset "Focus" "$focus_light" "$focus_dark" \
  $(echo $focus_light_rgb | awk '{print $1}') \
  $(echo $focus_light_rgb | awk '{print $2}') \
  $(echo $focus_light_rgb | awk '{print $3}') \
  $(echo $focus_dark_rgb | awk '{print $1}') \
  $(echo $focus_dark_rgb | awk '{print $2}') \
  $(echo $focus_dark_rgb | awk '{print $3}')

# Theme Colors - Hope
hope_light="#E6C9A8"
hope_dark="#F7DAB9"
hope_light_rgb=$(hex_to_rgb "$hope_light")
hope_dark_rgb=$(hex_to_rgb "$hope_dark")
create_color_asset "Hope" "$hope_light" "$hope_dark" \
  $(echo $hope_light_rgb | awk '{print $1}') \
  $(echo $hope_light_rgb | awk '{print $2}') \
  $(echo $hope_light_rgb | awk '{print $3}') \
  $(echo $hope_dark_rgb | awk '{print $1}') \
  $(echo $hope_dark_rgb | awk '{print $2}') \
  $(echo $hope_dark_rgb | awk '{print $3}')

# Neutral Colors - Background
bg_light="#F7F3EB"
bg_dark="#1C1F2E"
bg_light_rgb=$(hex_to_rgb "$bg_light")
bg_dark_rgb=$(hex_to_rgb "$bg_dark")
create_color_asset "Background" "$bg_light" "$bg_dark" \
  $(echo $bg_light_rgb | awk '{print $1}') \
  $(echo $bg_light_rgb | awk '{print $2}') \
  $(echo $bg_light_rgb | awk '{print $3}') \
  $(echo $bg_dark_rgb | awk '{print $1}') \
  $(echo $bg_dark_rgb | awk '{print $2}') \
  $(echo $bg_dark_rgb | awk '{print $3}')

# Neutral Colors - CardBackground
card_bg_light="#FFFFFF"
card_bg_dark="#2D3142"
card_bg_light_rgb=$(hex_to_rgb "$card_bg_light")
card_bg_dark_rgb=$(hex_to_rgb "$card_bg_dark")
create_color_asset "CardBackground" "$card_bg_light" "$card_bg_dark" \
  $(echo $card_bg_light_rgb | awk '{print $1}') \
  $(echo $card_bg_light_rgb | awk '{print $2}') \
  $(echo $card_bg_light_rgb | awk '{print $3}') \
  $(echo $card_bg_dark_rgb | awk '{print $1}') \
  $(echo $card_bg_dark_rgb | awk '{print $2}') \
  $(echo $card_bg_dark_rgb | awk '{print $3}')

# Neutral Colors - TextPrimary
text_primary_light="#2D3142"
text_primary_dark="#F7F3EB"
text_primary_light_rgb=$(hex_to_rgb "$text_primary_light")
text_primary_dark_rgb=$(hex_to_rgb "$text_primary_dark")
create_color_asset "TextPrimary" "$text_primary_light" "$text_primary_dark" \
  $(echo $text_primary_light_rgb | awk '{print $1}') \
  $(echo $text_primary_light_rgb | awk '{print $2}') \
  $(echo $text_primary_light_rgb | awk '{print $3}') \
  $(echo $text_primary_dark_rgb | awk '{print $1}') \
  $(echo $text_primary_dark_rgb | awk '{print $2}') \
  $(echo $text_primary_dark_rgb | awk '{print $3}')

# Neutral Colors - TextSecondary
text_secondary_light="#5C6079"
text_secondary_dark="#B5BAC9"
text_secondary_light_rgb=$(hex_to_rgb "$text_secondary_light")
text_secondary_dark_rgb=$(hex_to_rgb "$text_secondary_dark")
create_color_asset "TextSecondary" "$text_secondary_light" "$text_secondary_dark" \
  $(echo $text_secondary_light_rgb | awk '{print $1}') \
  $(echo $text_secondary_light_rgb | awk '{print $2}') \
  $(echo $text_secondary_light_rgb | awk '{print $3}') \
  $(echo $text_secondary_dark_rgb | awk '{print $1}') \
  $(echo $text_secondary_dark_rgb | awk '{print $2}') \
  $(echo $text_secondary_dark_rgb | awk '{print $3}')

# Neutral Colors - TextTertiary
text_tertiary_light="#767B91"
text_tertiary_dark="#9DA3B7"
text_tertiary_light_rgb=$(hex_to_rgb "$text_tertiary_light")
text_tertiary_dark_rgb=$(hex_to_rgb "$text_tertiary_dark")
create_color_asset "TextTertiary" "$text_tertiary_light" "$text_tertiary_dark" \
  $(echo $text_tertiary_light_rgb | awk '{print $1}') \
  $(echo $text_tertiary_light_rgb | awk '{print $2}') \
  $(echo $text_tertiary_light_rgb | awk '{print $3}') \
  $(echo $text_tertiary_dark_rgb | awk '{print $1}') \
  $(echo $text_tertiary_dark_rgb | awk '{print $2}') \
  $(echo $text_tertiary_dark_rgb | awk '{print $3}')

# Neutral Colors - Divider
divider_light="#E1E2E8"
divider_dark="#3D4259"
divider_light_rgb=$(hex_to_rgb "$divider_light")
divider_dark_rgb=$(hex_to_rgb "$divider_dark")
create_color_asset "Divider" "$divider_light" "$divider_dark" \
  $(echo $divider_light_rgb | awk '{print $1}') \
  $(echo $divider_light_rgb | awk '{print $2}') \
  $(echo $divider_light_rgb | awk '{print $3}') \
  $(echo $divider_dark_rgb | awk '{print $1}') \
  $(echo $divider_dark_rgb | awk '{print $2}') \
  $(echo $divider_dark_rgb | awk '{print $3}')

# Functional Colors - Success
success_light="#4CAF50"
success_dark="#5DBF61"
success_light_rgb=$(hex_to_rgb "$success_light")
success_dark_rgb=$(hex_to_rgb "$success_dark")
create_color_asset "Success" "$success_light" "$success_dark" \
  $(echo $success_light_rgb | awk '{print $1}') \
  $(echo $success_light_rgb | awk '{print $2}') \
  $(echo $success_light_rgb | awk '{print $3}') \
  $(echo $success_dark_rgb | awk '{print $1}') \
  $(echo $success_dark_rgb | awk '{print $2}') \
  $(echo $success_dark_rgb | awk '{print $3}')

# Functional Colors - Warning
warning_light="#FF9800"
warning_dark="#FFB74D"
warning_light_rgb=$(hex_to_rgb "$warning_light")
warning_dark_rgb=$(hex_to_rgb "$warning_dark")
create_color_asset "Warning" "$warning_light" "$warning_dark" \
  $(echo $warning_light_rgb | awk '{print $1}') \
  $(echo $warning_light_rgb | awk '{print $2}') \
  $(echo $warning_light_rgb | awk '{print $3}') \
  $(echo $warning_dark_rgb | awk '{print $1}') \
  $(echo $warning_dark_rgb | awk '{print $2}') \
  $(echo $warning_dark_rgb | awk '{print $3}')

# Functional Colors - Error
error_light="#F44336"
error_dark="#FF5252"
error_light_rgb=$(hex_to_rgb "$error_light")
error_dark_rgb=$(hex_to_rgb "$error_dark")
create_color_asset "Error" "$error_light" "$error_dark" \
  $(echo $error_light_rgb | awk '{print $1}') \
  $(echo $error_light_rgb | awk '{print $2}') \
  $(echo $error_light_rgb | awk '{print $3}') \
  $(echo $error_dark_rgb | awk '{print $1}') \
  $(echo $error_dark_rgb | awk '{print $2}') \
  $(echo $error_dark_rgb | awk '{print $3}')

echo "Color assets creation completed!"
echo "Total assets created: 15"
echo "Assets available in: BetFreeApp/BetFreeApp/Assets.xcassets/Colors/" 