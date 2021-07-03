export PROMPT='%~> '
export PATH=/opt/homebrew/bin:~/.cargo/bin:$PATH

export EDITOR='vim'
if [ $(which nvim) ]; then
  export EDITOR='nvim'
fi

# Set prefixed alias for quick edit app configs
# @args $1 = name | $2 = config path | $3 = config file
# @example set_config_alias kitty ~/.config/kitty kitty.conf
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
# @example 0x0 notes.txt
0x0() {
	curl -F"file=@$1" https://0x0.st | tee >(pbcopy)
	echo "(Copied to clipboard)"
}

# Clone and enter repo
# @args $1 = repo | $... passed as `git clone` flags
# @example clone mvllow/dots
# @example clone mvllow/dots new-folder-name
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
# @example clean_swap
clean_swap() {
	echo "Purging ~/.local/share/nvim/swap"
	rm -rf ~/.local/share/nvim/swap
}

# Set Rosé Pine variant for kitty and neovim
# TODO update for general purpose variant switcher
# @example set_theme
# @example set_theme dawn
set_theme() {
	if [ "$1" = "dawn" ]; then
		variant="dawn"
		kitty_theme_file="rose-pine-dawn.conf"
	elif [ "$1" = "moon" ]; then
		variant="moon"
		kitty_theme_file="rose-pine-moon.conf"
	else
		variant="base"
		kitty_theme_file="rose-pine.conf"
	fi

	# Set kitty theme
	# This requires `allow_remote_control yes` in your kitty config
	kitty @ set-colors --all --configured ~/.config/kitty/$kitty_theme_file

	# Update kitty.conf with new theme for persistence
	# Assumes `include rose-pine.conf` or similar on first line
	# See https://github.com/mvllow/kitty/blob/main/kitty.conf#L1
	sed -i "" "1s/rose-pine.*\.conf/$kitty_theme_file/" ~/.config/kitty/kitty.conf

	# Set neovim theme
	# Assumes `vim.g.rose_pine_variant` on second line of conf.lua
	# See https://github.com/mvllow/nvim/blob/main/conf.lua#L2
	sed -i "" "2s/.*/vim.g.rose_pine_variant = '$variant'/" ~/.config/nvim/conf.lua
}

# Enable better, case insensitive completions (eg. dow = Downloads)
# https://stackoverflow.com/a/24237590
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

