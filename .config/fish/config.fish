set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config

fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/opt/ruby/bin

if status is-interactive
    set fish_greeting '🐟'

    function fish_prompt
        set -g fish_prompt_pwd_dir_length 0
        printf '%s%s> ' (prompt_pwd) (set_color yellow; fish_git_prompt; set_color normal)
    end
end

# Set directory to buffer location for current session
set lcd "+'lcd %:p:h'"

# Quickly jump to config files
alias ,fish "nvim ~/.config/fish/config.fish $lcd"
alias ,kitty "nvim ~/.config/kitty/kitty.conf $lcd"
alias ,nvim "nvim ~/.config/nvim/init.lua $lcd"

# Custom git command for our dotfiles
alias .git "git --git-dir=$HOME/dots.git --work-tree=$HOME"
alias .lazygit "lazygit --git-dir=$HOME/dots.git --work-tree=$HOME"

# Custom bindings
bind \e\[108\;9u toggle-theme # <super+l>
