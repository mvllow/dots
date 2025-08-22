function rm -d "Move to trash"
    set os_name (uname)

    if test "$os_name" = Darwin
        if not command -v trash >/dev/null
            echo "unable to find command: 'trash'"
            return
        end
        command trash -s $argv
    else if test "$os_name" = Linux
        if not command -v gio >/dev/null
            echo "unable to find command: 'gio'"
            return
        end
        command gio trash $argv
    else
        echo "unsupported os: '$os_name'"
    end
end
