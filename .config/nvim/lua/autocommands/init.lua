function define_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        vim.cmd('augroup ' .. group_name)
        vim.cmd('autocmd!')

        for _, def in pairs(definition) do
            local command = table.concat(vim.tbl_flatten {'autocmd', def}, ' ')
            vim.cmd(command)
        end

        vim.cmd('augroup END')
    end
end

local auto_formatters = {}
local format_cmd = 'lua vim.lsp.buf.formatting_sync(nil, 1000)'

local extensions = {
	'*.cjs',
	'*.js',
	'*.jsx',
	'*.ts',
	'*.tsx',
	'*.vue',
	'*.svelte',
	'*.html',
	'*.css',
	'*.json',
	'*.yaml',
}

for _,value in pairs(extensions) do
	table.insert(auto_formatters, {'BufWritePre', value, format_cmd})
end

-- TODO: Fix random efm crashes
	-- [ ERROR ] 2021-04-28T23:04:33-0500 ] ...im/HEAD-a6504ec_2/share/nvim/runtime/lua/vim/lsp/rpc.lua:457 ]	"rpc"	"/Users/not/.local/share/nvim/lspinstall/efm/./efm-langserver"	"stderr"	"panic: runtime error: invalid memory address or nil pointer dereference"
	-- [ ERROR ] 2021-04-28T23:04:33-0500 ] ...im/HEAD-a6504ec_2/share/nvim/runtime/lua/vim/lsp/rpc.lua:457 ]	"rpc"	"/Users/not/.local/share/nvim/lspinstall/efm/./efm-langserver"	"stderr"	"\n[signal SIGSEGV: segmentation violation code=0x2 addr=0x20 pc=0x104935874]\n\ngoroutine 19 [running]:\ntime.(*Timer).Stop(...)\n\t"

vim.lsp.set_log_level('debug')
-- :lua vim.cmd('e'..vim.lsp.get_log_path())

define_augroups({
	_general_settings = {
        {'BufWinEnter', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'},
        {'BufRead', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'},
        {'BufNewFile', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'},
    },
	_auto_formatters = auto_formatters
})
