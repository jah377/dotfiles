#!/usr/bin/env bash

# See: https://nikitabobko.github.io/AeroSpace/goodness#show-aerospace-workspaces-in-sketchybar
# See: https://www.josean.com/posts/sketchybar-setup

# Make sure it's executable with:
# chmod +x ~/.config/sketchybar/items/space.sh


sketchybar --add event aerospace_workspace_change

sid_settings=(
    background.color=$BACKGROUND_COLOR
    background.corner_radius=5
    background.height=20
    background.drawing=off
    
    label.font="sketchybar-app-font:Regular:15.0"
    label.padding_right=20
    label.y_offset=-1
)

for sid in $(aerospace list-workspaces --all); do

    sid_settings+=(
        icon="$sid"
        click_script="aerospace workspace $sid"
        script="$CONFIG_DIR/plugins/aerospace.sh $sid"
    )

    sketchybar --add item space.$sid left \
               --subscribe space.$sid aerospace_workspace_change front_app_switched \
               --set space.$sid "${sid_settings[@]}"
done


    




