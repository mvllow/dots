# Generated by mvllow/dots

export GPG_TTY=$(tty)

alias vi='nvim'
alias chop='git branch --merged | egrep -v "(^\*|master)" | xargs git branch -d'

autoload -U promptinit; promptinit
prompt pure
