function remove -a directory -d "delete non-dirty repo directory"
    set -l current_directory (pwd)

    cd "$directory"
    set -l is_directory_clean (git status --porcelain)

    if test -z "$is_directory_clean"
        cd "$current_directory"
        rm -rf "$directory"
        echo "Removed $directory"
    else
        cd "$current_directory"
        echo "Directory has unsaved git changes. Nothing has been deleted."
    end
end
