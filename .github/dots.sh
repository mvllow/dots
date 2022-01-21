#!/usr/bin/env bash

clear
echo "dots"

echo "- initialising repo"
git clone \
	--separate-git-dir=$HOME/dots.git \
	https://github.com/mvllow/dots.git \
	dots-tmp

rsync --recursive --verbose --exclude '.git' dots-tmp/ $HOME/
rm -rf dots-tmp

alias dotgit="git --git-dir=$HOME/dots.git/ --work-tree=$HOME"
dotgit config status.showUntrackedFiles no
dotgit remote add origin git@github.com:mvllow/dots.git

if ! [ $(which brew) ]; then
	echo "- installing homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	export PATH=/opt/homebrew/bin:$PATH
fi

brew upgrade
brew bundle --file="$HOME/brewfile"
brew cleanup

if [ $(which fish) ]; then
	echo "- setting default shell: fish"
	echo $(which fish) | sudo tee -a /etc/shells
	chsh -s $(which fish)
fi

if [ -f ~/.ssh/id_ed25519 ]; then
	echo "- generating ssh key"
	ssh-keygen -t ed25519 -C $(git config --global user.email) -f ~/.ssh/id_ed25519 -q -N ""
	pbcopy <~/.ssh/id_ed25519.pub
	echo "- copied ssh key to clipboard"
fi

if [ $(uname) == "Darwin" ]; then
	# copy sf mono from terminal.app
	cp -r /System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts/. /Library/Fonts/

	# dock
	defaults write com.apple.dock autohide -bool true      # autohide
	defaults write com.apple.dock tilesize -int 48         # set tilesize
	defaults write com.apple.dock orientation left         # set orientation
	defaults write com.apple.dock persistent-apps -array   # remove all docked apps
	defaults write com.apple.dock show-recents -bool false # disable recent apps
	defaults write com.apple.dock static-only -bool true   # show only active apps
	defaults write com.apple.dock mru-spaces -bool false   # disable mru (most recent use) spaces

	# keyboard
	defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false             # disable auto correct
	defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false     # disable auto capitalise
	defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false   # disable smart dash
	defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false  # disable smart quote
	defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false # disable period on double space
	defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false             # enable key repeat in all apps
	defaults write NSGlobalDomain InitialKeyRepeat -int 15                         # set shorter delay before key repeat
	defaults write NSGlobalDomain KeyRepeat -int 2                                 # enable faster key repeat

	# menubar
	defaults write NSGlobalDomain _HIHideMenuBar -bool true     # autohide
	defaults write com.apple.Siri StatusMenuVisible -bool false # hide siri

	# screencapture
	defaults write com.apple.screencapture location ~/Downloads      # set default save location
	defaults write com.apple.screencapture disable-shadow -bool true # disable shadow

	# trackpad
	defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true                  # tap to click (trackpad)
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true # tap to click (bluetooth trackpad)
	defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1         # tap to click (mouse, current host)
	defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1                      # tap to click (mouse)
	defaults write -g com.apple.trackpad.scaling -int 3                                   # increase tracking speed

	# rectangle
	defaults write com.knollsoft.Rectangle gapSize -int 10          # set window gaps
	defaults write com.knollsoft.Rectangle launchOnLogin -bool true # launch on login
	defaults write com.knollsoft.Rectangle almostMaximize -dict \
		keyCode -int 46 \
		modifierFlags -int 786432 # set almost maximize to ctrl+option+m
fi

echo "done; suggested next steps:"
echo "- map caps lock to escape"
echo "- enable full disk access for terminal.app"
echo "- enable messages in icloud"
echo "- show develop in safari menu"
echo "- reboot for all changes to take effect"
