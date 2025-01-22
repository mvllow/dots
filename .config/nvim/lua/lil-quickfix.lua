---
--- lil-quickfix.lua
--- https://github.com/mvllow/lilvim
---
--- Extend builtin quickfix behaviour with entry and window management
---
---@commands
--- :LilQuickfix : Toggle quickfix window
--- :copen       : Open the quickfix window
--- :cnext       : Goto next quickfix entry
--- :cprev       : Goto previous quickfix entry
---
---@keymaps
--- |NORMAL|
--- ]q : Goto next quickfix entry
--- [q : Goto previous quickfix entry
--- dd : Delete selected quickfix entry
--- |VISUAL|
--- d  : Delete selected quickfix entries
---

local function delete_quickfix_entries()
	local is_quickfix = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].quickfix == 1
	if not is_quickfix then
		return
	end

	local start_line, end_line

	-- If in visual mode, delete the selected lines. Otherwise, delete the current line
	if vim.fn.mode():lower() == "v" then
		start_line = vim.fn.line("v")
		end_line = vim.fn.line(".")
		if start_line > end_line then
			start_line, end_line = end_line, start_line
		end

		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", false)
	else
		start_line = vim.fn.line(".")
		end_line = start_line
	end

	local quickfix_list = vim.fn.getqflist()

	for i = end_line, start_line, -1 do
		table.remove(quickfix_list, i)
	end

	vim.fn.setqflist(quickfix_list, "r")

	vim.cmd("copen")

	local new_line = math.min(start_line, #quickfix_list)
	vim.api.nvim_win_set_cursor(0, { new_line, 0 })
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
		return
	end
	if not vim.tbl_isempty(vim.fn.getqflist()) then
		vim.cmd("copen")
	else
		vim.notify("quickfix is empty", vim.log.levels.INFO, { title = "lil-quickfix" })
	end
end

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("LilQuickfix", { clear = true }),
	pattern = "qf",
	callback = function()
		vim.keymap.set("n", "dd", delete_quickfix_entries, { buffer = true, desc = "Delete quickfix entry" })
		vim.keymap.set("v", "d", delete_quickfix_entries, { buffer = true, desc = "Delete quickfix entries" })
	end
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = vim.api.nvim_create_augroup("LilQuickfix", { clear = true }),
	pattern = { "[^l]*" },
	command = "cwindow"
})

vim.api.nvim_create_user_command("LilQuickfix", toggle_quickfix, {})
