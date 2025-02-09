-- LSP
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "saghen/blink.cmp" },
			{ "williamboman/mason.nvim", config = true },
			{
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				opts = {
					ensure_installed = {
						"black",
						"isort",
						"prettierd",
						"stylua",
						"yamlfmt",
					},
				},
			},
			{ "williamboman/mason-lspconfig.nvim" },
			{ "lukas-reineke/lsp-format.nvim" },
		},
		config = function()
			vim.lsp.config("*", {
				root_markers = { ".git" },
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

			-- from: https://lsp-zero.netlify.app/blog/you-might-not-need-lsp-zero.html
			-- and https://github.com/VonHeikemen/prime-init.lua/blob/master/after/plugin/lsp.lua
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP keybindings",
				callback = function(event)
					local opts = { buffer = event.buf }

					vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
					vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
					vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
					vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
					vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
					vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
					vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
					vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
					vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
					vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
				end,
			})

			require("mason-lspconfig").setup({
				automatic_installation = true,
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
						require("lspconfig")[server_name].setup({})
					end,
					lua_ls = function()
						require("lspconfig").lua_ls.setup({
							-- {{{ lua lsp settings for nvim
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
										library = {
											-- vim.api.nvim_get_runtime_file("lua", true),
											vim.fn.expand("$VIMRUNTIME/lua"),
											vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
											vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
											"${3rd}/luv/library",
										},
									},
									-- Do not send telemetry data containing a randomized but unique identifier
									telemetry = {
										enable = false,
									},
								},
							},
							-- }}}
						})
					end,
				},
			})
		end,
	},
}
