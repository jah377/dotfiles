#!/bin/bash

# Must make script executable with:
# chmod +x ~/.config/sketchybar/items/volume.sh

sketchybar --add item volume right \
           --set volume script="$PLUGIN_DIR/volume.sh" \
           --subscribe volume volume_change 