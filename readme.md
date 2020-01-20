![](https://images.unsplash.com/photo-1449247709967-d4461a6a6103?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&fp-y=.7&w=1951&h=480&q=80)

# Minimalist developer

The setup script will install and configure a minimal amount of applications, command line tools, and other packages.

## Getting started

```sh
$ curl -LJO https://raw.githubusercontent.com/mvllow/dots/master/setup.sh && sh ./setup.sh
```

We are close to a zero-input script. Use our beta script to enable flags to include your git username/email. Brew still requires input if not installed.

```sh
$ curl -LJO https://raw.githubusercontent.com/mvllow/dots/master/setup-beta.sh && sh ./setup-beta.sh  -u johnsmith -e you@domain.com
```

## Caveats

VSCode needs to be approved via System Preferences on first open. Because of this, extensions may not install properly on the initial run. To fix, open VSCode and run the script again.

## Apps

> Only installed apps will be configured.

**Shells**

We avoid changing your default shell (and needing _sudo_) by executing non-standard shells via `.zshrc`. Currently we support [elvish](elv.sh) and later [fish](fishshell.com).

**Terminals**

There are settings for both Hyper and iTerm2.

**Editors**

Our `.vimrc` uses zero dependencies/plugins and will be shared with NeoVim if found.

Both VSCode (stable/insiders) and Sublime Text (stable/dev) are supported.

## System preferences

**Automated**

- Autohide dock and only show active apps
- Disable warning when emptying trash & changing file extensions
- Show battery % in menubar
- Increase tracking speed and enable tap to click
- Enable (faster) key repeat with shorter delay
- Disable auto correct/capitilise and smart dashes/quotes
- Expose SF Mono making it accessible via Font Book

**Manual**

- Keyboard -> Modifier keys -> Caps Lock = Escape

## Guides

- [Signing git commits with GPG](https://github.com/mvllow/dots/blob/master/guides/signing-git-commits-with-gpg.md)
