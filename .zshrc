prompt='%~> '

export PATH=/opt/homebrew/bin:$PATH
export EDITOR='vim'

alias ,vim="$EDITOR ~/.vimrc +'lcd ~'"
alias ,zsh="$EDITOR ~/.zshrc +'lcd ~'"
alias chop="git branch --merged | egrep -v \"(^\*|master|main)\" | xargs git branch -d"