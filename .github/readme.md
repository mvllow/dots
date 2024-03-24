# dots

> A bare repo resembling your `$HOME`

## Usage

Clone to a temporary directory:

```sh
git clone --separate-git-dir=$HOME/dots.git \
    https://github.com/mvllow/dots.git \
    dots-tmp
```

Copy working tree snapshot to the home directory, then delete the temporary directory:

```sh
rsync --recursive --verbose --exclude '.git' dots-tmp/ $HOME/
rm -rf dots-tmp
```

Optionally, add an alias to use git with this new structure:

```sh
alias .git='git --git-dir=$HOME/dots.git/ --work-tree=$HOME'
```

Optionally, hide untracked files—you will have to manually add new files:

```sh
.git config --local status.showUntrackedFiles no
```

Change upstream from https to ssh:

```sh
.git remote set-url origin git@github.com:mvllow/dots.git
```

## References

- [macOS setup](https://github.com/mvllow/dots/wiki/macOS-setup)
- [Using a custom shell](https://github.com/mvllow/dots/wiki/Using-a-custom-shell)
- [Signing git commits](https://github.com/mvllow/dots/wiki/Signing-git-commits)
- [Update kitty config from neovim](https://github.com/mvllow/dots/wiki/Update-kitty-config-from-neovim)
