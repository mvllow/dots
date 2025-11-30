---@param hex string A string representing the hex colour, e.g. '#fa8072'
---@return integer Red, integer Green, integer Blue
---@private
local function hex_to_rgb(hex)
	hex = hex:gsub('#', '')
	return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

---@param r number Red (0-255)
---@param g number Green (0-255)
---@param b number Blue (0-255)
---@return string
---@private
local function rgb_to_hex(r, g, b)
	return string.format('#%02x%02x%02x', r, g, b)
end

local blend_cache = {}

---@param fg string The foreground colour as a hex string, e.g. '#fa8072'
---@param bg string The background colour as a hex string, e.g. '#000000'
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
	return palette[key] or key or ''
end

---@class Config
local config = {
	--- Extend or override the default palette:
	--- ```lua
	--- vim.g.bloom_palette = {
	---   dark = {
	---     base = '#1a1a1a'
	---   },
	---   light = {
	---     rose = '#fa8072'
	---   }
	--- }
	--- ```
	palette = vim.g.bloom_palette or {},

	--- Helper table to set user highlight groups, extending the theme's
	--- group values. The palette is accessible by name, e.g. 'iris':
	--- ```lua
	--- vim.g.bloom_groups = {
	---   Normal = { fg = 'iris' }
	--- }
	--- ```
	---
	--- To override a value completely, use the Neovim api directly:
	--- ```lua
	--- vim.api.nvim_create_autocmd('ColorScheme', {
	---   pattern = 'bloom',
	---   callback = function()
	---     vim.api.nvim_set_hl(0, 'Group', { ... })
	---   end
	--- })
	--- ```
	groups = vim.g.bloom_groups or {},
}

if vim.g.colors_name then
	vim.cmd('hi clear')
	vim.cmd('syntax reset')
end
vim.g.colors_name = 'bloom'

---@class Palette
local palette = vim.tbl_extend('force', {
	base          = '#faf4ed',
	surface       = '#fffaf3',
	overlay_dark  = '#f2e9e1',
	overlay_light = '#d7d5d2',
	muted         = '#9893a5',
	subtle        = '#797593',
	text          = '#464261',
	love          = '#b4637a',
	gold          = '#ea9d34',
	rose          = '#d7827e',
	pine          = '#286983',
	foam          = '#56949f',
	iris          = '#907aa9'
}, config.palette.light or {})

if vim.o.background == 'dark' then
	palette = vim.tbl_extend('force', {
		-- Rosé Pine Noir
		-- base          = '#141413',
		-- surface       = '#1f1e1d',
		-- overlay_dark  = '#2a282f',
		-- overlay_light = '#3c3a41',
		-- muted         = '#6e6a73',
		-- subtle        = '#a19ca9',
		-- text          = '#e0def4',
		-- love          = '#d17a87',
		-- gold          = '#d9aa65',
		-- rose          = '#d4a8a6',
		-- pine          = '#3e8fb0',
		-- foam          = '#88b9c0',
		-- iris          = '#b59dd4',

		base = '#191724',
		surface = '#1f1d2e',
		overlay_dark = '#272536',
		overlay_light = '#2F2C3E',
		muted = '#6e6a86',
		subtle = '#908caa',
		text = '#e0def4',
		love = '#eb6f92',
		gold = '#f6c177',
		rose = '#ebbcba',
		pine = '#31748f',
		foam = '#9ccfd8',
		iris = '#c4a7e7',
	}, config.palette.dark or {})
end



-- We recommend explicitly setting these options for a more predictable
-- experience
local no_pumborder = vim.o.pumborder == '' or vim.o.pumborder == 'none'
local no_winborder = vim.o.winborder == '' or vim.o.winborder == 'none'
local dynamic = {
	pum_bg = no_pumborder and palette.surface or palette.base,
	win_bg = no_winborder and palette.surface or palette.base
}

