function rm -d "Move to trash"
    if test (count $argv) -eq 0
        echo "==> no files specified" >&2
        return 1
    end

    set -l os_name (uname)

    switch "$os_name"
        case Darwin
            if not command -v trash >/dev/null 2>&1
                echo "==> unable to find command: 'trash'" >&2
                echo "==> install with: brew install trash" >&2
                return 1
            end
            command trash -s $argv

        case Linux
            if not command -v gio >/dev/null 2>&1
                echo "==> unable to find command: 'gio'" >&2
                echo "==> install with your package manager (usually part of glib2)" >&2
                return 1
            end
            command gio trash $argv

        case '*'
            echo "==> unsupported os: '$os_name'" >&2
            echo "==> supported: Darwin, Linux" >&2
            return 1
    end
end
