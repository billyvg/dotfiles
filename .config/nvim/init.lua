-- {{ Packer bootstrap
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	Packer_bootstrap =
		vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
end
-- }}

require("packer").startup({
	function(use)
		-- Packer can manage itself
		use("wbthomason/packer.nvim")

		-- {{{ Plugin: fuzzy finder
		use({
			"junegunn/fzf",
			run = "./install --bin",
			-- run = function()
			-- 	vim.fn["fzf#install"]()
			-- end,
		})

		use({
			"ibhagwan/fzf-lua",
			-- optional for icon support
			requires = { "kyazdani42/nvim-web-devicons" },
			config = function()
				vim.keymap.set("n", "<C-p>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
				vim.keymap.set(
					"n",
					"<leader>ff",
					"<cmd>lua require('fzf-lua').live_grep_native()<CR>",
					{ silent = true }
				)
			end,
		})
		-- }}}

		-- {{{ Plugin: linter
		-- use {
		-- 'mfussenegger/nvim-lint',
		-- config = function()
		-- require('lint').linters_by_ft = {
		-- typescript = {'eslint',},
		-- javascript = {'eslint',},
		-- ["typescript.jsx"] = {'eslint',},
		-- ["javascript.jsx"] = {'eslint',},
		-- }
		-- end
		-- }
		-- }}}

		-- {{{ Plugins: treesitter
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = {
						"dockerfile",
						"html",
						"json",
						"python",
						"yaml",
						"comment",
						"jsdoc",
						"javascript",
						"graphql",
						"regex",
						"scss",
						"lua",
						"typescript",
						"tsx",
						"bash",
						"cmake",
						"css",
					},
					highlight = {
						enable = true,
					},
					indent = {
						enable = true,
					},
					autotag = {
						enable = true,
					},
				})
			end,
		})

		-- Tree sitter Playground
		-- https://github.com/nvim-treesitter/playground
		use("nvim-treesitter/playground")

		-- https://github.com/nvim-treesitter/nvim-treesitter-refactor
		-- use 'nvim-treesitter/nvim-treesitter-refactor'

		-- Custom text objects using treesitter
		-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		use("nvim-treesitter/nvim-treesitter-textobjects")
		--- }}}

		-- {{{ Plugins: LSP

		-- {{{ Plugin: Snippets
		use("L3MON4D3/LuaSnip")
		-- }}}

		-- {{{ Plugin: Autocompletion
		use("hrsh7th/cmp-nvim-lsp")
		use("hrsh7th/cmp-buffer")
		use("hrsh7th/cmp-path")
		use("hrsh7th/cmp-cmdline")
		-- use("f3fora/cmp-spell")
		use("hrsh7th/cmp-calc")
		use("hrsh7th/cmp-emoji")

		use({
			"hrsh7th/nvim-cmp",
			requires = {
				{ "L3MON4D3/LuaSnip" },
			},
			config = function()
				local cmp = require("cmp")
				local luasnip = require("luasnip")
				local lspkind = require("lspkind")

				local has_words_before = function()
					local line, col = unpack(vim.api.nvim_win_get_cursor(0))
					return col ~= 0
						and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
				end

				cmp.setup({
					experimental = { ghost_text = false },
					snippet = {
						-- REQUIRED - you must specify a snippet engine
						expand = function(args)
							require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
						end,
					},
					mapping = cmp.mapping.preset.insert({
						["<C-b>"] = cmp.mapping.scroll_docs(-4),
						["<C-f>"] = cmp.mapping.scroll_docs(4),
						["<C-Space>"] = cmp.mapping.complete(),
						["<C-e>"] = cmp.mapping.abort(),
						["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
						["<Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							elseif luasnip.expand_or_jumpable() then
								luasnip.expand_or_jump()
							elseif has_words_before() then
								cmp.complete()
							else
								fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
							end
						end, { "i", "s" }),
						["<S-Tab>"] = cmp.mapping(function()
							if cmp.visible() then
								cmp.select_prev_item()
							elseif luasnip.jumpable(-1) then
								luasnip.jump(-1)
							end
						end, { "i", "s" }),
					}),
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "buffer", keyword_length = 5 },
						{ name = "luasnip" },
						{ name = "calc" },
						{ name = "emoji" },
						-- { name = "spell" },
					}),

					formatting = {
						format = lspkind.cmp_format({
							mode = "symbol", -- show only symbol annotations
							maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

							-- The function below will be called before any actual modifications from lspkind
							-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
							-- before = function (entry, vim_item)
							--   ...
							--   return vim_item
							-- end
						}),
					},
				})

				-- Use buffer source for `/`.
				cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })

				-- Use cmdline & path source for ':'.
				cmp.setup.cmdline(":", {
					sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
				})
			end,
		})
		-- }}}

		-- {{{ Plugin: LSP Installer
		-- Easier LSP installation
		use({
			"williamboman/nvim-lsp-installer",
			{
				"neovim/nvim-lspconfig",
				config = function()
					local servers = {
						"bashls",
						"cmake",
						"cssls",
						"codeqlls",
						"dockerls",
						"eslint",
						"html",
						"jsonls",
						"tsserver",
						"sumneko_lua",
						"remark_ls",
						"pyright",
						"sqlls",
						"stylelint_lsp",
						"vimls",
						"yamlls",
					}
					require("nvim-lsp-installer").setup({
						ensure_installed = {},
						automatic_installation = true,
					})

					-- from https://github.com/neovim/nvim-lspconfig
					-- See `:help vim.diagnostic.*` for documentation on any of the below functions
					local opts = { silent = true }
					vim.keymap.set("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
					vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
					vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
					vim.keymap.set("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

					-- Use an on_attach function to only map the following keys
					-- after the language server attaches to the current buffer
					local on_attach = function(client, bufnr)
						-- Enable completion triggered by <c-x><c-o>
						vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

						local buf_opts = { buffer = bufnr, unpack(opts) }

						-- Mappings.
						-- See `:help vim.lsp.*` for documentation on any of the below functions
						vim.keymap.set("n", "gD", vim.lsp.buf.declaration, buf_opts)
						vim.keymap.set("n", "gd", vim.lsp.buf.definition, buf_opts)
						vim.keymap.set("n", "gr", vim.lsp.buf.references, buf_opts)
						vim.keymap.set("n", "gi", vim.lsp.buf.implementation, buf_opts)
						vim.keymap.set("n", "K", vim.lsp.buf.hover, buf_opts)
						-- vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, buf_opts)
						vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, buf_opts)
						vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, buf_opts)
						vim.keymap.set("n", "<leader>wl", function()
							print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
						end, buf_opts)
						vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, buf_opts)
						vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, buf_opts)
						vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, buf_opts)
						vim.keymap.set("n", "<leader>fmt", vim.lsp.buf.format, buf_opts)
					end

					local lspconfig = require("lspconfig")

					local lua_settings = {
						Lua = {
							runtime = {
								version = "LuaJIT", -- LuaJIT in the case of Neovim
								path = vim.split(package.path, ";"),
							},
							diagnostics = {
								-- Get the language server to recognize the `vim` global
								globals = { "vim" },
							},
							workspace = {
								-- Make the server aware of Neovim runtime files
								library = vim.api.nvim_get_runtime_file("", true),
							},
						},
					}

					-- map buffer local keybindings when the language server attaches
					for _, lsp in pairs(servers) do
						if lsp == "sumneko_lua" then
							lspconfig.sumneko_lua.setup({
								on_attach = on_attach,
								settings = lua_settings,
							})
						elseif lsp == "tsserver" then
							lspconfig.tsserver.setup({
								on_attach = function(client, bufnr)
									-- local ts_utils = require("nvim-lsp-ts-utils")
									-- ts_utils.setup({})
									-- ts_utils.setup_client(client)
									-- vim.keymap.set("n", "gs", ":TSLspOrganize<CR>", {buffer=bufnr})
									-- vim.keymap.set("n", "gi", ":TSLspRenameFile<CR>", {buffer=bufnr})
									-- vim.keymap.set("n", "go", ":TSLspImportAll<CR>", {buffer=bufnr})
									on_attach(client, bufnr)
								end,
							})
						else
							lspconfig[lsp].setup({
								on_attach = on_attach,
							})
						end
					end
				end,
			},
		})
		-- }}}

		-- This tiny plugin adds vscode-like pictograms to neovim built-in LSP
		use({
			"onsails/lspkind-nvim",
			-- setup in cmp plugin
		})
		-- }}}

		-- {{{ Plugin: Commenter
		use({
			"terrortylor/nvim-comment",
			cmd = { "CommentToggle" },
			setup = function()
				vim.keymap.set("n", "<leader>/", "<cmd>CommentToggle<CR>", { silent = true })
				vim.keymap.set("v", "<leader>/", ":'<,'>CommentToggle<CR>", { silent = true })
			end,
			config = function()
				require("nvim_comment").setup({})
			end,
		})
		-- }}}

		-- {{{ Plugin: surround
		-- use 'tpope/vim-surround'
		use({
			"kylechui/nvim-surround",
			config = function()
				require("nvim-surround").setup({})
			end,
		})
		-- }}}

		-- {{{ Plugin: Quick Fix
		-- use({ "kevinhwang91/nvim-bqf", ft = "qf" })
		-- }}}

		-- {{{ Plugin: Trouble
		-- https://github.com/folke/trouble.nvim
		use({
			"folke/trouble.nvim",
			requires = "kyazdani42/nvim-web-devicons",
			cmd = { "Trouble" },
			setup = function()
				vim.keymap.set("n", "<leader>xx", "<cmd>Trouble<cr>", { silent = true })
				-- vim.keymap.set("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", { silent = true })
				-- vim.keymap.set("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", { silent = true })
				-- vim.keymap.set("n", "<leader>xl", "<cmd>Trouble locist<cr>", { silent = true })
				-- vim.keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", { silent = true })
				-- vim.keymap.set("n", "<leader>gR", "<cmd>Trouble lsp_references<cr>", { silent = true })
			end,
			config = function()
				require("trouble").setup({})
			end,
		})
		-- }}}

		-- {{{ Plugin: rename current file
		-- :Rename[!] {newname}
		use("danro/rename.vim")
		-- }}}

		-- {{{ Plugins: tmux integrations
		use("christoomey/vim-tmux-navigator") -- allows us to use vim hotkeys to move into tmux panes
		use("tmux-plugins/vim-tmux") -- for editing .tmux.conf
		-- }}}

		-- {{{ Plugin: format on save
		use({
			"mhartington/formatter.nvim",
			config = function()
				-- Utilities for creating configurations
				local util = require("formatter.util")

				-- Provides the Format and FormatWrite commands
				require("formatter").setup({
					-- Enable or disable logging
					logging = true,
					-- Set the log level
					log_level = vim.log.levels.WARN,
					-- All formatter configurations are opt-in
					filetype = {
						-- Formatter configurations for filetype "lua" go here
						-- and will be executed in order
						lua = {
							-- "formatter.filetypes.lua" defines default configurations for the
							-- "lua" filetype
							require("formatter.filetypes.lua").stylua,
						},

						-- Note we need to install eslint_d separately
						-- npm install -g eslint_d
						javascript = {
							require("formatter.filetypes.javascript").eslint_d,
						},
						javascriptreact = {
							require("formatter.filetypes.javascriptreact").eslint_d,
						},
						typescript = {
							require("formatter.filetypes.typescript").eslint_d,
						},
						typescriptreact = {
							require("formatter.filetypes.typescriptreact").eslint_d,
						},
					},
				})

				-- if you want to set up formatting on save, you can use this as a callback
				local augroup = vim.api.nvim_create_augroup("Formatter", {})
				vim.api.nvim_create_autocmd("BufWritePost", {
					group = augroup,
					callback = function()
						vim.cmd([[Format]])
					end,
					-- buffer = bufnr,
					-- callback = function()
					-- 	lsp_formatting(bufnr)
					-- end,
				})
			end,
		})
		-- }}}

		-- {{{ Plugins: git
		use({
			"tpope/vim-fugitive",
		})

		use({
			"tpope/vim-rhubarb", -- to support :GBrowse for github
			-- cmd = 'GBrowse'
		})

		use({
			"lewis6991/gitsigns.nvim",
			config = function()
				require("gitsigns").setup()
			end,
		})

		use({
			"akinsho/git-conflict.nvim",
			config = function()
				require("git-conflict").setup()
				vim.keymap.set("n", "\1", "<Plug>(git-conflict-ours)")
				vim.keymap.set("n", "\2", "<Plug>(git-conflict-theirs)")
				vim.keymap.set("n", "\b", "<Plug>(git-conflict-both)")
				vim.keymap.set("n", "\n", "<Plug>(git-conflict-none)")
				vim.keymap.set("n", "]x", "<Plug>(git-conflict-prev-conflict)")
				vim.keymap.set("n", "[x", "<Plug>(git-conflict-next-conflict)")
			end,
		})
		-- }}}

		-- {{{ Plugins: Formatting / whitespace
		use("bronson/vim-trailing-whitespace")
		use({
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("indent_blankline").setup({
					-- space_char_blankline = " ",
					show_current_context = true,
					show_current_context_start = true,
				})
			end,
		})
		-- }}}

		-- {{{ Plugin: shows colors for color hex codes
		use({
			"norcalli/nvim-colorizer.lua",
			config = function()
				require("colorizer").setup()
			end,
		})
		-- }}}

		-- {{{ Plugin: Colorscheme
		-- use({
		-- 	"sainnhe/sonokai",
		-- 	config = function()
		-- 		vim.cmd("syntax on")
		-- 		-- vim.g.sonokai_style = 'andromeda'
		-- 		vim.g.sonokai_enable_italic = 1
		-- 		-- vim.g.sonokai_disable_italic_comment = 1
		-- 		vim.cmd("colorscheme sonokai")
		-- 	end,
		-- })

		use({
			"catppuccin/nvim",
			as = "catppuccin",
			requires = { "kyazdani42/nvim-web-devicons" },
			run = ":CatppuccinCompile",
			config = function()
				require("catppuccin").setup({
					compile = {
						enabled = true,
						path = vim.fn.stdpath("cache") .. "/catppuccin",
					},
					integration = {
						nvimtree = {
							enabled = true,
							show_root = true, -- makes the root folder not transparent
							transparent_panel = false, -- make the panel transparent
						},
						lsp_trouble = true,
						dashboard = false,
						bufferline = false,
						telekasten = false,
					},
				})
				vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
				vim.cmd([[colorscheme catppuccin]])

				vim.api.nvim_create_autocmd("OptionSet", {
					pattern = "background",
					callback = function()
						vim.cmd("Catppuccin " .. (vim.v.option_new == "light" and "latte" or "mocha"))
					end,
				})
			end,
		})

		-- use {
		-- 'projekt0n/github-nvim-theme',
		-- config = function()
		-- require('github-theme').setup()
		-- end
		-- }
		-- }}}

		-- {{{ Plugin: Snippets
		-- }}}

		-- {{{ Plugin: Autoclose
		use({
			"windwp/nvim-autopairs",
			config = function()
				local npairs = require("nvim-autopairs")
				npairs.setup()

				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				local cmp = require("cmp")
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

				-- -- skip it, if you use another global object
				-- _G.MUtils= {}

				-- vim.g.completion_confirm_key = ""

				-- MUtils.completion_confirm=function()
				-- if vim.fn.pumvisible() ~= 0  then
				-- if vim.fn.complete_info()["selected"] ~= -1 then
				-- require'completion'.confirmCompletion()
				-- return npairs.esc("<c-y>")
				-- else
				-- vim.api.nvim_select_popupmenu_item(0 , false , false ,{})
				-- require'completion'.confirmCompletion()
				-- return npairs.esc("<c-n><c-y>")
				-- end
				-- else
				-- return npairs.autopairs_cr()
				-- end
				-- end

				-- vim.keymap.set('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true })
			end,
		})
		-- }}}

		-- {{{ Plugin: Directory viewer
		use({
			"kyazdani42/nvim-tree.lua",
			requires = { "kyazdani42/nvim-web-devicons" },
			cmd = { "NvimTreeToggle" },
			config = function()
				require("nvim-tree").setup({})
			end,
			setup = function()
				vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>")
			end,
		})
		-- }}}

		-- {{{ Plugin: Statusline
		-- use({
		-- 	"glepnir/galaxyline.nvim",
		-- 	branch = "main",
		-- 	-- your statusline
		-- 	config = function()
		-- 		require("statusline")
		-- 	end,
		-- 	-- some optional icons
		-- 	requires = { "kyazdani42/nvim-web-devicons", opt = true },
		-- })
		use({
			"feline-nvim/feline.nvim",
			config = function()
				require("feline").setup({
					components = require("catppuccin.groups.integrations.feline").get(),
				})
			end,
		})
		-- }}}

		-- {{{ Plugin: SyntaxAttr
		-- shows SyntaxAttr highlighting attributes of char under cursor
		use({
			"vim-scripts/SyntaxAttr.vim",
			config = function()
				vim.keymap.set("n", "<leader>a", ":call SyntaxAttr()<CR>")
			end,
		})
		-- }}}

		-- Language-related
		-- {{{ Language: Javascript
		use("jxnblk/vim-mdx-js")
		-- }}}

		-- Automatically set up your configuration after cloning packer.nvim
		-- Put this at the end after all plugins
		if Packer_bootstrap then
			require("packer").sync()
		end
	end,
	config = {
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "single" })
			end,
		},
	},
})

