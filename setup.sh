#!/bin/sh

app_dir=$(mktemp -d)
app_repo=https://github.com/mvllow/dots.git
app_config=~/.config/mvllow/dots

subl_user_dir=$HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
code_user_dir=$HOME/Library/Application\ Support/Code/User
code_beta_user_dir=$HOME/Library/Application\ Support/Code\ -\ Insiders/User

blue_text() { echo "\033[0;96m$1\033[0m" ; }
green_text() { echo "\033[0;92m$1\033[0m" ; }
grey_text() { echo "\033[0;90m$1\033[0m" ; }

init() {
  clear
  echo
  blue_text "Minimalist developer"
  grey_text "by @mvllow"
  echo
  echo "- Cloning mvllow/dots → temp dir"
  mkdir -p "$app_config"
  git clone https://github.com/mvllow/dots.git $app_dir > /dev/null 2>&1;
}

get_command_line_tools() {
  if ! [ $(xcode-select -p) ]; then
    echo "- Installing command line tools"
    xcode-select --install > /dev/null 2>&1;
    read -p "> Please wait until finished, then enter to continue... "
  else
    grey_text "- (skipping) Installing command line tools"
  fi
}

get_homebrew() {
  if ! [ brew ]; then
    echo "- Installing homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    grey_text "- (skipping) Installing homebrew"
  fi

  echo "- Installing homebrew bundle"
  brew upgrade > /dev/null 2>&1;
  brew bundle --file="$app_dir/brewfile" > /dev/null 2>&1;

  echo "- Cleaning homebrew bundle and packages"
  brew cleanup > /dev/null 2>&1;
  brew bundle cleanup --file="$app_dir/brewfile" --force > /dev/null 2>&1;
}

get_node_packages() {
  echo "- Upgrading global node packages"
  npm upgrade -g > /dev/null 2>&1;
  npm i -g pure-prompt now prettier degit > /dev/null 2>&1;
}

prepare_git() {
  if ! [ -f ~/.gitconfig ]; then
    echo "- Creating global git config"
    read -p "> Name for git: " git_name
    read -p "> Email for git: " git_email

    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    git config --global core.editor "nvim"
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.st status
  else
    grey_text "- (skipping) Generating global git config"
  fi
}

prepare_keys() {
  if ! [ -f ~/.ssh/id_rsa ]; then
    echo "- Generating ssh keys"

    if ! [ -z $git_email ]; then
      read -p "> Email for ssh: " git_email
    fi

    ssh-keygen -t rsa -b 4096 -C "$git_email" -N "" -f ~/.ssh/id_rsa
    pbcopy < ~/.ssh/id_rsa.pub
  else
    grey_text "- (skipping) Generating ssh keys"
  fi
}

set_app_prefs() {
  echo "- Configuring app preferences"
  cp -r "$app_dir/.zshrc" ~/.zshrc
  cp -r "$app_dir/.vimrc" ~/.vimrc

  if [ $(which hyper) ]; then
    cp -r "$app_dir/.hyper.js" ~/.hyper.js
  fi

  if ! [ -e ~/.vim/pack/minpac ]; then
    git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac
  fi

  if [ $(which nvim) ]; then
    mkdir -p ~/.config/nvim
    echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after" > ~/.config/nvim/init.vim
    echo "let &packpath=&runtimepath" >> ~/.config/nvim/init.vim
    echo "source ~/.vimrc" >> ~/.config/nvim/init.vim
  fi

  if [ $(which code) ]; then
    mkdir -p "$code_user_dir"
    cp "$app_dir/vscode/settings.json" "$code_user_dir/settings.json"

    code --install-extension dbaeumer.vscode-eslint > /dev/null 2>&1;
    code --install-extension esbenp.prettier-vscode > /dev/null 2>&1;
    code --install-extension jamesbirtles.svelte-vscode > /dev/null 2>&1;
    code --install-extension joshpeng.sublime-babel-vscode > /dev/null 2>&1;
    code --install-extension juliettepretot.lucy-vscode > /dev/null 2>&1;
    code --install-extension tyriar.sort-lines > /dev/null 2>&1;
    code --install-extension vscodevim.vim > /dev/null 2>&1;
  fi
  
  if [ $(which code-insiders) ]; then
    mkdir -p "$code_beta_user_dir"
    cp "$app_dir/vscode/settings.json" "$code_beta_user_dir/settings.json"

    code-insiders --install-extension dbaeumer.vscode-eslint > /dev/null 2>&1;
    code-insiders --install-extension esbenp.prettier-vscode > /dev/null 2>&1;
    code-insiders --install-extension jamesbirtles.svelte-vscode > /dev/null 2>&1;
    code-insiders --install-extension joshpeng.sublime-babel-vscode > /dev/null 2>&1;
    code-insiders --install-extension juliettepretot.lucy-vscode > /dev/null 2>&1;
    code-insiders --install-extension tyriar.sort-lines > /dev/null 2>&1;
    code-insiders --install-extension vscodevim.vim > /dev/null 2>&1;
  fi

  if [ $(which subl) ]; then
    mkdir -p "$subl_user_dir"
    cp "$app_dir/sublime/keymap.json" "$subl_user_dir/Default\ \(OSX\).sublime-keymap"
    cp "$app_dir/sublime/packages.json" "$subl_user_dir/Package\ Control.sublime-settings"
    cp "$app_dir/sublime/settings.json" "$subl_user_dir/Preferences.sublime-settings"
  fi
}

set_system_prefs() {
  echo "- Configuring system preferences"
  cp -R /System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts/. /Library/Fonts/

  # Dock: clear existing icons
  defaults write com.apple.dock persistent-apps -array
  # Dock: enable autohide
  defaults write com.apple.dock autohide -bool true
  # Dock: decrease size
  defaults write com.apple.dock tilesize -int 40
  # Dock: pin to left
  defaults write com.apple.dock pinning -string start
  # Dock: hide recent apps
  defaults write com.apple.dock show-recents -bool false
  # Dock: show only active apps
  defaults write com.apple.dock static-only -bool true
  # Dock: minimise windows into app icon
  defaults write com.apple.dock minimize-to-application -bool true
  
  # Keyboard: disable auto correct
  defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
  # Keyboard: disable auto capitilise
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
  # Keyboard: disable smart dashes
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
  # Keyboard: disable smart quotes
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  # Keyboard: enable key repeeat
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

  # Finder: keep folders on top when sorting by name
  defaults write com.apple.finder _FXSortFoldersFirst -bool true
  # Finder: disable warning on file extension change
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
  # Finder: disable warning when emptying trash
  defaults write com.apple.finder WarnOnEmptyTrash -bool false
  # Finder: disable app quarantine popup
  defaults write com.apple.LaunchServices LSQuarantine -bool false

  # Menubar: show battery percentage
  defaults write com.apple.menuextra.battery ShowPercent -string "YES"
}

init
get_command_line_tools
get_homebrew
get_node_packages
prepare_git
prepare_keys
set_app_prefs
set_system_prefs

echo
green_text "Complete, woo! Please log out to ensure all changes apply."
