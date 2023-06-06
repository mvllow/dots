#!/usr/bin/env bash

# If only one file
# If file starts with init, e.g. init.lua
# If file starts with config, e.g. config.toml
# If file starts with settings, e.g. settings.yml
# If file starts with setup, e.g. setup.sh
# If file starts with folder name, e.g. kitty.conf
#   - We do this one later to avoid conflicts such as detecting fish_variables over config.fish

folders=$(ls "$HOME/.config" | tr ' ' '\n')
selected=$(printf "$folders" | fzf --color=bw)
files=$(ls "$HOME/.config/$selected" | tr ' ' '\n')

if [ $(echo "$files" | wc -l) = 1 ]; then
	filename=$(echo "$files" | tail -1)
	nvim "$HOME/.config/$selected/$filename" -c 'lcd %:p:h'
elif $(echo "$files" | grep -qe "^init"); then
	filename=$(echo "$files" | grep -e "^init" | tail -1)
	nvim "$HOME/.config/$selected/$filename" -c 'lcd %:p:h'
elif $(echo "$files" | grep -qe "^config"); then
	filename=$(echo "$files" | grep -e "^config" | tail -1)
	nvim "$HOME/.config/$selected/$filename" -c 'lcd %:p:h'
elif $(echo "$files" | grep -qe "^settings"); then
	filename=$(echo "$files" | grep -e "^settings" | tail -1)
	nvim "$HOME/.config/$selected/$filename" -c 'lcd %:p:h'
elif $(echo "$files" | grep -qe "^setup"); then
	filename=$(echo "$files" | grep -e "^setup" | tail -1)
	nvim "$HOME/.config/$selected/$filename" -c 'lcd %:p:h'
elif $(echo "$files" | grep -qe "^$selected"); then
	filename=$(echo "$files" | grep -e "^$selected" | tail -1)
	nvim "$HOME/.config/$selected/$filename" -c 'lcd %:p:h'
else
	nvim "$HOME/.config/$selected" -c "Telescope find_files"
fi
