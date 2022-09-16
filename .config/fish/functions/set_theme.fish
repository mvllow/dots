function set_theme -a theme
    set -q THEME; or use_terminal_colors
    set dark_theme rose-pine
    set light_theme rose-pine-dawn

    if [ "$theme" = system ]
        # Match system theme
        if [ $(dark-mode status) = on ]
            set THEME $dark_theme
        else
            set THEME $light_theme
        end
    else
        # Toggle theme
        if [ $(dark-mode status) = on ]
            set THEME $light_theme
            dark-mode off
        else
            set THEME $dark_theme
            dark-mode on
        end
    end

    if [ "$TERM" = xterm-kitty ]
        # Manually change kitty theme to local variant, e.g. rose-pine
        # Requires `allow_remote_control yes` in your kitty.conf
        kitty @ set-colors --all --configured "$HOME/.config/kitty/themes/$THEME.conf"

        sed -i "" -e \
            "s/include themes\/.*\.conf/include themes\/$THEME.conf/" \
            "$HOME/.config/kitty/kitty.conf"

        # Or use built-in themes, e.g. Rosé Pine
        # kitty +kitten themes --reload-in=all $THEME
    end
end
