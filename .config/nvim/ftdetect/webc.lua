vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
	pattern = '*.webc',
	callback = function()
		vim.opt_local.ft = 'webc'
	end,
})
