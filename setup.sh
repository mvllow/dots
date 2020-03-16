#!/bin/sh

app=~/.config/mvllow/dots
repo=https://github.com/mvllow/dots.git

green() {
  echo "\033[0;92m$1\033[0m"
}

gray() {
  echo "\033[0;90m$1\033[0m"
}

item() {
  echo "\033[0;90m> $1\033[0m"
}

put_header() {
  clear
  echo
  echo "Minimalist developer 🌸"
  echo
}

put_header

while getopts u:e:dDh option; do
  case "${option}" in
    u) git_user=${OPTARG};;
    e) git_email=${OPTARG};;
    r) rm -rf $app;;
    D)
      rm -rf $app
      exit 2
      ;;
    h)
      gray "Example usage:"
      echo
      echo "  sh $0 [-u USER] [-e EMAIL]"
      echo
      gray "Options:"
      echo
      echo "  -u [user]           set user for global git config"
      echo "  -e [email]          set email for global git config and ssh keys"
      echo "  -r                  replace $app with remote"
      echo "  -D                  delete $app and exit"
      echo "  -h                  show this message"
      echo
      gray "App settings:"
      echo
      echo "  $app"
      echo
      gray "Documentation:"
      echo
      echo "  $repo"
      echo
      exit 2
      ;;
  esac
done

init() {
  put_header

  echo "Let's start with getting Homebrew"

  if ! type brew &>/dev/null; then
    item "https://brew.sh"

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    item "Already exists... skipping"
  fi

  echo

  get_command_line_tools
  get_repo

  echo "Updating brew packages"
  item "Using $app/brewfile"

  brew upgrade &>/dev/null;
  brew bundle --file="$app/brewfile" &>/dev/null;
  brew cleanup &>/dev/null;

  item "Cleaning up"
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
    item "Cloning to $app"

    mkdir -p $app
    git clone $repo $app &>/dev/null;
  else
    item "$app exists... skipping"
  fi

  echo
}

config_git() {
  echo "Configuring global git"

  if ! [ -f ~/.gitconfig ]; then
    item "Setting general information"
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

    item "Adding aliases: [ch]eckout [br]anch [st]atus"

    git config --global alias.ch checkout
    git config --global alias.br branch
    git config --global alias.st status
  else
    item "Already exists... skipping"
  fi

  echo
}

config_ssh() {
  echo "Configuring ssh keys"

  if ! [ -f ~/.ssh/id_rsa ]; then
    if [[ -z ${git_email} ]]; then
      item "Generating key with git email"
      ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N "" -C $git_email
    else
      item "Generating key with computer hostname"
      ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N ""
    fi

    pbcopy < ~/.ssh/id_rsa.pub

    item "Public key copied to clipboard"
    item "Saved to ~/.ssh/id_rsa.pub"
  else
    item "Already exists... skipping"
  fi

  echo
}

config_shell() {
  echo "Configuring shells"

  if [ -x /usr/local/bin/elvish ]; then
    item "Copying elvish settings"
    cp -r $app/.elvish ~/
  fi

  item "Copying zsh settings"
  cp $app/.zshrc ~/
  echo
}

config_apps() {
  echo "Updating app preferences"
  
  if [ $(which hyper) ]; then
    item "Copying Hyper settings"
    cp -r $app/.hyper.js ~/
  fi

  item "Copying Vim settings"
  cp -r $app/.vimrc ~/

  if [ $(which nvim) ]; then
    item "Sharing Vim settings with NeoVim"
    mkdir -p ~/.config/nvim
    echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after" > ~/.config/nvim/init.vim
    echo "let &packpath=&runtimepath" >> ~/.config/nvim/init.vim
    echo "source ~/.vimrc" >> ~/.config/nvim/init.vim
  fi

  if [ $(which code) ]; then
    item "Copying VSCode settings"
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
    item "Copying VSCode Insiders settings"
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
    item "Copying Sublime Text settings"
    mkdir -p ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
    cp -r $app/subl/ ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
  fi

  echo
}

config_prefs() {
  echo "Configuring system preferences"

  item "Copying SF Mono to Font Book"
  cp -r /System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts/. /Library/Fonts/

  item "Modifying dock preferences"
  # Dock: enable autohide
  defaults write com.apple.dock autohide -bool true
  # Dock: hide recent apps
  defaults write com.apple.dock show-recents -bool false
  # Dock: show only active apps
  defaults write com.apple.dock static-only -bool true
  
  item "Modifying keyboard preferences"
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

  item "Modifying trackpad preferences"
  # Trackpad: enable tap to click (this user and login screen)
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  # Trackpad: increase tracking speed
  defaults write -g com.apple.trackpad.scaling 3

  item "Modifying finder preferences"
  # Finder: disable warning on file extension change
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
  # Finder: disable warning when emptying trash
  defaults write com.apple.finder WarnOnEmptyTrash -bool false

  item "Modifying menubar preferences"
  # Menubar: show battery percentage
  defaults write com.apple.menuextra.battery ShowPercent -string "YES"

  echo
}

woohoo() {
    green "Done. Stay humble, stay hopeful."
    echo
}

if [ $(uname) == "Darwin" ]; then
    init
else
    put_header

    echo "Unsupported OS: $(uname)"
    exit 1
fi