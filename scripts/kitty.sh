#!/usr/bin/env bash
set -euo pipefail

# Download Catppuccin theme files for kitty from the official repository.
# Kitty's auto_color_scheme expects 'color-scheme-dark.conf' and
# 'color-scheme-light.conf' in the kitty config directory.
# See: https://github.com/catppuccin/kitty

KITTY_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/kitty"
CATPPUCCIN_BASE_URL="https://raw.githubusercontent.com/catppuccin/kitty/main/themes"

mkdir -p "$KITTY_CONFIG_DIR"

echo "Downloading Catppuccin Mocha (dark) theme..."
curl -fsSL "$CATPPUCCIN_BASE_URL/mocha.conf" -o "$KITTY_CONFIG_DIR/color-scheme-dark.conf"

echo "Downloading Catppuccin Latte (light) theme..."
curl -fsSL "$CATPPUCCIN_BASE_URL/latte.conf" -o "$KITTY_CONFIG_DIR/color-scheme-light.conf"

echo "Catppuccin themes installed to $KITTY_CONFIG_DIR"
