# @dependencies
# trash (https://github.com/sindresorhus/trash-cli)
function rm -w trash -d "Trash file or directory"
    command trash $argv
end
