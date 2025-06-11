#!/bin/bash

# Must make script executable with:
# chmod +x ~/.config/sketchybar/items/ram.sh

sketchybar --add item ram right    \
           --set ram update_freq=2 \
                     icon=􀫦       \
                     script="$PLUGIN_DIR/ram.sh"