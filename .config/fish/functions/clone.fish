# @usage
#
# clone dots
#   => Clones git@github.com:<user>/dots to ./dots
#
# clone mvllow/pinecone
#   => Clones git@github.com:mvllow/pinecone to ./mvllow-pinecone
#
# clone rose-pine/neovim
#   => Clones git@github.com:rose-pine/neovim to ./rose-pine-neovim
#
function clone --wraps "git clone" -a input --description "Clone remote repositories"
    string match -rq '(?<user>.*)?\/(?<repository>.*)' -- $input

    if test -n "$repository"
        set source "$input"
        set output "$user-$repository"
    else
        set source "$(git config --get user.name)/$input"
        set output "$input"
    end

    if test $argv[2]
        git clone git@github.com:$source.git $argv[2..]
        cd "$argv[2]"
    else
        git clone git@github.com:$source.git $output
        cd "$output"
    end
end
