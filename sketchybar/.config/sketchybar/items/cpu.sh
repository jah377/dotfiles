#!/usr/bin/env bash

# See: https://www.josean.com/posts/sketchybar-setup

# Make sure it's executable with:
# chmod +x ~/.config/sketchybar/items/cpu.sh

cpu_settings=(
    icon=􀧓
    icon.color=$WHITE
    label.color=$WHITE
    update_freq=2
    script="$PLUGIN_DIR/cpu.sh"
)

sketchybar --add item cpu right     \
           --set cpu  "${cpu_settings[@]}"
