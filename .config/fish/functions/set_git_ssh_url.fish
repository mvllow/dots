function set_git_ssh_url -a repo
    git remote set-url --push origin git@github.com:$repo.git $argv[2..]
end
