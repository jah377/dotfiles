#!/usr/bin/env bash
#
# Script Name: osx.sh
# Description: Configure osx settings
# Notes: https://github.com/mathiasbynens/dotfiles/blob/main/.macos

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Use AppleScript to set custom wallpaper
WALLPAPER="green_plants.jpg"
WALLPAPER_PATH="$HOME/dotfiles/backgrounds/$WALLPAPER"

osascript <<EOF
tell application "System Events"
  tell every desktop
    set picture to POSIX file "$WALLPAPER_PATH"
  end tell
end tell
EOF

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

###############################################################################
# Screen                                                                      #
###############################################################################

# Save screenshots to custom screenshots directory
SCREENSHOTS_PATH="$HOME/screenshots"
if [ ! -d "$SCREENSHOTS_PATH" ]; then
    mkdir "$SCREENSHOTS_PATH"
fi
defaults write com.apple.screencapture location -string "${SCREENSHOTS_PATH}"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"
