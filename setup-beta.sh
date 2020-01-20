#!/bin/sh

app=~/.config/mvllow/dots
repo=https://github.com/mvllow/dots.git

while getopts u:e:h option; do
  case "${option}" in
    u) git_user=${OPTARG};;
    e) git_email=${OPTARG};;
    h)
      echo "Example usage:"
      echo "$0 [-u GIT USERNAME] [-e EMAIL]" >&2
      echo
      exit 2
      ;;
  esac
done

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

  if ! type brew &>/dev/null; then
    echo "Let's start with getting Homebrew"
    color_grey "https://brew.sh"
    echo
    echo "This will prompt to install command line tools if necessary"
    echo

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    color_grey "Homebrew already installed... skipping"
    echo
  fi

  get_command_line_tools
  get_repo

  echo "Updating brew packages"
  color_grey "Using $app/brewfile"
  echo

  brew upgrade &>/dev/null;
  brew bundle --file="$app/brewfile" &>/dev/null;
  brew cleanup &>/dev/null;

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
  if ! [ -e $app ]; then
    echo "Fetching remote repo"
    color_grey "Cloning to $app"
    echo

    mkdir -p $app
    git clone $repo $app &>/dev/null;
  else
    color_grey "$app exists... skipping"
    echo
  fi
}

config_git() {
  if ! [ -f ~/.gitconfig ]; then
    if [[ -z ${git_user} ]]; then
      git config --global user.name "$git_user"
    fi

    if [[ -z ${git_email} ]]; then
      git config --global user.email "$git_email"
    fi

    if ! type nvim &>/dev/null; then
      git config --global core.editor "nvim"
    else
      git config --global core.editor "vim"
    fi

    echo "Adding git aliases"
    color_grey "[ch]eckout [br]anch [st]atus"

    git config --global alias.ch checkout
    git config --global alias.br branch
    git config --global alias.st status
    echo
  else
    color_grey "Global git config found... skipping"
    echo
  fi
}

config_ssh() {
  if ! [ -f ~/.ssh/id_rsa ]; then
    if [[ -z ${git_email} ]]; then
      ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N "" -C $git_email
    else
      ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N ""
    fi

    pbcopy < ~/.ssh/id_rsa.pub

    echo "Public key has been copied to your clipboard"
    color_grey "Your key can be found at ~/.ssh/id_rsa.pub"
    echo
  else
    color_grey "Local ssh keys found... skipping"
    echo
  fi
}

config_shell() {
  echo "By default, Catalina now uses zsh instead of bash"
  echo "If elvish was installed via brew, we will configure that as well"
  echo

  if [ -x /usr/local/bin/elvish ]; then
    cp -r $app/.elvish ~/
  fi

  cp $app/.zshrc ~/
}

config_apps() {
  echo "Updating app preferences"
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
}

config_prefs() {
  echo "Exposing SF Mono, making it accessibile via Font Book"
  cp -r /System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts/. /Library/Fonts/
  echo

  echo "Updating system preferences"
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