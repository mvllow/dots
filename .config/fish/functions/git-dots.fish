function git-dots -a directory -d "find untracked dotfiles"
    alias _git "git --git-dir=$HOME/dots.git --work-tree=$HOME"

    if test -n "$directory"
        _git ls-files --other "$directory/*"
    else
        _git ls-files --other "$HOME/.config/*"
    end
end
