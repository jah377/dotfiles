#!/bin/bash

# Must make script executable with:
# chmod +x ~/.config/sketchybar/plugins/calendar.sh

sketchybar --set $NAME label="$(date +'%a %d %b %I:%M %p')"