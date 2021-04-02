#!/bin/bash

app=~/.config/dots
repo=https://github.com/mvllow/dots

clear
echo "Minimalist developer 🌸\n"

while getopts u:e:h option; do
    case "${option}" in
        u) user=${OPTARG};;
        e) email=${OPTARG};;
        h)
            echo "\033[0;90m  Usage\033[0m\n"
            echo "    $ sh $0 <options>"
            echo
            echo "\033[0;90m  Options\033[0m\n"
            echo "    -u [user]   set username for git"
            echo "    -e [email]  set email for git and ssh"
            echo "    -h          show this message"
            echo
            echo "\033[0;90m  Examples\033[0m\n"
            echo "    $ sh $0 -e dots@mellow.dev"
            echo
            exit 2;;
    esac
done

if ! [ $(uname) == "Darwin" ]; then
    echo "\033[0;31m✕ Unsupported OS\033[0m"
    echo "\033[0;90m  Linux support is on the radar <3\033[0m\n"
    exit 1
fi

if [ $(uname -m) == "arm64" ]; then
    echo "\033[1;33mApple silicon supported 🎉\033[0m\n"
fi

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
    echo "Installing brew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo
fi

echo "(brew) Upgrading"
brew upgrade &>/dev/null
echo "(brew) Installing bundle"
brew bundle --file="$app/brewfile"
echo "(brew) Cleaning up"
brew cleanup &>/dev/null
echo

if [ -z ${user} ]; then
    read -p "What's your GitHub username? "
    echo
    user=$REPLY
fi

if [ -z ${email} ]; then
    read -p "What's your GitHub email? "
    echo
    email=$REPLY
fi

echo ".DS_Store" > ~/.gitignore

git config --global core.excludesfile ~/.gitignore
git config --global user.name "$user"
git config --global user.email "$email"
git config --global core.editor "vim"
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.st status
git config --global alias.lola "log -n 10 --graph --decorate --pretty=oneline --abbrev-commit"

echo ".DS_Store" > ~/.gitignore

if ! [ -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b ed25519 -f ~/.ssh/id_rsa -q -N "" -C $email
    pbcopy < ~/.ssh/id_rsa.pub
fi

if ! [ -f ~/.zshrc ]; then
    cp -r $app/.zshrc ~/
fi

if ! [ -f ~/.vimrc ]; then
    cp -r $app/.vimrc ~/
fi

if [ $(which code-insiders) ]; then
    mkdir -p ~/Library/Application\ Support/Code\ -\ Insiders/User
    cp $app/vscode/settings.json ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json
    xargs -n1 code-insiders --install-extension < $app/vscode/extensions.txt &>/dev/null
fi

cp -r /System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts/. /Library/Fonts/

# Dock: enable autohide
defaults write com.apple.dock autohide -bool true
# Dock: hide recent apps
defaults write com.apple.dock show-recents -bool false
# Dock: show only active apps
defaults write com.apple.dock static-only -bool true

# Menubar: enable autohide
defaults write NSGlobalDomain _HIHideMenuBar -bool true

# Keyboard: disable auto correct
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
# Keyboard: disable auto capitalise
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
# Keyboard: disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# Keyboard: disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# Keyboard: enable key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Keyboard: faster key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
# Keyboard: shorter delay before key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Trackpad: enable tap to click (this user and login screen)
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Trackpad: increase tracking speed
defaults write -g com.apple.trackpad.scaling 3

echo "Done ✨\n"
echo "\033[0;90m  Don't forget to set caps lock to escape in your settings\033[0m"
echo "\033[0;90m  Maybe even select a new wallpaper\033[0m"
echo "\033[0;90m  And reboot to allow all changes to happen\033[0m"
echo
