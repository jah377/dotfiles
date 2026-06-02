#!/usr/bin/env bash

# See: https://www.josean.com/posts/sketchybar-setup

# Make sure it's executable with:
# chmod +x ~/.config/sketchybar/items/calendar.sh

calendar_settings=(
    icon=􀉉
    icon.color=$WHITE
    label.color=$WHITE
    update_freq=30
    padding_right=0 # Want calendar/clock to appear as single item
    script="$PLUGIN_DIR/calendar.sh"
)

sketchybar --add item calendar right    \
           --set calendar "${calendar_settings[@]}"
