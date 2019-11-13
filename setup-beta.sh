#!/bin/sh

# Warning, this script is untested and most likely unfinished.

app=~/.config/mvllow/dots
repo=https://github.com/mvllow/dots.git

color_grey() {
    echo "\033[0;90m$1\033[0m"
}

init() {
    put_header
    sleep 2
    echo "Let's start by checking for the necessary tools."

    if ! [ $(xcode-select --print-path) ]; then
        echo "We need command line tools for git, brew, and more."
        color_grey "This could take a while, so when the installation finishes press enter to let me know it's done."

        get_command_line_tools
    else
        echo "You already have command line tools, so we can continue."
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
    fi
}

put_header() {
    clear
    echo "Welcome to mvllow/dots 🌸"
    echo
}

# TODO: Call macOS specific ops here and add flag to bypass automatically for initial linux support
if [ $(uname) == "Darwin" ]; then
    init
else
    echo "Unsupported OS: $(uname)"
    exit 1
fi