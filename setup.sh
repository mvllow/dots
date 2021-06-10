#!/bin/bash

app=~/.config/dots
repo=https://github.com/mvllow/dots

clear
echo "Minimalist developer\n"

while getopts u:e:s:h option; do
	case "${option}" in
		u) user=${OPTARG};;
		e) email=${OPTARG};;
		s) shell=${OPTARG};;
		h)
			echo "\033[0;90m  Usage\033[0m\n"
			echo "    $ sh $0 <options>"
			echo
			echo "\033[0;90m  Options\033[0m\n"
			echo "    -u [user]   set username for git"
			echo "    -e [email]  set email for git and ssh"
			echo "    -s [shell]  set default shell (assumes brew path)"
			echo "    -h          show this message"
			echo
			echo "\033[0;90m  Examples\033[0m\n"
			echo "    $ sh $0 -u dots -e dots@mellow.dev"
			echo "    $ sh $0 -s fish"
			echo
			exit 2;;
	esac
done

get_command_line_tools() {
	if ! [ $(xcode-select --print-path) ]; then
		xcode-select --install &>/dev/null; sleep 3
		get_command_line_tools
	fi
}
get_command_line_tools

if ! [ -e $app ]; then
	mkdir -p $app
	git clone $repo $app &>/dev/null
fi

if ! [ $(which brew) ]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	export PATH=/opt/homebrew/bin:$PATH
	echo
fi

brew upgrade &>/dev/null
brew bundle --file="$app/brewfile"
brew cleanup &>/dev/null
echo

configs=("kitty" "fish" "nvim")
for i in "${configs[@]}"; do
	if [ $(which $i) ]; then
		mkdir -p ~/.config/$i
		git clone https://github.com/mvllow/$i ~/.config/$i/
	fi
done

if ! [ -z ${shell} ]; then
	if [ $(which "/opt/homebrew/bin/$shell") ]; then
		echo /opt/homebrew/bin/$shell | sudo tee -a /etc/shells
	fi
fi


if [ -z ${user} ]; then
	read -p "What's your username (for git)? "
	echo
	user=$REPLY
fi

if [ -z ${email} ]; then
	read -p "What's your email (for git/ssh)? "
	echo
	email=$REPLY
fi

echo ".DS_Store" > ~/.gitignore
git config --global core.excludesfile ~/.gitignore
git config --global user.name "$user"
git config --global user.email "$email"
git config --global pull.rebase false
git config --global init.defaultBranch "main"

if ! [ -f ~/.ssh/id_ed25519 ]; then
	ssh-keygen -t ed25519 -C $email -f ~/.ssh/id_ed25519 -q -N ""
	if [ $(uname) == "Darwin" ]; then
		echo "*** Copied ssh key to clipboard ***"
		pbcopy < ~/.ssh/id_ed25519.pub
		echo
	fi
fi

if [ $(uname) == "Darwin" ]; then
	cp -r /System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts/. /Library/Fonts/

	# Dock: autohide
	defaults write com.apple.dock autohide -bool true
	# Dock: hide recent apps
	defaults write com.apple.dock show-recents -bool false
	# Dock: show only active apps
	defaults write com.apple.dock static-only -bool true

	# Menubar: autohide
	defaults write NSGlobalDomain _HIHideMenuBar -bool true

	# Keyboard: disable auto correct
	defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
	# Keyboard: disable auto capitalise
	defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
	# Keyboard: disable smart dash/quote
	defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
	defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
	# Keyboard: enable key repeat in all apps
	defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
	# Keyboard: faster key repeat
	defaults write NSGlobalDomain KeyRepeat -int 2
	# Keyboard: shorter delay before key repeat
	defaults write NSGlobalDomain InitialKeyRepeat -int 15

	# Trackpad: enable tap to click (this user and login screen)
	defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
	defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
	defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
	# Trackpad: increase tracking speed
	defaults write -g com.apple.trackpad.scaling 3
fi

echo "Done ✨\n"
echo "\033[0;90m  Don't forget to set caps lock to escape in your settings\033[0m"
echo "\033[0;90m  Maybe even select a new wallpaper\033[0m"
echo "\033[0;90m  And reboot to allow all changes to happen\033[0m"
echo
