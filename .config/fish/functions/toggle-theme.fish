function toggle-theme -d "toggle kitty theme (which will indirectly update fish)"
    use-terminal-colors

    if [ "$THEME" = "Rosé Pine" ]
        set -U THEME "Rosé Pine Dawn"
        dark-mode off
    else
        set -U THEME "Rosé Pine"
        dark-mode on
    end

    kitty +kitten themes --reload-in=all $THEME
end
