# @dependencies
# dark-mode (https://github.com/sindresorhus/dark-mode)
# @usage
# set_theme
# set_theme system
function set_theme -a theme -d "Set system and terminal theme"
    function _use_terminal_colors
        printf "* Matching terminal colors.\n"

        # Syntax highlighting variables
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

        # Pager color variables
        # https://fishshell.com/docs/current/interactive.html#pager-color-variables
        set -U fish_pager_color_progress cyan
        set -U fish_pager_color_background
        set -U fish_pager_color_prefix blue
        set -U fish_pager_color_completion brblack
        set -U fish_pager_color_description brblack
        set -U fish_pager_color_secondary_background
        set -U fish_pager_color_secondary_prefix
        set -U fish_pager_color_secondary_completion
        set -U fish_pager_color_secondary_description
        set -U fish_pager_color_selected_background
        set -U fish_pager_color_selected_prefix blue
        set -U fish_pager_color_selected_completion white
        set -U fish_pager_color_selected_description white

        # Because this function should only run once, erase after use
        functions -e _use_terminal_colors
    end

    # If we have not set a theme before, ensure fish is using our terminal's
    # palette
    set -q THEME; or _use_terminal_colors

    set dark_status $(dark-mode status)
    set dark_theme rose-pine
    set light_theme rose-pine-dawn

    if test "$dark_status" = on; and test "$THEME" = "$dark_theme"
        set theme_matches_system true
    else if test "$dark_status" = off; and test "$THEME" = "$light_theme"
        set theme_matches_system true
    else
        set theme_matches_system false
    end

    # Match system theme if out of sync
    if test "$theme" = system; or test "$theme_matches_system" = false
        if test "$dark_status" = off
            set -U THEME "$light_theme"
        else
            set -U THEME "$dark_theme"
        end
    else
        set should_toggle_system_dark_mode true

        if test "$THEME" = "$light_theme"
            set -U THEME $dark_theme
        else
            set -U THEME $light_theme
        end
    end

    if test "$TERM" = xterm-kitty
        # Manually change kitty theme to local variant, e.g. rose-pine
        # Requires `allow_remote_control yes` in your kitty.conf
        # Note: $dark_theme and $light_theme need to be set above to the
        # desired theme filename, e.g. "rose-pine" and "rose-pine-dawn"
        kitty @ set-colors --all --configured "$HOME/.config/kitty/themes/$THEME.conf"

        sed -i "" -e \
            "s/include themes\/.*\.conf/include themes\/$THEME.conf/" \
            "$HOME/.config/kitty/kitty.conf"

        # Or use built-in themes, e.g. Rosé Pine
        # Note: $dark_theme and $light_theme need to be set above to the
        # desired theme names, e.g. "Rosé Pine" and "Rosé Pine Dawn"
        # kitty +kitten themes --reload-in=all $THEME
    end

    # Toggle system theme last because it takes longer
    if test "$should_toggle_system_dark_mode" = true
        dark-mode
    end
end
