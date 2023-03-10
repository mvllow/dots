-- Install package mangager:
-- git clone --depth=1 https://github.com/savq/paq-nvim.git ~/.local/share/nvim/site/pack/paqs/start/paq-nvim

-- Plugins

require("paq")({
	"savq/paq-nvim",
	"lewis6991/gitsigns.nvim",
	"nvim-lua/plenary.nvim", -- Required by telescope.nvim, null-ls.nvim
	"nvim-telescope/telescope.nvim",
	{ "rose-pine/neovim", as = "rose-pine" },
	"nvim-treesitter/nvim-treesitter",
	"JoosepAlviste/nvim-ts-context-commentstring",
	"echasnovski/mini.nvim",
	"neovim/nvim-lspconfig",
	"folke/neodev.nvim",
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"jose-elias-alvarez/null-ls.nvim",
	"nvim-tree/nvim-tree.lua",
	"mvllow/matcha.nvim",
})

-- General options

vim.opt.guicursor = ""
vim.opt.pumheight = 3
vim.opt.laststatus = 0
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 3
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.api.nvim_create_autocmd("BufEnter", { command = "setlocal formatoptions-=o" })
vim.api.nvim_create_autocmd("VimResized", { command = "tabdo wincmd =" })

vim.diagnostic.config({ virtual_text = false })

-- General keymaps

local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent == nil and true or opts.silent
	vim.keymap.set(mode, lhs, rhs, opts)
end

vim.g.mapleader = " "

-- Improve search behaviour
map("n", "<esc>", ":noh<cr>", { desc = "Clear search highlights" })
map("n", "*", "*N", { desc = "Search under cursor" })
map("v", "*", [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]], { desc = "Search selection" })

-- Move through wrapped lines
map({ "n", "v" }, "j", "gj")
map({ "n", "v" }, "k", "gk")

-- Keep selection when indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Substitute current word
map("n", "S", ":%s/<c-r><c-w>//g<left><left>", { silent = false })

-- Goto
map("n", "go", "<c-o>", { desc = "Goto previous position" })
map("n", "gO", "<c-i>", { desc = "Goto next position" })
map("n", "gp", "<c-^>", { desc = "Goto previously focused buffer" })
map({ "n", "v" }, "gm", "%", { desc = "Goto matching pair" })

-- Window
map("n", "<leader>wh", "<c-w>h", { desc = "Focus window to the left" })
map("n", "<leader>wj", "<c-w>j", { desc = "Focus window below" })
map("n", "<leader>wk", "<c-w>k", { desc = "Focus window above" })
map("n", "<leader>wl", "<c-w>l", { desc = "Focus window to the right" })
map("n", "<leader>wr", "<c-w>r", { desc = "Swap window positions" })

-- Plugin options/keymaps

require("gitsigns").setup()
require("mini.comment").setup({
	hooks = {
		pre = function()
			require("ts_context_commentstring.internal").update_commentstring()
		end,
	},
})
require("mini.pairs").setup()

require("nvim-treesitter.configs").setup({
	ensure_installed = "all",
	highlight = { enable = true },
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
})

require("rose-pine").setup({
	disable_italics = true,
	highlight_groups = {
		Comment = { fg = "muted", italic = true },
		TelescopeBorder = { fg = "highlight_high" },
		TelescopeNormal = { fg = "subtle" },
		TelescopePromptNormal = { fg = "text" },
		TelescopeSelection = { fg = "text" },
		TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
	},
})
vim.cmd.colorscheme("rose-pine")

require("telescope").setup({
	defaults = { layout_config = { horizontal = { preview_width = 80 } } },
})

-- "<cmd>Telescope find_files find_command=fd,-t,f,-H,-E,.git,--strip-cwd-prefix theme=dropdown previewer=false<cr>",
map("n", "<leader>f", require("telescope.builtin").find_files)
map("n", "<leader>/", require("telescope.builtin").live_grep)
map("n", "<leader>p", require("telescope.builtin").commands)
map("n", "<leader>d", require("telescope.builtin").diagnostics)

require("mini.completion").setup({
	lsp_completion = { source_func = "omnifunc", auto_setup = false },
})

map("i", "<tab>", [[pumvisible() ? "\<c-n>" : "\<tab>"]], { expr = true })
map("i", "<s-tab>", [[pumvisible() ? "\<c-p>" : "\<s-tab>"]], { expr = true })

local keys = {
	["cr"] = vim.api.nvim_replace_termcodes("<cr>", true, true, true),
	["ctrl-y"] = vim.api.nvim_replace_termcodes("<c-y>", true, true, true),
	["ctrl-y_cr"] = vim.api.nvim_replace_termcodes("<c-y><cr>", true, true, true),
}
map("i", "<cr>", function()
	if vim.fn.pumvisible() ~= 0 then
		-- If popup is visible, confirm selected item or add new line otherwise
		local item_selected = vim.fn.complete_info()["selected"] ~= -1
		return item_selected and keys["ctrl-y"] or keys["ctrl-y_cr"]
	else
		-- If popup is not visible, use plain `<cr>`. You might want to customize
		-- according to other plugins. For example, to use 'mini.pairs', replace
		-- next line with `return require('mini.pairs').cr()`
		return require("mini.pairs").cr()

		-- return keys["cr"]
	end
end, { expr = true })

local function lsp_on_attach(client, bufnr)
	-- Use omnifunc for completions
	-- https://github.com/echasnovski/nvim/blob/487ce206d88412db5577435ba956fcf5a19d6302/lua/ec/configs/nvim-lspconfig.lua#L11-L26
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.MiniCompletion.completefunc_lsp")

	map("i", "<c-k>", vim.lsp.buf.signature_help, { buffer = bufnr })
	map("n", "<leader>a", vim.lsp.buf.code_action, { buffer = bufnr })
	map("n", "<leader>r", vim.lsp.buf.rename, { buffer = bufnr })
	map("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
	map("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
	map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
	map("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr })
	map("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
	map("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
	map("n", "<leader>k", vim.diagnostic.open_float, { buffer = bufnr })
	map("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr })
	map("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr })
end

local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
local root_pattern = require("lspconfig").util.root_pattern

require("neodev").setup()
require("mason").setup()
require("mason-lspconfig").setup_handlers({
	function(server_name)
		local servers = {
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

		local opts = {}
		if servers[server_name] ~= nil then
			opts = servers[server_name]
		end

		require("lspconfig")[server_name].setup(vim.tbl_deep_extend("force", {
			on_attach = lsp_on_attach,
			capabilities = lsp_capabilities,
		}, opts))
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
	sources = {
		require("null-ls").builtins.formatting.fish_indent,
		require("null-ls").builtins.formatting.goimports,
		require("null-ls").builtins.formatting.prettierd.with({ extra_filetypes = { "jsonc", "astro", "svelte" } }),
		require("null-ls").builtins.formatting.rustfmt,
		require("null-ls").builtins.formatting.shfmt,
		require("null-ls").builtins.formatting.stylua,
	},
	on_attach = format_on_save,
})

require("nvim-tree").setup({
	actions = { open_file = { quit_on_open = true } },
	git = { ignore = false },
	renderer = { icons = { show = { file = false, folder = false, folder_arrow = false, git = false } } },
	trash = { cmd = "trash" },
	view = {
		side = "right",
		mappings = {
			list = {
				{ key = "d", action = "trash" },
				{ key = "D", action = "remove" },
			},
		},
	},
})
map("n", "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", { desc = "Toggle file tree" })

map("n", [[\f]], function()
	require("matcha").toggle("LspFormatting")
end)
