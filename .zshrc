export GPG_TTY=$(tty)

if type nvim > /dev/null 2>&1; then
  alias vi='nvim'
fi

autoload -U promptinit; promptinit
prompt pure
