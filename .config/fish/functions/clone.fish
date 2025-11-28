function clone -w "git clone" -a source -d "Clone remote repository"
    set -l dev_dir "$HOME/dev"

    if not string match -qr / -- "$source"
        set -l username (git config --global user.name)
        if test -z "$username"
            echo "==> could not determine git username from git config" >&2
            return 1
        end
        set source "$username/$source"
    end

    set -l repo (string split / "$source")[-1]
    set -l out_dir "$repo"
    if test (count $argv) -ge 2
        set out_dir "$argv[2]"
    end
    set -l out_path "$dev_dir/$out_dir"

    git clone "git@github.com:$source.git" "$out_path"

    if test $status -ne 0
        return 1
    end

    set -l session_name (tmux_session_name "$out_path")

    if not type -q tmux
        return 0
    end

    if not tmux has-session -t "$session_name" 2>/dev/null
        tmux new-session -ds "$session_name" -c "$out_path"
    end

    if test -n "$TMUX"
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    end
end
