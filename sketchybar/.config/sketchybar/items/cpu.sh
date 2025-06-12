#!/usr/bin/env bash

# See: https://www.josean.com/posts/sketchybar-setup

# Make sure it's executable with:
# chmod +x ~/.config/sketchybar/items/cpu.sh

sketchybar --add item cpu right \
           --set cpu  update_freq=2 \
                      icon=􀧓  \
                      script="$PLUGIN_DIR/cpu.sh"
