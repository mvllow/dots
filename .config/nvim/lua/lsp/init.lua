local on_attach = function(client, bufnr) end

local function make_config()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			'documentation',
			'detail',
			'additionalTextEdits',
		}
	}

	return {
		capabilities = capabilities,
		on_attach = on_attach
	}
end

local function setup_servers()
	require'lspinstall'.setup()

	local servers = require'lspinstall'.installed_servers()

	for _, server in pairs(servers) do
		local config = make_config()

		if server == 'efm' then
			config = vim.tbl_extend('force', config, require'lsp/efm')
		end

		if server == 'lua' then
			config = vim.tbl_extend('force', config, require'lsp/lua')
		end

		require'lspconfig'[server].setup(config)
	end
end

setup_servers()

require'lspinstall'.post_install_hook = function ()
	setup_servers()
	vim.cmd('bufdo e')
end

