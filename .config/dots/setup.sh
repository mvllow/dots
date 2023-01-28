#!/usr/bin/env sh

clear
echo "dots"

echo "[repo]"
echo "> Cloning files to temporary directory"
git clone \
	--separate-git-dir=$HOME/dots.git \
	https://github.com/mvllow/dots.git \
	dots-tmp

echo "> Copying files to home directory"
rsync --recursive --verbose --exclude '.git' dots-tmp/ $HOME/
rm -rf dots-tmp

echo "> Setting config"
git --git-dir=$HOME/dots.git/ --work-tree=$HOME config status.showUntrackedFiles no

echo "> Setting remote"
git --git-dir=$HOME/dots.git/ --work-tree=$HOME remote add origin git@github.com:mvllow/dots.git

echo "[brew]"
if ! [ $(which brew) ]; then
	echo "> Installing package manager"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	export PATH=/opt/homebrew/bin:$PATH
fi

echo "> Upgrading packages"
brew upgrade

echo "> Installing packages"
brew bundle --file="$HOME/.config/dots/brewfile"

echo "> Cleaning up"
brew cleanup

if [ $(which npm) ]; then
	echo "[npm]"
	echo "> Installing global npm packages"
	npm install --global trash-cli
fi

if [ $(which fish) ]; then
	echo "[fish]"
	echo "> Setting default shell"
	echo $(which fish) | sudo tee -a /etc/shells
	chsh -s $(which fish)
fi

if [ -f ~/.ssh/id_ed25519 ]; then
	echo "[ssh]"
	echo "> Generating key"
	ssh-keygen -t ed25519 -C $(git config --global user.email) -f ~/.ssh/id_ed25519 -q -N ""
	pbcopy <~/.ssh/id_ed25519.pub
	echo "  (copied key to clipboard)"
fi

if [ $(uname) == "Darwin" ]; then
	echo "[system]"
	echo "> Copying SF Mono to Font Book"
	cp -r /System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts/. /Library/Fonts/

	echo "> Modifying system settings"

	# Dock.
	defaults write com.apple.dock autohide -bool true      # autohide
	defaults write com.apple.dock tilesize -int 48         # set tilesize
	defaults write com.apple.dock orientation left         # set orientation
	defaults write com.apple.dock persistent-apps -array   # remove all docked apps
	defaults write com.apple.dock show-recents -bool false # disable recent apps
	defaults write com.apple.dock static-only -bool true   # show only active apps
	defaults write com.apple.dock mru-spaces -bool false   # disable mru (most recent use) spaces

	# Keyboard.
	defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false             # disable auto correct
	defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false     # disable auto capitalise
	defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false   # disable smart dash
	defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false  # disable smart quote
	defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false # disable period on double space
	defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false             # enable key repeat in all apps
	defaults write NSGlobalDomain InitialKeyRepeat -int 15                         # set shorter delay before key repeat
	defaults write NSGlobalDomain KeyRepeat -int 2                                 # enable faster key repeat

	# Menubar.
	defaults write NSGlobalDomain _HIHideMenuBar -bool true     # autohide
	defaults write com.apple.Siri StatusMenuVisible -bool false # hide siri

	# Screencapture.
	defaults write com.apple.screencapture location ~/Downloads      # set default save location
	defaults write com.apple.screencapture disable-shadow -bool true # disable shadow

	# Trackpad.
	defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true                  # tap to click (trackpad)
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true # tap to click (bluetooth trackpad)
	defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1         # tap to click (mouse, current host)
	defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1                      # tap to click (mouse)
	defaults write -g com.apple.trackpad.scaling -int 3                                   # increase tracking speed

	# echo "> Modifying app settings"
	# Rectangle.
	# defaults write com.knollsoft.Rectangle gapSize -int 10          # set window gaps
	# defaults write com.knollsoft.Rectangle launchOnLogin -bool true # launch on login
	# defaults write com.knollsoft.Rectangle almostMaximize -dict \
	# 	keyCode -int 46 \
	# 	modifierFlags -int 786432 # set almost maximize to ctrl+option+m
fi

echo
echo "https://github.com/mvllow/dots/wiki/macOS-setup"
