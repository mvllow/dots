![](https://images.unsplash.com/photo-1449247709967-d4461a6a6103?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&fp-y=.7&w=1951&h=480&q=80)

# Minimalist developer

## Getting started

- Assumes a fresh install of macOS Catalina
- Else, low attachment to your current settings (see below)

The setup script will install and configure a minimal amount of applications, command line tools, and other packages.

Packages not found in the repo's `brewfile` will be **purged**.

```sh
$ curl -LJO https://raw.githubusercontent.com/mvllow/dots/master/setup.sh && sh ./setup.sh
```

## Preferences

It is recommeneded to read through `setup.sh` to know exactly what is being modified. The list below has been simplified.

- Dock: autohide
- Dock: show only active apps
- Finder: disable app quarantine popup
- Finder: disable warning when emptying trash
- Finder: disable warning on file extension change
- Menubar: show battery percentage
- Trackpad: increase tracking speed
- Trackpad: enable tap to click (this user and login screen)
- Keyboard: enable (faster) key repeat with shorter delay
- Keyboard: disable auto correct/capitilise
- Keyboard: disable smart dashes/quotes

**Not yet automated**

- Keyboard -> Modifier keys -> Caps Lock = Escape
- General -> Accent color -> Grayscale

## Tools & Packages

All stable builds are supported, as well as most pre-release versions.

- Zsh and Elvish shells
- Hyper and iTerm2
- [Neo]Vim
- Sublime Text
- Visual Studio Code
