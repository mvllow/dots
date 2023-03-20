# @usage
# clone dots # clones <git config --get user.name>/dots
# clone mvllow/pinecone
# clone rose-pine/neovim rose-pine-neovim
function clone -w "git clone" -a input -d "Clone remote repository and change to created directory"
    # Extract repo name out of "user/repo"
    string match -rq '.*?\/(?<repo>.*)' -- $input

    if test -n "$repo"
        set src "$input"
        set dst "$repo"
    else
        # Use git's user.name if user was not passed as input
        # eg. if "repo" is passed, we assume "git_user_name/repo"
        set src "$(git config --get user.name)/$input"
        set dst "$input"
    end

    # Clone "user/repo" while passing any extra arguments
    git clone git@github.com:$src.git $argv[2..]

    if test $status = 0
        if test $argv[2]
            cd $argv[2]
        else
            cd "$dst"
        end
    end
end
