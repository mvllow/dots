#!/bin/sh

app=~/.config/mvllow/dots
repo=https://github.com/mvllow/dots.git

# TODO: test -d
# add usage exampled for -d
while getopts u:e:dh option; do
  case "${option}" in
    u) git_user=${OPTARG};;
    e) git_email=${OPTARG};;
    d) rm -rf $app;;
    h)
      echo "Example usage:"
      echo "$0 [-u USERNAME] [-e EMAIL]" >&2
      echo
      echo "Commands:"
      echo "-u []    username for global git config"
      echo "-e []    email for global git config and ssh keys"
      echo "-d       overwrite local repo with remote"
      echo
      exit 2
      ;;
  esac
done

color_green() {
  echo "\033[0;92m$1\033[0m"
}

color_grey() {
  echo "\033[0;90m> $1\033[0m"
}

put_header() {
  clear
  echo
  echo "Welcome to mvllow/dots 🌸"
  echo
}

init() {
  put_header

  echo "Let's start with getting Homebrew"

  if ! type brew &>/dev/null; then
    color_grey "https://brew.sh"

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    color_grey "Already exists... skipping"
  fi

  echo

  get_command_line_tools
  get_repo

  echo "Updating brew packages"
  color_grey "Using $app/brewfile"

  brew upgrade &>/dev/null;
  brew bundle --file="$app/brewfile" &>/dev/null;
  brew cleanup &>/dev/null;

  color_grey "Cleaning up"
  echo

  config_git
  config_ssh
  config_shell
  config_apps
  config_prefs
  woohoo
}

get_command_line_tools() {
  xcode-select --install &>/dev/null;

  sleep 5

  if ! [ $(xcode-select --print-path) ]; then
    put_header

    echo "Waiting for command line tools to finish installing..."

    get_command_line_tools
  fi
}

get_repo() {
  echo "Fetching remote repo"

  if ! [ -e $app ]; then
    color_grey "Cloning to $app"

    mkdir -p $app
    git clone $repo $app &>/dev/null;
  else
    color_grey "$app exists... skipping"
  fi

  echo
}

config_git() {
  echo "Configuring global git"

  if ! [ -f ~/.gitconfig ]; then
    color_grey "Setting general information"
    if ! [[ -z ${git_user} ]]; then
      git config --global user.name "$git_user"
    fi

    if ! [[ -z ${git_email} ]]; then
      git config --global user.email "$git_email"
    fi

    if type nvim &>/dev/null; then
      git config --global core.editor "nvim"
    else
      git config --global core.editor "vim"
    fi

    color_grey "Adding aliases: [ch]eckout [br]anch [st]atus"

    git config --global alias.ch checkout
    git config --global alias.br branch
    git config --global alias.st status
  else
    color_grey "Already exists... skipping"
  fi

  echo
}

config_ssh() {
  echo "Configuring ssh keys"

  if ! [ -f ~/.ssh/id_rsa ]; then
    if [[ -z ${git_email} ]]; then
      color_grey "Generating key with git email"
      ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N "" -C $git_email
    else
      color_grey "Generating key with computer hostname"
      ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N ""
    fi

    pbcopy < ~/.ssh/id_rsa.pub

    color_grey "Public key copied to clipboard"
    color_grey "Saved to ~/.ssh/id_rsa.pub"
  else
    color_grey "Already exists... skipping"
  fi

  echo
}

config_shell() {
  echo "Configuring shells"

  if [ -x /usr/local/bin/elvish ]; then
    color_grey "Copying elvish settings"
    cp -r $app/.elvish ~/
  fi

  color_grey "Copying zsh settings"
  cp $app/.zshrc ~/
  echo
}

config_apps() {
  echo "Updating app preferences"

  if [ $(ls /Applications/ | grep iTerm) ]; then
    color_grey "Copying iTerm settings"
    cp -r $app/iterm/com.googlecode.iterm2.plist ~/Library/Preferences
  fi
  
  if [ $(which hyper) ]; then
    color_grey "Copying Hyper settings"
    cp -r $app/.hyper.js ~/
  fi

  color_grey "Copying Vim settings"
  cp -r $app/.vimrc ~/

  if [ $(which nvim) ]; then
    color_grey "Sharing Vim settings with NeoVim"
    mkdir -p ~/.config/nvim
    echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after" > ~/.config/nvim/init.vim
    echo "let &packpath=&runtimepath" >> ~/.config/nvim/init.vim
    echo "source ~/.vimrc" >> ~/.config/nvim/init.vim
  fi

  if [ $(which code) ]; then
    color_grey "Copying VSCode settings"
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
    color_grey "Copying VSCode Insiders settings"
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
    color_grey "Copying Sublime Text settings"
    mkdir -p ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
    cp -r $app/subl/ ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
  fi

  echo
}

config_prefs() {
  echo "Configuring system preferences"

  color_grey "Copying SF Mono to Font Book"
  cp -r /System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts/. /Library/Fonts/

  color_grey "Modifying dock preferences"
  # Dock: enable autohide
  defaults write com.apple.dock autohide -bool true
  # Dock: hide recent apps
  defaults write com.apple.dock show-recents -bool false
  # Dock: show only active apps
  defaults write com.apple.dock static-only -bool true
  
  color_grey "Modifying keyboard preferences"
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

  color_grey "Modifying trackpad preferences"
  # Trackpad: enable tap to click (this user and login screen)
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  # Trackpad: increase tracking speed
  defaults write -g com.apple.trackpad.scaling 3

  color_grey "Modifying finder preferences"
  # Finder: disable warning on file extension change
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
  # Finder: disable warning when emptying trash
  defaults write com.apple.finder WarnOnEmptyTrash -bool false

  color_grey "Modifying menubar preferences"
  # Menubar: show battery percentage
  defaults write com.apple.menuextra.battery ShowPercent -string "YES"

  echo
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