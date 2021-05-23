prompt='%~> '

export PATH=/opt/homebrew/bin:.cargo/bin:$PATH
export EDITOR='nvim'

alias ,vim="$EDITOR ~/.vimrc +'lcd ~'"
alias ,nvim="$EDITOR ~/.config/nvim/conf.lua +'lcd ~/.config/nvim'"
alias ,kitty="$EDITOR ~/.config/kitty/kitty.conf +'lcd ~/.config/kitty'"
alias ,elvish="$EDITOR ~/.elvish/rc.elv +'lcd ~/.elvish'"
alias ,fish="$EDITOR ~/.config/fish/config.fish +'lcd ~/.config/fish'"
alias ,zsh="$EDITOR ~/.zshrc +'lcd ~'"

alias p=pnpm
alias px=pnpx

# Chop branches already merged in <branch>
# @example chop develop
chop() {
	branch=$1

	if [ -z "$branch" ]; then
		branch='main'
	fi

	git branch --merged | egrep -v "(^\*|$branch)" | xargs git branch -d
}

# Clone <repo> to ~/dev
# @example clone mvllow/dots
clone() {
	repo=$1

	cd ~/dev
	git clone "git@github.com:$repo.git"
}

# Clear neovim swap files
clean_swap() {
	echo "Purging ~/.local/share/nvim/swap"
	rm -rf ~/.local/share/nvim/swap
}

# Spawn custom shell without changing system defaults
# if (( $+commands[elvish] )); then
#   SHELL=/opt/homebrew/bin/elvish
#   [ -x $SHELL ] && exec $SHELL
# fi
