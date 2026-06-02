#!/usr/bin/env bash

# See: https://github.com/mehd-io/dotfiles/tree/main/sketchybar

# Make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/update_workspace_icons.sh

CONFIG_DIR="$HOME/.config/sketchybar"

get_workspace_apps(){
    local sid=$1 # workspace ID
    local apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}' | sort -u)
    echo "$apps"
}

get_workspace_icons() {
    local sid=$1
    local sid_apps="$(get_workspace_apps "$sid")"

    if [ "${sid_apps}" != "" ]; then
        icon_strip=" "
        while read -r sid_apps; do
            icon_strip+="$($CONFIG_DIR/plugins/icon_map_fn.sh "$sid_apps")"
        done <<<"${sid_apps}"
    else
        icon_strip=" —"
    fi

    echo "$icon_strip"
}

# Update all workspaces to ensure clean state
for sid in $(aerospace list-workspaces --all); do
    sid_icon_strip="$(get_workspace_icons "$sid")"
    sketchybar --set space.$sid label="$sid_icon_strip"
done