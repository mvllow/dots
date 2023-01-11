vim.cmd("hi clear")

if 1 == vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end

vim.g.colors_name = "un"
vim.opt.termguicolors = true

local variant = vim.g.un_variant or "rose_pine"

local variants = {
	rose_pine = {
		light = {
			primary = "#d7827e",
			b_low = "#faf4ed",
			b_med = "#fffaf3",
			b_high = "#f2e9e1",
			f_low = "#9893a5",
			f_med = "#797593",
			f_high = "#575279",
			diagnostic_error = "",
			diagnostic_hint = "",
			diagnostic_info = "",
			diagnostic_warn = "",
			diff_add = "",
			diff_change = "",
			diff_delete = "",
		},
		dark = {
			primary = "#c4a7e7",
			b_low = "#191724",
			b_med = "#1f1d2e",
			b_high = "#26233a",
			f_low = "#6e6a86",
			f_med = "#908caa",
			f_high = "#e0def4",
			diagnostic_error = "",
			diagnostic_hint = "",
			diagnostic_info = "",
			diagnostic_warn = "",
			diff_add = "",
			diff_change = "",
			diff_delete = "",
		},
	},
	stone = {
		light = {
			primary = "#a66647",
			b_low = "#edebe4",
			b_med = "#d8d4c8",
			b_high = "#cac5b5",
			f_low = "#61615f",
			f_med = "#99948c",
			f_high = "#3a3831",
			diagnostic_error = "",
			diagnostic_hint = "",
			diagnostic_info = "",
			diagnostic_warn = "",
			diff_add = "",
			diff_change = "",
			diff_delete = "",
		},
		dark = {
			primary = "#d5bfad",
			b_low = "#1c1917",
			b_med = "#292524",
			b_high = "#44403c",
			f_low = "#78716c",
			f_med = "#a8a29e",
			f_high = "#e7e5e4",
			diagnostic_error = "",
			diagnostic_hint = "",
			diagnostic_info = "",
			diagnostic_warn = "",
			diff_add = "",
			diff_change = "",
			diff_delete = "",
		},
	},
	forest = {
		light = {
			primary = "#a66647",
			b_low = "#edebe4",
			b_med = "#d8d4c8",
			b_high = "#cac5b5",
			f_low = "#61615f",
			f_med = "#99948c",
			f_high = "#3a3831",
			diagnostic_error = "",
			diagnostic_hint = "",
			diagnostic_info = "",
			diagnostic_warn = "",
			diff_add = "",
			diff_change = "",
			diff_delete = "",
		},
		dark = {
			primary = "#a7ab90",
			b_low = "#282822",
			b_med = "#2f2e28",
			b_high = "#34332d",
			f_low = "#535353",
			f_med = "#949494",
			-- f_high = "#d5d5d5",
			f_high = "#efebe4",
			diagnostic_error = "",
			diagnostic_hint = "",
			diagnostic_info = "",
			diagnostic_warn = "",
			diff_add = "",
			diff_change = "",
			diff_delete = "",
		},
	},
}

-- Match palette to vim background.
local p = vim.o.background == "light" and variants[variant].light or variants[variant].dark

local h = function(group, color)
	return vim.api.nvim_set_hl(0, group, color)
end

