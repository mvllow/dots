# dots

## Usage

Clone the bare repo to your home directory:

```bash
git clone --bare https://git.sr.ht/~mellow/dots ~/.dots.git
```

Checkout the contents:

```bash
git --git-dir=$HOME/.dots.git --work-tree=$HOME checkout
```

_You may **destructively** overwrite existing files present in both `$HOME` and the repo by adding `--force`._

Optionally, change the upstream from HTTPS to SSH:

```bash
git --git-dir=$HOME/.dots.git --work-tree=$HOME remote set-url origin git@git.sr.ht:~mellow/dots.git
```
