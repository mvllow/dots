# Set default configuration path locations
# https://wiki.archlinux.org/title/XDG_Base_Directory
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

set -gx EDITOR nvim
set -gx FZF_DEFAULT_OPTS "--no-color --reverse --tmux center,50%,50%"
set -gx GOPATH $XDG_DATA_HOME/go
set -gx RIPGREP_CONFIG_PATH $XDG_CONFIG_HOME/ripgrep/config

fish_add_path /opt/homebrew/bin
fish_add_path $GOPATH/bin
fish_add_path $HOME/.local/bin

if status is-interactive
    set fish_greeting

    if not set -q TMUX
        tmux attach || tmux new -A -s (basename (pwd) | tr . _)
    end

    abbr -a ,aerospace "nvim -c 'lcd %:p:h' ~/.config/aerospace/aerospace.toml"
    abbr -a ,bin "nvim -c 'lcd %:p:h' ~/.local/bin"
    abbr -a ,fish "nvim -c 'lcd %:p:h' ~/.config/fish/config.fish"
    abbr -a ,ghostty "nvim -c 'lcd %:p:h' ~/.config/ghostty/config"
    abbr -a ,git "nvim -c 'lcd %:p:h' ~/.config/git/config"
    abbr -a ,lazygit "nvim -c 'lcd %:p:h' ~/.config/lazygit/config.yml"
    abbr -a ,nvim "nvim -c 'lcd %:p:h' ~/.config/nvim/init.lua"
    abbr -a ,tmux "nvim -c 'lcd %:p:h' ~/.config/tmux/tmux.conf"

    abbr -a ta tmux attach
    abbr -a tn tmux new -A -s (basename (pwd) | tr . _)
    abbr -a ts tmux-sessions

    abbr -a -c git -c lazygit . -- --git-dir=\$HOME/dots.git --work-tree=\$HOME
end
