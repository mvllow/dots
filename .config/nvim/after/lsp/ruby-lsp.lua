return {
	filetypes = { "ruby", "eruby" },
	cmd = { "ruby-lsp" },
	root_markers = { "Gemfile", ".git" },
	init_options = {
		formatter = 'auto',
		addonSettings = {
			["Ruby LSP Rails"] = {
				enablePendingMigrationsPrompt = false,
			},
		},
	},
}
