#!/usr/bin/env bash

# See: https://www.josean.com/posts/sketchybar-setup

# Make sure it's executable with:
# chmod +x ~/.config/sketchybar/items/battery.sh

sketchybar --add item battery right \
           --set battery update_freq=120 \
                         script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery system_woke power_source_change
