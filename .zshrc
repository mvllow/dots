export GPG_TTY=$(tty)

if (( $+commands[nvim] )); then
  alias vi='nvim'
fi

if (( $+commands[code-insiders] )); then
  alias code='code-insiders'
fi

autoload -U promptinit; promptinit

PURE_PROMPT_SYMBOL="▲"

prompt pure
