# Upload file to 0x0.st and copy created link to clipboard
#
# @usage share file.txt
function share -a file
    set url (curl -F "file=@$file" -Fexpires=1 https://0x0.st | xargs echo -n)
    echo $url | pbcopy
    printf "> Uploaded $file at $url (copied to clipboard)\n"
end
