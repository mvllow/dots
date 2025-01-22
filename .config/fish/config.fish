# Set default configuration path locations
# https://wiki.archlinux.org/title/XDG_Base_Directory
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

set -gx EDITOR nvim
set -gx FZF_DEFAULT_OPTS "--no-color --reverse"
set -gx RIPGREP_CONFIG_PATH $XDG_CONFIG_HOME/ripgrep/config

fish_add_path $HOME/.local/bin
fish_add_path $HOME/go/bin
fish_add_path /opt/homebrew/bin

if status is-interactive
    set fish_greeting

    if not set -q TMUX
        tmux attach || tmux new -A -s (basename (pwd) | tr . _)
    end

    abbr -a ,aerospace "nvim +'lcd %:p:h' ~/.config/aerospace/aerospace.toml"
    abbr -a ,fish "nvim +'lcd %:p:h' ~/.config/fish/config.fish"
    abbr -a ,ghostty "nvim +'lcd %:p:h' ~/.config/ghostty/config"
    abbr -a ,git "nvim +'lcd %:p:h' ~/.config/git/config"
    abbr -a ,lazygit "nvim +'lcd %:p:h' ~/.config/lazygit/config.yml"
    abbr -a ,nvim "nvim +'lcd %:p:h' ~/.config/nvim/init.lua"
    abbr -a ,tmux "nvim +'lcd %:p:h' ~/.config/tmux/tmux.conf"

    abbr -a -c git -c lazygit . -- --git-dir=\$HOME/dots.git --work-tree=\$HOME

    alias tn="tmux new-session -d -s (basename $PWD) -c $PWD; and tmux switch-client -t (basename $PWD)"
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
