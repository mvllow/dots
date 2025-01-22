---@param hex string A string representing the hex colour, e.g. "#fa8072"
---@return integer Red, integer Green, integer Blue
---@private
local function hex_to_rgb(hex)
	hex = hex:gsub("#", "")
	return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

---@param r number Red (0-255)
---@param g number Green (0-255)
---@param b number Blue (0-255)
---@return string
---@private
local function rgb_to_hex(r, g, b)
	return string.format("#%02x%02x%02x", r, g, b)
end

local blend_cache = {}

---@param fg string The foreground colour as a hex string, e.g. "#fa8072"
---@param bg string The background colour as a hex string, e.g. "#000000"
---@param alpha number A number between 0 (background) and 1 (foreground)
---@return string
---@private
local function blend(fg, bg, alpha)
	local cache_key = fg .. bg .. alpha
	if blend_cache[cache_key] then
		return blend_cache[cache_key]
	end

	local r1, g1, b1 = hex_to_rgb(fg)
	local r2, g2, b2 = hex_to_rgb(bg)

	local r = r1 * alpha + r2 * (1 - alpha)
	local g = g1 * alpha + g2 * (1 - alpha)
	local b = b1 * alpha + b2 * (1 - alpha)

	local result = rgb_to_hex(math.floor(r), math.floor(g), math.floor(b))

	blend_cache[cache_key] = result
	return result
end

---@param palette Palette
---@param key string
---@return string
---@private
local function find_palette_value_by_key(palette, key)
	return palette[key] or key or ""
end

---@class Config
local config = {
	--- Helper table to set user highlight groups, extending the theme's group
	--- values. The palette is accessible by name, e.g. "iris":
	--- ```lua
	--- vim.g.rose_pine_groups = {
	---   Normal = { fg = "iris" }
	--- }
	--- ```
	---
	--- If you want to override a value completely, use the Neovim api directly:
	--- ```lua
	--- vim.api.nvim_create_autocmd("ColorScheme", {
	---   pattern = "bauhaus",
	---   callback = function()
	---     vim.api.nvim_set_hl(0, { ... })
	---   end
	--- })
	--- ```
	groups = vim.g.rose_pine_groups or {}
}

if vim.g.colors_name then
	vim.cmd("hi clear")
	vim.cmd("syntax reset")
end
vim.g.colors_name = "bauhaus"

local black       = "#010203"
local white       = "#F7ECDF"

---@class Palette
local palette     = {
	base      = "#FAEFE1",
	text      = "#261C15",
	red       = "#C9352F",
	on_red    = white,
	yellow    = "#ECB055",
	on_yellow = black,
	blue      = "#2E3088",
	on_blue   = white,
}

if vim.o.background == "dark" then
	palette = {
		base      = "#141519",
		text      = "#F9F9F6",
		red       = "#D63831",
		on_red    = white,
		yellow    = "#EAB83F",
		on_yellow = black,
		blue      = "#2249A6",
		on_blue   = white,
	}
end

