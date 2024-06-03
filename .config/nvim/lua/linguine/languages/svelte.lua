local M = {}

function M.matchit()
	vim.cmd([[
if exists('loaded_matchit') && !exists('b:match_words')
  let b:match_ignorecase = 0
  let b:match_words =
        \ '#\%(if\|await\|each\)\>:\:\%(else\|catch\|then\)\>:\/\%(if\|await\|each\)\>,' .
        \ '{:},' .
        \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
        \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
        \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'
endif
]])
end

function M.on_lsp_attach(client)
	-- https://github.com/sveltejs/language-tools/issues/2008#issuecomment-2042675326
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = vim.api.nvim_create_augroup("OnDidChangeFile", { clear = true }),
		pattern = { "*.js", "*.ts" },
		callback = function(ctx)
			client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
		end,
	})
end

return M
