#!/usr/bin/env bash

set -e

THEME_DIR=~/.themes/"Custom Shell Accent Theme"/gnome-shell
BAK_FILE="$THEME_DIR/gnome-shell.css.bak"

# not first time running this script
# if theme and backup exist then just reuse the existing files
if [[ -d "$THEME_DIR" && -f "$BAK_FILE" ]]; then
    echo "Existing theme detected at: $THEME_DIR"
    echo ""

    while true; do
        read -rp "Enter new accent colour as a hex string (e.g. #ff0000): " hex_color

        if [[ "$hex_color" =~ ^#[0-9a-fA-F]{6}$ ]]; then
            echo "Colour accepted: $hex_color"
            break
        else
            echo "\"$hex_color\" is not a valid colour. Please enter a valid #rrggbb hex colour (e.g. #ff0000)."
        fi
    done
    echo ""

    cp "$BAK_FILE" "$THEME_DIR/gnome-shell.css"
    sed -i "s/-st-accent-color/$hex_color/g" "$THEME_DIR/gnome-shell.css"
    echo "Done! Accent colour updated to $hex_color."
    echo ""
    echo "Theme location: $THEME_DIR"
    echo "For the new colour to apply, switch to 'Default' and then to 'Custom Shell Accent Theme' again, using the 'User Themes' extension."
    exit 0
fi

# first time running this script
# warning and ask to proceed
shellversion=$(gnome-shell --version | awk '{print $3}')
echo "Using GNOME Shell $shellversion"
echo "Recommended for this script is: 49.5"
echo ""

major=${shellversion%%.*}

if [[ "$major" == "49" ]]; then
  echo "You're using a tested version ($shellversion), nice!"
  echo "Still, remember that things might break if you decide to update GNOME in the future."
  echo "The theme won't apply automatically, you have to manually enable it with the 'User Themes' extension."
  echo ""
  read -p "Do you want to continue? [y/N]: " answer
  if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    echo "Aborting."
    exit 1
  fi
elif [[ "$major" == "47" || "$major" == "48" ]]; then
  echo "CAUTION! GNOME Shell $shellversion has NOT been tested."
  echo "Worst case scenario is that your GNOME Shell's colors and layout get messed up."
  echo "Still, remember that things might break if you decide to update GNOME in the future."
  echo "The theme won't apply automatically, you have to manually enable it with the 'User Themes' extension."
  echo ""
  read -p "Do you want to continue? [y/N]: " answer
  if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    echo "Aborting."
    exit 1
  fi
else
  echo "ERROR: Unsupported GNOME Shell version: $shellversion"
  echo "Only versions 47-49.5 are allowed."
  echo "This script is not future-proof, and may break on versions 50+."
  echo "Versions below 47 won't work at all."
  exit 1
fi

clear
echo "You acknowledged that things may break, proceeding.."
echo ""

# folders setup
echo "Creating custom theme in ~/.themes/"
mkdir -p ~/.themes/
cd ~/.themes/

mkdir -p "Custom Shell Accent Theme"
cd "Custom Shell Accent Theme"

mkdir -p "gnome-shell"
cd "gnome-shell"

# extract gnome-shell gresource files
echo "Extracting GNOME Shell theme resources..."
for r in $(gresource list /usr/share/gnome-shell/gnome-shell-theme.gresource); do
    gresource extract /usr/share/gnome-shell/gnome-shell-theme.gresource "$r" > "$(basename "$r")"
done
echo "Done extracting resources."
echo ""

# ask which mode the user wants
while true; do
    echo "Select a colour mode:"
    echo "  1) Dark Mode"
    echo "  2) Light Mode"
    read -rp "Enter your choice [1/2]: " mode_choice

    case "$mode_choice" in
        1)
            cp gnome-shell-dark.css gnome-shell.css
            echo "Dark mode selected."
            break
            ;;
        2)
            cp gnome-shell-light.css gnome-shell.css
            echo "Light mode selected."
            break
            ;;
        *)
            echo "Invalid choice. Please press 1 or 2."
            echo ""
            ;;
    esac
done
echo ""

# create a backup of gnome-shell.css
cp gnome-shell.css gnome-shell.css.bak
echo "Backup created: gnome-shell.css.bak"
echo ""

# ask for a valid hex colour until the user gives a correct one
while true; do
    read -rp "Enter accent colour as a hex string (e.g. #ff0000): " hex_color

    if [[ "$hex_color" =~ ^#[0-9a-fA-F]{6}$ ]]; then
        echo "Colour accepted: $hex_color"
        break
    else
        echo "\"$hex_color\" is not a valid colour. Please enter a valid #rrggbb hex colour (e.g. #ff0000)."
    fi
done
echo ""

# replace -st-accent-color in gnome-shell.css
sed -i "s/-st-accent-color/$hex_color/g" gnome-shell.css
echo "Done! All instances of -st-accent-color have been replaced with $hex_color in gnome-shell.css."
echo ""
echo "Theme location: ~/.themes/Custom Shell Accent Theme/gnome-shell/"
echo "To apply the theme, use the 'User Themes' extension."
