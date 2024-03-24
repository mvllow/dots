function rm -w trash -d "Move file or directory to the trash"
    if type -q trash
        command trash $argv
    else
        echo "`trash` not found in path"
    end
end
