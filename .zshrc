export GPG_TTY=$(tty)
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

if type nvim > /dev/null 2>&1; then
  alias vi='nvim'
fi

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %b'
setopt prompt_subst
PROMPT='%~%F{blue}${vcs_info_msg_0_}%F{reset}> '
