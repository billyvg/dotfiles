return {
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				typescript = { "biomejs", "eslint_d", "eslint" },
				javascript = { "biomejs", "eslint_d", "eslint" },
				typescriptreact = { "biomejs", "eslint_d", "eslint" },
				javascriptreact = { "biomejs", "eslint_d", "eslint" },
			},
		},
		config = function()
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					-- try_lint without arguments runs the linters defined in `linters_by_ft`
					-- for the current filetype
					require("lint").try_lint()
				end,
			})
		end,
	},
}
