set -q XDG_CONFIG_HOME; or set -xg XDG_CONFIG_HOME $HOME/.config
set -gx EDITOR nvim
set -gx LS_COLORS true

fish_add_path /opt/homebrew/bin
fish_add_path $HOME/.cargo/bin

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

# Manage dotfiles
abbr --add .git "git --git-dir=\$HOME/dots.git --work-tree=\$HOME"
abbr --add .lazygit "lazygit --git-dir=\$HOME/dots.git --work-tree=\$HOME"
abbr --add .list "git --git-dir=\$HOME/dots.git --work-tree=\$HOME ls-files --other --no-empty-directory --exclude-standard \$HOME/.config/*"

# Manage cli configs
abbr --add ,amfora "$EDITOR ~/.config/amfora/config.toml -c 'lcd %:p:h'"
abbr --add ,dots "$EDITOR ~/.config/dots/setup.sh -c 'lcd %:p:h'"
abbr --add ,fish "$EDITOR ~/.config/fish/config.fish -c 'lcd %:p:h'"
abbr --add ,git "$EDITOR ~/.config/git/config -c 'lcd %:p:h'"
abbr --add ,kitty "$EDITOR ~/.config/kitty/kitty.conf -c 'lcd %:p:h'"
abbr --add ,lazygit "$EDITOR ~/.config/lazygit/config.yml -c 'lcd %:p:h'"
abbr --add ,nvim "$EDITOR ~/.config/nvim/init.lua -c 'lcd %:p:h'"

# Docker
abbr --add da "docker run --rm -it -p 7655:22 alpine:latest"

bind \e\[108\;9u toggle-theme # <super+l>
