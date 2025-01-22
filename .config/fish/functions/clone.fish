# Clone remote repository
#
# $ clone rose-pine/neovim
#   > Cloning into 'neovim'...
#
# Your local git username is inferred:
# $ clone dots
#   > Cloning into 'dots'...
function clone -w "git clone" -a source -d "Clone remote repository"
    if not string match -qr / -- $source
        set username (git config --global user.name)
        if test -z "$username"
            echo "could not determine git username from git config"
            return 1
        end
        set source "$username/$source"
    end

    set repo (string split / $source)[-1]
    set output $repo
    if test $argv[2]
        set output $argv[2]
    end

    git clone git@github.com:$source.git $output

    if test $status -ne 0
        return 1
    end

    if not type -q tmux
        return 0
    end

    if not tmux has-session -t "$output" ^/dev/null
        tmux new-session -ds "$output" -c (realpath "$output")
    end

    if test -n "$TMUX"
        tmux switch-client -t "$output"
    else
        tmux attach-session -t "$output"
    end
end
