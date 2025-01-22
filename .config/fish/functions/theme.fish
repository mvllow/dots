function theme -d "Toggle macOS system theme"
    if test (uname) != Darwin
        echo "==> this function only works on macOS" >&2
        return 1
    end

    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to not dark mode'

    defaults read -g AppleInterfaceStyle >/dev/null 2>&1
    set -l new_mode (test $status -eq 0; and echo "dark"; or echo "light")
    echo "==> set theme to $new_mode"
end
