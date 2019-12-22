![](https://images.unsplash.com/photo-1449247709967-d4461a6a6103?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&fp-y=.7&w=1951&h=480&q=80)

# Minimalist developer

The setup script will install and configure a minimal amount of applications, command line tools, and other packages.

## Getting started

```sh
$ curl -LJO https://raw.githubusercontent.com/mvllow/dots/master/setup.sh && sh ./setup.sh
```

For automation, read through `setup-unsafe.sh`. All information is hardcoded and therefore requires zero user input. After forking, be sure to look over `brewfile` as well.

```sh
$ curl -LJO https://raw.githubusercontent.com/<your git username>/dots/master/setup-unsafe.sh && sh ./setup-unsafe.sh
```

## Apps

Only installed apps will be configured.

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

**Manual**

- Keyboard -> Modifier keys -> Caps Lock = Escape

## Guides

- [Signing git commits with GPG](https://github.com/mvllow/dots/blob/master/guides/signing-git-commits-with-gpg.md)
