#!/usr/bin/env bash

# See: https://www.josean.com/posts/sketchybar-setup

# Make sure it's executable with:
# chmod +x ~/.config/sketchybar/items/calendar.sh

sketchybar --add item calendar right     \
           --set calendar icon=􀧞         \
                          update_freq=30 \
                          script="$PLUGIN_DIR/calendar.sh"