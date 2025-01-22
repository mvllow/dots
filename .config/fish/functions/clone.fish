# Clone remote repository
#
# $ clone rose-pine/neovim
#   > Cloning into 'neovim'...
#
# Your local git username is inferred:
# $ clone dots
#   > Cloning into 'dots'...
function clone -w "git clone" -a source -d "Clone remote repository"
    set dev_dir $HOME/dev

    if not string match -qr / -- $source
        set username (git config --global user.name)
        if test -z "$username"
            echo "could not determine git username from git config"
            return 1
        end
        set source "$username/$source"
    end

    set repo (string split / $source)[-1]
    set out_dir $repo
    if test $argv[2]
        set out_dir $argv[2]
    end

    git clone git@github.com:$source.git $dev_dir/$out_dir

    if test $status -ne 0
        return 1
    end

    # replace "." with "_"
    set safe_out_dir (string replace -r '\.' '_' $out_dir)

    if not type -q tmux
        return 0
    end

    if not tmux has-session -t "$safe_out_dir" ^/dev/null
        tmux new-session -ds "$safe_out_dir" -c (realpath "$dev_dir/$out_dir")
    end

    if test -n "$TMUX"
        tmux switch-client -t "$safe_out_dir"
    else
        tmux attach-session -t "$safe_out_dir"
    end
end
