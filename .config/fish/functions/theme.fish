function theme -a set_mode -d "Toggle or set macOS system theme"
    if test (uname) != Darwin
        echo "==> this function only works on macOS" >&2
        return 1
    end

    defaults read -g AppleInterfaceStyle >/dev/null 2>&1
    set -l current_mode (test $status -eq 0; and echo "dark"; or echo "light")

    if test -z "$set_mode"
        set set_mode (test "$current_mode" = "light"; and echo "dark"; or echo "light")
    end

    if not string match -q "$set_mode" light dark
        echo "==> invalid theme: '$set_mode'" >&2
        echo "==> usage: theme [light|dark]" >&2
        return 1
    end

    if test "$current_mode" = "$set_mode"
        echo "==> already using $set_mode theme"
        return 0
    end

    switch "$set_mode"
        case light
            if not osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = false" >/dev/null 2>&1
                echo "==> failed to set light theme" >&2
                return 1
            end

        case dark
            if not osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = true" >/dev/null 2>&1
                echo "==> failed to set dark theme" >&2
                return 1
            end
    end

    echo "==> set $set_mode theme"
end
