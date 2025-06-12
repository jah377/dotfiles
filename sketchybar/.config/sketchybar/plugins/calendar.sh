#!/usr/bin/env bash

# See: https://www.josean.com/posts/sketchybar-setup

# Make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/calendar.sh

sketchybar --set $NAME label="$(date +'%a %d/%m/%y [ %H:%m ]')"