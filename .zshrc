export GPG_TTY=$(tty)

if [ nvim ]; then
	alias vi='nvim'
fi

if [ code-insiders ] && ! [ code ]; then
	alias code='code-insiders'
fi

if [ git ]; then
	alias chop='git branch --merged | egrep -v "(^\*|master)" | xargs git branch -d'
fi

# todo: find performant way to check for pure-prompt npm package
# 			`npm list -g` is painfully slow
	autoload -U promptinit; promptinit
	prompt pure

if [ -f ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
	source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
