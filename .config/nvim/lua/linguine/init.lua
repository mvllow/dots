local Linguine = {}

function Linguine.setup(opts)
	opts = opts or {}

	local languages = require("linguine.languages")
	for language, module in pairs(languages) do
		if not require("lspconfig")[language] then
			vim.notify("LSP config for " .. language .. " is not available.", vim.log.levels.WARN)
		elseif not require("lspconfig")[language].manager then
			if module.lspconfig then
				require("lspconfig")[language].setup(module.lspconfig())
			end
		else
			vim.notify("LSP for " .. language .. " is already configured.", vim.log.levels.INFO)
		end

		if module.setup then
			module.setup()
		end
	end
end

function Linguine.setup_languages(languages)
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("LinguineLspAttach", { clear = true }),
		callback = function(event)
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if not client then
				return
			end

			for language, module in pairs(languages) do
				if client.name == language and module.lsp_on_attach then
					module.lsp_on_attach(client)
				end
			end
		end,
	})
end

return Linguine
