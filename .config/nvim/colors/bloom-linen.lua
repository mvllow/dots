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
	--- values. The palette is accessible by name, e.g. "magenta":
	--- ```lua
	--- vim.g.bloom_groups = {
	---   Normal = { fg = "magenta" }
	--- }
	--- ```
	---
	--- If you want to override a value completely, use the Neovim api directly:
	--- ```lua
	--- vim.api.nvim_create_autocmd("ColorScheme", {
	---   pattern = "bloom",
	---   callback = function()
	---     vim.api.nvim_set_hl(0, { ... })
	---   end
	--- })
	--- ```
	groups = vim.g.bloom_groups or {}
}

if vim.g.colors_name then
	vim.cmd("hi clear")
	vim.cmd("syntax reset")
end
vim.g.colors_name = "bloom-linen"

---@class Palette
local palette = {
	base          = "#f1e2db",
	surface       = "#f4e7e2",
	overlay_dark  = "#e5cabd",
	overlay_light = "#e0beae",
	muted         = "#817a64",
	subtle        = "#565143",
	text          = "#2b2921",
	red           = "#b17643",
	green         = "#6e7b74",
	blue          = "#3a6786",
	yellow        = "#c08a3a",
	magenta       = "#715a69",
	cyan          = "#a46e77"
}

if vim.o.background == "dark" then
	palette = {
		base          = "#242220",
		surface       = "#2c2927",
		overlay_dark  = "#322f2c",
		overlay_light = "#3d3a36",
		muted         = "#938a86",
		subtle        = "#d0c9c6",
		text          = "#f0eae8",
		red           = "#c6706f",
		green         = "#7d996f",
		blue          = "#8098b4",
		yellow        = "#d8aa3c",
		magenta       = "#b88aa3",
		cyan          = "#d1a298",
	}
end

local dynamic = {
	float_bg = vim.o.winborder == "none" and palette.surface or palette.base
}

-- Reload colorscheme on relevant option change
vim.api.nvim_create_autocmd("OptionSet", {
	pattern = { "winborder" },
	callback = function()
		vim.cmd.colorscheme(vim.g.colors_name)
	end
})

local highlights = {
	-- Interface
	CursorLine               = { bg = palette.overlay_dark, fg = palette.text },
	Directory                = { fg = palette.text, bold = true },
	LineNr                   = { fg = palette.muted },
	SpecialKey               = { fg = palette.muted },
	Normal                   = { bg = palette.base, fg = palette.text },
	QuickFixLine             = { fg = palette.cyan },
	StatusLine               = { bg = palette.surface, fg = palette.subtle },
	StatusLineNC             = { bg = palette.surface, fg = palette.muted },
	Visual                   = { bg = palette.overlay_light, fg = palette.text },
	WinSeparator             = { fg = palette.overlay_light },

	-- Message area
	ModeMsg                  = { fg = palette.muted },
	MoreMsg                  = { fg = palette.muted },
	-- hl(0, "MsgArea", { bg = palette.surface, fg = palette.subtle })

	-- Menus
	Pmenu                    = { bg = palette.surface, fg = palette.subtle },
	PmenuExtra               = { fg = palette.muted, italic = true },
	PmenuExtraSel            = { bg = palette.overlay_dark, fg = palette.subtle, italic = true },
	PmenuKind                = { fg = palette.muted, italic = true },
	PmenuKindSel             = { bg = palette.overlay_dark, fg = palette.subtle, italic = true },
	PmenuMatch               = { fg = palette.magenta },
	PmenuMatchSel            = { fg = palette.magenta, bold = true },
	PmenuSbar                = { bg = palette.overlay_light },
	PmenuSel                 = { bg = palette.overlay_dark, fg = palette.text, bold = true },
	PmenuThumb               = { bg = palette.muted },

	-- Floats
	FloatBorder              = { bg = dynamic.float_bg, fg = palette.overlay_light },
	FloatFooter              = { bg = dynamic.float_bg, fg = palette.muted },
	FloatTitle               = { bg = dynamic.float_bg, fg = palette.text, bold = true },
	NormalFloat              = { bg = dynamic.float_bg, fg = palette.subtle },

	-- Search
	CurSearch                = { bg = palette.magenta, fg = palette.base },
	IncSearch                = { bg = palette.text, fg = palette.base },
	Search                   = { bg = palette.overlay_light, fg = palette.text },

	-- Diagnostics
	DiagnosticDeprecated     = { fg = palette.muted, strikethrough = true },
	DiagnosticError          = { fg = palette.red },
	DiagnosticHint           = { fg = palette.magenta },
	DiagnosticInfo           = { fg = palette.blue },
	DiagnosticOk             = { fg = palette.muted },
	DiagnosticWarn           = { fg = palette.yellow },
	DiagnosticUnderlineError = { sp = palette.red, blend = 0.5, undercurl = true },
	DiagnosticUnderlineHint  = { sp = palette.magenta, blend = 0.5, undercurl = true },
	DiagnosticUnderlineInfo  = { sp = palette.blue, blend = 0.5, undercurl = true },
	DiagnosticUnderlineOk    = { sp = palette.muted, blend = 0.5, undercurl = true },
	DiagnosticUnderlineWarn  = { sp = palette.yellow, blend = 0.5, undercurl = true },
	Error                    = { bg = palette.red, blend = 0.5 },

	-- Diff
	Added                    = { fg = palette.green },
	Changed                  = { fg = palette.magenta },
	Removed                  = { fg = palette.red },
	DiffAdd                  = { fg = palette.green, bg = palette.green, blend = 0.2 },
	DiffChange               = { fg = palette.magenta, bg = palette.magenta, blend = 0.2 },
	DiffDelete               = { fg = palette.red, bg = palette.red, blend = 0.2 },
	DiffText                 = { fg = palette.cyan, bg = palette.cyan, blend = 0.2 },

	-- Syntax
	Comment                  = { fg = palette.muted },
	Constant                 = { fg = palette.subtle },
	Delimiter                = { fg = palette.muted },
	Function                 = { fg = palette.text },
	Identifier               = { fg = palette.text },
	MatchParen               = { fg = palette.base, bg = palette.cyan, underline = true },
	NonText                  = { fg = palette.overlay_light },
	Operator                 = { fg = palette.muted },
	Question                 = { fg = palette.blue },
	Special                  = { fg = palette.muted },
	SpellBad                 = { sp = palette.muted, underdotted = true },
	SpellCap                 = { sp = palette.muted, underdotted = true },
	SpellRare                = { sp = palette.muted, underdotted = true },
	SpellLocal               = { sp = palette.muted, underdotted = true },
	Statement                = { fg = palette.text },
	String                   = { fg = palette.subtle },
	Type                     = { fg = palette.text, bold = true },
	Underlined               = { fg = palette.text, sp = palette.muted, underline = true },

	-- Treesitter syntax
	["@variable"]            = { fg = palette.magenta },
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
			highlight.bg = blend(highlight.bg, palette.base, highlight.blend)
		elseif highlight.fg ~= nil then
			highlight.fg = blend(highlight.fg, palette.base, highlight.blend)
		elseif highlight.sp ~= nil then
			highlight.sp = blend(highlight.sp, palette.base, highlight.blend)
		end

		highlight.blend = nil
	end

	if transparent and highlight.bg == palette.base then
		highlight.bg = "NONE"
	end

	vim.api.nvim_set_hl(0, group, highlight)
end
