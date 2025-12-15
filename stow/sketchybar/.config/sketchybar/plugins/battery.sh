#!/bin/sh

# See: https://www.josean.com/posts/sketchybar-setup

# Make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/battery.sh

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

BATT_PERCENT=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ $BATT_PERCENT = "" ]; then
  exit 0
fi

if [[ $CHARGING != "" ]]; then
  # sf-pro >> battery.100percent.bolt
  ICON="􀢋" 
else
  case ${BATT_PERCENT} in
    # sf-pro >> battery.100percent
    100) ICON="􀛨" ;;
    # sf-pro >> battery.75percent
    9[0-9]) ICON="􀺸" ;;
    8[0-9]) ICON="􀺸" ;;
    7[0-9]) ICON="􀺸" ;;
    # sf-pro >> battery.50percent
    6[0-9]) ICON="􀺶" ;;
    5[0-9]) ICON="􀺶" ;;
    4[0-9]) ICON="􀺶" ;;
    # sf-pro >> battery.25percent
    3[0-9]) ICON="􀛩" ;;
    2[0-9]) ICON="􀛩" ;;
    # sf-pro >> battery.0percent
    1[0-9]) ICON="􀛪" ;;
    *) ICON="􀛪";;
  esac
fi

case ${BATT_PERCENT} in
  9[0-9]|100) BATT_COLOR=$GREEN ;;
  [6-8][0-9]) BATT_COLOR=$YELLOW ;;
  [3-5][0-9]) BATT_COLOR=$ORANGE ;;
  [1-2][0-9]) BATT_COLOR=$RED ;;
  *) BATT_COLOR=$RED
esac
 
battery_settings=(
  icon="$ICON"
  icon.color=$BATT_COLOR
  label="${BATT_PERCENT}%"
)

sketchybar --set $NAME "${battery_settings[@]}"
