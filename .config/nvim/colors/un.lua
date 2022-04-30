vim.cmd('hi clear')

if 1 == vim.fn.exists('syntax_on') then
	vim.cmd('syntax reset')
end

vim.opt.termguicolors = true
vim.g.colors_name = 'un'

local v = {
	l = {
		error = '#b4637a',
		warn = '#ea9d34',
		hint = '#56949f',
		info = '#907aa9',
		accent = '#d7827e',
		on_accent = '#faf4ed',
		bg_low = '#faf4ed',
		bg_med = '#fffaf3',
		bg_high = '#f2e9e1',
		fg_low = '#9893a5',
		fg_med = '#797593',
		fg_high = '#575279',
	},
	d = {
		error = '#eb6f92',
		warn = '#f6c177',
		hint = '#9ccfd8',
		info = '#c4a7e7',
		accent = '#ebbcba',
		on_accent = '#191724',
		bg_low = '#191724',
		bg_med = '#1f1d2e',
		bg_high = '#26233a',
		fg_low = '#6e6a86',
		fg_med = '#908caa',
		fg_high = '#e0def4',
	},
}

local p = vim.o.background == 'light' and v.l or v.d

local h = function(...)
	return vim.api.nvim_set_hl(0, ...)
end

--- Interface

h('ColorColumn', { bg = p.bg_med })
h('CursorColumn', { bg = p.bg_med })
h('CursorLine', { bg = p.bg_med })
h('CursorLineNr', { fg = p.fg_med })
h('WarningMsg', { fg = p.warn })
h('ErrorMsg', { fg = p.bg_error })
h('IncSearch', { bg = p.accent, fg = p.on_accent })
h('LineNr', { fg = p.fg_low })
h('MatchParen', { bg = p.accent, fg = p.on_accent })
h('NonText', { fg = p.fg_low })
h('Normal', { bg = p.bg_low, fg = p.fg_low })
h('Pmenu', { bg = p.bg_med, fg = p.fg_med })
h('PmenuSbar', { bg = p.bg_high })
h('PmenuSel', { bg = p.bg_high, fg = p.text })
h('PmenuThumb', { bg = p.fg_low })
h('Question', { fg = p.fg_med })
h('Search', { bg = p.bg_high })
h('SignColumn', { bg = p.bg_low })
h('StatusLine', { bg = p.bg_med, fg = p.fg_low })
h('Title', { fg = p.fg_high })
h('VertSplit', { fg = p.bg_med })
h('Visual', { bg = p.bg_high })
h('WinSeperator', { link = 'VertSplit' })

--- Syntax

h('Boolean', { fg = p.fg_med })
h('Character', { fg = p.fg_low })
h('Comment', { fg = p.fg_low, italic = true })
h('Conditional', { fg = p.fg_low })
h('Constant', { fg = p.fg_med })
h('Debug', { fg = p.fg_low })
h('Define', { fg = p.fg_low })
h('Delimiter', { fg = p.fg_low })
h('Directory', { fg = p.fg_med })
h('Error', { fg = p.fg_low })
h('Exception', { fg = p.fg_low })
h('Float', { fg = p.fg_low })
h('Function', { fg = p.fg_med })
h('Identifier', { fg = p.fg_med })
h('Include', { fg = p.fg_low })
h('Include', { fg = p.fg_med })
h('Keyword', { fg = p.fg_med })
h('Label', { fg = p.fg_med })
h('Macro', { fg = p.fg_low })
h('Number', { fg = p.fg_med })
h('Operator', { fg = p.fg_low })
h('PreCondit', { fg = p.fg_med })
h('PreProc', { fg = p.fg_med })
h('Repeat', { fg = p.fg_low })
h('Special', { fg = p.fg_high })
h('SpecialChar', { fg = p.fg_low })
h('SpecialComment', { fg = p.fg_low })
h('SpecialKey', { fg = p.fg_high })
h('Statement', { fg = p.fg_low })
h('StorageClass', { fg = p.fg_low })
h('String', { fg = p.fg_low })
h('Structure', { fg = p.fg_low })
h('Tag', { fg = p.fg_high })
h('Todo', { fg = p.fg_low })
h('Type', { fg = p.fg_low })
h('Typedef', { fg = p.fg_low })

--- Language syntax

h('markdownCode', { fg = p.fg_med })
h('markdownCodeDelimiter', { link = 'Delimiter' })
h('markdownUrl', { underline = true })

--- Treesitter syntax

h('TSBoolean', { link = 'Boolean' })
h('TSConstant', { link = 'Constant' })
h('TSField', { fg = p.fg_med })
h('TSFunction', { link = 'Function' })
h('TSInclude', { link = 'Include' })
h('TSKeyword', { link = 'Keyword' })
h('TSLabel', { link = 'Label' })
h('TSMethod', { fg = p.fg_med })
h('TSNote', { fg = p.accent })
h('TSNumber', { link = 'Number' })
h('TSParameter', { fg = p.fg_high })
h('TSProperty', { link = 'TSField' })
h('TSPunctBracket', { fg = p.fg_low })
h('TSPunctDelimiter', { link = 'Delimiter' })
h('TSPunctSpecial', { link = 'Special' })
h('TSString', { link = 'String' })
h('TSStringEscape', { link = 'String' })
h('TSTag', { link = 'Tag' })
h('TSTagDelimiter', { link = 'Delimiter' })
h('TSTitle', { link = 'Title' })
h('TSType', { link = 'Type' })
h('TSURI', { link = 'String' })
h('TSVariable', { fg = p.fg_high })
h('TSVariableBuiltin', { link = 'TSVariable' })
h('TSWarning', { fg = p.warn })

--- Diagnostics

h('DiagnosticError', { fg = p.error })
h('DiagnosticHint', { fg = p.hint })
h('DiagnosticInfo', { fg = p.info })
h('DiagnosticWarn', { fg = p.warn })
h('DiagnosticUnderlineError', { undercurl = true, sp = p.error })
h('DiagnosticUnderlineHint', { undercurl = true, sp = p.hint })
h('DiagnosticUnderlineInfo', { undercurl = true, sp = p.info })
h('DiagnosticUnderlineWarn', { undercurl = true, sp = p.warn })

--- Plugins

-- kyazdani42/nvim-tree.lua
h('NvimTreeSpecialFile', { fg = p.fg_low })

-- mvllow/modes.nvim
h('ModesCopy', { bg = p.warn })
h('ModesDelete', { bg = p.error })
h('ModesInsert', { bg = p.hint })
h('ModesVisual', { bg = p.info })
