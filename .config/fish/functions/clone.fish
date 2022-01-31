# Clone remote repository and change to created directory
#
# @requires git
# @usage
# clone mvllow/fun-shell
# clone rose-pine/neovim rose-pine-neovim

function clone --wrap 'git clone' -a repo
    string match -rq '.*?\/(?<name>.*)' -- $repo

    git clone git@github.com:$repo.git $argv[2..]

    if test $status = 0
        if test $argv[2]
            cd $argv[2]
        else
            cd $name
        end
    end
end
