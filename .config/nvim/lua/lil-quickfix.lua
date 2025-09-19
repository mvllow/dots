---@tag lil-quickfix
---@signature require"lil-quickfix"
---@text Extend built-in quickfix behaviour
---
--- Features:
---
---   - Delete entries
---   - Manage the quickfix window
---   - Persist quickfix items across sessions
---
--- # Commands ~
---
--- - :LilQuickfix : Toggle quickfix window
--- - :copen       : Open the quickfix window
--- - :cnext       : Goto next quickfix entry
--- - :cprev       : Goto previous quickfix entry
---
--- # Keymaps ~
---
--- - Normal
---   - ]q : Goto next quickfix entry
---   - [q : Goto previous quickfix entry
---   - dd : Delete selected quickfix entry
--- - Visual
---   - d  : Delete selected quickfix entries

local STORAGE_PATH = vim.fn.stdpath("data") .. "/lil-quickfix.json"
local quickfix_data = {}

local function notify(value, log_level)
	vim.notify("[lil-quickfix] " .. value, log_level or vim.log.levels.INFO, { title = "lil-quickfix" })
end

local function get_project_id()
	local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD")
	if vim.v.shell_error == 0 then
		local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("%s+$", "")
		return git_root .. ":" .. branch:gsub("%s+$", "")
	end

	return vim.fn.getcwd()
end

local function save_quickfix_data()
	local file = io.open(STORAGE_PATH, "w")
	if not file then
		return
	end

	local json = vim.fn.json_encode(quickfix_data)
	file:write(json)
	file:close()
end

local function load_quickfix_data()
	local file = io.open(STORAGE_PATH, "r")
	if not file then
		return
	end

	local content = file:read("*all")
	file:close()

	local ok, decoded = pcall(vim.fn.json_decode, content)
	if ok then
		quickfix_data = decoded
	end
end

local function save_quickfix()
	local qf_list = vim.fn.getqflist()
	if vim.tbl_isempty(qf_list) then
		return
	end

	local project_id = get_project_id()

	-- Convert quickfix items to a serializable format
	local serializable_list = {}
	for _, item in ipairs(qf_list) do
		local filename = item.filename or ""
		if item.bufnr and item.bufnr > 0 then
			local buf_name = vim.api.nvim_buf_get_name(item.bufnr)
			if buf_name and buf_name ~= "" then
				filename = buf_name
			end
		end

		table.insert(serializable_list, {
			filename = filename,
			lnum = item.lnum or 1,
			col = item.col or 1,
			text = item.text or "",
			type = item.type or "",
			valid = item.valid or 1,
		})
	end

	quickfix_data[project_id] = serializable_list
	save_quickfix_data()
end

local function restore_quickfix()
	local project_id = get_project_id()
	local stored_qf = quickfix_data[project_id]

	if not stored_qf or vim.tbl_isempty(stored_qf) then
		return
	end

	if not vim.tbl_isempty(vim.fn.getqflist()) then
		return -- Don't overwrite existing quickfix
	end

	-- Filter out items without valid filenames
	local valid_items = {}
	for _, item in ipairs(stored_qf) do
		if item.filename and item.filename ~= "" then
			table.insert(valid_items, item)
		end
	end

	if not vim.tbl_isempty(valid_items) then
		vim.fn.setqflist(valid_items, "r")
		notify("restored " .. #valid_items .. " entries")
	end
end

local function delete_quickfix_entries()
	local is_quickfix = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].quickfix == 1
	if not is_quickfix then
		return
	end

	local start_line, end_line

	-- If in visual mode, delete the selected lines. Otherwise, delete the
	-- current line
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
		notify("empty list")
	end
end

-- Set keymaps scoped to the quickfix window
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("LilQuickfixFiletype", { clear = true }),
	pattern = "qf",
	callback = function()
		vim.keymap.set("n", "dd", delete_quickfix_entries, { buffer = true, desc = "Delete quickfix entry" })
		vim.keymap.set("v", "d", delete_quickfix_entries, { buffer = true, desc = "Delete quickfix entries" })
	end
})

-- Automatically open quickfix after population
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = vim.api.nvim_create_augroup("LilQuickfixOpen", { clear = true }),
	pattern = { "[^l]*" },
	command = "cwindow"
})

-- Save on exit
vim.api.nvim_create_autocmd("VimLeave", {
	group = vim.api.nvim_create_augroup("LilQuickfixSave", { clear = true }),
	callback = save_quickfix,
})

-- Restore on startup
vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("LilQuickfixRestore", { clear = true }),
	callback = function()
		vim.defer_fn(restore_quickfix, 50)
		load_quickfix_data()
	end,
})

vim.api.nvim_create_user_command("LilQuickfix", toggle_quickfix, { desc = "Toggle quickfix window" })
