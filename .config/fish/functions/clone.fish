# Clone remote repository and change to created directory
#
# If only a repo is given, your git user.name is automatically used
#
# @usage
# clone dots <-- clones <your name>/dots
# clone mvllow/pinecone
# clone rose-pine/neovim rose-pine-neovim

function clone --wrap 'git clone' -a input
    # Extract repo name out of "user/repo"
    string match -rq '.*?\/(?<repo>.*)' -- $input

    if test -n "$repo"
        set url "$input"
        set dest "$repo"
    else
        # Use git's user.name if user was not passed as input
        # eg. if "repo" is passed, we assume "git_user_name/repo"
        set url "$(git config --get user.name)/$input"
        set dest "$input"
    end

    # Clone "user/repo" while passing any extra arguments
    git clone git@github.com:$url.git $argv[2..]

    if test $status = 0
        if test $argv[2]
            cd $argv[2]
        else
            cd "$dest"
        end
    end
end
