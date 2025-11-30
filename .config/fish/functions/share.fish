function share -a file -d "Upload file to 0x0.st"
    curl -s -F "file=@$file" https://0x0.st
end
