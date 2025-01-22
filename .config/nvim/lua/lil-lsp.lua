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

		if client:supports_method("textDocument/documentColor") then
			vim.lsp.document_color.enable(true, args.buf, {
				style = 'virtual'
			})
		end

		if client:supports_method("textDocument/foldingRange") then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
	end
})
