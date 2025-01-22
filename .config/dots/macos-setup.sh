#!/usr/bin/env bash

set -e

DOTFILES_REPO="https://github.com/mvllow/dots.git"

if ! xcode-select --print-path &>/dev/null; then
	echo "installing command line tools..."
	xcode-select --install &>/dev/null
	until xcode-select --print-path &>/dev/null; do
		sleep 3
	done
fi

if ! command -v brew >/dev/null 2>&1; then
	echo "installing homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! grep -Fq 'eval "$(/opt/homebrew/bin/brew shellenv)"' "$HOME/.zprofile" 2>/dev/null; then
	echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>"$HOME/.zprofile"
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

BREWFILE="$(dirname "$0")/Brewfile"
if [ -f "$BREWFILE" ]; then
	echo "installing applications from Brewfile..."
	brew bundle --file="$BREWFILE"
else
	echo "no Brewfile found, skipping app install"
fi

if command -v fish >/dev/null 2>&1; then
	CURRENT_SHELL="$(dscl . -read /Users/$USER UserShell | awk '{print $2}')"
	FISH_PATH="$(command -v fish)"
	if [ "$CURRENT_SHELL" != "$FISH_PATH" ]; then
		echo "setting fish as default shell..."
		if ! grep -q "$FISH_PATH" /etc/shells; then
			echo "$FISH_PATH" | sudo tee -a /etc/shells
		fi
		chsh -s "$FISH_PATH"
	fi
fi

if [ ! -f ~/.ssh/id_ed25519 ]; then
	echo "generating ssh key..."
	ssh-keygen -t ed25519 -C "$(git config --global user.email)" -f ~/.ssh/id_ed25519 -q -N ""
	pbcopy <~/.ssh/id_ed25519.pub
	echo "ssh key generated and copied to clipboard"
else
	pbcopy <~/.ssh/id_ed25519.pub
	echo "ssh key already exists, public key copied to clipboard"
fi

if command -v gh >/dev/null 2>&1; then
	if ! gh auth status &>/dev/null; then
		echo "authenticating with github cli (gh)..."
		echo "you may be prompted to upload your ssh key"
		gh auth login
	fi
fi

if [ ! -d "$HOME/dots.git" ]; then
	echo "cloning dotfiles bare repo..."
	git clone --bare "$DOTFILES_REPO" "$HOME/dots.git"
fi

alias .git="git --git-dir=$HOME/dots.git --work-tree=$HOME"
if ! grep -q "alias .git=" "$HOME/.zshrc" 2>/dev/null; then
	echo "alias .git='git --git-dir=\$HOME/dots.git/ --work-tree=\$HOME'" >>"$HOME/.zshrc"
fi

remote_url=$(git --git-dir="$HOME/dots.git" remote get-url origin)
if [[ "$remote_url" =~ ^https://github.com/(.*)$ ]]; then
	ssh_url="git@github.com:${BASH_REMATCH[1]}"
	git --git-dir="$HOME/dots.git" remote set-url origin "$ssh_url"
	echo "dotfiles remote changed to SSH"
fi

echo "setting macOS preferences..."
# defaults write -g _HIHideMenuBar -bool true
defaults write -g AppleTemperatureUnit -string "Celsius"
defaults write -g AppleMeasurementUnits -string "Centimeters"
defaults write -g AppleICUForce24HourTime -bool true
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15
defaults write -g com.apple.trackpad.scaling -float 3.0
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
defaults write -g com.apple.mouse.tapBehavior -int 1
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock expose-group-apps -bool true
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock static-only -bool true
mkdir -p ~/Pictures/Screenshots
defaults write com.apple.screencapture location ~/Pictures/Screenshots
defaults write com.apple.screencapture disable-shadow -bool true

if ls ~/Library/Fonts/SF-Mono-*.otf &>/dev/null; then
	echo "SF Mono font already installed, skipping copy"
else
	echo "copying SF Mono font to system fonts (may prompt for sudo)..."
	sudo cp -r /System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts/. ~/Library/Fonts/
fi

echo "setup complete"
echo
echo "next steps:"
echo "- map Caps Lock to Escape in System Preferences > Keyboard > Modifier Keys"
echo "- remap Shift+Super+Space to Search in Spotlight"
echo "- map Super+Space to Show apps in Spotlight"
echo "- disable keyboard backlight (and disable auto adjust)"
echo "- reboot to apply all changes"
echo
