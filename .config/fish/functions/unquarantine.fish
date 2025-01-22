function unquarantine -a app -d "Remove quarantine attribute from an app"
    xattr -rd com.apple.quarantine "$app"
end
