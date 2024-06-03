local M = {}

function M.on_lsp_attach(client)
	-- https://github.com/sveltejs/language-tools/issues/2008#issuecomment-2042675326
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = vim.api.nvim_create_augroup("OnDidChangeFile", { clear = true }),
		pattern = { "*.js", "*.ts" },
		callback = function(ctx)
			client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
		end,
	})
end

return M
