local M = {}

--- Specify ts and ng probe locations. Useful for monorepo projects such as
--- when using nx. The server will automatically restart after a crash.
function M.lspconfig()
	local limit = 3
	local exit_count = 0
	local project_library_path = vim.fn.getcwd()
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
		on_exit = function(code, signal)
			exit_count = exit_count + 1
			if exit_count > limit then
				vim.notify("Lsp angularls has exited multiple times. Not restarting.")
				return
			end
			if code == 1 and signal == 0 then
				vim.defer_fn(function()
					vim.cmd("LspStart angularls")
				end, 1000)
			end
		end,
	}
end

function M.goto_component_or_template()
	vim.lsp.buf_request(
		0,
		"angular/getTemplateLocationForComponent",
		vim.lsp.util.make_position_params(0),
		function(_, result)
			if result then
				vim.lsp.util.jump_to_location(result, "utf-8", true)
			end
		end
	)
	vim.lsp.buf_request(
		0,
		"angular/getComponentsWithTemplateFile",
		vim.lsp.util.make_position_params(0),
		function(_, result)
			if result and #result ~= 0 then
				if #result == 1 then
					vim.lsp.util.jump_to_location(result[1], "utf-8", true)
				else
					vim.fn.setqflist({}, " ", {
						title = "Components",
						items = vim.lsp.util.locations_to_items(result, "utf-8"),
					})
				end
			end
		end
	)
end

return M
