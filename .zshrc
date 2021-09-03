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

toggle_kitty_theme() {
	current_theme=$(awk '$1=="include" {print $2}' "$HOME/.config/kitty/kitty.conf")
	new_theme="rose-pine.conf"

	if [ "$current_theme" = "rose-pine.conf" ]; then
		new_theme="rose-pine-dawn.conf"
	fi

	# Set theme for active sessions. Requires `allow_remote_control yes`
	kitty @ set-colors --all --configured "~/.config/kitty/$new_theme"

	# Update config for persistence
	sed -i '' -e "s/include.*/include $new_theme/" "$HOME/.config/kitty/kitty.conf"
}

zle -N toggle_kitty_theme
bindkey "^[[108;9u" toggle_kitty_theme # <super+l>
