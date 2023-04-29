-- Install package manager:
-- git clone --depth=1 https://github.com/savq/paq-nvim.git ~/.local/share/nvim/site/pack/paqs/start/paq-nvim
require("paq")({
	"savq/paq-nvim",
	"nvim-lua/plenary.nvim",
	"nvim-treesitter/nvim-treesitter",
	{ "rose-pine/neovim", as = "rose-pine" },
	"lewis6991/gitsigns.nvim",
	"echasnovski/mini.nvim",
	"neovim/nvim-lspconfig",
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"jose-elias-alvarez/null-ls.nvim",
	"nvim-telescope/telescope.nvim",
	"nvim-tree/nvim-tree.lua",
	"mvllow/matcha.nvim",
})

-- Use block cursor in all modes
vim.opt.guicursor = ""

-- Persist undo history between sessions
vim.opt.undofile = true

-- Set tab width
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Set popup menu max height
vim.opt.pumheight = 3

-- Hide statusline
vim.opt.laststatus = 0

-- Add vertical scroll padding
vim.opt.scrolloff = 3

-- Show diagnostics and other symbols in the number column
vim.opt.signcolumn = "yes"

-- Open new splits below and vertical splits to the right
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Ignore case for all-lowercase searches
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Preserve horizontal blocks of text when virtually wrapping lines
vim.opt.breakindent = true

-- Time in milliseconds between writing swap files or triggering the
-- CursorHold autocommand
vim.opt.updatetime = 250

vim.api.nvim_create_autocmd("BufEnter", { command = "setlocal formatoptions-=o" })
vim.api.nvim_create_autocmd("VimResized", { command = "tabdo wincmd =" })

vim.diagnostic.config({ virtual_text = false })

local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent == nil and true or opts.silent
	vim.keymap.set(mode, lhs, rhs, opts)
end

vim.g.mapleader = " "

map("n", "<esc>", ":noh<cr>", { desc = "Clear search highlights" })
map("n", "*", "*N", { desc = "Search under cursor" })
map("v", "*", [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]], { desc = "Search selection" })

map({ "n", "v" }, "j", "gj", { desc = "Move down through wrapped lines" })
map({ "n", "v" }, "k", "gk", { desc = "Move up through wrapped lines" })

map("v", "<", "<gv", { desc = "Indent, keeping selection" })
map("v", ">", ">gv", { desc = "Dedent, keeping selection" })

map({ "n", "v" }, "<leader>y", [["*y]], { desc = "Copy to clipboard" })
map({ "n", "v" }, "<leader>p", [["*p]], { desc = "Paste from clipboard" })
map("n", "S", ":%s/<c-r>///g<left><left>", { silent = false, desc = "Substitue current search" })
-- map("n", "S", ":%s/<c-r><c-w>//g<left><left>", { silent = false, desc = "Substitue current word" })

map("n", "go", "<c-o>", { desc = "Goto previous position" })
map("n", "gn", "<c-i>", { desc = "Goto next position" })
map("n", "gp", "<c-^>", { desc = "Goto previously focused buffer" })
map({ "n", "v" }, "gm", "%", { desc = "Goto matching pair" })

map("n", "<leader>wh", "<c-w>h", { desc = "Focus window to the left" })
map("n", "<leader>wj", "<c-w>j", { desc = "Focus window below" })
map("n", "<leader>wk", "<c-w>k", { desc = "Focus window above" })
map("n", "<leader>wl", "<c-w>l", { desc = "Focus window to the right" })
map("n", "<leader>wr", "<c-w>r", { desc = "Swap window positions" })

-- Plugin configurations

require("nvim-treesitter.configs").setup({ ensure_installed = "all", highlight = { enable = true } })

require("rose-pine").setup({ disable_italics = true })
vim.cmd.colorscheme("rose-pine")

require("gitsigns").setup({ worktrees = { { toplevel = vim.env.HOME, gitdir = vim.env.HOME .. "/dots.git" } } })
map("n", "]h", "<cmd>Gitsigns next_hunk<cr>")
map("n", "[h", "<cmd>Gitsigns prev_hunk<cr>")

require("mini.comment").setup()
require("mini.completion").setup({ lsp_completion = { source_func = "omnifunc", auto_setup = false } })
map("i", "<tab>", [[pumvisible() ? "\<c-n>" : "\<tab>"]], { expr = true })
map("i", "<s-tab>", [[pumvisible() ? "\<c-p>" : "\<s-tab>"]], { expr = true })

local keys = {
	["cr"] = vim.api.nvim_replace_termcodes("<cr>", true, true, true),
	["ctrl-y"] = vim.api.nvim_replace_termcodes("<c-y>", true, true, true),
	["ctrl-y_cr"] = vim.api.nvim_replace_termcodes("<c-y><cr>", true, true, true),
}
map("i", "<cr>", function()
	if vim.fn.pumvisible() ~= 0 then
		-- If popup is visible, confirm selected item, otherwise add new line
		local item_selected = vim.fn.complete_info()["selected"] ~= -1
		return item_selected and keys["ctrl-y"] or keys["ctrl-y_cr"]
	else
		-- If popup is not visible, use plain `<cr>`. You might want to customize
		-- according to other plugins. For example, to use 'mini.pairs', replace
		-- next line with `return require('mini.pairs').cr()`
		return keys["cr"]
	end
end, { expr = true })

local function lsp_on_attach(client, bufnr)
	-- Use omnifunc for completions
	-- https://github.com/echasnovski/nvim/blob/487ce206d88412db5577435ba956fcf5a19d6302/lua/ec/configs/nvim-lspconfig.lua#L11-L26
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.MiniCompletion.completefunc_lsp")

	map("i", "<c-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature help" })
	map("n", "<leader>a", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code actions" })
	map("n", "<leader>r", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
	map("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Show documentation" })
	map("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Goto declaration" })
	map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Goto definition" })
	map("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Goto type definition" })
	map("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Goto implementation" })
	map("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Goto references" })
	map("n", "<leader>k", vim.diagnostic.open_float, { buffer = bufnr, desc = "Show line diagnostics" })
	map("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Goto next diagnostic" })
	map("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Goto previous diagnostic" })
