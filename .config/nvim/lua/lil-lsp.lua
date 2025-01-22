local lsp_configs = {}
for _, f in pairs(vim.api.nvim_get_runtime_file('after/lsp/*.lua', true)) do
	local server = vim.fn.fnamemodify(f, ':t:r')
	table.insert(lsp_configs, server)
end

local function install_lsp_server(server)
	local cfg = vim.lsp.config[server]

	if not cfg then
		vim.print("lil-lsp: Config for '" .. server .. "' not found")
		return false
	end

	if type(cfg.cmd) ~= "table" or not cfg.cmd[1] then
		vim.print("lil-lsp: Invalid command config for '" .. server .. "'")
		return false
	end

	if vim.fn.executable(cfg.cmd[1]) == 1 then
		vim.print("lil-lsp: '" .. server .. "' is already installed")
		return true
	end

	if cfg.lil_install_cmd then
		vim.print("lil-lsp: Install command:\n  " .. table.concat(cfg.lil_install_cmd, " "))
		local answer = vim.fn.input("lil-lsp: Run install for '" .. server .. "'? [y/N]: ")

		if answer:lower() == "y" or answer:lower() == "yes" then
			vim.print("lil-lsp: Installing '" .. server .. "'...\n")
			local result = vim.fn.system(cfg.lil_install_cmd)
			vim.print(result)

			if vim.fn.executable(cfg.cmd[1]) == 1 then
				vim.print("lil-lsp: Installed '" .. server .. "' successfully")
				return true
			else
				vim.print("lil-lsp: Installation failed for '" .. server .. "'")
			end
		end
	else
		vim.print("lil-lsp: No install command provided for '" .. server .. "'")
	end

	if cfg.lil_install_msg then
		vim.print(cfg.lil_install_msg)
	end

	return false
end

vim.api.nvim_create_user_command("LilLspInstall", function(opts)
	local server = opts.args
	if server and #server > 0 then
		install_lsp_server(server)
	else
		vim.print("lil-lsp: Usage: `:LilLspInstall <server_name>`")
	end
end, {
	nargs = 1,
	complete = function()
		return lsp_configs
	end
})

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
