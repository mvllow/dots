-- Install plugin manager
-- git clone --depth=1 https://github.com/savq/paq-nvim.git "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim

require("paq")({
	"savq/paq-nvim",
	"nvim-lua/plenary.nvim",
	"nvim-telescope/telescope.nvim",
	{ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
	-- "rose-pine/neovim",
	"theprimeagen/harpoon",
	"echasnovski/mini.nvim",
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
	"lewis6991/gitsigns.nvim",
	"folke/zen-mode.nvim",
	"mvllow/matcha.nvim",
	"mvllow/stand.nvim",
	"github/copilot.vim",
})

vim.opt.runtimepath:append("~/dev/rose-pine-neovim")
-- vim.opt.runtimepath:append("~/dev/stand.nvim")

vim.opt.guicursor = ""
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.scrolloff = 5
vim.opt.pumheight = 5
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.wrap = false
vim.opt.updatetime = 250
vim.opt.signcolumn = "yes"
vim.opt.statusline = " %f %m %= %l:%c ♥ "
vim.opt.shortmess:append("WcC")

vim.g.mapleader = " "

-- Bubble lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Cursor management
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- vim.keymap.set({ "n", "v" }, "j", "gj")
-- vim.keymap.set({ "n", "v" }, "k", "gk")
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Clipboard management
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')

vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

vim.keymap.set("n", "<C-j>", ":cnext<CR>zz")
vim.keymap.set("n", "<C-k>", ":cprev<CR>zz")

vim.keymap.set("n", "*", "*N")
vim.keymap.set("v", "*", [[y/\V<C-r>=escape(@",'/\')<CR><CR>N]])
vim.keymap.set("n", "S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>f", ":Telescope find_files theme=dropdown previewer=false<CR>")
vim.keymap.set("n", "<leader>/", ":Telescope live_grep layout_config={'preview_width':0.6}<CR>")

require("mini.files").setup({ content = { prefix = function() end } })
vim.keymap.set("n", "<leader>e", MiniFiles.open)

require("nvim-treesitter.configs").setup({ highlight = { enable = true } })

vim.keymap.set("n", "<C-e>", require("harpoon.ui").toggle_quick_menu)
vim.keymap.set("n", "<leader>a", require("harpoon.mark").add_file)
vim.keymap.set("n", "H", require("harpoon.ui").nav_prev)
vim.keymap.set("n", "L", require("harpoon.ui").nav_next)

require("rose-pine").setup()
vim.cmd.colorscheme("rose-pine")

require("gitsigns").setup()

require("mini.comment").setup()

require("mini.completion").setup({ lsp_completion = { source_func = "omnifunc", auto_setup = false } })
-- Tab seems to be working as expected without these?
-- vim.keymap.set("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
-- vim.keymap.set("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
local keys = {
	["cr"] = vim.api.nvim_replace_termcodes("<CR>", true, true, true),
	["ctrl-y"] = vim.api.nvim_replace_termcodes("<C-y>", true, true, true),
	["ctrl-y_cr"] = vim.api.nvim_replace_termcodes("<C-y><CR>", true, true, true),
}
vim.keymap.set("i", "<cr>", function()
	return vim.fn.pumvisible() ~= 0
		and (vim.fn.complete_info()["selected"] ~= 1 and keys["ctrl-y"] or keys["ctrl-y_cr"])
		or keys["cr"]
end, { expr = true })

local lsp_options = {
	capabilities = vim.lsp.protocol.make_client_capabilities(),
	on_attach = function(_, bufnr)
		-- Use omnifunc for completions
		-- https://github.com/echasnovski/nvim/blob/487ce206d88412db5577435ba956fcf5a19d6302/lua/ec/configs/nvim-lspconfig.lua#L11-L26
		vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.MiniCompletion.completefunc_lsp")

		vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = bufnr })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
		vim.keymap.set("n", "<leader>k", vim.diagnostic.open_float, { buffer = bufnr })
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr })
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr })
	end,
}

local root_pattern = require("lspconfig.util").root_pattern

require("mason").setup()
require("mason-lspconfig").setup_handlers({
	function(server_name)
		local servers = {
			denols = { root_dir = root_pattern("deno.json", "deno.jsonc") },
			tsserver = { single_file_support = false, root_dir = root_pattern("tsconfig.json", "tsconfig.jsonc") },
		}
		require("lspconfig")[server_name].setup(vim.tbl_deep_extend("force", servers[server_name] or {}, lsp_options))
	end,
})

vim.diagnostic.config({ signs = false, virtual_text = false })

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("LspFormatting", {}),
	callback = function()
		vim.lsp.buf.format()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("Prose", {}),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.wrap = true
	end,
})

require("zen-mode").setup({ plugins = { tmux = true } })
vim.keymap.set("n", "\\z", require("zen-mode").toggle)

require("matcha").setup({ keys = { b = "background", f = "LspFormatting", p = "Prose", w = "wrap" } })
require("stand").setup()
