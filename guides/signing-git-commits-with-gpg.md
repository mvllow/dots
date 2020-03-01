![](https://images.unsplash.com/photo-1449247709967-d4461a6a6103?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&fp-y=.7&w=1951&h=480&q=80)

## Signing git commits with GPG

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
$ open https://github.com/settings/gpg/new
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

```sh
# Kill agent, it will start again when needed
$ gpgconf --kill gpg-agent
```

**Test GPG signing**

Pinentry-mac should popup, allowing you to save your password to the keychain. Otherwise, restart the agent and try again.

```sh
# Test GPG signing
$ echo "test" | gpg --clearsign
```

**Error messages**

`Inappropriate ioctl for device` can usually be fixed by adding `export GPG_TTY=$(tty)` to the top of your profile.
