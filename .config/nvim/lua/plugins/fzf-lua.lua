return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"<c-p>",
				function()
					require("fzf-lua").files()
				end,
				desc = "Find Files",
			},
			{
				"<leader>ff",
				function()
					require("fzf-lua").grep_project()
				end,
				desc = "Grep in project",
			},
			{
				"<leader>fl",
				function()
					require("fzf-lua").live_grep()
				end,
				desc = "Live grep",
			},
			{
				"<leader>fw",
				function()
					require("fzf-lua").grep_cword()
				end,
				desc = "Find current word",
			},
			{
				"<leader>sdd",
				function()
					require("fzf-lua").diagnostics_document()
				end,
				desc = "Document diagnostics",
			},
			{
				"<leader>:",
				function()
					require("fzf-lua").command_history()
				end,
				desc = "Command history",
			},
			{
				"<leader>sC",
				function()
					require("fzf-lua").commands()
				end,
				desc = "Commands",
			},
		},
		opts = {},
	},
}
