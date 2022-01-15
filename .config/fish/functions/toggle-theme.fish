# Set theme for macOS system, kitty terminal, and fish shell
# https://github.com/mvllow/fun-shell
#
# @requires
# kitty (https://github.com/kovidgoyal/kitty)
# dark-mode (https://github.com/sindresorhus/dark-mode-cli)
#
# @usage
# toggle-theme
# toggle-theme [system|light|dark]

function toggle-theme -a mode
    set dark_theme "Rosé Pine"
    set light_theme "Rosé Pine Dawn"

    set -q THEME; or use-terminal-colors
    set -q THEME; or set -U THEME $dark_theme

    if [ "$mode" = system ]
        dark-mode status | read is_dark

        if [ "$is_dark" = on ]
            set -U THEME "$dark_theme"
        else
            set -U THEME "$light_theme"
        end
    else if [ "$mode" = light ]
        set -U THEME "$light_theme"
        dark-mode off
    else if [ "$mode" = dark ]
        set -U THEME "$dark_theme"
        dark-mode on
    else if [ "$THEME" = "$dark_theme" ]
        set -U THEME "$light_theme"
        dark-mode off
    else
        set -U THEME "$dark_theme"
        dark-mode on
    end

    if type -q kitty
        kitty +kitten themes --reload-in=all "$THEME"
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
