vim.cmd('hi clear')

if 1 == vim.fn.exists('syntax_on') then
	vim.cmd('syntax reset')
end

vim.opt.termguicolors = true
vim.g.colors_name = 'un'

local variants = {
	meno = {
		light = {
			error = '#c75c6a',
			warn = '#f5c359',
			hint = '#78ccc5',
			info = '#9745be',
			accent = '#78ccc5',
			on_accent = '#000000',
			b_low = '#fefefe',
			b_med = '#f5f5f5',
			b_high = '#e8e8e8',
			f_low = '#949494',
			f_med = '#636363',
			f_high = '#131313',
		},
		dark = {
			error = '#c75c6a',
			warn = '#f5c359',
			hint = '#78ccc5',
			info = '#9745be',
			accent = '#78ccc5',
			on_accent = '#000000',
			b_low = '#1a1a1a',
			b_med = '#212121',
			b_high = '#292929',
			f_low = '#adada4',
			f_med = '#cfcfc9',
			f_high = '#f0f0ef',
		},
	},
	nessuna = {
		light = {
			error = '#c75c6a',
			warn = '#f5c359',
			hint = '#78ccc5',
			info = '#9745be',
			accent = '#78ccc5',
			on_accent = '#000000',
			b_low = '#fefefe',
			b_med = '#f5f5f5',
			b_high = '#e8e8e8',
			f_low = '#949494',
			f_med = '#636363',
			f_high = '#131313',
		},
		dark = {
			error = '#c75c6a',
			warn = '#f5c359',
			hint = '#78ccc5',
			info = '#9745be',
			accent = '#78ccc5',
			on_accent = '#000000',
			b_low = '#1a1a1a',
			b_med = '#262626',
			b_high = '#323232',
			f_low = '#737373',
			f_med = '#a3a3a3',
			f_high = '#f7f7f7',
		},
	},
	warsaw = {
		light = {
			error = '#c75c6a',
			warn = '#f5c359',
			hint = '#78ccc5',
			info = '#9745be',
			accent = '#78ccc5',
			on_accent = '#000000',
			b_low = '#f6ecdf',
			b_med = '#fefaf3',
			b_high = '#efe4d4',
			f_low = '#f5c1a9',
			f_med = '#58b0b0',
			f_high = '#b9d9b4',
		},
		dark = {
			error = '#c75c6a',
			warn = '#f5c359',
			hint = '#78ccc5',
			info = '#9745be',
			accent = '#e3bd77',
			on_accent = '#141414',
			b_low = '#1a1a1a',
			b_med = '#000000',
			b_high = '#323232',
			f_low = '#f5c1a9',
			f_med = '#58b0b0',
			f_high = '#b9d9b4',
		},
	},
	rose_pine = {
		light = {
			error = '#b4637a',
			warn = '#ea9d34',
			hint = '#56949f',
			info = '#907aa9',
			accent = '#d7827e',
			on_accent = '#faf4ed',
			b_low = '#faf4ed',
			b_med = '#fffaf3',
			b_high = '#f2e9e1',
			f_low = '#9893a5',
			f_med = '#797593',
			f_high = '#575279',
		},
		dark = {
			error = '#eb6f92',
			warn = '#f6c177',
			hint = '#9ccfd8',
			info = '#c4a7e7',
			accent = '#ebbcba',
			on_accent = '#191724',
			b_low = '#191724',
			b_med = '#1f1d2e',
			b_high = '#26233a',
			f_low = '#6e6a86',
			f_med = '#908caa',
			f_high = '#e0def4',
		},
	},
}

-- Set variant
local v = vim.g.un_variant or 'rose_pine'
if not variants[v] then
	vim.notify('No `un_variant` named "' .. vim.g.un_variant .. '"')
	v = 'rose_pine'
end

-- Set palette based on variant
local p = vim.o.background == 'light' and variants[v].light or variants[v].dark

local h = function(group, color)
	return vim.api.nvim_set_hl(0, group, color)
end

p.b_low = vim.g.un_b_low or p.b_low
p.b_med = vim.g.un_b_med or p.b_med
p.b_high = vim.g.un_b_high or p.b_high
p.f_low = vim.g.un_f_low or p.f_low
p.f_med = vim.g.un_f_med or p.f_med
p.f_high = vim.g.un_f_high or p.f_high

--- Interface

h('ColorColumn', { bg = p.b_med })
h('CurSearch', { link = 'IncSearch' })
h('CursorColumn', { bg = p.b_med })
h('CursorLine', { bg = p.b_med })
h('CursorLineNr', { fg = p.f_med })
h('ErrorMsg', { fg = p.error })
h('IncSearch', { bg = p.accent, fg = p.on_accent })
h('LineNr', { fg = p.f_low })
h('MatchParen', { bg = p.accent, fg = p.on_accent })
h('NonText', { fg = p.f_low })
h('Normal', { bg = p.b_low, fg = p.f_low })
h('Pmenu', { bg = p.b_med, fg = p.f_med })
h('PmenuSbar', { bg = p.b_high })
h('PmenuSel', { bg = p.b_high, fg = p.f_high })
h('PmenuThumb', { bg = p.f_low })
h('Question', { fg = p.f_med })
h('Search', { bg = p.b_high })
h('SignColumn', { bg = p.b_low })
h('StatusLine', { bg = p.b_med, fg = p.f_low })
h('Title', { fg = p.f_high })
h('VertSplit', { fg = p.b_med })
h('Visual', { bg = p.b_high })
h('WarningMsg', { fg = p.warn })
h('WinSeperator', { link = 'VertSplit' })

--- Syntax

h('Boolean', { fg = p.f_med })
h('Character', { fg = p.f_low })
h('Comment', { fg = p.f_low, italic = true })
h('Conditional', { fg = p.f_low })
h('Constant', { fg = p.f_med })
h('Debug', { fg = p.f_low })
h('Define', { fg = p.f_low })
h('Delimiter', { fg = p.f_low })
h('Directory', { fg = p.f_med })
h('Error', { fg = p.error })
h('Exception', { fg = p.f_low })
h('Float', { fg = p.f_low })
h('Function', { fg = p.f_med })
h('Identifier', { fg = p.f_med })
h('Include', { fg = p.f_med })
h('Keyword', { fg = p.f_med })
h('Label', { fg = p.f_med })
h('Macro', { fg = p.f_low })
h('Number', { fg = p.f_med })
h('Operator', { fg = p.f_low })
h('PreCondit', { fg = p.f_med })
h('PreProc', { fg = p.f_med })
h('Repeat', { fg = p.f_low })
h('Special', { fg = p.f_high })
h('SpecialChar', { fg = p.f_low })
h('SpecialComment', { fg = p.f_low })
h('SpecialKey', { fg = p.f_high })
h('Statement', { fg = p.f_low })
h('StorageClass', { fg = p.f_low })
h('String', { fg = p.f_low })
h('Structure', { fg = p.f_low })
h('Tag', { fg = p.f_high })
h('Todo', { fg = p.f_low })
h('Type', { fg = p.f_low })
h('Typedef', { fg = p.f_low })

--- Language syntax

h('markdownCode', { fg = p.f_med })
h('markdownCodeDelimiter', { link = 'Delimiter' })
h('markdownUrl', { underline = true })

--- Treesitter syntax

h('TSBoolean', { link = 'Boolean' })
h('TSConstant', { link = 'Constant' })
h('TSField', { fg = p.f_med })
h('TSFunction', { link = 'Function' })
h('TSInclude', { link = 'Include' })
h('TSKeyword', { link = 'Keyword' })
h('TSLabel', { link = 'Label' })
h('TSMethod', { fg = p.f_med })
h('TSNote', { fg = p.accent })
h('TSNumber', { link = 'Number' })
h('TSParameter', { fg = p.f_high })
h('TSProperty', { link = 'TSField' })
h('TSPunctBracket', { fg = p.f_low })
h('TSPunctDelimiter', { link = 'Delimiter' })
h('TSPunctSpecial', { link = 'Special' })
h('TSString', { link = 'String' })
h('TSStringEscape', { link = 'String' })
h('TSTag', { link = 'Tag' })
h('TSTagDelimiter', { link = 'Delimiter' })
h('TSTitle', { link = 'Title' })
h('TSType', { link = 'Type' })
h('TSURI', { link = 'String' })
h('TSVariable', { fg = p.f_high })
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
h('NvimTreeFolderIcon', { fg = p.f_low })
h('NvimTreeSpecialFile', { fg = p.f_low })

-- mvllow/modes.nvim
h('ModesCopy', { bg = p.warn })
h('ModesDelete', { bg = p.error })
h('ModesInsert', { bg = p.hint })
h('ModesVisual', { bg = p.info })
