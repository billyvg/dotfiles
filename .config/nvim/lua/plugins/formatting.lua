local prettier_config = {
	"prettierd",
	"prettier",
	stop_after_first = true,
	require_cwd = true,
}

local js_config = {
	"biome-organize-imports",
	"eslint_d",
	"prettierd",
	stop_after_first = false,
	require_cwd = true,
}

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>fm",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	-- This will provide type hinting with LuaLS
	---@module "conform"
	---@type Conform.setupOpts
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			-- markdown = { "markdownlint" },
			-- yaml = { "yamlfmt" },
			-- yaml = prettier_config,
			json = prettier_config,
			javascript = js_config,
			["javascript.jsx"] = js_config,
			javascriptreact = js_config,
			typescript = js_config,
			typescriptreact = js_config,
			["typescript.tsx"] = js_config,
		},
		-- Set default options
		default_format_opts = {
			lsp_format = "fallback",
		},
		-- Set up format-on-save
		format_on_save = { lsp_fallback = true, timeout_ms = 500 },
		-- Customize formatters
		formatters = {},
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
