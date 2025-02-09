local js_linters = { "biomejs", "eslint_d" }

return {
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				typescript = js_linters,
				javascript = js_linters,
				typescriptreact = js_linters,
				javascriptreact = js_linters,
			},
		},
		config = function()
			local lint = require("lint")

			-- Allow other plugins to add linters to require('lint').linters_by_ft
			lint.linters_by_ft = lint.linters_by_ft or {}

			lint.linters_by_ft["typescript"] = js_linters
			lint.linters_by_ft["javascript"] = js_linters
			lint.linters_by_ft["typescriptreact"] = js_linters
			lint.linters_by_ft["javascriptreact"] = js_linters

			-- Create autocommand which carries out the actual linting
			-- on the specified events.
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					-- Only run the linter in buffers that you can modify in order to
					-- avoid superfluous noise, notably within the handy LSP pop-ups that
					-- describe the hovered symbol using Markdown.
					if vim.opt_local.modifiable:get() then
						lint.try_lint()
					end
				end,
			})
		end,
	},
}
