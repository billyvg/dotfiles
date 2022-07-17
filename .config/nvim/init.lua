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

		-- {{{ Plugin: fzf
		use({
			"junegunn/fzf",
			run = function()
				vim.fn["fzf#install"]()
			end,
		})
		use({
			"junegunn/fzf.vim",
			setup = function()
				vim.keymap.set("n", "<C-p>", ":FZF<CR>")
				vim.keymap.set("n", "<leader>f", ":RG<CR>")
			end,
			config = function()
				vim.api.nvim_exec(
					[[
        function! RipgrepFzf2(query, fullscreen)
          let command_fmt = 'rg --hidden --column --line-number --no-heading --follow --color=always --smart-case -- %s || true'
          let initial_command = printf(command_fmt, shellescape(a:query))
          let spec = {'options': ['--query', a:query]}
          call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
        endfunction

        command! -nargs=* -bang RG call RipgrepFzf2(<q-args>, <bang>0)
      ]],
					false
				)

				-- vim.api.nvim_command('command! -nargs=* -bang RG call g:RipgrepFzf(<q-args>, <bang>0)')
			end,
		})
		-- use {
		-- 'nvim-telescope/telescope.nvim',
		-- requires = {
		-- {'nvim-lua/popup.nvim'},
		-- {'nvim-lua/plenary.nvim'},
		-- {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
		-- },
		-- config = function ()
		-- vim.keymap.set('n', '<C-p>', ':Telescope find_files<CR>')
		-- vim.keymap.set('n', '<leader>ff', ':Telescope live_grep<CR>')
		-- require('telescope').load_extension('fzf')
		-- end
		-- }
		-- use {
		-- 'camspiers/snap', rocks = {'fzy'},
		-- config = function()
		-- local snap = require'snap'
		-- snap.register.map({"n"}, {"<C-p>"}, function ()
		-- snap.run {
		-- producer = snap.get'consumer.fzy'(snap.get'producer.ripgrep.file'),
		-- select = snap.get'select.file'.select,
		-- multiselect = snap.get'select.file'.multiselect,
		-- views = {snap.get'preview.file'}
		-- }
		-- end)
		-- snap.register.map({"n"}, {"<Leader>f"}, function ()
		-- snap.run {
		-- producer = snap.get'producer.ripgrep.vimgrep',
		-- select = snap.get'select.vimgrep'.select,
		-- multiselect = snap.get'select.vimgrep'.multiselect,
		-- views = {snap.get'preview.vimgrep'}
		-- }
		-- end)
		-- end
		-- }

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

		-- {{{ Plugin: Autocompletion
		use({
			"hrsh7th/nvim-compe",
			config = function()
				vim.o.completeopt = "menuone,noselect"
				require("compe").setup({
					enabled = true,
					autocomplete = true,
					debug = false,
					min_length = 1,
					preselect = "enable",
					throttle_time = 80,
					source_timeout = 200,
					resolve_timeout = 800,
					incomplete_delay = 400,
					max_abbr_width = 100,
					max_kind_width = 100,
					max_menu_width = 100,
					documentation = {
						border = { "", "", "", " ", "", "", "", " " }, -- the border option is the same as `|help nvim_open_win|`
						winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
						max_width = 120,
						min_width = 60,
						max_height = math.floor(vim.o.lines * 0.3),
						min_height = 1,
					},

					source = {
						path = true,
						buffer = true,
						calc = true,
						nvim_lsp = true,
						nvim_lua = true,
						vsnip = false,
						ultisnips = false,
						luasnip = false,
					},
				})
				local t = function(str)
					return vim.api.nvim_replace_termcodes(str, true, true, true)
				end

				local check_back_space = function()
					local col = vim.fn.col(".") - 1
					return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
				end

				-- Use (s-)tab to:
				--- move to prev/next item in completion menuone
				--- jump to prev/next snippet's placeholder
				_G.tab_complete = function()
					if vim.fn.pumvisible() == 1 then
						return t("<C-n>")
					-- elseif vim.fn['vsnip#available'](1) == 1 then
					-- return t "<Plug>(vsnip-expand-or-jump)"
					elseif check_back_space() then
						return t("<Tab>")
					else
						return vim.fn["compe#complete"]()
					end
				end

				_G.s_tab_complete = function()
					if vim.fn.pumvisible() == 1 then
						return t("<C-p>")
					-- elseif vim.fn['vsnip#jumpable'](-1) == 1 then
					-- return t "<Plug>(vsnip-jump-prev)"
					else
						-- If <S-Tab> is not working in your terminal, change it to <C-h>
						return t("<S-Tab>")
					end
				end

				vim.keymap.set("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
				vim.keymap.set("s", "<Tab>", "v:lua.tab_complete()", { expr = true })
				vim.keymap.set("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
				vim.keymap.set("s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })

				vim.keymap.set("i", "<C-Space>", "compe#complete()", { expr = true, silent = true })
				vim.keymap.set(
					"i",
					"<CR>",
					[[compe#confirm(luaeval("require 'nvim-autopairs'.autopairs_cr()"))]],
					{ expr = true, silent = true }
				)
				vim.keymap.set("i", "<C-e>", "compe#close('<C-e>')", { expr = true, silent = true })
				vim.keymap.set("i", "<C-f>", "compe#scroll({ 'delta': +4 })", { expr = true, silent = true })
				vim.keymap.set("i", "<C-d>", "compe#scroll({ 'delta': -4 })", { expr = true, silent = true })
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

					-- if you want to set up formatting on save, you can use this as a callback
					local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

					local lsp_formatting = function(bufnr)
						vim.lsp.buf.format({
							timeout_ms = 5000,
							filter = function(client)
								-- apply whatever logic you want (in this example, we'll only use null-ls)
								return client.name == "null-ls"
							end,
							bufnr = bufnr,
						})
					end

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

						if client.supports_method("textDocument/formatting") then
							vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
							vim.api.nvim_create_autocmd("BufWritePre", {
								group = augroup,
								buffer = bufnr,
								callback = function()
									lsp_formatting(bufnr)
								end,
							})
						end
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
			config = function()
				require("lspkind").init()
			end,
		})

		-- This plugin makes the Neovim LSP client use FZF to display results and navigate the code.
		use({
			"ojroques/nvim-lspfuzzy",
			requires = {
				{ "junegunn/fzf" },
				{ "junegunn/fzf.vim" }, -- to enable preview (optional)
			},
			config = function()
				require("lspfuzzy").setup({})
			end,
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

		-- {{{ Plugin: null-ls
		use({
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
				require("null-ls").setup({
					sources = {
						require("null-ls").builtins.formatting.stylua,
						require("null-ls").builtins.diagnostics.eslint,
						require("null-ls").builtins.formatting.eslint,
						require("null-ls").builtins.diagnostics.stylelint,
					},
				})
			end,
			requires = { "nvim-lua/plenary.nvim" },
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
			config = function()
				require("catppuccin").setup({
					integration = {
						nvimtree = {
							enabled = true,
							show_root = true, -- makes the root folder not transparent
							transparent_panel = false, -- make the panel transparent
						},
						lsp_trouble = true,
					},
				})
				vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
				vim.cmd([[colorscheme catppuccin]])
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
				require("nvim-autopairs.completion.compe").setup({
					map_cr = true, --  map <CR> on insert mode
					map_complete = true, -- it will auto insert `(` after select function or method item
				})

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
					components = require("catppuccin.core.integrations.feline"),
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

-- Some FZF Configuration
vim.opt.grepprg = "rg --vimgrep"
vim.env["FZF_DEFAULT_COMMAND"] = "rg --color=never --files --follow --hidden -g '!.git/*'"
vim.env["FZF_DEFAULT_OPTS"] = "--layout=reverse"

local fzf_group = vim.api.nvim_create_augroup("fzf_setup", { clear = true })
vim.api.nvim_create_autocmd(
	"TermOpen",
	{ pattern = "term://*FZF", command = "tnoremap <silent> <buffer><nowait> <esc> <c-c>", group = fzf_group }
)

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
