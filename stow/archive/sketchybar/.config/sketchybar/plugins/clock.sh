#!/usr/bin/env bash

# Make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/clock.sh

clock_settings=(
    label="$(date +'[ %H:%M ]')"
    label.font="SF Pro:Bold:15.0"
)

sketchybar --set $NAME "${clock_settings[@]}"

