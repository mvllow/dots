PROMPT='%~> '

alias chop='git branch --merged | egrep -v "(^\*|master)" | xargs git branch -d'

if (( $+commands[fish] )); then
  SHELL=/usr/local/bin/fish
  
  # Spawn custom shell
  # Useful if you want to avoid changing the default shell
  #
  # [ -x $SHELL ] && exec $SHELL
fi
