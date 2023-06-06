# Use XDG paths
# https://wiki.archlinux.org/title/XDG_Base_Directory
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

set -gx CARGO_HOME $XDG_DATA_HOME/cargo
set -gx GOPATH $XDG_DATA_HOME/go
set -gx LOCAL_BIN $HOME/.local/bin

set -gx EDITOR nvim

# Set binary paths
fish_add_path /opt/homebrew/bin
fish_add_path $CARGO_HOME/bin
fish_add_path $GOPATH/bin
fish_add_path $LOCAL_BIN

set fish_greeting

set_theme system

# Shortcuts to common config files
# Loop through a list of paths, using the part before the "/" as the abbreviation name, prefixed with ","
# @example `,fish` will open this file in $EDITOR
set -l configs 'alacritty/alacritty.yml' 'dots/setup.sh' 'fish/config.fish' git/config 'helix/config.toml' 'kitty/kitty.conf' 'lazygit/config.yml' lf/lfrc 'nvim/init.lua' skhd/skhdrc 'tmux/tmux.conf' yabai/yabairc
for config in $configs
    set app (string split "/" $config)[1]
    abbr ",$app" "$EDITOR ~/.config/$config" # open config file in $EDITOR
end

abbr ta "tmux attach"
abbr tn "tmux new -s (basename (pwd))"

# Git helpers for our dotfiles bare repo
# https://github.com/mvllow/dots
set dotgit_args "--git-dir=\$HOME/dots.git --work-tree=\$HOME"
abbr .git "git $dotgit_args"
abbr .gitls "git $dotgit_args ls-files --others --no-empty-directory --exclude-standard \$XDG_CONFIG_HOME/*"
abbr .lazygit "lazygit $dotgit_args"
