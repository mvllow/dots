return {
	angular = {
		lspconfig = function()
			local limit = 3
			local exit_count = 0
			local project_library_path = vim.fn.getcwd()
			--- Specify ts and ng probe locations. Useful for monorepo projects
			--- such as when using nx.
			local cmd = {
				"ngserver",
				"--stdio",
				"--tsProbeLocations",
				project_library_path,
				"--ngProbeLocations",
				project_library_path,
			}
			return {
				cmd = cmd,
				on_new_config = function(new_config)
					new_config.cmd = cmd
				end,
				root_dir = require("lspconfig.util").root_pattern("angular.json", "project.json"),
				-- Restart the server after a crash, up until the defined
				-- limit.
				on_exit = function(code, signal)
					exit_count = exit_count + 1
					if exit_count > limit then
						vim.notify(
							"angularls has exceeded the restart limit of "
								.. limit
								.. " times. Use `:LspStart angularls` to start it manually."
						)
						return
					end
					if code == 1 and signal == 0 then
						vim.defer_fn(function()
							vim.cmd("LspStart angularls")
						end, 1000)
					end
				end,
			}
		end,
	},
	astro = {
		lsp_on_attach = function(client)
			-- https://github.com/sveltejs/language-tools/issues/2008#issuecomment-2042675326
			vim.api.nvim_create_autocmd("BufWritePost", {
				group = vim.api.nvim_create_augroup("OnDidChangeFile", { clear = true }),
				pattern = { "*.js", "*.ts" },
				callback = function(ctx)
					client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
				end,
			})
		end,
	},
	lua = {
		lspconfig = function()
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
		end,
	},
	svelte = {
		lsp_on_attach = function(client)
			-- https://github.com/sveltejs/language-tools/issues/2008#issuecomment-2042675326
			vim.api.nvim_create_autocmd("BufWritePost", {
				group = vim.api.nvim_create_augroup("OnDidChangeFile", { clear = true }),
				pattern = { "*.js", "*.ts" },
				callback = function(ctx)
					client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
				end,
			})
		end,
	},
}
