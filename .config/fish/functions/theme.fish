function theme -a set_mode
    defaults read -g AppleInterfaceStyle >/dev/null 2>&1
    set -l current_mode (test $status -eq 0 && echo "dark" || echo "light")

    if test -z "$set_mode"
        set set_mode (test "$current_mode" = "light" && echo "dark" || echo "light")
    end

    switch $set_mode
        case light
            osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = false" >/dev/null
        case dark
            osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = true" >/dev/null
    end
end
