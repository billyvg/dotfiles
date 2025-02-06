return {
	-- the colorscheme should be available when starting Neovim
	--
	-- {{{ Plugin: Colorscheme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		dependencies = { "nvim-tree/nvim-web-devicons" },
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
		"folke/snacks.nvim",
		---@type snacks.Config
		opts = {
			picker = {
				-- your picker configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
				win = {
					input = {
						keys = {
							-- to close the picker on ESC instead of going to normal mode,
							-- add the following keymap to your config
							["<Esc>"] = { "close", mode = { "n", "i" } },
							-- I'm used to scrolling like this in LazyGit
							-- ["J"] = { "preview_scroll_down", mode = { "i", "n" } },
							-- ["K"] = { "preview_scroll_up", mode = { "i", "n" } },
							-- ["H"] = { "preview_scroll_left", mode = { "i", "n" } },
							-- ["L"] = { "preview_scroll_right", mode = { "i", "n" } },
						},
					},
				},
			},
		},
		keys = {
			{
				"<leader><space>",
				function()
					Snacks.picker.smart()
				end,
				desc = "Smart Find Files",
			},
			-- { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
			-- { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
			{
				"<leader>:",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command History",
			},
			-- { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
			-- { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
			-- find
			-- { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
			-- { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
			{
				"<C-P>",
				function()
					Snacks.picker.files()
				end,
				desc = "Find Files",
			},
			-- { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
			-- { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
			-- { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
			-- git
			-- { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
			-- { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
			-- { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
			-- { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
			-- { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
			-- Grep
			-- { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
			-- { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
			{
				"<leader>ff",
				function()
					Snacks.picker.grep({ need_search = false, live = true, supports_live = true })
				end,
				desc = "Grep",
			},
			-- { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
			-- search
			-- { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
			-- { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
			-- { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
			-- { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
			-- { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
			-- { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
			{
				"<leader>sd",
				function()
					Snacks.picker.diagnostics()
				end,
				desc = "Diagnostics",
			},
			-- { "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
			-- { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
			-- { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
			-- { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
			-- { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
			-- { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
			-- { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
			-- { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
			-- { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
			-- { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
			-- { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
			-- { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
			-- { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
			-- { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
			-- LSP
			-- { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
			-- { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
			-- { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
			-- { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
			-- { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
			-- { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
			-- { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
		},
	},
	-- {
	-- 	"ibhagwan/fzf-lua",
	-- 	dependencies = {
	-- 		{
	-- 			"junegunn/fzf",
	-- 			build = "./install --bin",
	-- 		},
	--       config = function()
	--         -- calling `setup` is optional for customization
	--         require('fzf-lua').setup({
	--             winopts = {
	--                 preview = { default = 'bat_native' },
	--             },
	--             file_ignore_patterns = { 'node_modules/.*', 'src/sentry/locale/.*' },
	--             grep = {
	--               rg_opts = "--sort-files --hidden --column --line-number --no-heading " ..
	--                 "--color=always --smart-case -g '!{.git,node_modules,src/sentry/locale}/*,*.po'",
	--             }
	--         })
	--       end,
	-- 		-- optional for icon support
	-- 		"nvim-tree/nvim-web-devicons",
	-- 	},
	-- 	keys = {
	-- 		{
	-- 			"<C-p>",
	-- 			function()
	-- 				require("fzf-lua").files()
	-- 			end,
	-- 			silent = true,
	-- 		},
	-- 		{
	-- 			"<leader>ff",
	-- 			function()
	-- 				require("fzf-lua").grep_project()
	-- 			end,
	-- 			silent = true,
	-- 		},
	-- 	},
	-- },
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
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		dependencies = { "nvim-tree/nvim-web-devicons", opts = {} },
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
		},
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
		opts = {},
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
		opts = {},
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

			-- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			-- local cmp = require("cmp")
			-- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

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
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "NvimTreeToggle" },
		keys = {
			{ "<leader>n", ":NvimTreeToggle<cr>" },
		},
		opts = {},
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
