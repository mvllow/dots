function theme -a option
    set -q THEME
    set -U DARK_MODE $(dark-mode status)

    function _set_kitty_theme
        kitty @ set-colors --all --configured "$HOME/.config/kitty/themes/$THEME.conf"
        sed -i "" -e \
            "s/include themes\/.*\.conf/include themes\/$THEME/" \
            "$HOME/.config/kitty/kitty.conf"
    end

    function _toggle_theme
        if test "$DARK_MODE" = on
            set -U THEME rose-pine-dawn
            set -U DARK_MODE off
        else
            set -U THEME rose-pine
            set -U DARK_MODE on
        end

        if test "$TERM" = xterm-kitty
            _set_kitty_theme
        end

        # Toggle system theme last because it takes longer
        dark-mode
    end

    function _match_system_theme
        if test "$DARK_MODE" = on
            set -U THEME rose-pine
        else
            set -U THEME rose-pine-dawn
        end

        if test "$TERM" = xterm-kitty
            _set_kitty_theme
        end
    end

    function _help
        echo
        echo "Usage: theme <option>"
        echo "  toggle           Toggle theme"
        echo "  match_system     Match system theme"
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
