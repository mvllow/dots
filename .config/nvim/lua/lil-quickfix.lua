local function delete_quickfix_entries()
	local is_quickfix = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].quickfix == 1
	if not is_quickfix then
		return
	end

	local start_line, end_line

	-- If in visual mode, delete the selected lines. Otherwise, delete the current line.
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

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("QuickFixMappings", { clear = true }),
	pattern = "qf",
	callback = function()
		vim.keymap.set("n", "dd", delete_quickfix_entries, { buffer = true })
		vim.keymap.set("v", "d", delete_quickfix_entries, { buffer = true })
	end
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = vim.api.nvim_create_augroup("QuickFixOpenOnCmd", { clear = true }),
	pattern = { "[^l]*" },
	command = "cwindow"
})
