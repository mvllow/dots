local lsp_configs = {}
for _, f in pairs(vim.api.nvim_get_runtime_file('after/lsp/*.lua', true)) do
	local server_name = vim.fn.fnamemodify(f, ':t:r')
	table.insert(lsp_configs, server_name)
end

vim.lsp.enable(lsp_configs)

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		if client:supports_method("textDocument/completion") then
			vim.cmd("set completeopt+=menuone,noselect")
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end

		if client:supports_method("textDocument/foldingRange") then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
	end
})
