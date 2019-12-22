#!/bin/sh

app=~/.config/mvllow/dots
repo=https://github.com/mvllow/dots.git

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
        color_grey "This could take a while, so when the installation finishes press enter to let me know it's done."

        get_command_line_tools
    else
        get_repo
    fi
}

get_command_line_tools() {
    xcode-select --install &>/dev/null;

    read -p ""

    if ! [ $(xcode-select --print-path) ]; then
        put_header

        echo "It doesn't look like command line tools are done installing."
        color_grey "Press enter when you want me to check again."

        get_command_line_tools
    else
        get_repo
    fi
}

get_repo() {
    put_header

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
    put_header

    if ! [ -f ~/.gitconfig ]; then
        echo "Let's setup git with our information."
        read -p "What's your git name? " name
        read -p "Your git email? " email
        echo

        git config --global user.name "$name"
        git config --global user.email "$email"

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
        if [ -z $email ]; then
            echo "We will generate ssh keys using your git email."
            color_grey "To use an alternative email:"
            color_grey "$ ssh-keygen -t rsa -b 4096 -C \"you@domain.com\" -N \"\" -f ~/.ssh/id_rsa"
            echo
        else
            echo "We will generate ssh keys now."
            read -p "What's your preferred email? " email
            echo
        fi

        ssh-keygen -t rsa -b 4096 -C "$email"
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
    if [ $(ls /Applications/ | grep iTerm) ]; then
        cp -r $app/iterm/com.googlecode.iterm2.plist ~/Library/Preferences
    fi
    
    if [ $(which hyper) ]; then
        cp -r $app/.hyper.js ~/
    fi

    if [ $(which nvim) ]; then
        mkdir -p ~/.config/nvim
        echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after" > ~/.config/nvim/init.vim
        echo "let &packpath=&runtimepath" >> ~/.config/nvim/init.vim
        echo "source ~/.vimrc" >> ~/.config/nvim/init.vim
    fi

    if [ $(which code) ]; then
        cp -r $app/code $HOME/Library/Application\ Support/Code/User

        code --install-extension blanu.vscode-styled-jsx &>/dev/null;
        code --install-extension dbaeumer.vscode-eslint &>/dev/null;
        code --install-extension esbenp.prettier-vscode &>/dev/null;
        code --install-extension jamesbirtles.svelte-vscode &>/dev/null;
        code --install-extension mvllow.rose-pine &>/dev/null;
        code --install-extension vscodevim.vim &>/dev/null;
    fi
  
    if [ $(which code-insiders) ]; then
        cp -r $app/code $HOME/Library/Application\ Support/Code\ -\ Insiders/User

        code-insiders --install-extension blanu.vscode-styled-jsx &>/dev/null;
        code-insiders --install-extension dbaeumer.vscode-eslint &>/dev/null;
        code-insiders --install-extension esbenp.prettier-vscode &>/dev/null;
        code-insiders --install-extension jamesbirtles.svelte-vscode &>/dev/null;
        code-insiders --install-extension mvllow.rose-pine &>/dev/null;
        code-insiders --install-extension vscodevim.vim &>/dev/null;
    fi

    if [ $(which subl) ]; then
        sublime_dir=$HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
        cp -r $app/subl/keymap.json "$sublime_dir/Default (OSX).sublime-keymap"
        cp -r $app/subl/packages.json "$sublime_dir/Package Control.sublime-settings"
        cp -r $app/subl/settings.json "$sublime_dir/Preferences.sublime-settings"
    fi

    config_prefs
}

config_prefs() {
    cp -r /System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts/. /Library/Fonts/

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
}

if [ $(uname) == "Darwin" ]; then
    init
else
    echo "Unsupported OS: $(uname)"
    exit 1
fi
