return {
	lil_install_cmd = { "npm", "i", "-g", "svelte-language-server" },

	on_attach = function(client)
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = { "*.js", "*.ts" },
			group = vim.api.nvim_create_augroup("svelte_ondidchangetsorjsfile", { clear = true }),
			callback = function(ctx)
				client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
			end,
		})
	end
}