-- Reload colorscheme on relevant option change
vim.api.nvim_create_autocmd('OptionSet', {
	pattern = { 'pumborder', 'winborder' },
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
	QuickFixLine             = { bg = palette.iris, fg = palette.iris, blend = 0.2 },
	StatusLine               = { bg = palette.surface, fg = palette.subtle },
	StatusLineNC             = { bg = palette.surface, fg = palette.muted },
	Visual                   = { bg = palette.overlay_light, fg = palette.text },
	WinBar                   = { bg = palette.surface, fg = palette.subtle },
	WinBarNC                 = { bg = palette.surface, fg = palette.muted },
	WinSeparator             = { fg = palette.overlay_light },

	-- Message area
	ModeMsg                  = { fg = palette.muted },
	MoreMsg                  = { fg = palette.muted },
	-- hl(0, 'MsgArea', { bg = palette.surface, fg = palette.subtle })

	-- Menus
	Pmenu                    = { bg = dynamic.pum_bg, fg = palette.subtle },
	PmenuExtra               = { fg = palette.muted, italic = true },
	PmenuExtraSel            = { bg = palette.overlay_dark, fg = palette.subtle, italic = true },
	PmenuKind                = { fg = palette.muted, italic = true },
	PmenuKindSel             = { bg = palette.overlay_dark, fg = palette.subtle, italic = true },
	PmenuMatch               = { fg = palette.iris },
	PmenuMatchSel            = { fg = palette.iris, bold = true },
	PmenuSbar                = { bg = palette.overlay_light },
	PmenuSel                 = { bg = palette.overlay_dark, fg = palette.text, bold = true },
	PmenuThumb               = { bg = palette.muted },
	PmenuBorder              = { bg = dynamic.pum_bg, fg = palette.overlay_light },

	-- Floats
	FloatBorder              = { bg = dynamic.win_bg, fg = palette.overlay_light },
	FloatFooter              = { bg = dynamic.win_bg, fg = palette.muted },
	FloatTitle               = { bg = dynamic.win_bg, fg = palette.text, bold = true },
	NormalFloat              = { bg = dynamic.win_bg, fg = palette.subtle },

	-- Search
	CurSearch                = { bg = palette.iris, fg = palette.base },
	IncSearch                = { bg = palette.text, fg = palette.base },
	Search                   = { bg = palette.overlay_light, fg = palette.text },

	-- Diagnostics
	DiagnosticDeprecated     = { fg = palette.muted, strikethrough = true },
	DiagnosticError          = { fg = palette.love },
	DiagnosticHint           = { fg = palette.iris },
	DiagnosticInfo           = { fg = palette.foam },
	DiagnosticOk             = { fg = palette.muted },

	DiagnosticFloatingInfo   = { bg = dynamic.win_bg, fg = palette.text },

	DiagnosticWarn           = { fg = palette.gold },
	DiagnosticUnderlineError = { sp = palette.love, blend = 0.5, undercurl = true },
	DiagnosticUnderlineHint  = { sp = palette.iris, blend = 0.5, undercurl = true },
	DiagnosticUnderlineInfo  = { sp = palette.foam, blend = 0.5, undercurl = true },
	DiagnosticUnderlineOk    = { sp = palette.muted, blend = 0.5, undercurl = true },
	DiagnosticUnderlineWarn  = { sp = palette.gold, blend = 0.5, undercurl = true },
	Error                    = { bg = palette.love, blend = 0.5 },

	-- Diff
	Added                    = { fg = palette.pine },
	Changed                  = { fg = palette.iris },
	Removed                  = { fg = palette.love },
	DiffAdd                  = { fg = palette.pine, bg = palette.pine, blend = 0.2 },
	DiffChange               = { fg = palette.iris, bg = palette.iris, blend = 0.2 },
	DiffDelete               = { fg = palette.love, bg = palette.love, blend = 0.2 },
	DiffText                 = { fg = palette.rose, bg = palette.rose, blend = 0.2 },

	-- Syntax
	Comment                  = { fg = palette.muted },
	Constant                 = { fg = palette.text },
	Delimiter                = { fg = palette.muted },
	Function                 = { fg = palette.rose },
	Identifier               = { fg = palette.text },
	MatchParen               = { fg = palette.base, bg = palette.rose, underline = true },
	NonText                  = { fg = palette.overlay_light },
	Operator                 = { fg = palette.muted },
	Question                 = { fg = palette.foam },
	Special                  = { fg = palette.iris },
	SpellBad                 = { sp = palette.subtle, underdotted = true },
	SpellCap                 = { sp = palette.subtle, underdotted = true },
	SpellRare                = { sp = palette.subtle, underdotted = true },
	SpellLocal               = { sp = palette.subtle, underdotted = true },
	Statement                = { fg = palette.pine },
	String                   = { fg = palette.gold },
	Type                     = { fg = palette.foam, bold = true },
	Underlined               = { fg = palette.text, sp = palette.muted, underline = true },

	-- Treesitter syntax
	['@tag']                 = { fg = palette.foam },
	['@tag.attribute']       = { fg = palette.iris },
	['@type']                = { fg = palette.foam },
	['@type.builtin']        = { fg = palette.foam, bold = true },
	['@function']            = { fg = palette.rose },
	['@function.builtin']    = { fg = palette.rose, bold = true },
	['@variable']            = { fg = palette.text },
	['@variable.builtin']    = { fg = palette.text, bold = true },

	-- Language overrides
	-- Please prefer updating the root when possible. Otherwise, document
	-- general use-cases.
	['@string.editorconfig'] = { fg = palette.love }, -- invalid values
}

local transparent = false
if config.groups['Normal'] ~= nil then
	if (config.groups['Normal'].bg or ''):lower() == 'none' then
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

	local parsed_highlight = vim.tbl_extend('force', {}, base)

	if highlight.fg ~= nil then
		parsed_highlight.fg = find_palette_value_by_key(palette, highlight.fg)
	end

	if highlight.bg ~= nil then
		parsed_highlight.bg = find_palette_value_by_key(palette, highlight.bg)
	end

	if highlight.sp ~= nil then
		parsed_highlight.sp = find_palette_value_by_key(palette, highlight.sp)
	end

	highlights[group] = vim.tbl_extend('force', original, parsed_highlight)
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
		highlight.bg = 'NONE'
	end

	vim.api.nvim_set_hl(0, group, highlight)
end
