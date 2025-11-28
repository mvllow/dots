function tn -a path -d "Create and switch to a tmux session for the given directory"
    set dir (realpath "$path")
    set session_name (basename "$dir")

    if not tmux has-session -t $session_name 2>/dev/null
        tmux new-session -d -s $session_name -c $dir
        echo "==> tmux session '$session_name' created in '$dir'"
    end

    tmux switch-client -t $session_name
end
