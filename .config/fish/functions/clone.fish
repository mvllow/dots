function clone --wrap 'git clone' -a repo -d "clone repo and enter directory"
    string match -rq '.*?\/(?<name>.*)' -- $repo

    git clone git@github.com:$repo.git $argv[2..]

    if test $argv[2]
        cd $argv[2]
    else
        cd $name
    end
end
