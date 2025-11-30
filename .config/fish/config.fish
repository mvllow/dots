# Set default configuration path locations
# https://wiki.archlinux.org/title/XDG_Base_Directory
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

set -gx EDITOR nvim
set -gx FZF_DEFAULT_OPTS "--no-color --reverse"

fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/go/bin"

if status is-interactive
    set fish_greeting

    if not set -q TMUX
        tmux attach 2>/dev/null || tmux new -A -s (tmux_session_name)
    end

    alias dots 'git --git-dir=$HOME/.dots.git --work-tree=$HOME'
    alias lazydots 'lazygit --git-dir=$HOME/.dots.git --work-tree=$HOME'

    abbr -a ,aerospace "$EDITOR ~/.config/aerospace"
    abbr -a ,fish "$EDITOR ~/.config/fish"
    abbr -a ,ghostty "$EDITOR ~/.config/ghostty"
    abbr -a ,git "$EDITOR ~/.config/git"
    abbr -a ,homebrew "$EDITOR ~/.config/homebrew"
    abbr -a ,lazygit "$EDITOR ~/.config/lazygit"
    abbr -a ,nvim "$EDITOR ~/.config/nvim"
    abbr -a ,tmux "$EDITOR ~/.config/tmux"
end

eval "$(/opt/homebrew/bin/brew shellenv)"
