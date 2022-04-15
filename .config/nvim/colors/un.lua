vim.cmd('hi clear')

if 1 == vim.fn.exists('syntax_on') then
	vim.cmd('syntax reset')
end

vim.opt.termguicolors = true
vim.g.colors_name = 'un'

local variants = {
	rose_pine = {
		l = {
			error = '#b4637a',
			accent = '#907aa9',
			on_accent = '#ffffff',
			bg_low = '#faf4ed',
			bg_med = '#fffaf3',
			bg_high = '#f2e9e1',
			fg_low = '#9893a5',
			fg_med = '#797593',
			fg_high = '#575279',
		},
		d = {
			error = '#eb6f92',
			accent = '#c4a7e7',
			on_accent = '#ffffff',
			bg_low = '#191724',
			bg_med = '#1f1d2e',
			bg_high = '#26233a',
			fg_low = '#6e6a86',
			fg_med = '#908caa',
			fg_high = '#e0def4',
		},
	},
	neutral = {
		l = {
			error = '#c75c6a',
			accent = '#f2cea5',
			on_accent = '#ffffff',
			bg_low = '#ffffff',
			bg_med = '#f3f3f3',
			bg_high = '#dfdfdf',
			fg_low = '#8f8f8f',
			fg_med = '#6f6f6f',
			fg_high = '#171717',
		},
		d = {
			error = '#c75c6a',
			accent = '#a58058',
			on_accent = '#ffffff',
			bg_low = '#1c1c1c',
			bg_med = '#232323',
			bg_high = '#323232',
			fg_low = '#707070',
			fg_med = '#a0a0a0',
			fg_high = '#f2f2f2',
		},
	},
	stone = {
		l = {
			error = '#c75c6a',
			accent = '#f2cea5',
			on_accent = '#ffffff',
			bg_low = '#fafaf9',
			bg_med = '#f5f5f4',
			bg_high = '#d6d3d1',
			fg_low = '#a8a29e',
			fg_med = '#57534e',
			fg_high = '#1c1917',
		},
		d = {
			error = '#c75c6a',
			accent = '#a58058',
			on_accent = '#ffffff',
			bg_low = '#1c1917',
			bg_med = '#292524',
			bg_high = '#44403c',
			fg_low = '#78716c',
			fg_med = '#a8a29e',
			fg_high = '#f5f5f4',
		},
	},
}

---@usage 'rose_pine' | 'neutral' | 'stone'
vim.g.un_variant = vim.g.un_variant or 'rose_pine'

local v = variants[vim.g.un_variant]
local p = vim.o.background == 'light' and v.l or v.d

local hl = function(...)
	return vim.api.nvim_set_hl(0, ...)
end

--- Interface

hl('ColorColumn', { bg = p.bg_med })
hl('CursorColumn', { bg = p.bg_med })
hl('CursorLine', { bg = p.bg_med })
hl('CursorLineNr', { fg = p.fg_med })
hl('WarningMsg', { fg = p.error })
hl('ErrorMsg', { bg = p.error, fg = p.bg_low })
hl('IncSearch', { bg = p.accent, fg = p.on_accent })
hl('LineNr', { fg = p.fg_low })
hl('MatchParen', { bg = p.accent, fg = p.on_accent })
hl('NonText', { fg = p.fg_low })
hl('Normal', { bg = p.bg_low, fg = p.fg_low })
hl('Pmenu', { bg = p.bg_med, fg = p.fg_med })
hl('PmenuSbar', { bg = p.bg_high })
hl('PmenuSel', { bg = p.bg_high, fg = p.text })
hl('PmenuThumb', { bg = p.fg_low })
hl('Question', { fg = p.fg_med })
hl('Search', { bg = p.bg_high })
hl('SignColumn', { bg = p.bg_low })
hl('StatusLine', { bg = p.bg_med, fg = p.fg_low })
hl('Title', { fg = p.fg_high })
hl('VertSplit', { fg = p.bg_med })
hl('Visual', { bg = p.bg_high })
hl('WinSeperator', { link = 'VertSplit' })

