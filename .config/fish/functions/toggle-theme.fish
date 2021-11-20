function toggle-theme -d "toggle kitty theme (which will indirectly update fish)"
    use-terminal-colors

    set current_theme (awk '$1=="include" {print $2}' "$HOME/.config/kitty/kitty.conf")
    set new_theme "rose-pine.conf"

    if [ "$current_theme" = "rose-pine.conf" ]
        set new_theme "rose-pine-dawn.conf"
    end

    # Set theme for active sessions. Requires `allow_remote_control yes`
    kitty @ set-colors --all --configured "~/.config/kitty/$new_theme"

    # Update config for persistence
    sed -i '' -e "s/include.*/include $new_theme/" "$HOME/.config/kitty/kitty.conf"
end
