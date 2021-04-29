#!/bin/bash

dots=~/.config/dots
configs=("kitty" "fish" "nvim")

mkdir -p $dots
cd $dots

# workspace is clean
if [ -z "$(git status --porcelain)" ]; then 
  rm -rf $dots/brewfile
  brew bundle dump --file=$dots/brewfile

	for i in "${configs[@]}"; do
		if [ $(which $i) ]; then
			mkdir -p ~/.config/$i
			cp -a ~/.config/$i/ $dots/.config/$i/
		fi
	done

  # vscode
  # cp -r ~/Library/Application\ Support/Code/User/settings.json $dots/vscode/settings.json
  # code --list-extensions > $dots/vscode/extensions.txt

  git add .
  git commit -m "✨ sync with local ✨"

# uncommitted changes in workspace
else
    echo "\033[0;31m✕ Working directory has uncommited changes\033[0m"
    echo "\033[0;90m  Please commit changes in $dots\033[0m\n"
fi
