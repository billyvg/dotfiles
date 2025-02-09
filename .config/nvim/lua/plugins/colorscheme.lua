return {
	-- the colorscheme should be available when starting Neovim
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
					lsp_trouble = true,
					dashboard = true,
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
}
