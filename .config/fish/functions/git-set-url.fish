function git-set-url -a repo -d "set remote url to ssh variant"
    git remote set-url --push origin git@github.com:$repo.git $argv[2..]
end
