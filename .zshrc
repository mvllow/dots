prompt='%~> '

export PATH=/opt/homebrew/bin:$PATH
export CLICOLOR=1
export EDITOR='nvim'
export XDG_CONFIG_HOME="$HOME/.config"

alias .git="git --git-dir=$HOME/dots.git --work-tree=$HOME"
alias .lazygit="lazygit --git-dir=$HOME/dots.git --work-tree=$HOME"

alias ,kitty="$EDITOR ~/.config/kitty/kitty.conf +'lcd ~/.config/kitty'"
alias ,nvim="$EDITOR ~/.config/nvim/init.lua +'lcd ~/.config/nvim'"
alias ,zsh="$EDITOR ~/.zshrc +'lcd ~/'"

alias chop="git branch --merged | egrep -v '(^\*|master|main)' | xargs git branch -d"

# Upload file to 0x0
#
# @usage 0x0 note.txt
0x0() {
	curl -F "file=@$1" https://0x0.st | tee >(pbcopy)
	echo "(copied to clipboard)\n"
}

# Clone and cd into repo directory
#
# @param $1 repo
# @param $... git clone <repo> flags
# @usage clone mvllow/dots
# @usage clone mvllow/dots new-folder
clone() {
	repo=$1
	name=${repo#*/}

	git clone git@github.com:$repo.git ${@:2}

	if [ -n "$2" ]; then
		cd $2
	else
		cd $name
	fi
}

# Update git remote url
#
# @param $1 repo
# @param $... git remote set-url origin <repo> flags
# @usage set_git_ssh_url mvllow/dots
set_git_ssh_url() {
	repo=$1

	git remote set-url --push origin git@github.com:$repo.git ${@:2}
}

# Remove nvim swap files
clean_swap() {
	echo "purging nvim swap"
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
	# Requires `allow_remote_control yes` in kitty.conf
	kitty @ set-colors --all --configured ~/.config/kitty/$1.conf

	# Update config for persistence
	sed -i '' -e "/$decorator/ {" -e "n; s/$starts_with.*/$replace_with/" -e "}" $file
}

# Set neovim theme
#
# @param $1 theme name (rose-pine[-moon|-dawn])
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
	else
		theme=$dark_theme
	fi

	set_kitty_theme $theme
	set_neovim_theme $theme

	# Update active theme
	sed -i '' -e "s/theme.*/theme=$theme/" $theme_file
}

zle -N toggle_kitty_theme
bindkey "^[[108;9u" toggle_kitty_theme # <super+l>

# Enable better, case insensitive completions
# https://stackoverflow.com/a/24237590
#
# @example `cd dow<tab>` transforms to `cd Downloads`
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit
