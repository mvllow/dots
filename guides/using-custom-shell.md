![](https://images.unsplash.com/photo-1596404996691-e49f3855a803?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&fp-y=.5&w=1951&h=480&q=80)

# Using a custom shell

Recent versions of macOS now ship with zsh by default. There are several alternatives, but changing your default shell may potentially cause issues if you're not careful.

We can add a snippet to our `.zshrc` that checks for our desired shell, in this case "fish". If it exists, we execute fish within zsh.

```sh
if (( $+commands[fish] )); then
  SHELL=/usr/local/bin/fish
  [ -x $SHELL ] && exec $SHELL
fi
```
