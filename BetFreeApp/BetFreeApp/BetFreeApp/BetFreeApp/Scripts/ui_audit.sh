#!/bin/bash

# UI Standardization Audit Tool for BetFree App
# This script scans the codebase to identify potential UI standardization issues

# Define the project directory (replace with your actual path)
PROJECT_DIR=$(dirname $(dirname $(dirname $(dirname $(dirname $(cd "$(dirname "$0")" && pwd))))))

# Colors for output
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}     BetFree UI Standardization Audit    ${NC}"
echo -e "${BLUE}=========================================${NC}"

# Function to count occurrences of a pattern
count_occurrences() {
    local pattern="$1"
    local file_pattern="$2"
    local count=$(grep -r "$pattern" --include="$file_pattern" $PROJECT_DIR | wc -l)
    echo $count
}

# Direct Color Usage (instead of BFColors)
echo -e "\n${YELLOW}Direct Color Usage:${NC}"

direct_color_white=$(count_occurrences "Color.white" "*.swift")
echo -e "  Color.white: ${RED}$direct_color_white${NC} occurrences"

direct_color_black=$(count_occurrences "Color.black" "*.swift")
echo -e "  Color.black: ${RED}$direct_color_black${NC} occurrences"

direct_color_gray=$(count_occurrences "Color.gray" "*.swift")
echo -e "  Color.gray: ${RED}$direct_color_gray${NC} occurrences"

direct_color_red=$(count_occurrences "Color.red" "*.swift")
echo -e "  Color.red: ${RED}$direct_color_red${NC} occurrences"

direct_color_blue=$(count_occurrences "Color.blue" "*.swift")
echo -e "  Color.blue: ${RED}$direct_color_blue${NC} occurrences"

direct_color_green=$(count_occurrences "Color.green" "*.swift")
echo -e "  Color.green: ${RED}$direct_color_green${NC} occurrences"

direct_color_yellow=$(count_occurrences "Color.yellow" "*.swift")
echo -e "  Color.yellow: ${RED}$direct_color_yellow${NC} occurrences"

direct_color_hex=$(count_occurrences "Color(hex: " "*.swift")
echo -e "  Direct hex colors: ${RED}$direct_color_hex${NC} occurrences"

# Direct Font Usage (instead of BFTypography)
echo -e "\n${YELLOW}Direct Font Usage:${NC}"

direct_font_size=$(count_occurrences ".font(.system" "*.swift")
echo -e "  Font(.system...): ${RED}$direct_font_size${NC} occurrences"

direct_font_dot=$(count_occurrences ".font(." "*.swift")
direct_font_adapted=$(count_occurrences ".font(BFTypography" "*.swift")
direct_font_nonstandard=$((direct_font_dot - direct_font_adapted))
echo -e "  Non-standardized fonts: ${RED}$direct_font_nonstandard${NC} occurrences"

# Direct Spacing Usage (instead of BFSpacing)
echo -e "\n${YELLOW}Direct Spacing Usage:${NC}"

direct_padding=$(count_occurrences ".padding(" "*.swift")
standardized_padding=$(count_occurrences ".padding(BFSpacing" "*.swift")
direct_padding_nonstandard=$((direct_padding - standardized_padding))
echo -e "  Non-standardized padding: ${RED}$direct_padding_nonstandard${NC} occurrences"

spacing_patterns=("spacing: 4" "spacing: 8" "spacing: 16" "spacing: 20" "spacing: 24" "spacing: 32")
direct_spacing_count=0

for pattern in "${spacing_patterns[@]}"; do
    count=$(count_occurrences "$pattern" "*.swift")
    direct_spacing_count=$((direct_spacing_count + count))
done

echo -e "  Hardcoded spacing values: ${RED}$direct_spacing_count${NC} occurrences"

# Standardized components usage
echo -e "\n${YELLOW}UI Component Standardization:${NC}"

button_count=$(count_occurrences "Button" "*.swift")
standardized_button=$(count_occurrences "BFPrimaryButton\|BFSecondaryButton\|BFButton" "*.swift")
echo -e "  Non-standardized buttons: ${RED}$((button_count - standardized_button))${NC} occurrences"

text_field_count=$(count_occurrences "TextField" "*.swift")
standardized_text_field=$(count_occurrences "BFTextField" "*.swift")
echo -e "  Non-standardized text fields: ${RED}$((text_field_count - standardized_text_field))${NC} occurrences"

# File Analysis 
echo -e "\n${YELLOW}Files with most standardization issues:${NC}"

# Create a temporary directory to store results
mkdir -p /tmp/ui_audit

# Find files with most color references
grep -r "Color\." --include="*.swift" $PROJECT_DIR | cut -d: -f1 | sort | uniq -c | sort -nr | head -5 > /tmp/ui_audit/color_files.txt

# Find files with most direct font sizing
grep -r ".font(.system" --include="*.swift" $PROJECT_DIR | cut -d: -f1 | sort | uniq -c | sort -nr | head -5 > /tmp/ui_audit/font_files.txt

# Find files with most padding references
grep -r ".padding(" --include="*.swift" $PROJECT_DIR | cut -d: -f1 | sort | uniq -c | sort -nr | head -5 > /tmp/ui_audit/padding_files.txt

# Combine and find top offenders
cat /tmp/ui_audit/color_files.txt /tmp/ui_audit/font_files.txt /tmp/ui_audit/padding_files.txt | awk '{print $2}' | sort | uniq -c | sort -nr | head -10 | while read -r count file
do
    if [ ! -z "$file" ]; then
        echo -e "  ${RED}$count${NC} issues in: ${BLUE}$file${NC}"
    fi
done

# Summary and Recommendations
echo -e "\n${YELLOW}Summary:${NC}"
total_issues=$((direct_color_white + direct_color_black + direct_color_gray + direct_color_red + direct_color_blue + direct_color_green + direct_color_yellow + direct_color_hex + direct_font_size + direct_font_nonstandard + direct_padding_nonstandard + direct_spacing_count))

if [ $total_issues -gt 100 ]; then
    severity="High"
    color=$RED
elif [ $total_issues -gt 50 ]; then
    severity="Medium"
    color=$YELLOW
else
    severity="Low"
    color=$GREEN
fi

echo -e "  Total standardization issues found: ${color}$total_issues${NC}"
echo -e "  Standardization status: ${color}$severity${NC}"

echo -e "\n${YELLOW}Recommendations:${NC}"
echo -e "  1. Replace direct color usage with BFColors or standardized extensions"
echo -e "  2. Replace direct font declarations with BFTypography"
echo -e "  3. Use BFSpacing for consistent spacing values"
echo -e "  4. Focus on high-issue files first for maximum impact"
echo -e "  5. Use standardized components from BFStandardizedComponents.swift where possible"

# Clean up
rm -rf /tmp/ui_audit

echo -e "\n${BLUE}=========================================${NC}"
echo -e "${BLUE}            Audit Complete              ${NC}"
echo -e "${BLUE}=========================================${NC}" 