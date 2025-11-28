# Set default configuration path locations
# https://wiki.archlinux.org/title/XDG_Base_Directory
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

set -gx EDITOR nvim
set -gx FZF_DEFAULT_OPTS "--no-color --reverse"
set -gx RIPGREP_CONFIG_PATH "$XDG_CONFIG_HOME/ripgrep/config"

fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/go/bin"

if status is-interactive
    set fish_greeting
    set -l session_name (tmux_session_name)

    if not set -q TMUX
        tmux attach 2>/dev/null || tmux new -A -s "$session_name"
    end

    abbr -a ,aerospace "$EDITOR ~/.config/aerospace"
    abbr -a ,direnv "$EDITOR ~/.config/direnv"
    abbr -a ,fish "$EDITOR ~/.config/fish"
    abbr -a ,ghostty "$EDITOR ~/.config/ghostty"
    abbr -a ,git "$EDITOR ~/.config/git"
    abbr -a ,homebrew "$EDITOR ~/.config/homebrew"
    abbr -a ,lazygit "$EDITOR ~/.config/lazygit"
    abbr -a ,music "$EDITOR ~/.config/music"
    abbr -a ,newsboat "$EDITOR ~/.config/newsboat"
    abbr -a ,nvim "$EDITOR ~/.config/nvim"
    abbr -a ,ripgrep "$EDITOR ~/.config/ripgrep"
    abbr -a ,tmux "$EDITOR ~/.config/tmux"

    abbr -a -c git -c lazygit . -- --git-dir=\$HOME/dots.git --work-tree=\$HOME
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

eval "$(/opt/homebrew/bin/brew shellenv)"
