#!/usr/bin/env sh

file=./Brewfile

mv "$file" "$file.bak"
brew bundle dump --file="$file"
