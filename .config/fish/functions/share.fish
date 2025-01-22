function share -a file -d "Upload a file to https://0x0.st"
    if test (count $argv) -eq 0
        echo "==> no file specified" >&2
        echo "==> usage: share <file>" >&2
        return 1
    end

    if not test -f "$file"
        echo "==> file not found: '$file'" >&2
        return 1
    end

    if not command -v curl >/dev/null 2>&1
        echo "==> unable to find command: 'curl'" >&2
        return 1
    end

    set -l curl_output (curl -s -A "share-fish/1.0" -F "file=@$file" -F expires=1 https://0x0.st 2>&1)
    set -l curl_status $status

    if test $curl_status -ne 0
        echo "==> upload failed (curl exit code: $curl_status)" >&2
        echo "==> curl output: $curl_output" >&2
        return 1
    end

    set -l url (echo "$curl_output" | string trim)

    if test -z "$url"; or not string match -q "http*" "$url"
        echo "==> upload failed - invalid response" >&2
        echo "==> server response: $curl_output" >&2
        return 1
    end

    set -l os_name (uname)
    switch "$os_name"
        case Darwin
            if command -v pbcopy >/dev/null 2>&1
                echo "$url" | pbcopy
                printf "==> uploaded '%s' at %s (copied to clipboard)\n" "$file" "$url"
            else
                printf "==> uploaded '%s' at %s\n" "$file" "$url"
            end

        case Linux
            if command -v xclip >/dev/null 2>&1
                echo "$url" | xclip -selection clipboard
                printf "==> uploaded '%s' at %s (copied to clipboard)\n" "$file" "$url"
            else if command -v wl-copy >/dev/null 2>&1
                echo "$url" | wl-copy
                printf "==> uploaded '%s' at %s (copied to clipboard)\n" "$file" "$url"
            else
                printf "==> uploaded '%s' at %s\n" "$file" "$url"
            end

        case '*'
            printf "==> uploaded '%s' at %s\n" "$file" "$url"
    end
end
