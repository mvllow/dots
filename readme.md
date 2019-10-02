![](https://images.unsplash.com/photo-1449247709967-d4461a6a6103?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&fp-y=.7&w=1951&h=480&q=80)

# Minimalist developer

## Getting started

- Assumes a fresh install of macOS Catalina
- Else, low attachment to your current settings (there are _no_ backups)

The setup script will install and configure a minimal amount of applications, command line tools, and other packages.

Packages not found in the repo's `brewfile` will be purged.

```sh
$ curl -LJO https://raw.githubusercontent.com/mvllow/dots/master/setup.sh && sh ./setup.sh
```

Some preferences that have not yet been reliably automated:

- Set wallpaper, no favourites yet!
- Move all default launchpad apps into a single folder named "Apple"
- Preferences > Keyboard > Modifier Keys > Map Caps Lock to Escape
- Preferences > Siri > Show siri in menu bar (disable)
- Preferences > Date & Time > Clock > Use a 24-hour clock (enable)
- Preferences > Date & Time > Clock > Show the day of the week (enable)

## Signing GitHub commits with GPG

The setup script will install the following for you (including Keybase). The rest was left out of the script to prevent complexity.

```sh
$ brew install gnupg pinentry-mac

# Optionally use key from Keybase
$ brew cask install keybase
```

### Generate GPG keys

```sh
# With existing Keybase
$ keybase pgp export | gpg --import
$ keybase pgp export -q <keyid> --secret | gpg --import --allow-secret-key-import

# With new GPG key
$ gpg --full-generate-key
```

### Export and copy key

```sh
# List keyid
$ gpg --list-secret-keys --keyid-format LONG

# Copy key to clipboard
$ gpg --armor --export <keyid> | pbcopy

# Add to GitHub
$ open https://github.com/settings/keys/new
```

### Git and GPG config

```sh
$ git config --global user.signingkey <keyid>
$ git config --global gpg.program $(which gpg)
$ git config --global commit.gpgsign true

# ~/.zshrc or similar
export GPG_TTY=$(tty)

# ~/.gnupg/gpg-agent.conf
pinentry-program /usr/local/bin/pinentry-mac

# ~/.gnupg/gpg.conf
no-tty
use-agent
```

### Troubleshooting

**Restart GPG agent**

```
# Kill agent, it will start again when needed
$ gpgconf --kill gpg-agent
```

**Test GPG signing**

Pinentry-mac should popup, allowing you to save your password to the keychain. Otherwise, restart the agent and try again.

```
# Test GPG signing
$ echo "test" | gpg --clearsign
```

**Error messages**

`Inappropriate ioctl for device` can usually be fixed by adding `export GPG_TTY=$(tty)` to the top of your profile.