--- Tree Sitter
h("@boolean", { fg = p.primary })
h("@character", { fg = p.f_high })
h("@character.special", { link = "@character" })
h("@class", { fg = p.f_high })
h("@comment", { fg = p.f_low, italic = true })
h("@conditional", { fg = p.f_med })
h("@constant", { fg = p.f_high })
h("@constant.builtin", { link = "@constant" })
h("@constant.macro", { link = "@constant" })
h("@constructor", { fg = p.f_high })
h("@debug", { fg = p.f_high })
h("@decorator", { fg = p.f_high })
h("@define", { fg = p.f_high })
h("@enum", { fg = p.f_high })
h("@enumMember", { fg = p.f_high })
h("@event", { fg = p.f_high })
h("@exception", { fg = p.f_high })
h("@field", { fg = p.f_high })
h("@float", { fg = p.f_high })
h("@function", { fg = p.f_high })
h("@function.builtin", { link = "@function" })
h("@function.macro", { link = "@function" })
h("@include", { fg = p.f_high })
h("@interface", { fg = p.f_high })
h("@keyword", { fg = p.f_med })
h("@label", { fg = p.f_high })
h("@macro", { fg = p.f_high })
h("@method", { fg = p.f_high })
h("@modifier", { fg = p.f_high })
h("@namespace", { fg = p.f_high })
h("@number", { fg = p.f_high })
h("@operator", { fg = p.f_med })
h("@parameter", { fg = p.f_high })
h("@preproc", { fg = p.f_high })
h("@property", { fg = p.f_high })
h("@punctuation", { fg = p.f_med })
h("@regexp", { fg = p.f_high })
h("@repeat", { fg = p.f_high })
h("@storageclass", { fg = p.f_high })
h("@string", { fg = p.primary })
h("@string.escape", { link = "@string" })
h("@string.special", { link = "@string" })
h("@struct", { fg = p.f_high })
h("@tag", { fg = p.f_high })
h("@text", { fg = p.f_high })
h("@text.literal", { link = "@text" })
h("@text.reference", { link = "@text" })
h("@text.title", { link = "@text" })
h("@text.todo", { link = "@text" })
h("@text.underline", { link = "@text" })
h("@text.uri", { link = "@text" })
h("@type", { fg = p.f_high })
h("@type.definition", { link = "@type" })
h("@typeParameter", { fg = p.f_high })
h("@variable", { fg = p.f_high })

--- UI
h("ColorColumn", { bg = p.b_low })
-- h('Conceal', {})
h("CurSearch", { fg = p.b_low, bg = p.primary })
-- h('Cursor', {})
-- h('lCursor', {})
-- h('CursorIM', {})
-- h('CursorColumn', {})
h("CursorLine", { bg = p.b_med })
-- h('Directory', {})
-- h('DiffAdd', {})
-- h('DiffChange', {})
-- h('DiffDelete', {})
-- h('DiffText', {})
-- h('EndOfBuffer', {})
-- h('TermCursor', {})
-- h('TermCursorNC', {})
-- h('ErrorMsg', {})
-- h('WinSeparator', {})
-- h('Folded', {})
-- h('FoldColumn', {})
h("SignColumn", { bg = p.b_low })
h("IncSearch", { link = "CurSearch" })
-- h('Substitute', {})
h("LineNr", { fg = p.f_med })
h("LineNrAbove", { fg = p.f_low })
h("LineNrBelow", { fg = p.f_low })
h("CursorLineNr", { fg = p.f_med })
-- h('CursorLineFold', {})
-- h('CursorLineSign', {})
h("MatchParen", { reverse = true })
-- h('ModeMsg', {})
h("MsgArea", { fg = p.primary })
-- h('MsgSeparator', {})
-- h('MoreMsg', {})
h("NonText", { fg = p.b_high })
h("Normal", { bg = p.b_low })
-- h('NormalFloat', {})
-- h('NormalNC', {})
h("PMenu", { bg = p.b_med })
h("PMenuSel", { bg = p.b_high })
h("PMenuSbar", { bg = p.b_high })
h("PMenuThumb", { bg = p.primary })
-- h('Question', {})
-- h('QuickFixLine', {})
h("Search", { bg = p.b_high })
-- h('SpecialKey', {})
-- h('SpellBad', {})
-- h('SpellCap', {})
-- h('SpellLocal', {})
-- h('SpellRare', {})
h("StatusLine", { fg = p.f_med, bg = p.b_med })
-- h('StatusLineNC', {})
-- h('TabLine', {})
-- h('TabLineFill', {})
-- h('TabLineSel', {})
-- h('Title', {})
h("Visual", { bg = p.b_high })
-- h('VisualNOS', {})
-- h('WarningMsg', {})
-- h('Whitespace', {})
-- h('WildMenu', {})
-- h('WinBar', {})
-- h('WinBarNC', {})
--
--- GUI
-- h('Menu', {})
-- h('Scrollbar', {})
-- h('Tooltip', {})
