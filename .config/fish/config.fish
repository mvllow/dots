# Set env variables
# For more information on XDG paths:
# https://wiki.archlinux.org/title/XDG_Base_Directory
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

set -gx CARGO_HOME $XDG_DATA_HOME/cargo
set -gx GOPATH $XDG_DATA_HOME/go

set -gx EDITOR nvim

# Set binary paths
fish_add_path /opt/homebrew/bin
fish_add_path $CARGO_HOME/bin
fish_add_path $GOPATH/bin
fish_add_path $HOME/.local/bin

if status is-interactive
    # Remove new shell greeting
    set fish_greeting

    # Match theme to system on start
    theme system

    # Terminal tab title
    function fish_title
        echo (fish_prompt_pwd_dir_length=0 prompt_pwd)
    end

    function fish_prompt
        set -g fish_prompt_pwd_dir_length 0
        printf '%s%s> ' (prompt_pwd) (set_color brblack; fish_git_prompt; set_color normal)
    end
end

# Skip aliased builtins via `command rm` or `builtin rm`
alias ls "ls -a"
alias nvim "nvim -c 'lcd %:p:h' $argv"
alias rm trash

abbr --add ,dots "nvim ~/.config/dots/setup.sh"
abbr --add ,fish "nvim ~/.config/fish/config.fish"
abbr --add ,git "nvim ~/.config/git/config"
abbr --add ,kitty "nvim ~/.config/kitty/kitty.conf"
abbr --add ,lazygit "nvim ~/.config/lazygit/config.yml"
abbr --add ,music "nvim ~/.config/yt-dlp/music.conf"
abbr --add ,nvim "nvim ~/.config/nvim/init.lua"

set dotgit_args "--git-dir=\$HOME/dots.git --work-tree=\$HOME"

abbr --add .git "git $dotgit_args"
abbr --add .lazygit "lazygit $dotgit_args"
abbr --add .ls "git $dotgit_args ls-files --others --no-empty-directory --exclude-standard \$XDG_CONFIG_HOME/*"
