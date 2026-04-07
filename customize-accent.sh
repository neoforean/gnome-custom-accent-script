#!/usr/bin/env bash

set -e

THEME_DIR=~/.themes/"Custom Shell Accent Theme"/gnome-shell
BAK_FILE="$THEME_DIR/gnome-shell.css.bak"

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
    exit 0
fi

# folders setup
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
