#!/usr/bin/env bash

# See: https://www.josean.com/posts/sketchybar-setup

# Make sure it's executable with:
# chmod +x ~/.config/sketchybar/items/front_app.sh

front_app_settings=(
    background.color=$ACCENT_COLOR
    label.color=$BAR_COLOR
    icon.color=$BAR_COLOR
    icon.font="sketchybar-app-font:Regular:15.0"
    script="$PLUGIN_DIR/front_app.sh"
)

sketchybar --add item front_app left \
           --subscribe front_app front_app_switched \
           --set front_app "${front_app_settings[@]}"     

