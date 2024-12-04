local prettier = { "prettierd", "prettier", stop_after_first = true }
return {
	fish = { "fish_indent" },
	go = { "goimports" },
	lua = { "stylua" },
	sh = { "shfmt" },

	-- prettier (default)
	javascript = prettier,
	javascriptreact = prettier,
	typescript = prettier,
	typescriptreact = prettier,
	vue = prettier,
	css = prettier,
	scss = prettier,
	less = prettier,
	html = prettier,
	htmlangular = prettier,
	json = prettier,
	jsonc = prettier,
	graphql = prettier,
	markdown = prettier,
	yaml = prettier,

	-- prettier (via extensions)
	astro = prettier,
	svelte = prettier,
}
