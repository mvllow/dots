local M = {}

--- Add vim runtime files to workspace library.
function M.lspconfig()
	return {
		settings = {
			Lua = {
				workspace = {
					checkThirdParty = false,
					library = { vim.env.VIMRUNTIME },
				},
			},
		},
	}
end

return M
