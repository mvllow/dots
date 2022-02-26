set -q XDG_CONFIG_HOME; or set -xg XDG_CONFIG_HOME $HOME/.config
set -gx EDITOR nvim
set -gx LS_COLORS true
set -gx GOPATH $HOME/go

fish_add_path /opt/homebrew/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $GOPATH/bin

if status is-interactive
    set fish_greeting '🐟'

    toggle-theme system

    function fish_title
        echo (fish_prompt_pwd_dir_length=0 prompt_pwd)
    end

    function fish_prompt
        set -g fish_prompt_pwd_dir_length 0
        printf '%s%s> ' (prompt_pwd) (set_color yellow; fish_git_prompt; set_color normal)
    end
end

abbr --add .git "git --git-dir=$HOME/dots.git --work-tree=$HOME"
abbr --add .lazygit "lazygit --git-dir=$HOME/dots.git --work-tree=$HOME"
abbr --add .list "git --git-dir=$HOME/dots.git --work-tree=$HOME ls-files --other --no-empty-directory --exclude-standard $HOME/.config/*"
abbr --add ,amfora "$EDITOR $XDG_CONFIG_HOME/amfora/config.toml +'lcd %:p:h'"
abbr --add ,emacs "$EDITOR $XDG_CONFIG_HOME/emacs/init.el +'lcd %:p:h'"
abbr --add ,fish "$EDITOR $XDG_CONFIG_HOME/fish/config.fish +'lcd %:p:h'"
abbr --add ,kitty "$EDITOR $XDG_CONFIG_HOME/kitty/kitty.conf +'lcd %:p:h'"
abbr --add ,lazygit "$EDITOR $XDG_CONFIG_HOME/lazygit/config.yml +'lcd %:p:h'"
abbr --add ,nvim "$EDITOR $XDG_CONFIG_HOME/nvim/init.lua +'lcd %:p:h'"
abbr --add clean-nvim-swap "rm -rf $HOME/.local/share/nvim/swap"

bind \e\[108\;9u toggle-theme # <super+l>
