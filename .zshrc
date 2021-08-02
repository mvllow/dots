prompt='%~> '

export PATH=/opt/homebrew/bin:$PATH
export EDITOR='nvim'
export XDG_CONFIG_HOME="$HOME/.config"

# Set prefixed alias for quick edit app configs
#
# @param $1 name
# @param $2 config path
# @param $3 config file
# @usage set_config_alias kitty ~/.config/kitty kitty.conf
set_config_alias() {
	alias ,$1="$EDITOR $2/$3 +'lcd $2'"
}

set_config_alias fish ~/.config/fish config.fish
set_config_alias kitty ~/.config/kitty kitty.conf
set_config_alias nvim ~/.config/nvim conf.lua
set_config_alias vim ~/ .vimrc
set_config_alias zsh ~/ .zshrc

alias chop="git branch --merged | egrep -v \"(^\*|master|main)\" | xargs git branch -d"
alias p=pnpm
alias px=pnpx

# Upload file to 0x0
#
# @usage 0x0 notes.txt
0x0() {
	curl -F "file=@$1" https://0x0.st | tee >(pbcopy)
	echo "(Copied to clipboard)"
}

# Clone and enter repo
#
# @param $1 repo
# @param $... git clone flags
# @usage clone mvllow/dots
# @usage clone mvllow/dots new-folder-name
clone() {
	author=${1%/*}
	repo=${1##*/}

	git clone git@github.com:$author/$repo.git ${@:2}

	if [ -n "$2" ]; then
		cd $2
	else
		cd $repo
	fi
}

# Clean neovim swap files
#
# @usage clean_swap
clean_swap() {
	echo "Purging ~/.local/share/nvim/swap"
	rm -rf ~/.local/share/nvim/swap
}

# Set kitty theme
#
# @param $1 theme name (rose-pine[-moon|-dawn])
# @usage set_kitty_theme rose-pine
set_kitty_theme() {
	file="$HOME/.config/kitty/kitty.conf"
	decorator="@theme"
	starts_with="include"
	replace_with="include $1.conf"

	# Update theme for active sessions
	kitty @ set-colors --all --configured ~/.config/kitty/$1.conf

	# Update config for persistence
	sed -i '' -e "/$decorator/ {" -e "n; s/$starts_with.*/$replace_with/" -e "}" $file
}

# Set neovim theme
#
# @param $1 theme variant (base|moon|dawn)
# @usage set_neovim_theme dawn
set_neovim_theme() {
	file="$HOME/.config/nvim/conf.lua"
	starts_with="vim.g.rose_pine_variant"
	replace_with="vim.g.rose_pine_variant = '$1'"

	# Update config for persistence
	sed -i '' -e "s/$starts_with.*/$replace_with/" $file
}

# Toggle theme
#
# @usage toggle_theme
toggle_theme() {
	dark_theme="rose-pine"
	light_theme="rose-pine-dawn"

	theme_file="$HOME/.config/theme.conf"

	# Create default config
	if ! [ -e $theme_file ]; then
		echo "theme=$dark_theme" >$theme_file
	fi

	# Read theme file
	# Eg. `theme=` will set $theme
	while read line; do
		eval "$line"
	done <"$theme_file"

	if [ "$theme" = "$dark_theme" ]; then
		theme=$light_theme
		set_kitty_theme $light_theme
		set_neovim_theme $light_theme
	else
		theme=$dark_theme
		set_kitty_theme $dark_theme
		set_neovim_theme $dark_theme
	fi

	# Update active theme
	sed -i '' -e "s/theme.*/theme=$theme/" $theme_file
}

zle -N toggle_theme
bindkey "^[[108;9u" toggle_theme # super+l

# Enable better, case insensitive completions (eg. dow<tab> = Downloads)
# https://stackoverflow.com/a/24237590
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit
