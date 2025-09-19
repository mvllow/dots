---@tag lil-stats
---@signature require"lil-stats"
---@text Show file statistics
---
--- Features:
---
---   - File size, format and line counts
---   - Special comment detection (TODO, FIXME, etc.)
---   - Git status and diagnostics
---
--- # Commands ~
---
--- - :LilStats : Show current file statistics

local function notify(value, log_level)
	vim.notify("[lil-stats] " .. value, log_level or vim.log.levels.INFO, { title = "lil-stats" })
end

local function count_lines(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local total_lines = #lines
	local comment_lines = {}

	local parser = vim.treesitter.get_parser(bufnr)
	if parser then
		local lang = parser:lang()
		local tree = parser:parse()[1]
		local root = tree:root()

		local ok, query = pcall(vim.treesitter.query.parse, lang, [[ (comment) @comment ]])

		if ok then
			for _, node, _ in query:iter_captures(root, bufnr, 0, -1) do
				local start_row, _, end_row, _ = node:range()
				for line = start_row, end_row do
					comment_lines[line + 1] = true
				end
			end
		end
	end

	local code_lines = 0
	local blank_lines = 0

	for i, line in ipairs(lines) do
		local trimmed = line:match("^%s*(.-)%s*$")
		if trimmed == "" then
			blank_lines = blank_lines + 1
		elseif not comment_lines[i] then
			code_lines = code_lines + 1
		end
	end

	return {
		total = total_lines,
		code = code_lines,
		comments = vim.tbl_count(comment_lines),
		blank = blank_lines,
	}
end

local function get_file_info(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local filename = vim.api.nvim_buf_get_name(bufnr)

	if filename == "" then
		return nil
	end

	local stat = vim.loop.fs_stat(filename)
	if not stat then
		return nil
	end

	return {
		size = stat.size,
		modified = stat.mtime.sec,
		encoding = vim.bo[bufnr].fileencoding,
		format = vim.bo[bufnr].fileformat,
	}
end

local function get_git_info(filename)
	if filename == "" then
		return nil
	end

	local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null"):gsub("%s+$", "")
	if vim.v.shell_error ~= 0 then
		return nil
	end

	local status = vim.fn.system("git status --porcelain " .. vim.fn.shellescape(filename) .. " 2>/dev/null"):gsub(
		"%s+$", "")
	local file_status = ""
	if status ~= "" then
		file_status = status:sub(1, 1) -- first character is staged status
		if file_status == " " then
			file_status = status:sub(2, 2) -- second character is working tree status
		end
	end

	return {
		branch = branch,
		status = file_status
	}
end

local function find_special_comments(bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local counts = {}

	for _, line in ipairs(lines) do
		-- Look for any 'CAPS:' pattern
		for word in line:gmatch("([A-Z]+):") do
			counts[word] = (counts[word] or 0) + 1
		end
	end

	return counts
end

local function get_diagnostics(bufnr)
	local diagnostics = vim.diagnostic.get(bufnr)
	local counts = { error = 0, warn = 0, info = 0, hint = 0 }

	for _, diag in ipairs(diagnostics) do
		if diag.severity == vim.diagnostic.severity.ERROR then
			counts.error = counts.error + 1
		elseif diag.severity == vim.diagnostic.severity.WARN then
			counts.warn = counts.warn + 1
		elseif diag.severity == vim.diagnostic.severity.INFO then
			counts.info = counts.info + 1
		elseif diag.severity == vim.diagnostic.severity.HINT then
			counts.hint = counts.hint + 1
		end
	end

	return counts
end

local function format_size(bytes)
	if bytes < 1024 then
		return bytes .. "B"
	elseif bytes < 1024 * 1024 then
		return string.format("%.1fK", bytes / 1024)
	else
		return string.format("%.1fM", bytes / (1024 * 1024))
	end
end

local function format_time_ago(timestamp)
	local now = os.time()
	local diff = now - timestamp

	if diff < 60 then
		return "just now"
	elseif diff < 3600 then
		return math.floor(diff / 60) .. "m ago"
	elseif diff < 86400 then
		return math.floor(diff / 3600) .. "h ago"
	else
		return math.floor(diff / 86400) .. "d ago"
	end
end

local function show_stats()
	local bufnr = vim.api.nvim_get_current_buf()
	local filename = vim.api.nvim_buf_get_name(bufnr)

	if filename == "" then
		notify("no file")
		return
	end

	local basename = vim.fn.fnamemodify(filename, ":t")
	local file_info = get_file_info(bufnr)
	local git_info = get_git_info(filename)
	local lines = count_lines(bufnr)
	local special_comments = find_special_comments(bufnr)
	local diagnostics = get_diagnostics(bufnr)

	-- Build content
	local content = {}
	local highlights = {}

	-- File section
	table.insert(content, "File")
	table.insert(highlights, { #content - 1, 0, #content[#content], "Comment" })

	if file_info then
		local file_line = "  " ..
		    format_size(file_info.size) .. " | " .. file_info.encoding .. " | " .. file_info.format:upper()
		table.insert(content, file_line)

		local time_line = "  Modified " .. format_time_ago(file_info.modified)
		table.insert(content, time_line)
	end

	local lines_line = "  " .. lines.total .. " lines (" .. lines.code .. " code)"
	table.insert(content, lines_line)

	table.insert(content, "")

	-- Git section
	table.insert(content, "Git")
	table.insert(highlights, { #content - 1, 0, #content[#content], "Comment" })

	if git_info then
		local git_line = "  " .. git_info.branch
		if git_info.status ~= "" then
			git_line = git_line .. " (" .. git_info.status .. ")"
		end
		table.insert(content, git_line)
	else
		local no_git_line = "  Not a git repository"
		table.insert(content, no_git_line)
	end

	table.insert(content, "")

	-- Comments section
	table.insert(content, "Comments")
	table.insert(highlights, { #content - 1, 0, #content[#content], "Comment" })

	local has_comments = lines.comments > 0
	local has_special = next(special_comments) ~= nil

	if has_comments or has_special then
		if has_comments then
			local comment_count_line = "  " ..
			    lines.comments .. " comment line" .. (lines.comments > 1 and "s" or "")
			table.insert(content, comment_count_line)
		end

		if has_special then
			local special_parts = {}
			for word, count in pairs(special_comments) do
				table.insert(special_parts, count .. " " .. word)
			end
			local special_line = "  " .. table.concat(special_parts, ", ")
			table.insert(content, special_line)
			table.insert(highlights, { #content - 1, 0, #special_line, "DiagnosticHint" })
		end
	else
		local none_line = "  None"
		table.insert(content, none_line)
	end

	table.insert(content, "")

	-- Diagnostics section
	table.insert(content, "Diagnostics")
	table.insert(highlights, { #content - 1, 0, #content[#content], "Comment" })

	local diag_parts = {}
	if diagnostics.error > 0 then
		table.insert(diag_parts, diagnostics.error .. " error" .. (diagnostics.error > 1 and "s" or ""))
	end
	if diagnostics.warn > 0 then
		table.insert(diag_parts, diagnostics.warn .. " warning" .. (diagnostics.warn > 1 and "s" or ""))
	end
	local diag_line = "  " .. (next(diag_parts) and table.concat(diag_parts, ", ") or "None")
	table.insert(content, diag_line)
	if diagnostics.error > 0 then
		table.insert(highlights, { #content - 1, 0, #diag_line, "DiagnosticError" })
	elseif diagnostics.warn > 0 then
		table.insert(highlights, { #content - 1, 0, #diag_line, "DiagnosticWarn" })
	end

	-- Create split
	vim.cmd("botright 15split [lil-stats: " .. basename .. "]")
	local buf = vim.api.nvim_get_current_buf()

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

	local ns = vim.api.nvim_create_namespace("lil-stats")
	for _, hl in ipairs(highlights) do
		vim.api.nvim_buf_set_extmark(buf, ns, hl[1], hl[2], {
			end_col = hl[3],
			hl_group = hl[4]
		})
	end

	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.bo.swapfile = false
	vim.bo.modifiable = false
	vim.wo.number = false
	vim.wo.relativenumber = false
	vim.wo.cursorline = false
	vim.wo.wrap = false

	vim.keymap.set('n', 'q', ':close<cr>', { buffer = buf, silent = true })
	vim.keymap.set('n', '<esc>', ':close<cr>', { buffer = buf, silent = true })
end

vim.api.nvim_create_user_command("LilStats", show_stats, { desc = "Show file statistics" })
