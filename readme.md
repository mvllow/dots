![Dots banner](images/dots.png)

# Minimalist developer

The setup script will install and configure a minimal amount of applications, command line tools, and other packages

## Getting started

```sh
curl -LJO https://raw.githubusercontent.com/mvllow/dots/main/setup.sh && sh ./setup.sh
```

> For global git config/ssh keys see usage below

![Usage](images/usage.png 'Usage')

## Modified files

> Only installed apps will be configured (see [brewfile](https://github.com/mvllow/dots/blob/main/brewfile))

**Fish ([config ↗](https://github.com/mvllow/fish))**

```sh
~/.config/fish/*
```

**Kitty ([config ↗](https://github.com/mvllow/kitty))**

```sh
~/.config/kitty/*
```

**Neovim ([config ↗](https://github.com/mvllow/nvim))**

```sh
~/.config/nvim/*
```

**VSCode ([config](vscode/settings.json), [extensions](vscode/extensions.txt))**

```sh
~/Library/Application Support/Code/settings.json
```

## System preferences

| Setting                                 | Value |
| --------------------------------------- | ----- |
| **Menubar**                             |       |
| Autohide                                | true  |
| **Dock**                                |       |
| Autohide                                | true  |
| Show recent apps                        | false |
| Show only active apps                   | true  |
| **Keyboard**                            |       |
| Auto correct                            | false |
| Auto capitilise                         | false |
| Period with double-space                | false |
| Use smart quotes/dashes                 | false |
| Enable system-wide key repeat           | true  |
| Enable faster key repeat                | 2     |
| Enabled shorter delay before key repeat | 15    |
| **Trackpad**                            |       |
| Tap to click                            | true  |
| Increase tracking speed                 | 3     |

### Manual settings

- Preferences > Keyboard > Modifier Keys > Map caps lock to escape

## Misc

- SF Mono is copied to Font Book for easier accessibility
- Theme used is [Rosé Pine](https://github.com/rose-pine/rose-pine-theme)
- Font used is [Cartograph CF](https://connary.com/cartograph.html)

## Guides

- [Signing git commits with GPG](https://github.com/mvllow/dots/blob/main/guides/signing-git-commits-with-gpg.md)
- [Using a custom shell](https://github.com/mvllow/dots/blob/main/guides/using-custom-shell.md)
