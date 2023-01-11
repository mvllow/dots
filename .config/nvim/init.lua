require("user/package") -- loads lua/user/package.lua
require("user/options") -- loads lua/user/options.lua
require("user/keymaps") -- loads lua/user/keymaps.lua

require("lazy").setup("plugins", {
	install = { colorscheme = { "un" } },
	change_detection = { notify = false },
}) -- loads and merges each lua/plugins/*