end

local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
local root_pattern = require("lspconfig").util.root_pattern

require("mason").setup()
require("mason-lspconfig").setup_handlers({
	function(server_name)
		local servers = {
			clangd = { capabilities = { offsetEncoding = "utf-8" } },
			denols = { root_dir = root_pattern("deno.json", "deno.jsonc") },
			tailwindcss = { root_dir = root_pattern("tailwind.config.js", "tailwind.config.cjs") },
			tsserver = { single_file_support = false, root_dir = root_pattern("tsconfig.json", "tsconfig.jsonc") },
		}

		local opts = {}
		if servers[server_name] ~= nil then
			opts = servers[server_name]
		end

		require("lspconfig")[server_name].setup(
			vim.tbl_deep_extend("force", { on_attach = lsp_on_attach, capabilities = lsp_capabilities }, opts)
		)
	end,
})

local lsp_formatting = vim.api.nvim_create_augroup("LspFormatting", {})
local function format_on_save(client, bufnr)
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = lsp_formatting, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = lsp_formatting,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({
					bufnr = bufnr,
					filter = function(lsp_client)
						return lsp_client.name == "null-ls"
					end,
				})
			end,
		})
	end
end

require("null-ls").setup({
	on_attach = format_on_save,
	sources = {
		require("null-ls").builtins.formatting.clang_format,
		require("null-ls").builtins.formatting.fish_indent,
		require("null-ls").builtins.formatting.goimports,
		require("null-ls").builtins.formatting.prettierd.with({
			extra_filetypes = { "jsonc", "astro", "svelte" },
		}),
		require("null-ls").builtins.formatting.rustfmt,
		require("null-ls").builtins.formatting.shfmt,
		require("null-ls").builtins.formatting.stylua,
	},
})
map("n", "<space><space>", vim.lsp.buf.format)

-- telescope.nvim
map("n", "<leader>/", "<cmd>Telescope live_grep layout_config={'preview_width':0.6}<cr>")
map("n", "<leader>f", "<cmd>Telescope find_files theme=dropdown previewer=false<cr>")

-- nvim-tree.lua
require("nvim-tree").setup({
	on_attach = function(bufnr)
		local api = require("nvim-tree.api")
		api.config.mappings.default_on_attach(bufnr)
		map("n", "d", api.fs.trash, { buffer = bufnr })
	end,
	actions = { open_file = { quit_on_open = true } },
	git = { ignore = false },
	renderer = { icons = { show = { file = false, folder = false, folder_arrow = false, git = false } } },
	trash = { cmd = "trash" },
	view = { side = "right" },
})
map("n", "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>")

require("matcha").setup({ keys = { b = "background", f = "LspFormatting" } })
