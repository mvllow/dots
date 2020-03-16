export GPG_TTY=/dev/tty
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

PROMPT='%~> '

if (( $+commands[nvim] )); then
  alias vi='nvim'
fi

if (( $+commands[code-insiders] )); then
  alias code='code-insiders'
fi

alias chop='git branch --merged | egrep -v "(^\*|master)" | xargs git branch -d'

# Spawn custom shell
# Useful if you want to avoid changing the default shell
#
# SHELL=/usr/local/bin/elvish
# [ -x $SHELL ] && exec $SHELL
