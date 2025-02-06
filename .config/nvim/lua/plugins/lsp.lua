return {
	-- {{ Autocompletion
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = "rafamadriz/friendly-snippets",

		-- use a release tag to download pre-built binaries
		version = "*",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- See the full "keymap" documentation for information on defining your own keymap.
			keymap = { preset = "super-tab" },

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				ghost_text = { enabled = false },
			},

			signature = { enabled = true },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
		opts_extend = { "sources.default" },
	},
	-- }}

	-- LSP
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "saghen/blink.cmp" },
			{ "williamboman/mason.nvim", config = true },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "lukas-reineke/lsp-format.nvim" },
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- from: https://github.com/VonHeikemen/prime-init.lua/blob/master/after/plugin/lsp.lua
			-- vim.api.nvim_create_autocmd('LspAttach', {
			--   desc = 'LSP keybindings',
			--   callback = function(event)
			--     local opts = {buffer = event.buf}
			--
			--     vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
			--     vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
			--     vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
			--     vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
			--     vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
			--     vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
			--     vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
			--     vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
			--     vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
			--     vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
			--   end
			-- })

			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"biome",
					"cssls",
					"dockerls",
					-- "eslint",
					-- "gopls",
					"html",
					"jsonls",
					"lua_ls",
					-- 'pylsp',
					-- "basedpyright",
					"pyright",
					-- "rust_analyzer",
					"stylelint_lsp",
					-- "sqlls",
					"ts_ls",
					-- "tailwindcss",
					"vimls",
					"yamlls",
				},
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({
							-- on_attach = on_attach,
							capabilities = capabilities, -- need to attach blink capabilities
						})
					end,
					lua_ls = function()
						require("lspconfig").lua_ls.setup({
							capabilities = capabilities,
							settings = {
								Lua = {
									runtime = {
										-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
										version = "LuaJIT",
										path = vim.split(package.path, ";"),
									},
									diagnostics = {
										-- Get the language server to recognize the `vim` global
										globals = { "vim" },
									},
									workspace = {
										-- Make the server aware of Neovim runtime files
										library = vim.api.nvim_get_runtime_file("lua", true),
									},
									-- Do not send telemetry data containing a randomized but unique identifier
									telemetry = {
										enable = false,
									},
								},
							},
						})
					end,
				},
			})
		end,
	},
}
