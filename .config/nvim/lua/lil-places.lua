---
--- lil-places.lua
--- https://github.com/mvllow/lilvim
---
--- Extend builtin mark behaviour with persistent storage
---
--- @commands
--- :LilPlaces    : Show marked places
--- :delmarks a-z : Delete marks
---
---@keymaps
--- |NORMAL|
--- m[a-z] : Mark place
--- '[a-z] : Visit place
---

local STORAGE_PATH = vim.fn.stdpath("data") .. "/lil-places.json"
local maps = {}

local function get_map_id()
	local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD")
	if vim.v.shell_error == 0 then
		local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("%s+$", "")
		return git_root .. ":" .. branch:gsub("%s+$", "")
	end

	return vim.fn.getcwd()
end

local function save_maps()
	local file = io.open(STORAGE_PATH, "w")
	if not file then
		return
	end

	local json = vim.fn.json_encode(maps)
	file:write(json)
	file:close()
end

local function load_maps()
	local file = io.open(STORAGE_PATH, "r")
	if not file then
		return
	end

	local content = file:read("*all")
	file:close()

	local ok, decoded = pcall(vim.fn.json_decode, content)
	if ok then
		maps = decoded
	end
end

vim.keymap.set("n", "m", function()
	local char = vim.fn.getcharstr()
	if char:match("^[a-z]$") then
		local map_id = get_map_id()
		maps[map_id] = maps[map_id] or {}

		local pos = vim.api.nvim_win_get_cursor(0)
		maps[map_id][char] = {
			file = vim.fn.expand("%:p"),
			pos = { pos[1], pos[2] }
		}
	end

	return "m" .. char
end, { expr = true, desc = "Mark place" })

vim.keymap.set("n", "'", function()
	local char = vim.fn.getcharstr()
	if char:match("^[a-z]$") then
		local map_id = get_map_id()
		local marks = maps[map_id] or {}
		local mark = marks[char]

		if mark then
			vim.cmd("edit " .. mark.file)
			vim.api.nvim_win_set_cursor(0, mark.pos)
			return
		else
			vim.notify("Mark '" .. char .. "' not found in this project", vim.log.levels.WARN)
			return
		end
	end

	vim.cmd("normal! '" .. char)
end, { desc = "Visit place" })

local function handle_delmarks(args)
	local map_id = get_map_id()
	if not maps[map_id] then return end

	if args == "!" then
		-- Remove all
		maps[map_id] = {}
	elseif args:match("^[a-z]$") then
		-- Remove single mark (a)
		maps[map_id][args] = nil
	elseif args:match("^[a-z]%-[a-z]$") then
		-- Remove range (a-c)
		local start_char, end_char = args:match("([a-z])-([a-z])")
		for char = string.byte(start_char), string.byte(end_char) do
			maps[map_id][string.char(char)] = nil
		end
	else
		-- Remove list (abc or a b c)
		for char in args:gmatch("[a-z]") do
			maps[map_id][char] = nil
		end
	end

	save_maps()
end

local function view()
	local map_id = get_map_id()
	local marks = maps[map_id] or {}

	if vim.tbl_isempty(marks) then
		vim.notify("No marks in this project")
		return
	end

	local display_marks = {}
	for mark_name, mark_data in pairs(marks) do
		table.insert(display_marks, {
			mark = mark_name,
			path = vim.fn.fnamemodify(mark_data.file, ":~:."),
			full_path = mark_data.file,
			pos = mark_data.pos
		})
	end

	table.sort(display_marks, function(a, b)
		return a.mark:lower() < b.mark:lower()
	end)

	vim.ui.select(display_marks, {
		prompt = "Places",
		format_item = function(item)
			return string.format("'%s  %s:%d", item.mark, item.path, item.pos[1])
		end
	}, function(choice)
		if choice then
			vim.cmd("edit +" .. choice.pos[1] .. " " .. choice.full_path)
			vim.schedule(function()
				vim.api.nvim_win_set_cursor(0, { choice.pos[1], choice.pos[2] })
			end)
		end
	end)
end

load_maps()

vim.api.nvim_create_autocmd("CmdlineLeave", {
	group = vim.api.nvim_create_augroup("LilPlacesDelmarks", { clear = true }),
	callback = function()
		local cmdline = vim.fn.getcmdline()
		if cmdline:match("^delmarks%s+(.+)$") then
			local args = cmdline:match("^delmarks%s+(.+)$")
			if args:match("[a-z!]") then
				handle_delmarks(args)
			end
		end
	end
})

vim.api.nvim_create_autocmd("VimLeave", {
	group = vim.api.nvim_create_augroup("LilPlacesQuit", { clear = true }),
	callback = save_maps
})

vim.api.nvim_create_user_command("LilPlaces", view, {})
