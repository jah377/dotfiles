#!/usr/bin/env bash

# Make sure it's executable with:
# chmod +x ~/.config/sketchybar/items/clock.sh

clock_settings=(
    # Reset padding to give illusion of single calendar + clock item
    padding_left=-6 # See sketchybarrc >> background.corner_radius
    icon.padding_left=0
    icon.padding_right=0
    label.color=$WHITE
    update_freq=10
    script="$PLUGIN_DIR/clock.sh"
)

sketchybar --add item clock right \
           --set clock "${clock_settings[@]}"