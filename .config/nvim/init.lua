local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	})
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require("mini.deps").setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

vim.g.mapleader = " "

now(function()
	vim.opt.shiftwidth = 4
	vim.opt.tabstop = 4

	vim.opt.pumheight = 3
	vim.opt.scrolloff = 3
	vim.opt.signcolumn = "yes"

	vim.opt.breakindent = true
	vim.opt.linebreak = true
	vim.opt.showbreak = [[\\]]

	vim.opt.ignorecase = true
	vim.opt.smartcase = true

	vim.opt.undofile = true
	vim.opt.updatetime = 250

	vim.keymap.set({ "n", "v" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
	vim.keymap.set({ "n", "v" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
	vim.keymap.set({ "n", "v" }, "<up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
	vim.keymap.set({ "n", "v" }, "<down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
	vim.keymap.set("n", "<esc>", ":noh<cr>", { silent = true })
	vim.keymap.set("n", "<c-n>", ":cnext<cr>zz")
	vim.keymap.set("n", "<c-p>", ":cprev<cr>zz")
	vim.keymap.set("n", "*", "*N")
	vim.keymap.set("v", "*", [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]])
	vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
	vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
	vim.keymap.set("n", "S", ":%s/<c-r><c-w>//g<left><left>")

	vim.keymap.set("n", "<leader>e", vim.cmd.Explore)

	vim.keymap.set("n", "gl", vim.diagnostic.open_float)
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

	vim.diagnostic.config({
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "⏺",
				[vim.diagnostic.severity.WARN] = "⏺",
				[vim.diagnostic.severity.INFO] = "⏺",
				[vim.diagnostic.severity.HINT] = "⏺",
			},
		},
		virtual_text = {
			prefix = ">",
		},
	})

	add("tpope/vim-sleuth")

	add({
		source = "nvim-treesitter/nvim-treesitter",
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})
	require("nvim-treesitter.configs").setup({
		auto_install = true,
		ensure_installed = { "lua", "vimdoc", "markdown" },
		highlight = { enable = true, additional_vim_regex_highlighting = { "ruby" } },
		indent = { enable = true, disable = { "ruby" } },
	})

	add({ source = "rose-pine/neovim", name = "rose-pine" })
	require("rose-pine").setup({
		styles = { italic = false },
		highlight_groups = {
			MatchParen = { bold = true, underline = true },
		},
	})
	vim.cmd.colorscheme("rose-pine")

	require("mini.completion").setup()
	local keys = {
		["cr"] = vim.api.nvim_replace_termcodes("<cr>", true, true, true),
		["ctrl-y"] = vim.api.nvim_replace_termcodes("<c-y>", true, true, true),
		["ctrl-y_cr"] = vim.api.nvim_replace_termcodes("<c-y><cr>", true, true, true),
	}
	vim.keymap.set("i", "<cr>", function()
		if vim.fn.pumvisible() ~= 0 then
			local item_selected = vim.fn.complete_info()["selected"] ~= -1
			return item_selected and keys["ctrl-y"] or keys["ctrl-y_cr"]
		else
			return keys["cr"]
		end
	end, { expr = true })
	vim.keymap.set("i", "<tab>", [[pumvisible() ? "\<c-n>" : "\<tab>"]], { expr = true })
	vim.keymap.set("i", "<s-tab>", [[pumvisible() ? "\<c-p>" : "\<s-tab>"]], { expr = true })

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("CustomLspAttach", { clear = true }),
		callback = function(event)
			local buffer = event.buf
			local client = vim.lsp.get_client_by_id(event.data.client_id) or {}

			vim.b.minicompletion_config = {
				lsp_completion = { source_func = "omnifunc", auto_setup = false },
			}
			vim.api.nvim_set_option_value("omnifunc", "v:lua.MiniCompletion.completefunc_lsp", { buf = buffer })

			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buffer })
			vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, { buffer = buffer })
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = buffer })

			if client.name == "angularls" then
				vim.keymap.set("n", "go", function()
					vim.lsp.buf_request(
						0,
						"angular/getTemplateLocationForComponent",
						vim.lsp.util.make_position_params(0),
						function(_, result)
							if result then
								vim.lsp.util.jump_to_location(result, "utf-8", true)
							end
						end
					)
					vim.lsp.buf_request(
						0,
						"angular/getComponentsWithTemplateFile",
						vim.lsp.util.make_position_params(0),
						function(_, result)
							if result and #result ~= 0 then
								if #result == 1 then
									vim.lsp.util.jump_to_location(result[1], "utf-8", true)
								else
									vim.fn.setqflist({}, " ", {
										title = "Components",
										items = vim.lsp.util.locations_to_items(result, "utf-8"),
									})
								end
							end
						end
					)
				end, { buffer = buffer })
			end
		end,
	})
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local servers = {
		lua_ls = {
			settings = {
				Lua = {
					workspace = {
						checkThirdParty = false,
						library = { vim.env.VIMRUNTIME },
					},
				},
			},
		},
	}

	add({
		source = "neovim/nvim-lspconfig",
		depends = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
	})
	require("mason").setup()
	require("mason-lspconfig").setup({
		handlers = {
			function(server_name)
				local server = servers[server_name] or {}
				server.capabilities = capabilities
				require("lspconfig")[server_name].setup(server)
			end,
		},
	})

	add("stevearc/conform.nvim")
	require("conform").setup({
		notify_on_error = false,
		formatters_by_ft = {
			fish = { "fish_indent" },
			go = { "goimports" },
			lua = { "stylua" },
			rust = { "rustfmt" },

			-- prettier (default)
			javascript = { { "prettierd", "prettier" } },
			javascriptreact = { { "prettierd", "prettier" } },
			typescript = { { "prettierd", "prettier" } },
			typescriptreact = { { "prettierd", "prettier" } },
			vue = { { "prettierd", "prettier" } },
			css = { { "prettierd", "prettier" } },
			scss = { { "prettierd", "prettier" } },
			less = { { "prettierd", "prettier" } },
			html = { { "prettierd", "prettier" } },
			json = { { "prettierd", "prettier" } },
			jsonc = { { "prettierd", "prettier" } },
			graphql = { { "prettierd", "prettier" } },
			markdown = { { "prettierd", "prettier" } },
			yaml = { { "prettierd", "prettier" } },

			-- prettier (via extensions)
			astro = { { "prettierd", "prettier" } },
			svelte = { { "prettierd", "prettier" } },
		},
	})
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
		pattern = "*",
		callback = function(args)
			require("conform").format({ bufnr = args.buf, lsp_fallback = true })
		end,
	})
end)

later(function()
	vim.api.nvim_create_autocmd("VimResized", {
		command = "tabdo wincmd =",
	})

	add("github/copilot.vim")

	require("mini.diff").setup({
		view = {
			signs = { add = "+", change = "*", delete = "~" },
		},
	})

	require("mini.pick").setup()
	vim.keymap.set("n", "<leader>f", ":Pick files<cr>")
	vim.keymap.set("n", "<leader>.", ":Pick resume<cr><space><bs>")
	vim.keymap.set("n", "<leader>/", ":Pick grep_live<cr>")

	require("mini.surround").setup()

	add("vim-test/vim-test")

	add("brenoprata10/nvim-highlight-colors")
	require("nvim-highlight-colors").setup({
		render = "virtual",
		virtual_symbol = "⏺",
		enable_tailwind = true,
	})
end)