local highlights = {
	-- Interface
	CursorLine               = { bg = palette.text, fg = palette.base },
	Directory                = { fg = palette.text, bold = true },
	LineNr                   = { fg = palette.text },
	SpecialKey               = { fg = palette.text },
	Normal                   = { bg = palette.base, fg = palette.text },
	QuickFixLine             = { fg = palette.red },
	StatusLine               = { bg = palette.base, fg = palette.text },
	StatusLineNC             = { bg = palette.text, fg = palette.base },
	Visual                   = { bg = palette.blue, fg = palette.on_blue },
	WinSeparator             = { fg = palette.text },

	-- Message area
	ModeMsg                  = { fg = palette.text },
	MoreMsg                  = { fg = palette.text },
	-- hl(0, "MsgArea", { bg = palette.surface, fg = palette.subtle })

	-- Menus
	Pmenu                    = { bg = palette.yellow, fg = palette.base },
	PmenuExtra               = { fg = palette.on_yellow, italic = true },
	PmenuExtraSel            = { bg = palette.text, fg = palette.base, italic = true },
	PmenuKind                = { fg = palette.on_yellow, italic = true },
	PmenuKindSel             = { bg = palette.text, fg = palette.base, italic = true },
	PmenuMatch               = { fg = palette.text },
	PmenuMatchSel            = { fg = palette.text, bold = true },
	PmenuSbar                = { bg = palette.on_yellow },
	PmenuSel                 = { bg = palette.text, fg = palette.base, bold = true },
	PmenuThumb               = { bg = palette.on_yellow },

	-- Floats
	FloatBorder              = { bg = palette.blue, fg = palette.on_blue },
	FloatFooter              = { bg = palette.blue, fg = palette.on_blue },
	FloatTitle               = { bg = palette.blue, fg = palette.on_blue, bold = true },
	NormalFloat              = { bg = palette.blue, fg = palette.on_blue },

	-- Search
	CurSearch                = { bg = palette.yellow, fg = palette.on_yellow },
	IncSearch                = { bg = palette.yellow, fg = palette.on_yellow },
	Search                   = { bg = palette.text, fg = palette.base },

	-- Diagnostics
	DiagnosticDeprecated     = { fg = palette.text, strikethrough = true },
	DiagnosticError          = { fg = palette.red },
	DiagnosticHint           = { fg = palette.blue },
	DiagnosticInfo           = { fg = palette.blue },
	DiagnosticOk             = { fg = palette.blue },
	DiagnosticWarn           = { fg = palette.yellow },
	DiagnosticFloatingInfo   = { bg = palette.blue, fg = palette.on_blue },
	DiagnosticUnderlineError = { sp = palette.red, blend = 0.5, undercurl = true },
	DiagnosticUnderlineHint  = { sp = palette.blue, blend = 0.5, undercurl = true },
	DiagnosticUnderlineInfo  = { sp = palette.blue, blend = 0.5, undercurl = true },
	DiagnosticUnderlineOk    = { sp = palette.blue, blend = 0.5, undercurl = true },
	DiagnosticUnderlineWarn  = { sp = palette.yellow, blend = 0.5, undercurl = true },
	Error                    = { bg = palette.red, blend = 0.5 },

	-- Diff
	Added                    = { fg = palette.blue },
	Changed                  = { fg = palette.yellow },
	Removed                  = { fg = palette.red },
	DiffAdd                  = { bg = palette.blue, fg = palette.blue, blend = 0.2 },
	DiffChange               = { bg = palette.yellow, fg = palette.yellow, blend = 0.2 },
	DiffDelete               = { bg = palette.red, fg = palette.red, blend = 0.2 },
	DiffText                 = { bg = palette.text, fg = palette.text, blend = 0.2 },

	-- Syntax
	Comment                  = { fg = palette.text },
	Constant                 = { fg = palette.text },
	Delimiter                = { fg = palette.text },
	Function                 = { fg = palette.red },
	Identifier               = { fg = palette.text },
	MatchParen               = { bg = palette.yellow, fg = palette.on_yellow, underline = true },
	NonText                  = { fg = palette.text, italic = true },
	Operator                 = { fg = palette.text },
	Question                 = { fg = palette.blue },
	Special                  = { fg = palette.text },
	SpellBad                 = { sp = palette.text, underdotted = true },
	SpellCap                 = { sp = palette.text, underdotted = true },
	SpellRare                = { sp = palette.text, underdotted = true },
	SpellLocal               = { sp = palette.text, underdotted = true },
	Statement                = { fg = palette.text },
	String                   = { fg = palette.yellow },
	Type                     = { fg = palette.blue, bold = true },
	Underlined               = { fg = palette.text, sp = palette.text, underline = true },

	-- Treesitter syntax
	["@type"]                = { fg = palette.blue },
	["@type.builtin"]        = { fg = palette.blue, bold = true },
	["@function"]            = { fg = palette.red },
	["@function.builtin"]    = { fg = palette.red, bold = true },
	["@variable"]            = { fg = palette.text },
	["@variable.builtin"]    = { fg = palette.text, bold = true },
}

local transparent = false
if config.groups["Normal"] ~= nil then
	if (config.groups["Normal"].bg or ""):lower() == "none" then
		transparent = true
	end
end

-- Merge user highlight groups
for group, highlight in pairs(config.groups) do
	local original = highlights[group] or {}
	local base = highlight

	-- Find root link to extend its properties
	while original.link ~= nil do
		original = highlights[original.link] or {}
	end
	while base.link ~= nil do
		base = highlights[base.link] or {}
	end

	local parsed_highlight = vim.tbl_extend("force", {}, base)

	if highlight.fg ~= nil then
		parsed_highlight.fg = find_palette_value_by_key(palette, highlight.fg)
	end

	if highlight.bg ~= nil then
		parsed_highlight.bg = find_palette_value_by_key(palette, highlight.bg)
	end

	if highlight.sp ~= nil then
		parsed_highlight.sp = find_palette_value_by_key(palette, highlight.sp)
	end

	highlights[group] = vim.tbl_extend("force", original, parsed_highlight)
end

-- Apply all highlights
for group, highlight in pairs(highlights) do
	if highlight.blend ~= nil then
		if highlight.bg ~= nil then
			highlight.bg = blend(highlight.bg, palette.text, highlight.blend)
		elseif highlight.fg ~= nil then
			highlight.fg = blend(highlight.fg, palette.text, highlight.blend)
		elseif highlight.sp ~= nil then
			highlight.sp = blend(highlight.sp, palette.text, highlight.blend)
		end

		highlight.blend = nil
	end

	if transparent and highlight.bg == palette.text then
		highlight.bg = "NONE"
	end

	vim.api.nvim_set_hl(0, group, highlight)
end
