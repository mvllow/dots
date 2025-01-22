return {
	settings = {
		Lua = {
			telemetry = {
				enable = false
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					"${3rd}/luv/library"
				},
			},
		},
	},
}
