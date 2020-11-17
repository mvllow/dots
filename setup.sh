#!/bin/sh

# --- START USER CONFIG ---

# General
app=~/.config/dots
repo=https://github.com/mvllow/dots

use_homebrew=true
brewfile=$app/brewfile

# These depend on an email address (usually the same as your Git[Hub/Lab/etc] account)
# Uncomment the below line to hardcode your email or pass it via the [-e] flag
# git_ssh_email=you@example.com
maybe_config_git=true
# Only tries if ~/.ssh/id_rsa doesn't already exists
# If no email is provided, your computer's hostname will be used instead
maybe_config_ssh=true

# Copy preferences from repo for supported apps
config_installed_apps=true

# Changes macOS system preferences
# Defaults can be found at https://github.com/mvllow/dots
config_os_prefs=true

# --- END USER CONFIG ---

# echo text with blank line above
echo_title() {
  echo "\n$1"
}

# echo gray text
echo_subtitle() {
  echo "\033[0;90m$1\033[0m"
}

# flags
# a letter followed by `:` accepts an argument
while getopts e:rDh option; do
  case "${option}" in
    e) git_ssh_email=${OPTARG};;
    r) rm -rf $app;;
    D)
      rm -rf $app
      exit 2
      ;;
    h)
      clear
      echo_title "Minimalist developer 🌸"
      echo
      echo_subtitle "Example usage:"
      echo
      echo "  sh $0 [-e EMAIL]"
      echo
      echo_subtitle "Options:"
      echo
      echo "  -e [email]          set email for global git config and ssh keys"
      echo "  -r                  replace $app with remote"
      echo "  -D                  delete $app and exit"
      echo "  -h                  show this message"
      echo
      echo_subtitle "App settings:"
      echo
      echo "  $app"
      echo
      echo_subtitle "Documentation:"
      echo
      echo "  $repo"
      echo
      exit 2
      ;;
  esac
done

get_command_line_tools() {
  if ! [ $(xcode-select --print-path) ]; then
    xcode-select --install &>/dev/null;

    sleep 3
    
    get_command_line_tools
  fi
}

clear
echo_title "Minimalist developer 🌸"

