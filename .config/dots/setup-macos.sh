#!/usr/bin/env sh

echo
echo "Installing command line tools..."
get_command_line_tools() {
  if ! [ $(xcode-select --print-path) ]; then
    xcode-select --install &>/dev/null;
    sleep 3; get_command_line_tools
  fi
}
get_command_line_tools

ssh-keygen -t ed25519 -C "$(git config --global user.email)" -f ~/.ssh/id_ed25519 -q -N ""
pbcopy <~/.ssh/id_ed25519.pub
echo
echo "Copied ssh public key to clipboard"
echo "> Add your key to https://github.com/settings/ssh/new"

cp -r /System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts/. /Library/Fonts/
echo
echo "Copied SF Mono from Terminal.app to fonts library"

echo
echo "Updating system settings..."

# Set preferred languages.
defaults delete -g AppleLanguages
defaults write -g AppleLanguages -array 'it' 'en-GB'
defaults write -g AppleLocale -string 'it_IT'

# Enable 24-hour time format.
defaults write -g AppleICUForce24HourTime -bool true

# Set key repeat delay (initial) and repeat interval.
# This allows values outside of the macOS limit, 15 and 2 respectively.
#
# See: https://mac-key-repeat.zaymon.dev/
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# (Optional) Disable press-and-hold for special characters.
# Uncomment for faster key repeat in all apps, e.g. vim.
# defaults write -g ApplePressAndHoldEnabled -bool false

# Enable "Tap to click" for builtin laptop trackpad and Bluetooth trackpad.
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
defaults write -g com.apple.mouse.tapBehavior -int 1

# Increase trackpad tracking speed (higher = faster).
defaults write -g com.apple.trackpad.scaling -float 3.0

# Automatically switch between light and dark mode based on time of day.
defaults write -g AppleInterfaceStyleSwitchesAutomatically -bool true

# Always hide the menu bar unless hovering at the top of the screen.
defaults write -g _HIHideMenuBar -bool true

# Enable Night Shift to automatically adjust display colours based on sunset/sunrise.
defaults write com.apple.nightshift.plist NightModeSunriseSunsetEnabled -bool true

# Set screencapture save locations and style.
defaults write com.apple.screencapture location ~/Downloads
defaults write com.apple.screencapture disable-shadow -bool true

# Enable hardware-based accent colours.
# 3—yellow 4—green 5—blue 6—pink 7—purple 8—orange
defaults write -g NSColorSimulateHardwareAccent -bool YES
defaults write -g NSColorSimulatedHardwareEnclosureNumber -int 3

# Automatically hide the Dock when not in use.
defaults write com.apple.dock autohide -bool true

# Disable showing recent apps in the Dock.
defaults write com.apple.dock show-recents -bool false

# Show only active apps in the Dock, hiding all other app icons.
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock static-only -bool true

# Restart the Dock to apply changes immediately.
killall Dock

# Restart system settings to apply changes immediately.
killall SystemUIServer

echo
echo "Done! Please reboot to apply all changes."
