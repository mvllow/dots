# Clone remote repository
#
# Your local git username is inferred and used when only the repo is given:
# $ clone dots
#   > Cloning into 'dots'...
#
# When given a username, prepend the folder name if not duplicative:
# $ clone rose-pine/neovim
#   > Cloning into 'rose-pine-neovim'...
# $ clone rose-pine/rose-pine-site
#   > Cloning into 'rose-pine-site'...
function clone -w "git clone" -a source -d "Clone remote repository"
    if test $argv[2]
        git clone git@github.com:$source.git $argv[2..]
        cd $argv[2]
        return
    end

    set user (git config --get user.name)

    if not string match -rq / -- $source
        set output "$source"
        set source "$user/$source"
    else
        string match -rq '(?<user>.*)?\/(?<repo>.*)' -- $source

        if test -n "$repo"
            if [ "$user" != "$repo" ]
                set output (string replace "$user-" "" "$repo")
                set output "$user-$output"
            else
                set output "$repo"
            end
        end
    end

    git clone git@github.com:$source.git $output
    cd $output
end
