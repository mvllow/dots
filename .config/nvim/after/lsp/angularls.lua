return {
	lil_install_cmd = { "npm", "i", "-g", "@angular/language-server" },
	lil_install_msg =
	"Ensure the language service is installed in your local project: npm i -D @angular/language-service",

	on_attach = function()
		local clients = vim.lsp.get_clients({ name = "angularls" })
		if not clients or #clients == 0 then
			vim.notify("Angular LSP not active", vim.log.levels.ERROR)
			return
		end
		local client = clients[1]

		local function find_component_decorator()
			local bufnr = vim.api.nvim_get_current_buf()
			local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
			for i, line in ipairs(lines) do
				if line:match("@Component") then
					return i - 1 -- Convert to 0-based index
				end
			end

			vim.notify("No @Component decorator found in file", vim.log.levels.WARN)
			return nil
		end

		vim.api.nvim_buf_create_user_command(0, "AngularGotoTemplate", function()
			-- Create params with position at the @Component line for the
			-- command to recognise component we are trying to get the template
			-- location of.
			local params = {
				textDocument = vim.lsp.util.make_text_document_params(),
				position = { line = find_component_decorator(), character = 0 }
			}

			client:request(
				"angular/getTemplateLocationForComponent",
				params,
				function(err, result)
					if err then
						vim.notify("Error: " .. err.message, vim.log.levels.ERROR)
						return
					end
					if result then
						if result.uri then
							vim.cmd.edit(vim.uri_to_fname(result.uri))
						else
							vim.notify("No template location found", vim.log.levels.WARN)
						end
					end
				end,
				0
			)
		end, { desc = "Goto corresponding template" })

		vim.api.nvim_buf_create_user_command(0, "AngularGotoComponent", function()
			local params = vim.lsp.util.make_position_params(0, "utf-8")
			client:request(
				"angular/getComponentsWithTemplateFile",
				params,
				function(err, result)
					if err then
						vim.notify("Error: " .. err.message, vim.log.levels.ERROR)
						return
					end
					if result and #result ~= 0 then
						if #result == 1 then
							vim.cmd.edit(vim.uri_to_fname(result[1].uri))
						else
							vim.fn.setqflist({}, " ", {
								title = "Angular Components",
								items = vim.lsp.util.locations_to_items(result, "utf-8")
							})
							vim.cmd.copen()
						end
					else
						vim.notify("No component found", vim.log.levels.WARN)
					end
				end,
				0
			)
		end, { desc = "Goto corresponding component" })

		local function is_template_file()
			local current_file = vim.fn.expand("%:t")
			return current_file:match("%.html$") ~= nil
		end

		vim.keymap.set("n", "<c-l>", function()
			if is_template_file() then
				vim.cmd("AngularGotoComponent")
			else
				vim.cmd("AngularGotoTemplate")
			end
		end, { desc = "Toggle between Angular component and template" })
	end,
}
