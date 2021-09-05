function 0x0 -a file -d "upload to 0x0.st and copy created link to clipboard"
    # TODO: Fix xargs from eating the url we copy
    curl -F "file=@$file" https://0x0.st | xargs echo -n | pbcopy
    echo "(copied to clipboard)"
end
