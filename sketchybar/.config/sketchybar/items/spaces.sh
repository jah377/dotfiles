#!/usr/bin/env bash

# See: https://nikitabobko.github.io/AeroSpace/goodness#show-aerospace-workspaces-in-sketchybar
# See: https://www.josean.com/posts/sketchybar-setup

# Make sure it's executable with:
# chmod +x ~/.config/sketchybar/items/space.sh

##### Adding Aerospace Workspace Indicators #####

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
    sketchybar --add item space.$sid left \
               --subscribe space.$sid aerospace_workspace_change \
               --set space.$sid \
                     background.color=0x44ffffff \
                     background.corner_radius=5 \
                     background.height=20 \
                     background.drawing=off \
                     icon="$sid" \
                     label.font="sketchybar-app-font:Regular:16.0" \
                     label.padding_right=20 \
                     label.y_offset=-1 \
                     click_script="aerospace workspace $sid" \
                     script="$CONFIG_DIR/plugins/aerospace.sh $sid"

    apps=$(aerospace list-windows --workspace $sid | awk -F '|' '{ gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2 }' | sort -u)
    icon_strip=" "
    if [ "${apps}" != "" ]; then
      while read -r app
      do
        icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
      done <<< "${apps}"
    else
      icon_strip=" —"
    fi

    sketchybar --set space.$sid label="$icon_strip"
done