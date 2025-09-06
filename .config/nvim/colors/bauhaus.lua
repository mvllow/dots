---@param hex string A string representing the hex colour, e.g. "#fa8072"
---@return integer Red, integer Green, integer Blue
local function hex_to_rgb(hex)
	hex = hex:gsub("#", "")
	return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

---@param r number Red (0-255)
---@param g number Green (0-255)
---@param b number Blue (0-255)
---@return string
local function rgb_to_hex(r, g, b)
	return string.format("#%02x%02x%02x", r, g, b)
end

local blend_cache = {}

---@param fg string Foreground color
---@param bg string Background color
---@param alpha number Blend ratio
---@return string
local function blend(fg, bg, alpha)
	local key = fg .. bg .. alpha
	if blend_cache[key] then return blend_cache[key] end

	local r1, g1, b1 = hex_to_rgb(fg)
	local r2, g2, b2 = hex_to_rgb(bg)
	local r = r1 * alpha + r2 * (1 - alpha)
	local g = g1 * alpha + g2 * (1 - alpha)
	local b = b1 * alpha + b2 * (1 - alpha)
	local result = rgb_to_hex(math.floor(r), math.floor(g), math.floor(b))

	blend_cache[key] = result
	return result
end

if vim.g.colors_name then
	vim.cmd("hi clear")
	vim.cmd("syntax reset")
end
vim.g.colors_name = "bauhaus"

---@class Palette
local palette = {
	base    = "#f8f8f6",
	surface = blend("#2a2a2a", "#f8f8f6", 0.1),
	overlay = blend("#2a2a2a", "#f8f8f6", 0.2),
	muted   = blend("#2a2a2a", "#f8f8f6", 0.6),
	subtle  = blend("#2a2a2a", "#f8f8f6", 0.8),
	text    = "#2a2a2a",
	red     = "#b73a3a",
	green   = "#4a944a",
	yellow  = "#d18f00",
	blue    = "#3566b8",
	magenta = "#9e4bb5",
	cyan    = "#cc6f56",
}
if vim.o.background == "dark" then
	palette = {
		base    = "#1a1a1a",
		surface = blend("#e0e0e0", "#1a1a1a", 0.1),
		overlay = blend("#e0e0e0", "#1a1a1a", 0.2),
		muted   = blend("#e0e0e0", "#1a1a1a", 0.6),
		subtle  = blend("#e0e0e0", "#1a1a1a", 0.8),
		text    = "#e0e0e0",
		red     = "#e05f5f",
		green   = "#5dc28b",
		yellow  = "#f2c94c",
		blue    = "#5794f2",
		magenta = "#c27ac8",
		cyan    = "#c49a9a",
	}
end

local highlights = {
	Normal                   = { bg = palette.base, fg = palette.text },
	CursorLine               = { bg = palette.overlay },
	Visual                   = { bg = blend(palette.overlay, palette.base, 0.85) },
	StatusLine               = { bg = palette.surface, fg = palette.text },
	StatusLineNC             = { bg = palette.surface, fg = palette.muted },
	LineNr                   = { fg = blend(palette.muted, palette.base, 0.6) },
	Directory                = { fg = palette.blue, bold = true },
	Pmenu                    = { bg = palette.surface, fg = palette.subtle },
	PmenuSel                 = { bg = palette.overlay, fg = palette.text, bold = true },
	Search                   = { bg = palette.yellow, fg = palette.base },
	IncSearch                = { bg = palette.blue, fg = palette.base },
	MatchParen               = { bg = palette.cyan, fg = palette.base, underline = true },

	Comment                  = { fg = palette.muted },
	String                   = { fg = palette.yellow },
	Function                 = { fg = palette.cyan, bold = true },
	Statement                = { fg = palette.blue, bold = true },
	Type                     = { fg = palette.green, bold = true },
	Constant                 = { fg = palette.text },
	Operator                 = { fg = palette.subtle },

	DiagnosticError          = { fg = palette.red },
	DiagnosticWarn           = { fg = palette.yellow },
	DiagnosticInfo           = { fg = palette.blue },
	DiagnosticHint           = { fg = palette.magenta },
	DiagnosticOk             = { fg = palette.green },

	DiagnosticUnderlineError = { sp = palette.red, undercurl = true },
	DiagnosticUnderlineWarn  = { sp = palette.yellow, undercurl = true },
	DiagnosticUnderlineInfo  = { sp = palette.blue, undercurl = true },
	DiagnosticUnderlineHint  = { sp = palette.magenta, undercurl = true },

	SpellBad                 = { sp = palette.red, underdotted = true },
	SpellCap                 = { sp = palette.blue, underdotted = true },
	SpellRare                = { sp = palette.magenta, underdotted = true },
	SpellLocal               = { sp = palette.green, underdotted = true },

	DiffAdd                  = { fg = palette.green, bg = blend(palette.green, palette.base, 0.2) },
	DiffChange               = { fg = palette.blue, bg = blend(palette.blue, palette.base, 0.2) },
	DiffDelete               = { fg = palette.red, bg = blend(palette.red, palette.base, 0.2) },
	DiffText                 = { fg = palette.cyan, bg = blend(palette.cyan, palette.base, 0.2) },
}

for group, hl in pairs(highlights) do
	vim.api.nvim_set_hl(0, group, hl)
end

local ts_groups = {
	["@tag"]              = { fg = palette.blue },
	["@tag.attribute"]    = { fg = palette.magenta },
	["@type"]             = { fg = palette.green, bold = true },
	["@type.builtin"]     = { fg = palette.green, bold = true },
	["@function"]         = { fg = palette.cyan },
	["@function.builtin"] = { fg = palette.cyan, bold = true },
	["@variable"]         = { fg = palette.text },
	["@variable.builtin"] = { fg = palette.text, bold = true },
}

for group, hl in pairs(ts_groups) do
	vim.api.nvim_set_hl(0, group, hl)
end

local lsp_semantics = {
	["@lsp.type.class"]                      = { link = "@type" },
	["@lsp.type.struct"]                     = { link = "@type" },
	["@lsp.type.enum"]                       = { link = "@type" },
	["@lsp.type.interface"]                  = { link = "@type" },
	["@lsp.type.property"]                   = { fg = palette.text },
	["@lsp.type.parameter"]                  = { fg = palette.text },
	["@lsp.type.variable"]                   = { link = "@variable" },
	["@lsp.type.function"]                   = { link = "@function" },
	["@lsp.type.method"]                     = { link = "@function" },
	["@lsp.type.keyword"]                    = { link = "Statement" },
	["@lsp.type.comment"]                    = { link = "Comment" },
	["@lsp.type.string"]                     = { link = "String" },
	["@lsp.type.number"]                     = { link = "Constant" },
	["@lsp.type.operator"]                   = { link = "Operator" },
	["@lsp.type.namespace"]                  = { fg = palette.muted },
	["@lsp.type.enumMember"]                 = { fg = palette.yellow },
	["@lsp.type.typeParameter"]              = { fg = palette.blue },
	["@lsp.typemod.function.defaultLibrary"] = { bold = true },
}

for group, hl in pairs(lsp_semantics) do
	vim.api.nvim_set_hl(0, group, hl)
end
