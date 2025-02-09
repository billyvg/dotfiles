-- git
return {
	{
		"tpope/vim-fugitive",
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
}