--- Syntax

hl('Boolean', { fg = p.fg_med })
hl('Character', { fg = p.fg_low })
hl('Comment', { fg = p.fg_low, italic = true })
hl('Conditional', { fg = p.fg_low })
hl('Constant', { fg = p.fg_med })
hl('Debug', { fg = p.fg_low })
hl('Define', { fg = p.fg_low })
hl('Delimiter', { fg = p.fg_low })
hl('Directory', { fg = p.fg_med })
hl('Error', { fg = p.fg_low })
hl('Exception', { fg = p.fg_low })
hl('Float', { fg = p.fg_low })
hl('Function', { fg = p.fg_med })
hl('Identifier', { fg = p.fg_med })
hl('Include', { fg = p.fg_low })
hl('Include', { fg = p.fg_med })
hl('Keyword', { fg = p.fg_med })
hl('Label', { fg = p.fg_med })
hl('Macro', { fg = p.fg_low })
hl('Number', { fg = p.fg_med })
hl('Operator', { fg = p.fg_low })
hl('PreCondit', { fg = p.fg_med })
hl('PreProc', { fg = p.fg_med })
hl('Repeat', { fg = p.fg_low })
hl('Special', { fg = p.fg_high })
hl('SpecialChar', { fg = p.fg_low })
hl('SpecialComment', { fg = p.fg_low })
hl('SpecialKey', { fg = p.fg_high })
hl('Statement', { fg = p.fg_low })
hl('StorageClass', { fg = p.fg_low })
hl('String', { fg = p.fg_low })
hl('Structure', { fg = p.fg_low })
hl('Tag', { fg = p.fg_high })
hl('Todo', { fg = p.fg_low })
hl('Type', { fg = p.fg_low })
hl('Typedef', { fg = p.fg_low })

--- Language syntax

hl('markdownCode', { fg = p.fg_med })
hl('markdownCodeDelimiter', { link = 'Delimiter' })
hl('markdownUrl', { underline = true })

--- Treesitter syntax

hl('TSBoolean', { link = 'Boolean' })
hl('TSConstant', { link = 'Constant' })
hl('TSField', { fg = p.fg_med })
hl('TSFunction', { link = 'Function' })
hl('TSInclude', { link = 'Include' })
hl('TSKeyword', { link = 'Keyword' })
hl('TSLabel', { link = 'Label' })
hl('TSMethod', { fg = p.fg_med })
hl('TSNote', { fg = p.accent })
hl('TSNumber', { link = 'Number' })
hl('TSParameter', { fg = p.fg_high })
hl('TSProperty', { link = 'TSField' })
hl('TSPunctBracket', { fg = p.fg_low })
hl('TSPunctDelimiter', { link = 'Delimiter' })
hl('TSPunctSpecial', { link = 'Special' })
hl('TSString', { link = 'String' })
hl('TSStringEscape', { link = 'String' })
hl('TSTag', { link = 'Tag' })
hl('TSTagDelimiter', { link = 'Delimiter' })
hl('TSTitle', { link = 'Title' })
hl('TSType', { link = 'Type' })
hl('TSURI', { link = 'String' })
hl('TSVariable', { fg = p.fg_high })
hl('TSVariableBuiltin', { link = 'TSVariable' })
hl('TSWarning', { link = 'TSNote' })

--- Diagnostics

hl('DiagnosticError', { fg = p.error })
hl('DiagnosticHint', { fg = p.fg_low })
hl('DiagnosticInfo', { fg = p.fg_med })
hl('DiagnosticWarn', { fg = p.fg_high })
hl('DiagnosticUnderlineError', { undercurl = true, sp = p.error })
hl('DiagnosticUnderlineHint', { undercurl = true, sp = p.fg_low })
hl('DiagnosticUnderlineInfo', { undercurl = true, sp = p.fg_med })
hl('DiagnosticUnderlineWarn', { undercurl = true, sp = p.fg_high })

--- Plugins

-- kyazdani42/nvim-tree.lua
hl('NvimTreeSpecialFile', { fg = p.fg_low })
