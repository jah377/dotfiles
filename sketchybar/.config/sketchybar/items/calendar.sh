#!/bin/bash

# Must make script executable with:
# chmod +x ~/.config/sketchybar/items/calendar.sh

# Note: `icon` symbol pasted from `SF Symbols` application (see brew.sh)
sketchybar --add item calendar right \
           --set calendar icon=􀧞  \
                          update_freq=30 \
                          script="$PLUGIN_DIR/calendar.sh"