-- {{{ Editor Options
vim.g.mapleader = " "
vim.opt.modelines = 1
if vim.fn.has("termguicolors") then
	vim.opt.termguicolors = true -- True color support
end
vim.opt.background = "dark" -- Dark background
vim.opt.undodir = vim.fn.stdpath("data") .. ".undodir" -- Persistent undo
vim.opt.undofile = true --
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.softtabstop = 2 --
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.colorcolumn = { 120 }
vim.opt.mouse = "a"
vim.opt.cursorline = true
vim.opt.signcolumn = "yes" -- always show git gutter
vim.opt.showmode = false -- hide modeline
vim.opt.foldmethod = "marker"

-- {{{ Conceal markers
if vim.fn.has("conceal") then
	vim.opt.conceallevel = 2
	vim.opt.concealcursor = "niv"
end
-- }}}
--
if vim.fn.exists("&inccommand") then
	vim.opt.inccommand = "split"
end

-- }}}

-- vim.cmd("hi CursorLine ctermbg=186") -- not sure why this is set

-- {{{ Key Mappings
-- <Tab> to navigate the completion menu
-- vim.keymap.set('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
-- vim.keymap.set('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})

-- vim.keymap.set('i', '<cr>', 'pumvisible() ? "\\<C-y>" : "\\<C-g>u\\<CR>"', {expr = true}) -- enter to confirm delete

vim.keymap.set("c", "<C-p>", 'getcmdline()[getcmdpos()-2] ==# " " ? expand("%:p:h") : "\\<C-p>"', { expr = true }) -- insert current dir path in command line
vim.keymap.set("n", "<leader>ev", ":split $MYVIMRC<CR>")
vim.keymap.set("n", "<leader>sv", ":source $MYVIMRC<CR>:PackerCompile<CR>")
vim.keymap.set("n", "<leader>m", ":messages<CR>")
vim.keymap.set("n", "Q", "<nop>") -- no EX mode accidents

vim.keymap.set("n", "<leader>\\", ":vsplit<CR>")
vim.keymap.set("n", "<leader>-", ":split<CR>")

-- Toggle colorschemes
vim.keymap.set("n", "<leader>dm", function()
	vim.opt.background = vim.opt.background:get() == "light" and "dark" or "light"
end)

-- vim.keymap.set("n", "<leader>c", ":Gvdiff<CR>")
-- vim.keymap.set("n", "<leader><", ":diffget //2<CR>:diffupdate<CR>]c<CR>")
-- vim.keymap.set("n", "<leader>>", ":diffget //3<CR>:diffupdate<CR>]c<CR>")
-- vim.keymap.set('n', '<leader>fc', '<ESC>/^[<=>]\{7\}\( .*\\|\$\)<CR>', { silent = true })

-- vim.keymap.set('n', '<leader>1', ':source ~/.nvimdev.vim<CR>')
-- vim.keymap.set('n', '<leader>ur', ':UpdateRemotePlugins<CR>:qall!<CR>')
-- vim.keymap.set('n', '<D-s>', ':\\<C-u>Update<CR>', {silent = true})
-- vim.keymap.set('i', '<D-s>', '<c-o>:Update<CR><CR>')
-- vim.keymap.set('i', '<M-s>', '<c-o>:Update<CR><CR>')
-- vim.keymap.set('v', '<M-c>', '"+y')
-- vim.keymap.set('v', 'jk', '<esc>')

-- {{{ Terminal key mapping
vim.keymap.set("t", "<C-w>", "<C-\\><C-n><C-w>")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w><C-l>")
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w><C-h>")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w><C-k>")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w><C-j>")
-- }}}
-- }}}

vim.opt.grepprg = "rg --vimgrep"

local vimrc_group = vim.api.nvim_create_augroup("vimrc", { clear = true })
vim.api.nvim_create_autocmd(
	"BufWinEnter,WinEnter",
	{ pattern = "term://*zsh", command = "startinsert", group = vimrc_group }
)

-- {{{ Filetype autocommands
-- vim.api.nvim_create_autocmd("BufNewFile,BufRead,BufEnter", { pattern = "*.jsx,*.tsx,*.ts", command = "set filetype=typescript.tsx" group = vimrc_group })
vim.api.nvim_create_autocmd(
	"BufRead,BufEnter",
	{ pattern = ".babelrc", command = "set filetype=json", group = vimrc_group }
)
vim.api.nvim_create_autocmd(
	"BufRead,BufEnter",
	{ pattern = ".eslintrc", command = "set filetype=json", group = vimrc_group }
)
-- }}}

-- {{{ Whitespace characters
-- vim.opt.list = true
-- vim.opt.listchars:append("space:⋅")
-- vim.opt.listchars:append("eol:↴")
-- }}}
