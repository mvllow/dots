#!/bin/sh

# todo: update variables for personal use
app=~/.config/mvllow/dots
repo=https://github.com/mvllow/dots.git
# git_name="user123"
# git_email="you@domain.com"

color_green() {
    echo "\033[0;92m$1\033[0m"
}

color_grey() {
    echo "\033[0;90m$1\033[0m"
}

put_header() {
    clear
    echo "Welcome to mvllow/dots 🌸"
    echo
}

init() {
    put_header

    echo "Let's start by checking for the necessary tools."
    echo

    if ! [ $(xcode-select --print-path) ]; then
        echo "We need command line tools for git, brew, and more."
        color_grey "This could take a while, so we will check every few seconds."

        get_command_line_tools
    else
        get_repo
    fi
}

get_command_line_tools() {
    xcode-select --install &>/dev/null;

    sleep 5

    if ! [ $(xcode-select --print-path) ]; then
        put_header

        echo "Waiting for command line tools to finish installing..."

        get_command_line_tools
    else
        get_repo
    fi
}

get_repo() {
    if ! [ -e $app ]; then
        echo "We're going to clone the repo now."
        color_grey "Cloning to $app"
        echo

        mkdir -p $app
        git clone $repo $app &>/dev/null;
    else
        echo "It looks like you already have the repo locally."
        color_grey "To use the remote branch, remove $app"
        echo
    fi

    get_homebrew
}

get_homebrew() {
    if ! type brew &>/dev/null; then
        echo "Before we change any preferences, let's install Homebrew to manage our packages."
        color_grey "Learn more about Homebrew at https://brew.sh"
        echo

        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    echo "Updating Homebrew packages..."
    color_grey "Using $app/brewfile"
    echo

    brew upgrade &>/dev/null;
    brew bundle --file="$app/brewfile" &>/dev/null;
    brew cleanup &>/dev/null;

    echo "If you have existing formulae, you may decide to purge anything not listed in the brewfile:"
    color_grey "$ brew bundle cleanup --file=\"$app/brewfile\" --force"
    echo

    config_git
}

config_git() {
    if ! [ -f ~/.gitconfig ]; then
        echo "Let's setup git with your information."

        if [ -z ${git_name+x} ]; then
            read -p "What's your git name? " git_name
        fi

        if [ -z ${git_email+x} ]; then
            read -p "Your git email? " git_email
        fi
        echo

        git config --global user.name "$git_name"
        git config --global user.email "$git_email"

        if ! type nvim &>/dev/null; then
            git config --global core.editor "nvim"
        else
            git config --global core.editor "vim"
        fi

        echo "Great! Now we will add a few aliases..."
        echo "git checkout -> git co"
        git config --global alias.co checkout
        echo "git branch   -> git br"
        git config --global alias.br branch
        echo "git status   -> git st"
        git config --global alias.st status
        echo
    else
        echo "It looks like you already have global git configured."
        color_grey "To use our setup, remove ~/.gitconfig"
        echo
    fi

    config_ssh
}

config_ssh() {
    if ! [ -f ~/.ssh/id_rsa ]; then
        ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N ""
        pbcopy < ~/.ssh/id_rsa.pub

        echo "Public key has been copied to your clipboard."
        color_grey "Your key can be found at ~/.ssh/id_rsa.pub"
        echo
    else
        echo "It looks like you already have local ssh keys."
        color_grey "To use our setup, remove ~/.ssh/id_rsa"
        echo
    fi

    config_shell
}

config_shell() {
    echo "By default, Catalina now uses zsh instead of bash."
    echo "If elvish was installed via brew, we will configure that as well."
    echo

    if [ -x /usr/local/bin/elvish ]; then
        cp -r $app/.elvish ~/
    fi

    cp $app/.zshrc ~/

    config_apps
}

config_apps() {
    echo "Now changing app preferences."
    color_grey "More information available at github.com/mvllow/dots"
    echo

    if [ $(ls /Applications/ | grep iTerm) ]; then
        cp -r $app/iterm/com.googlecode.iterm2.plist ~/Library/Preferences
    fi
    
    if [ $(which hyper) ]; then
        cp -r $app/.hyper.js ~/
    fi

    cp -r $app/.vimrc ~/

    if [ $(which nvim) ]; then
        mkdir -p ~/.config/nvim
        echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after" > ~/.config/nvim/init.vim
        echo "let &packpath=&runtimepath" >> ~/.config/nvim/init.vim
        echo "source ~/.vimrc" >> ~/.config/nvim/init.vim
    fi

    if [ $(which code) ]; then
        mkdir -p ~/Library/Application\ Support/Code/User
        cp $app/code/settings.json ~/Library/Application\ Support/Code/User/settings.json

        code --install-extension blanu.vscode-styled-jsx &>/dev/null;
        code --install-extension dbaeumer.vscode-eslint &>/dev/null;
        code --install-extension esbenp.prettier-vscode &>/dev/null;
        code --install-extension jamesbirtles.svelte-vscode &>/dev/null;
        code --install-extension mvllow.rose-pine &>/dev/null;
        code --install-extension vscodevim.vim &>/dev/null;
    fi
  
    if [ $(which code-insiders) ]; then
        mkdir -p ~/Library/Application\ Support/Code\ -\ Insiders/User
        cp $app/code/settings.json ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json

        code-insiders --install-extension blanu.vscode-styled-jsx &>/dev/null;
        code-insiders --install-extension dbaeumer.vscode-eslint &>/dev/null;
        code-insiders --install-extension esbenp.prettier-vscode &>/dev/null;
        code-insiders --install-extension jamesbirtles.svelte-vscode &>/dev/null;
        code-insiders --install-extension mvllow.rose-pine &>/dev/null;
        code-insiders --install-extension vscodevim.vim &>/dev/null;
    fi

    if [ $(which subl) ]; then
        mkdir -p ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
        cp -r $app/subl/ ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
    fi

    config_prefs
}

config_prefs() {
    echo "We are going to expose SF Mono making it accessibile via Font Book."
    cp -r /System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts/. /Library/Fonts/
    echo

    echo "Now changing system preferences."
    color_grey "More information available at github.com/mvllow/dots"
    echo

    # Dock: enable autohide
    defaults write com.apple.dock autohide -bool true
    # Dock: hide recent apps
    defaults write com.apple.dock show-recents -bool false
    # Dock: show only active apps
    defaults write com.apple.dock static-only -bool true
    
    # Keyboard: disable auto correct
    defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
    # Keyboard: disable auto capitilise
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

    # Finder: disable warning on file extension change
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    # Finder: disable warning when emptying trash
    defaults write com.apple.finder WarnOnEmptyTrash -bool false

    # Menubar: show battery percentage
    defaults write com.apple.menuextra.battery ShowPercent -string "YES"

    woohoo
}

woohoo() {
    color_green "Done. Stay humble, stay hopeful."
    echo
}

if [ $(uname) == "Darwin" ]; then
    init
else
    put_header

    echo "Unsupported OS: $(uname)"
    exit 1
fi
