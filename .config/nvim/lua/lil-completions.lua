--- lil-completions.lua
--- https://github.com/mvllow/lilvim

--- Setup completions and snippets.

local use = require('lil-helpers').use

use({
	'hrsh7th/nvim-cmp',
	requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip' },
	config = function()
		local cmp = require('cmp')
		cmp.setup({
			snippet = {
				expand = function(args)
					require('luasnip').lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				['<c-space>'] = cmp.mapping.complete({ select = false }),
				['<cr>'] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				}),
				['<tab>'] = function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					else
						fallback()
					end
				end,
				['<s-tab>'] = function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end,
			}),
			sources = {
				{ name = 'nvim_lsp' },
			},
		})
	end,
})

vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.pumheight = 3
