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

	local is_lsp_opt, _ = pcall(function() return vim.lsp[opt] and vim.lsp[opt].enable and vim.lsp[opt].is_enabled end)
	if is_lsp_opt then
		vim.lsp[opt].enable(not vim.lsp[opt].is_enabled())
		vim.notify("Set " .. opt .. " to " .. tostring(vim.lsp[opt].is_enabled()))
		return
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
map_toggle("gdc", "document_color")
map_toggle("gih", "inlay_hint")
map_toggle("h", function()
	local has_mini_diff, mini_diff = pcall(require, "mini.diff")
	if has_mini_diff then
		mini_diff.toggle_overlay()
	end
end)
map_toggle("l", "list")
map_toggle("n", "number")
map_toggle("s", "spell")
