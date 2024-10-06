# Use XDG paths for consolidating configuration locations
# https://wiki.archlinux.org/title/XDG_Base_Directory
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

set -gx EDITOR nvim
set -gx FZF_DEFAULT_OPTS "--color=16"
set -gx GOPATH $XDG_DATA_HOME/go

fish_add_path /opt/homebrew/bin
fish_add_path $HOME/.local/bin
fish_add_path $GOPATH/bin

if not set -q TMUX
    tmux new -A
end

if status is-interactive
    set fish_greeting

    # Open common configuration files
    # $ ,fish
    # > Editing ~/.config/fish/config.fish in Neovim
    set -l configs fish/config.fish ghostty/config git/config lazygit/config.yml nvim/init.lua skhd/skhdrc tmux/tmux.conf yabai/yabairc
    for config in $configs
        set folder_name (string split "/" $config)[1]
        set folder_path "$XDG_CONFIG_HOME/$config"
        abbr ",$folder_name" "nvim $folder_path"
    end

    alias vim nvim
    alias lg lazygit

    abbr ta "tmux attach"
    abbr tn "tmux new -s (basename (pwd))"

    # Helpers to manage our dotfiles bare repo
    # https://github.com/mvllow/dots
    abbr .git "git --git-dir=\$HOME/dots.git --work-tree=\$HOME"
    abbr .lg "lazygit --git-dir=\$HOME/dots.git --work-tree=\$HOME"
end
