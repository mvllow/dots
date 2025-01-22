function tn -d "Create and switch to a tmux session for the current directory"
    set session_name (tmux_session_name)

    tmux new-session -d -s $session_name -c (pwd)
    tmux switch-client -t $session_name

    echo "==> tmux session '$session_name' created and attached"
end
