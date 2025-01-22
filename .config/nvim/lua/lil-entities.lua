local entities_to_unicode = {
	["&larr;"] = "←",
	["&uarr;"] = "↑",
	["&rarr;"] = "→",
	["&darr;"] = "↓",
	["&harr;"] = "↔",
	["&varr;"] = "↕",
	["&nwarr;"] = "↖",
	["&nearr;"] = "↗",
	["&searr;"] = "↘",
	["&swarr;"] = "↙",
	["&crarr;"] = "↵",
	["&ndash;"] = "–",
	["&mdash;"] = "—",
	["&minus;"] = "−",
	["&times;"] = "×",
	["&middot;"] = "·",
	["&copy;"] = "©",
	["&euro;"] = "€",
	["&quot;"] = "\"",
	["&raquo;"] = "»",
	["&laquo;"] = "«",
	["&#10003;"] = "✓",
	["&check;"] = "✓",
}

local unicode_to_entities = {}
for entity, unicode in pairs(entities_to_unicode) do
	unicode_to_entities[unicode] = entity
end

local function replace_entities_with_unicode()
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	for linenr, line in ipairs(lines) do
		for entity, unicode in pairs(entities_to_unicode) do
			line = line:gsub(entity, unicode)
		end
		vim.api.nvim_buf_set_lines(bufnr, linenr - 1, linenr, false, { line })
	end
end

local function replace_unicode_with_entities()
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	for linenr, line in ipairs(lines) do
		for unicode, entity in pairs(unicode_to_entities) do
			line = line:gsub(unicode, entity)
		end
		vim.api.nvim_buf_set_lines(bufnr, linenr - 1, linenr, false, { line })
	end
end

vim.api.nvim_create_user_command("ReplaceEntitiesWithUnicode", replace_entities_with_unicode, {})
vim.api.nvim_create_user_command("ReplaceUnicodeWithEntities", replace_unicode_with_entities, {})
