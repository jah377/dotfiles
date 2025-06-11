#!/bin/bash

# Must make script executable with:
# chmod +x ~/.config/sketchybar/items/disk.sh

sketchybar --add item disk right    \
           --set disk update_freq=2 \
                     icon=􀤄       \
                     script="$PLUGIN_DIR/disk.sh"