function chop
    argparse d/delete -- $argv
    or return 1

    if set -q _flag_delete
        echo "Deleting stale branches..."
        bash -c '
            git fetch --prune
            git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs -r git branch -D
        '
    else
        echo "Listing stale branches (run again with '-d' to delete):"
        bash -c '
            git fetch --prune
            git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}"
        '
    end
end
