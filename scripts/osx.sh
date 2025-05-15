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
WALLPAPER_PATH="$HOME/dotfiles/backgrounds/backgrounds/$WALLPAPER"

osascript <<EOF
tell application "System Events"
  tell every desktop
    set picture to POSIX file "$WALLPAPER_PATH"
  end tell
end tell
EOF

###############################################################################
# Mouse, keyboard, Bluetooth accessories, and input                           #
###############################################################################

# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Display function keys on touchbar; must restart
defaults write com.apple.touchbar.agent PresentationModeGlobal functionKeys
pkill "Touch Bar agent"; killall "ControlStrip"

###############################################################################
# Touchpad                                                                    #
###############################################################################

# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen

# Top left screen corner → no-op
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0

# Top right screen corner → no-op
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0

# Top left screen corner → no-op
defaults write com.apple.dock wvous-bt-corner -int 0
defaults write com.apple.dock wvous-bt-modifier -int 0

# Bottom left screen corner → no-op
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-bl-modifier -int 0

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


###############################################################################
# Dock                                                                        #
###############################################################################

# Only show active applications in dock
defaults write com.apple.dock static-only -bool true

# Reduce size of icons
defaults write com.apple.dock tilesize -int 45

# Disable magnification animation when hovering over dock
defaults write com.apple.dock magnification -bool false

# Show dock at bottom of screen 
defaults write com.apple.dock orientation -string "bottom"

# Automatically hide and show the dock
defaults write com.apple.dock autohide -bool true

# Wipe all (default) app icons from the Dock
defaults write com.apple.dock persistent-apps -array

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

killall Dock

###############################################################################
# Finder                                                                      #
###############################################################################

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles true

# View items as a list
defaults write com.apple.finder FXPreferredViewStyle -string "nlsv"

# Show path of file
defaults write com.apple.finder ShowPathbar -bool true

# Show status of directory in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Set $HOME as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Show the ~/Library folder
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

###############################################################################
# Menu Bar                                                                    #
###############################################################################

# Show battery at %
defaults write com.apple.controlcenter BatteryShowPercentage -bool true


