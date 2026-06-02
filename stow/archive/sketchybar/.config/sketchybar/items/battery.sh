#!/usr/bin/env bash

# See: https://www.josean.com/posts/sketchybar-setup

# Make sure it's executable with:
# chmod +x ~/.config/sketchybar/items/battery.sh

battery_settings=(
    label.color=$WHITE
    update_freq=120
    script="$PLUGIN_DIR/battery.sh"
)

sketchybar --add item battery right     \
           --subscript battery system_woke power_source_change  \
           --set battery "${battery_settings[@]}"
