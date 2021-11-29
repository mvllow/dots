function toggle-theme -d "toggle kitty theme (which will indirectly update fish)"
    use-terminal-colors

    if [ "$THEME" = "Rosé Pine" ]
        set -U THEME "Rosé Pine Dawn"
    else
        set -U THEME "Rosé Pine"
    end

    kitty +kitten themes --reload-in=all $THEME
end
