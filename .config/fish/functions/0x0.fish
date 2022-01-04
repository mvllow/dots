# Upload file to 0x0.st and copy created link to clipboard
# https://github.com/mvllow/fun-shell
#
# @usage
# 0x0 file.txt

function 0x0 -a file
    # TODO: Fix xargs from eating the url we copy
    curl -F "file=@$file" https://0x0.st | xargs echo -n | pbcopy
    echo "(copied to clipboard)"
end
