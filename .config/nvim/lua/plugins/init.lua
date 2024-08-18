return {
	-- the colorscheme should be available when starting Neovim
	--
	-- {{{ Plugin: Colorscheme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		dependencies = { "kyazdani42/nvim-web-devicons" },
		build = ":CatppuccinCompile",
		config = function()
			require("catppuccin").setup({
				-- TODO move this to `opts`?
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
					lsp_trouble = false,
					dashboard = false,
					bufferline = false,
					telekasten = false,
				},
			})
			vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha

			vim.api.nvim_create_autocmd("OptionSet", {
				pattern = "background",
				callback = function()
					vim.cmd("Catppuccin " .. (vim.v.option_new == "light" and "latte" or "mocha"))
				end,
			})

			vim.cmd([[colorscheme catppuccin]])
		end,
	},

	-- {
	-- 	"sainnhe/sonokai",
	-- 	config = function()
	-- 		vim.cmd("syntax on")
	-- 		-- vim.g.sonokai_style = 'andromeda'
	-- 		vim.g.sonokai_enable_italic = 1
	-- 		-- vim.g.sonokai_disable_italic_comment = 1
	-- 		vim.cmd("colorscheme sonokai")
	-- 	end,
	-- },

	-- {
	-- 'projekt0n/github-nvim-theme',
	-- config = function()
	-- require('github-theme').setup()
	-- end
	-- }
	-- }}}

	-- {{{ Plugin: fuzzy finder
	{
		"ibhagwan/fzf-lua",
		dependencies = {
			{
				"junegunn/fzf",
				build = "./install --bin",
			},
      config = function()
        -- calling `setup` is optional for customization
        require('fzf-lua').setup({
            winopts = {
                preview = { default = 'bat_native' },
            },
            file_ignore_patterns = { 'node_modules/.*', 'src/sentry/locale/.*' },
            grep = {
              rg_opts = "--sort-files --hidden --column --line-number --no-heading " ..
                "--color=always --smart-case -g '!{.git,node_modules,src/sentry/locale}/*,*.po'",
            }
        })
      end,
			-- optional for icon support
			"kyazdani42/nvim-web-devicons",
		},
		keys = {
			{
				"<C-p>",
				function()
					require("fzf-lua").files()
				end,
				silent = true,
			},
			{
				"<leader>ff",
				function()
					require("fzf-lua").grep_project()
				end,
				silent = true,
			},
		},
	},
	-- }}}

	-- {{{ Plugin: Commenter
	{
		"terrortylor/nvim-comment",
		main = "nvim_comment",
		cmd = { "CommentToggle" },
		keys = {
			{ "<leader>/", "<cmd>CommentToggle<cr>", mode = { "n" }, silent = true },
			{ "<leader>/", ":'<,'>CommentToggle<CR>", mode = { "v" }, silent = true },
		},
		config = true,
	},
	-- }}}

	-- {{{ Plugin: surround
	-- use 'tpope/vim-surround'
	{
		"kylechui/nvim-surround",
		config = true,
	},
	-- }}}

	-- {{{ Plugin: Quick Fix
	-- { "kevinhwang91/nvim-bqf", ft = "qf" },
	-- }}}

	-- {{{ Plugin: Trouble
	-- https://github.com/folke/trouble.nvim
	{
		"folke/trouble.nvim",
		dependencies = "kyazdani42/nvim-web-devicons",
		cmd = { "Trouble", "TroubleToggle" },
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle<cr>" },
			{ "<leader>xq", "<cmd>Trouble quickfix<cr>" },
			-- { "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>" },
			-- { "<leader>xd", "<cmd>Trouble document_diagnostics<cr>" },
			-- { "<leader>xl", "<cmd>Trouble locist<cr>" },
			-- { "<leader>gR", "<cmd>Trouble lsp_references<cr>" },
		},
		config = {},
	},
	-- }}}

	-- {{{ Plugin: rename current file
	-- :Rename[!] {newname}
	{
		"danro/rename.vim",
		cmd = { "Rename" },
	},
	-- }}}

	-- {{{ Plugins: tmux integrations
	"christoomey/vim-tmux-navigator", -- allows us to use vim hotkeys to move into tmux panes
	"tmux-plugins/vim-tmux", -- for editing .tmux.conf
	-- }}}

	-- {{{ Plugins: git
	{
		"tpope/vim-fugitive",
	},

	{
		"tpope/vim-rhubarb", -- to support :GBrowse for github
		-- cmd = { "GBrowse" },
	},

	{
		"lewis6991/gitsigns.nvim",
		config = {},
	},

	{
		"akinsho/git-conflict.nvim",
		-- opts = {
		--   default_mappings = {
		--     ours = 'o',
		--     theirs = 't',
		--     none = '0',
		--     both = 'b',
		--     next = 'n',
		--     prev = 'p',
		--   },
		-- },
		config = true,
	},
	-- }}}

	-- {{{ Plugins: Formatting / whitespace
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},
	-- }}}

	-- {{{ Plugin: shows colors for color hex codes
	{
		"norcalli/nvim-colorizer.lua",
		config = {},
	},
	-- }}}

	-- {{{ Plugin: Autoclose
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			-- Before        Input         After
			-- ------------------------------------
			-- (  |))         (            (  (|))
			enable_check_bracket_line = true,

			-- Before        Input         After
			-- ------------------------------------
			-- |foobar        (            (|foobar
			-- |.foobar       (            (|.foobar
			-- ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
		},
		config = function(_, opts)
			local npairs = require("nvim-autopairs")
			npairs.setup(opts)

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
	},
	-- }}}

	-- {{{ Plugin: Directory viewer
	{
		"kyazdani42/nvim-tree.lua",
		dependencies = { "kyazdani42/nvim-web-devicons" },
		cmd = { "NvimTreeToggle" },
		keys = {
			{ "<leader>n", ":NvimTreeToggle<cr>" },
		},
		config = {},
	},
	-- }}}

	-- {{{ Plugin: Statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			sections = {
				lualine_c = {
					{
						"filename",
						file_status = true, -- Displays file status (readonly status, modified status)
						newfile_status = false, -- Display new file status (new file means no write after created)
						path = 4, -- 0: Just the filename
						-- 1: Relative path
						-- 2: Absolute path
						-- 3: Absolute path, with tilde as the home directory
						-- 4: Filename and parent dir, with tilde as the home directory

						shorting_target = 40, -- Shortens path to leave 40 spaces in the window
						-- for other components. (terrible name, any suggestions?)
						symbols = {
							modified = "[+]", -- Text to show when the file is modified.
							readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
							unnamed = "[No Name]", -- Text to show for unnamed buffers.
							newfile = "[New]", -- Text to show for newly created file before first write
						},
					},
				},
			},
			inactive_sections = {
				lualine_c = {
					{
						"filename",
						file_status = true, -- Displays file status (readonly status, modified status)
						newfile_status = false, -- Display new file status (new file means no write after created)
						path = 3, -- 0: Just the filename
						-- 1: Relative path
						-- 2: Absolute path
						-- 3: Absolute path, with tilde as the home directory
						-- 4: Filename and parent dir, with tilde as the home directory

						-- shorting_target = 40, -- Shortens path to leave 40 spaces in the window
						-- for other components. (terrible name, any suggestions?)
						symbols = {
							modified = "[+]", -- Text to show when the file is modified.
							readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
							unnamed = "[No Name]", -- Text to show for unnamed buffers.
							newfile = "[New]", -- Text to show for newly created file before first write
						},
					},
				},
			},
		},
		config = true,
	},
	-- }}}

	-- {{{ Plugin: SyntaxAttr
	-- shows SyntaxAttr highlighting attributes of char under cursor
	-- {
	-- 	"vim-scripts/SyntaxAttr.vim",
	-- 	config = function()
	-- 		vim.keymap.set("n", "<leader>a", ":call SyntaxAttr()<CR>")
	-- 	end,
	-- },
	-- }}}

	-- Language-related
	-- {{{ Language: Javascript
	-- "jxnblk/vim-mdx-js",
	-- }}}
}
