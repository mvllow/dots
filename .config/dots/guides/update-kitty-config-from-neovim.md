# Update kitty config from neovim

> This guide assumes you are using lua. Feel free to adapt to vimscript if necessary.

## Configuring kitty through neovim

Kitty can be configured in real-time from your shell. Let's explore dynamically setting padding when entering and leaving neovim:

i.e. without

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

# Set kitty theme
# @args $1 = theme name (rose-pine[-moon|-dawn])
# @example set_kitty_theme rose-pine
set_kitty_theme() {
	file="$HOME/.config/kitty/kitty.conf"
	decorator="@theme"
	starts_with="include"
	replace_with="include $1.conf"

	# Update theme for active sessions
	kitty @ set-colors --all --configured ~/.config/kitty/$1.conf

	# Update config for persistence
	sed -i '' -e "/$decorator/ {" -e "n; s/$starts_with.*/$replace_with/" -e "}" $file
}

# Set neovim theme
# @args $1 = theme variant (base|moon|dawn)
# @example set_neovim_theme dawn
set_neovim_theme() {
	file="$HOME/.config/nvim/conf.lua"
	starts_with="vim.g.rose_pine_variant"
	replace_with="vim.g.rose_pine_variant = '$1'"

	# Update config for persistence
	sed -i '' -e "s/$starts_with.*/$replace_with/" $file
}

# Toggle theme
# @example toggle_theme
toggle_theme() {
  # File to save active theme
	theme_file="$HOME/.config/theme.conf"

	dark_theme="rose-pine"
	light_theme="rose-pine-dawn"

	# Create default config
	if ! [ -e $theme_file ]; then
		echo "theme=$dark_theme" >$theme_file
	fi

	# Read theme file
	# Eg. `theme=` will set $theme
	while read line; do
		eval "$line"
	done <"$theme_file"

	if [ "$theme" = "$dark_theme" ]; then
		theme=$light_theme
		set_kitty_theme $light_theme
		set_neovim_theme $light_theme
	else
		theme=$dark_theme
		set_kitty_theme $dark_theme
		set_neovim_theme $dark_theme
	fi

	# Update active theme
	sed -i '' -e "s/theme.*/theme=$theme/" $theme_file
}

# Set keybind to toggle theme
zle -N toggle_theme
bindkey "^[[108;9u" toggle_theme # super+l
```
