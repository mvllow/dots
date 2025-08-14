LilToggleState = {}

local function toggle(opt)
	local is_vim_opt, _ = pcall(function() return vim.o[opt] end)
	if is_vim_opt then
		if type(vim.o[opt]) == "boolean" then
			vim.o[opt] = not vim.o[opt]
			vim.notify("Set " .. opt .. " to " .. tostring(vim.o[opt]))
			return
		end

		if type(vim.o[opt]) == "number" then
			if vim.o[opt] == 0 then
				vim.o[opt] = LilToggleState[opt] or 1
			else
				LilToggleState[opt] = vim.o[opt]
				vim.o[opt] = 0
			end
			vim.notify("Set " .. opt .. " to " .. tostring(vim.o[opt]))
			return
		end

		if vim.o[opt] == "light" or vim.o[opt] == "dark" then
			vim.o[opt] = vim.o[opt] == "light" and "dark" or "light"
			vim.notify("Set " .. opt .. " to " .. tostring(vim.o[opt]))
			return
		end

		return
	end

	local is_lsp_opt, lsp_opt = pcall(function() return vim.lsp[opt] end)
	if is_lsp_opt and lsp_opt ~= nil and type(lsp_opt.enable) == "function" and type(lsp_opt.is_enabled) == "function" then
		vim.lsp[opt].enable(not vim.lsp[opt].is_enabled())
		vim.notify("Set " .. opt .. " to " .. tostring(vim.lsp[opt].is_enabled()))
		return
	end

	local has_commands, commands = pcall(vim.api.nvim_get_autocmds, { group = opt })
	if has_commands and type(commands) == "table" then
		LilToggleState[opt] = commands
		pcall(vim.api.nvim_del_augroup_by_name, opt)
		vim.notify(opt .. " disabled")
		return
	end

	vim.api.nvim_create_augroup(opt, { clear = true })

	commands = LilToggleState[opt] or commands
	if type(commands) == "table" then
		for _, command in pairs(commands) do
			local opts = {}
			opts.desc = command.desc or ""
			opts.group = command.group_name or opt

			-- Use one of pattern or buffer
			if command.pattern ~= nil then
				opts.pattern = command.pattern
			elseif command.buffer ~= nil then
				opts.buffer = command.buffer
			end

			-- Use one of callback or command
			if command.callback ~= nil then
				opts.callback = command.callback
			elseif command.command ~= nil then
				opts.command = command.command
			end

			vim.api.nvim_create_autocmd(command.event, opts)
			vim.notify(opt .. " enabled")
		end
	end
end

local function toggle_quickfix()
	local is_open = false
	for _, window in pairs(vim.fn.getwininfo()) do
		if window["quickfix"] == 1 then
			is_open = true
		end
	end
	if is_open then
		vim.cmd("cclose")
		vim.notify("Quickfix closed")
		return
	end
	if vim.tbl_isempty(vim.fn.getqflist()) then
		vim.notify("Quickfix is empty")
	else
		vim.cmd("copen")
		vim.notify("Quickfix opened")
	end
end

local prefix = vim.g.lil_toggle_prefix or [[\]]
local modes  = { "n", "v", "x" }

local function map_toggle(lhs, rhs)
	if type(rhs) == "function" then
		vim.keymap.set(modes, prefix .. lhs, rhs)
		return
	end
	vim.keymap.set(modes, prefix .. lhs, function() toggle(rhs) end)
end

map_toggle("a", "autocomplete")
map_toggle("b", "background")
map_toggle("c", "cmdheight")
map_toggle("f", "FormatOnSave")
map_toggle("gdc", "document_color")
map_toggle("gih", "inlay_hint")
map_toggle("h", function()
	local has_mini_diff, mini_diff = pcall(require, "mini.diff")
	if has_mini_diff then
		mini_diff.toggle_overlay()
	end
end)
map_toggle("l", "list")
map_toggle("m", "laststatus")
map_toggle("n", "number")
map_toggle("q", toggle_quickfix)
map_toggle("s", "spell")
