function toggle-theme -d "toggle kitty theme (which will indirectly update fish)"
    use-terminal-colors

    if [ "$THEME" = "Rosé Pine" ]
        dark-mode off
        set -U THEME "Rosé Pine Dawn"
    else
        dark-mode on
        set -U THEME "Rosé Pine"
    end

    kitty +kitten themes --reload-in=all $THEME
end
