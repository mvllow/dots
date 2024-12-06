# Use XDG paths for consolidating configurations
# https://wiki.archlinux.org/title/XDG_Base_Directory
set -x XDG_CACHE_HOME $HOME/.cache
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_DATA_HOME $HOME/.local/share
set -x XDG_STATE_HOME $HOME/.local/state

set -x EDITOR nvim
set -x FZF_DEFAULT_OPTS --no-color
set -x GOPATH $XDG_DATA_HOME/go

fish_add_path /opt/homebrew/bin
fish_add_path $HOME/.local/bin

if status is-interactive
    if not set -q TMUX
        tmux new -A -s (basename (pwd) | tr . _)
    end

    set fish_greeting

    # Open common configuration files
    set -l configs fish/config.fish ghostty/config git/config lazygit/config.yml nvim/init.lua skhd/skhdrc tmux/tmux.conf yabai/yabairc
    for config in $configs
        set folder_name (string split "/" $config)[1]
        set folder_path "$XDG_CONFIG_HOME/$config"
        abbr ",$folder_name" "nvim $folder_path"
    end

    abbr ",bin" "nvim ~/.local/bin/"

    alias vim nvim

    # Helpers to manage our dotfiles bare repo
    # https://github.com/mvllow/dots
    abbr .git "git --git-dir=\$HOME/dots.git --work-tree=\$HOME"
    abbr .lazygit "lazygit --git-dir=\$HOME/dots.git --work-tree=\$HOME"
end
