#!/bin/zsh

# Warning, this script is untested and most likely unfinished.

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
    xcode-select --install > /dev/null 2>&1;

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
        git clone $repo $app > /dev/null 2>&1;
    else
        echo "It looks like you already have the repo locally."
        color_grey "To use the remote branch, remove $app"
        echo
    fi

    get_homebrew
}

get_homebrew() {
    if ! type brew > /dev/null 2>&1; then
        echo "Before we change any preferences, let's install Homebrew to manage our packages."
        color_grey "Learn more about Homebrew at https://brew.sh"
        echo

        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    echo "Updating Homebrew packages..."
    color_grey "Using $app/brewfile"
    echo

    brew upgrade > /dev/null 2>&1;
    brew bundle --file="$app/brewfile" > /dev/null 2>&1;
    brew cleanup > /dev/null 2>&1;

    echo "If you have existing formulae, you may decide to purge anything not listed in the brewfile:"
    color_grey "$ brew bundle cleanup --file=\"$app/brewfile\" --force"
    echo

    get_node_packages
}

get_node_packages() {
    echo "Updating Node packages..."
    color_grey "Probably located in /usr/local/lib (check via npm list -g --depth=0)"
    echo

    npm upgrade -g > /dev/null 2>&1;
    npm install -g pure-prompt now > /dev/null 2>&1;
}

config_git() {
  if ! [ -f ~/.gitconfig ]; then
    # echo "- Creating global git config"
    # read -p "> Name for git: " git_name
    # read -p "> Email for git: " git_email

    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    git config --global core.editor "nvim"
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.st status
  fi

}

if [ $(uname) == "Darwin" ]; then
    init
else
    echo "Unsupported OS: $(uname)"
    exit 1
fi
