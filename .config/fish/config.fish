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
    abbr -a ,music "nvim +'lcd %:p:h' ~/.config/music/list.txt"
    abbr -a ,fish "nvim +'lcd %:p:h' ~/.config/fish/config.fish"
    abbr -a ,foot "nvim +'lcd %:p:h' ~/.config/foot/foot.ini"
    abbr -a ,ghostty "nvim +'lcd %:p:h' ~/.config/ghostty/config"
    abbr -a ,git "nvim +'lcd %:p:h' ~/.config/git/config"
    abbr -a ,lazygit "nvim +'lcd %:p:h' ~/.config/lazygit/config.yml"
    abbr -a ,nvim "nvim +'lcd %:p:h' ~/.config/nvim/init.lua"
    abbr -a ,niri "nvim +'lcd %:p:h' ~/.config/niri/config.kdl"
    abbr -a ,sway "nvim +'lcd %:p:h' ~/.config/sway/config"
    abbr -a ,tmux "nvim +'lcd %:p:h' ~/.config/tmux/tmux.conf"

    abbr -a -c git -c lazygit . -- --git-dir=\$HOME/dots.git --work-tree=\$HOME

    alias tn="tmux new-session -d -s (basename (pwd) | tr . _) -c (pwd); and tmux switch-client -t (basename (pwd) | tr . _)"
end