# if using macOS
if [ $(uname) == "Darwin" ]; then
  # if xcode command line tools don't exist
  if ! [ $(xcode-select --print-path) ]; then
    echo_title "Installing Command Line Tools"

    get_command_line_tools
  fi

  # if $app directory doesn't exist
  if ! [ -e $app ]; then
    echo_title "Cloning remote repo"
    echo_subtitle "$repo -> $app"

    mkdir -p $app
    git clone $repo $app &>/dev/null;
  else
    echo_title "Using local repo"
    echo_subtitle "$app"
  fi

  if [ "$use_homebrew" = true ]; then
    # if brew doesn't exist
    if [ ! type brew &>/dev/null; then
      echo_title "Installing Homebrew"
      echo_subtitle "https://brew.sh"

      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi

    echo_title "Installing Homebrew packages"
    echo_subtitle "Using $brewfile"

    brew upgrade &>/dev/null;
    echo
    brew bundle --file="$brewfile"
    echo
    brew cleanup &>/dev/null;
  fi

  if [ "$maybe_config_git" = true ]; then
    # if $git_ssh_email isn't null
    if ! [ -z ${git_ssh_email} ]; then
      echo_title "Configuring global git"
      echo_subtitle "Adding aliases:"
      echo_subtitle "  co   -> checkout"
      echo_subtitle "  br   -> branch"
      echo_subtitle "  st   -> status"
      echo_subtitle "  lola -> log --graph --decorate --pretty=oneline --abbrev-commit --all"

      git config --global user.email "$git_ssh_email"
      git config --global alias.co checkout
      git config --global alias.br branch
      git config --global alias.st status
      git config --global alias.lola "log --graph --decorate --pretty=oneline --abbrev-commit --all"

      # if nvim exists
      if type nvim &>/dev/null; then
        git config --global core.editor "nvim"
      else
        git config --global core.editor "vim"
      fi
    else
      echo_title "Skipping git config: no email found"
      echo_subtitle "Try again with -e you@domain.com"
    fi
  fi

  if [ "$maybe_config_ssh" = true ]; then
    # if ~/.ssh/id_rsa file doesn't exist
    if ! [ -f ~/.ssh/id_rsa ]; then
      # if $git_ssh_email isn't null
      if ! [ -z ${git_ssh_email} ]; then
        ssh-keygen -t rsa -b ed25519 -f ~/.ssh/id_rsa -q -N "" -C $git_ssh_email
      else
        ssh-keygen -t rsa -b ed25519 -f ~/.ssh/id_rsa -q -N ""
      fi
    else
      echo_title "Skipping ssh config: key exists"
    fi

    echo_title "Public key copied to clipboard"
    echo_subtitle "~/.ssh/id_rsa.pub"

    pbcopy < ~/.ssh/id_rsa.pub
  fi

  if [ "$config_installed_apps" = true ]; then
    echo_title "Configuring installed apps"

    if [ $(which zsh) ]; then
      echo_subtitle "Copying Zsh settings"
      cp -r $app/.zshrc ~/
    fi

    if [ $(which hyper) ]; then
      echo_subtitle "Copying Hyper settings"
      cp -r $app/.hyper.js ~/
    fi


    # if ~/.vimrc file doesn't exist
    if ! [ -f ~/.vimrc ]; then
      echo_subtitle "Copying Vim settings"
      cp -r $app/.vimrc ~/
    fi

    if [ $(which nvim) ]; then
      # if ~/.config/nvim/init.vim file doesn't exist
      if ! [ -f ~/.config/nvim/init.vim]; then
          echo_subtitle "Sharing Vim settings with NeoVim"

          mkdir -p ~/.config/nvim
          echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after" > ~/.config/nvim/init.vim
          echo "let &packpath=&runtimepath" >> ~/.config/nvim/init.vim
          echo "source ~/.vimrc" >> ~/.config/nvim/init.vim
      fi
    fi


    if [ $(which code) ]; then
      echo_subtitle "Copying VSCode settings"

      mkdir -p ~/Library/Application\ Support/Code/User
      cp $app/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json

      code --install-extension bradlc.vscode-tailwindcss &>/dev/null;
      code --install-extension dbaeumer.vscode-eslint &>/dev/null;
      code --install-extension esbenp.prettier-vscode &>/dev/null;
      code --install-extension ms-vsliveshare.vsliveshare &>/dev/null;
      code --install-extension mvllow.rose-pine &>/dev/null;
      code --install-extension octref.vetur &>/dev/null;
      code --install-extension sdras.night-owl &>/dev/null;
      code --install-extension vscodevim.vim &>/dev/null;
    fi

    if [ $(which code-insiders) ]; then
      echo_subtitle "Copying VSCode Insiders settings"

      mkdir -p ~/Library/Application\ Support/Code\ -\ Insiders/User
      cp $app/vscode/settings.json ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json

      code-insiders --install-extension bradlc.vscode-tailwindcss &>/dev/null;
      code-insiders --install-extension dbaeumer.vscode-eslint &>/dev/null;
      code-insiders --install-extension esbenp.prettier-vscode &>/dev/null;
      code-insiders --install-extension ms-vsliveshare.vsliveshare &>/dev/null;
      code-insiders --install-extension mvllow.rose-pine &>/dev/null;
      code-insiders --install-extension octref.vetur &>/dev/null;
      code-insiders --install-extension sdras.night-owl &>/dev/null;
      code-insiders --install-extension vscodevim.vim &>/dev/null;
    fi

    if [ $(which subl) ]; then
      echo_subtitle "Copying Sublime Text v3 settings"

      mkdir -p ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
      cp -r $app/sublime/keymap.json ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Default\ \(OSX\).sublime-keymap
      cp -r $app/sublime/packages.json ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Package\ Control.sublime-settings
      cp -r $app/sublime/settings.json ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings
    fi

    # Uncomment below to download sublime text v4
    # sublime_v4_url=https://download.sublimetext.com/sublime_text_build_4074_mac.zip
    # curl -sS $sublime_v4_url > sublime_text_4.zip
    # unzip sublime_text_4.zip
    # rm sublime_text_4.zip
    # mv "Sublime Text.app" /Applications
    # ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
  fi

  if [ "$config_os_prefs" = true ]; then
    echo_title "Configuring macOS preferences"
    echo_subtitle "Copying SF Mono to Font Book"

    cp -r /System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts/. /Library/Fonts/

    echo_subtitle "Modifying system defaults"
    # Dock: enable autohide
    defaults write com.apple.dock autohide -bool true
    # Dock: hide recent apps
    defaults write com.apple.dock show-recents -bool false
    # Dock: show only active apps
    defaults write com.apple.dock static-only -bool true
    
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
  fi
else
  echo_title "Unsupported OS"
  echo_subtitle "$(uname)"

  echo_title "Linux (testing on elementaryOS) support will come soon :)"
  exit 1
fi
