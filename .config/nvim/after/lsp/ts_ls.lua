---@install
--- npm install -g typescript typescript-language-server
return {
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(0, "TypescriptOrganiseImports", function()
			client:exec_cmd({
				command = "_typescript.organizeImports",
				arguments = { vim.api.nvim_buf_get_name(bufnr) }
			})
		end, { desc = "Organise imports" })

		vim.keymap.set("n", "gro", ":TypescriptOrganiseImports<cr>")
	end
}
