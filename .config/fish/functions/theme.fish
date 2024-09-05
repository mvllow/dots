function theme -a option
    set -q THEME
    set -U DARK_MODE $(dark-mode status)
    set -U DARK_THEME rose-pine
    set -U LIGHT_THEME rose-pine-dawn

    function _set_ghostty_theme
        sed -i "" -e \
            "s/theme = .*/theme = $THEME/" \
            "$HOME/.config/ghostty/config"

        osascript -e 'tell application "Ghostty" to activate' \
            -e 'tell application "System Events" to keystroke "," using {shift down, command down}'
    end

    function _set_kitty_theme
        if test "$TERM" = xterm-kitty
            kitty @ set-colors --all --configured "$HOME/.config/kitty/themes/$THEME.conf"
        end
        sed -i "" -e \
            "s/include themes\/.*\.conf/include themes\/$THEME/" \
            "$HOME/.config/kitty/kitty.conf"
    end

    function _toggle_theme
        if test "$DARK_MODE" = on
            set -U DARK_MODE off
            set -U THEME $LIGHT_THEME
        else
            set -U DARK_MODE on
            set -U THEME $DARK_THEME
        end

        _set_ghostty_theme
        _set_kitty_theme

        # Toggle system theme last because it takes longer
        dark-mode
    end

    function _match_system_theme
        if test "$DARK_MODE" = on
            set -U THEME $DARK_THEME
        else
            set -U THEME $LIGHT_THEME
        end

        _set_ghostty_theme
        _set_kitty_theme
    end

    function _help
        set -l background (if test "$DARK_MODE" = on; echo dark; else; echo light; end)
        set -l active_theme (if test "$DARK_MODE" = on; echo $DARK_THEME; else; echo $LIGHT_THEME; end)
        set -l inactive_theme (if test "$DARK_MODE" = on; echo $LIGHT_THEME; else; echo $DARK_THEME; end)

        echo
        set_color --bold cyan
        echo "* $active_theme"
        set_color normal
        echo "  $inactive_theme"
        echo
        echo "Usage: theme <option>"
        echo "  toggle           Toggle theme (→ $inactive_theme)"
        echo "  match_system     Match system background ($background)"
        echo "  unset            Unset theme"
        echo
        echo "  -h, --help       Show this help message"
        echo
    end

    if test -z "$option"
        _help
        return 1
    end

    switch "$option"
        case toggle
            _toggle_theme
        case match_system
            _match_system_theme
        case unset
            set -e THEME
        case -h or --help
            _help
        case '*'
            echo "Unknown option: $option"
            return 1
    end
end
