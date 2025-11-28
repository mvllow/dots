function tmux_session_name -a path
    if test -n "$path"
        basename "$path" | tr . _
    else
        basename (pwd) | tr . _
    end
end
