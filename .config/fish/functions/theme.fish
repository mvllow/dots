function theme -a set_mode
    set -l mode light

    if test -z $set_mode
        defaults read -g AppleInterfaceStyle >/dev/null 2>&1

        if test $status -eq 0
            set mode dark
        end
    else
        switch $set_mode
            case light
                osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = false" >/dev/null
                set mode light
            case dark
                osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = true" >/dev/null
                set mode dark
        end
    end

    switch $mode
        case light
            sed -i '' -e "s/^theme =.*/theme = rose-pine-dawn/" "$HOME/.config/ghostty/config"
        case dark
            sed -i '' -e "s/^theme =.*/theme = rose-pine/" "$HOME/.config/ghostty/config"
    end
end
