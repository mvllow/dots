export GPG_TTY=/dev/tty
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

SHELL=/usr/local/bin/elvish
PROMPT='%~> '

[ -x $SHELL ] && exec $SHELL
