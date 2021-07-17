# Custom kitty with neovim

> This guide assumes you are using lua. Feel free to adapt to vimscript if necessary.

## Configuring kitty through neovim

Kitty can be configured in real-time from your shell. Let's explore dynamically setting padding when entering and leaving neovim:

```lua
vim.api.nvim_exec(
	[[
	augroup ConfigureKitty
	au!
	au VimEnter * silent !kitty @ --to=$KITTY_LISTEN_ON set-spacing padding=0
	au VimLeave * silent !kitty @ --to=$KITTY_LISTEN_ON set-spacing padding=5
	augroup END
	]],
	false
)
```

Padding will be set to `0` on enter, and `5` on leave.

Here's a sample `kitty.conf` to enable this behaviour:

```
# Enable running kitty @ commands
allow_remote_control yes

# Listen via dedicated socket instead of tty
# https://github.com/kovidgoyal/kitty/issues/2426
listen_on unix:/tmp/mykitty

# Set preferred spacing
window_padding_width 5
```

## Sync kitty and neovim theme

We can go one step further and keep our kitty theme in sync with neovim. This part is a little less generic so feel free to tailor for your needs.

### Assumptions

- Using [Rosé Pine](https://github.com/rose-pine/rose-pine-theme) for both kitty and neovim.
-

```sh
# ~/.zshrc

# Choose a place to store our settings
# This will look something like `theme=rose-pine`
settings_file="$HOME/.config/settings.txt"
while read line; do
	eval "$line"
done <"$settings_file"

toggle_theme() {
	if [ "$theme" = "rose-pine" ]; then
		theme="rose-pine-moon"
		variant="moon"
	elif [ "$theme" = "rose-pine-moon" ]; then
		theme="rose-pine-dawn"
		variant="dawn"
	elif [ "$theme" = "rose-pine-dawn" ]; then
		theme="rose-pine"
		variant="base"
	else
		theme="rose-pine"
		variant="base"
	fi

	# Right now we only have one setting so overwriting the entire file is fine
	echo "theme=$theme" >"$HOME/.config/settings.txt"

	# Set kitty theme
	# This requires `allow_remote_control yes` in your kitty config
	kitty @ set-colors --all --configured ~/.config/kitty/$theme.conf

	# Update kitty.conf with new theme for persistence
	# Assumes `include rose-pine.conf` or similar on first line
	# See https://github.com/mvllow/kitty/blob/main/kitty.conf#L1
	sed -i "" "1s/rose-pine.*\.conf/$theme.conf/" ~/.config/kitty/kitty.conf

	# Set neovim theme
	# Assumes `vim.g.rose_pine_variant` on second line of conf.lua
	# See https://github.com/mvllow/nvim/blob/main/conf.lua#L2
	sed -i "" "2s/.*/vim.g.rose_pine_variant = '$variant'/" ~/.config/nvim/conf.lua
}

# Setup keybind to toggle theme
zle -N toggle_theme
bindkey "^[[108;9u" toggle_theme # super+l
```
