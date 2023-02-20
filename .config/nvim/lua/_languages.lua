local M = {}

-- Use lsp formatter instead of null-ls
M.lsp_formatter_names = { "denols" }

M.get_servers = function(lspconfig)
	local root_pattern = lspconfig.util.root_pattern

	return {
		denols = {
			root_dir = root_pattern("deno.json", "deno.jsonc"),
		},
		tailwindcss = {
			root_dir = root_pattern("tailwind.config.js", "tailwind.config.cjs"),
		},
		tsserver = {
			single_file_support = false,
			root_dir = root_pattern("tsconfig.json", "tsconfig.jsonc"),
		},
	}
end

M.get_sources = function(null_ls)
	return {
		null_ls.builtins.formatting.fish_indent,
		null_ls.builtins.formatting.goimports,
		null_ls.builtins.formatting.prettierd.with({ extra_filetypes = { "jsonc", "astro", "svelte" } }),
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.formatting.stylua,
	}
end

return M
