function rm --wraps trash -d "Move to trash"
    command trash -s $argv
end
