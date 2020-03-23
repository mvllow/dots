![Promo](images/promo.png "Promo")

# Minimalist developer

The setup script will install and configure a minimal amount of applications, command line tools, and other packages.

## Getting started

```sh
$ curl -LJO https://raw.githubusercontent.com/mvllow/dots/master/setup.sh && sh ./setup.sh
```

> For global git config/ssh keys see usage below

![Usage](images/usage.png "Usage")

## Caveats

VSCode needs to be approved via System Preferences on first open. Because of this, extensions may not install properly on the initial run. To fix, open VSCode and run the script again.

## Apps

> Only installed apps will be configured

**Shells**

We avoid changing your default shell (and needing _sudo_) by executing non-standard shells via `.zshrc`.

**Terminals**

[Hyper](hyper.is) is offically supported.

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
