function set-theme -a theme
    set -q THEME; or use-terminal-colors
    set -U THEME $theme

    set dark_theme rose-pine
    set light_theme rose-pine-dawn

    dark-mode status | read dark_mode_status

    switch $theme
        case system
            if [ "$dark_mode_status" = on ]
                set -U THEME $dark_theme
            else
                set -U THEME $light_theme
            end
        case meno-luna
        case rose-pine
        case rose-pine-moon
            dark-mode on
        case meno-sole
        case rose-pine-dawn
            dark-mode off
        case ''
            if [ "$dark_mode_status" = on ]
                set -U THEME $light_theme
                dark-mode off
            else
                set -U THEME $dark_theme
                dark-mode on
            end
        case '*'
            set -U THEME $dark_theme
            dark-mode on
    end

    if type -q kitty
        # Manually change kitty theme to local variant
        # Requires `allow_remote_control yes` in your kitty.conf
        kitty @ set-colors --all --configured "$HOME/.config/kitty/themes/$THEME.conf"

        sed -i "" -e \
            "s/include themes\/.*\.conf/include themes\/$THEME.conf/" \
            "$HOME/.config/kitty/kitty.conf"

        # Use kitten to set theme
        # Syntax may differ, eg. rose-pine becomes Rosé Pine
        # kitty +kitten themes --reload-in=all "$THEME"
    end
end

function use-terminal-colors
    # syntax highlighting variables
    # https://fishshell.com/docs/current/interactive.html#syntax-highlighting-variables
    set -U fish_color_normal normal
    set -U fish_color_command magenta
    set -U fish_color_keyword blue
    set -U fish_color_quote yellow
    set -U fish_color_redirection green
    set -U fish_color_end brblack
    set -U fish_color_error red
    set -U fish_color_param cyan
    set -U fish_color_comment brblack
    set -U fish_color_selection --reverse
    set -U fish_color_operator normal
    set -U fish_color_escape green
    set -U fish_color_autosuggestion brblack
    set -U fish_color_cwd cyan
    set -U fish_color_user yellow
    set -U fish_color_host blue
    set -U fish_color_host_remote magenta
    set -U fish_color_cancel normal
    set -U fish_color_search_match --background=black
    set -U fish_color_valid_path

    # pager color variables
    # https://fishshell.com/docs/current/interactive.html#pager-color-variables
    set -U fish_pager_color_progress cyan
    set -U fish_pager_color_background
    set -U fish_pager_color_prefix blue
    set -U fish_pager_color_completion normal
    set -U fish_pager_color_description normal
    set -U fish_pager_color_selected_background --reverse
    set -U fish_pager_color_selected_prefix
    set -U fish_pager_color_selected_completion
    set -U fish_pager_color_selected_description
    set -U fish_pager_color_secondary_background
    set -U fish_pager_color_secondary_prefix blue
    set -U fish_pager_color_secondary_completion normal
    set -U fish_pager_color_secondary_description normal
end