# Replace rm with trash
# https://github.com/sindresorhus/trash-cli
function rm --wraps="trash"
    command trash $argv
end
