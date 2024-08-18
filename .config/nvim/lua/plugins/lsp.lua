return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		lazy = true,
		config = false,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},

	{
		"williamboman/mason.nvim",
		lazy = false,
		config = true,
	},

	-- {{ Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			-- "f3fora/cmp-spell",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-emoji",
			"L3MON4D3/LuaSnip",
			-- setup in cmp plugin
			"onsails/lspkind-nvim",
		},
		config = function()
			-- Here is where you configure the autocompletion settings.
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_cmp()

			-- And you can configure cmp even more, if you want to.
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")
			local cmp_action = lsp_zero.cmp_action()

			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				-- experimental = { ghost_text = false },
				-- formatting = lsp_zero.cmp_format(),
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<C-f>"] = cmp_action.luasnip_jump_forward(),
					["<C-b>"] = cmp_action.luasnip_jump_backward(),
					["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function()
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer", keyword_length = 5 },
					{ name = "luasnip" },
					{ name = "calc" },
					{ name = "emoji" },
					-- { name = "spell" },
				}),

				-- adds a border to completion window
				-- window = {
				--   completion = cmp.config.window.bordered(),
				--   documentation = cmp.config.window.bordered(),
				-- },

				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol", -- show only symbol annotations
						maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

						-- The function below will be called before any actual modifications from lspkind
						-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
						-- before = function (entry, vim_item)
						--   ...
						--   return vim_item
						-- end
					}),
				},
			})

			-- -- Use buffer source for `/`.
			cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })

			-- -- Use cmdline & path source for ':'.
			cmp.setup.cmdline(":", {
				sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
			})
		end,
	},
	-- }}

	-- LSP
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim" },
			{
				"lukas-reineke/lsp-format.nvim",
				opts = {},
				-- dependencies = {
				-- 	{
				-- 		"creativenull/efmls-configs-nvim",
				-- 		version = "v1.x.x", -- version is optional, but recommended
				-- 	},
				-- },
			},
		},
		config = function()
			-- This is where all the LSP shenanigans will live
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_lspconfig()

			lsp_zero.on_attach(function(client, bufnr)
				-- see :help lsp-zero-keybindings
				-- to learn the available actions
				lsp_zero.default_keymaps({ buffer = bufnr })
			end)

			require("mason-lspconfig").setup({
				ensure_installed = {
					"tsserver",
					"bashls",
					"cssls",
					"efm",
					-- 'eslint',
					"html",
					"jsonls",
					"lua_ls",
					-- 'pylsp',
					"pyright",
					"stylelint_lsp",
					-- "tailwindcss",
					"vimls",
					"yamlls",
				},
				handlers = {
					lsp_zero.default_setup,
					-- tsserver = function()
					-- 	require("lspconfig").tsserver.setup { on_attach = require("lsp-format").on_attach }
					-- end,
					efm = function()
            local prettier = {
              formatCommand = 'prettierd "${INPUT}"',
              formatStdin = true,
              env = {
                string.format('PRETTIERD_LOCAL_PRETTIER_ONLY=%s', 1),
              },
            }
            require("lspconfig").efm.setup {
                on_attach = require("lsp-format").on_attach,
                init_options = { documentFormatting = true },
                settings = {
                    languages = {
                        javascript = {prettier},
                        javascriptreact = {prettier},
                        ["javascript.jsx"] = {prettier},
                        typescript = {prettier},
                        ["typescript.tsx"] = {prettier},
                        typescriptreact = {prettier},
                        yaml = { prettier },
                    },
                },
            }
          end,
						-- local languages = require("efmls-configs.defaults").languages()
						-- local efmls_config = {
						-- 	filetypes = vim.tbl_keys(languages),
						-- 	on_attach = require("lsp-format").on_attach,
						-- 	settings = {
						-- 		rootMarkers = { ".git/" },
						-- 		languages = languages,
						-- 	},
						-- 	init_options = {
						-- 		documentFormatting = false,
						-- 		documentRangeFormatting = true,
						-- 	},
						-- }
					--
					-- 	require("lspconfig").efm.setup(vim.tbl_extend("force", efmls_config, {
					-- 		-- Pass your custom lsp config below like on_attach and capabilities
					-- 		--
					-- 		-- on_attach = on_attach,
					-- 		-- capabilities = capabilities,
					-- 	}))
					-- end,
					eslint = function()
						require('lspconfig').eslint.setup({
							on_attach = function(client, bufnr)
                require("lsp-format").on_attach(client, bufnr)
								vim.api.nvim_create_autocmd("BufWritePre", {
								  buffer = bufnr,
								  command = "EslintFixAll",
								})
              end,
						})
					end,
					lua_ls = function()
						-- (Optional) Configure lua language server for neovim
						local lua_opts = lsp_zero.nvim_lua_ls()
						require("lspconfig").lua_ls.setup(lua_opts)
					end,
				},
			})
		end,
	},

	-- {
	-- 	"neovim/nvim-lspconfig",
	-- 	-- event = "LazyFile",
	-- 	dependencies = {
	-- 		-- { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
	-- 		-- { "folke/neodev.nvim", opts = {} },
	-- 		{
	-- 			"williamboman/mason.nvim",
	-- 			opts = {
	-- 				PATH = "prepend",
	-- 			},
	-- 		},
	-- 		"williamboman/mason-lspconfig.nvim",
	-- 	},
	-- 	---@class PluginLspOpts
	-- 	opts = {
	-- 		ensure_installed = { "typescript-language-server" },
	-- 		-- options for vim.diagnostic.config()
	-- 		diagnostics = {
	-- 			underline = true,
	-- 			update_in_insert = false,
	-- 			virtual_text = {
	-- 				spacing = 4,
	-- 				source = "if_many",
	-- 				prefix = "●",
	-- 				-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
	-- 				-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
	-- 				-- prefix = "icons",
	-- 			},
	-- 			severity_sort = true,
	-- 		},
	-- 		-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
	-- 		-- Be aware that you also will need to properly configure your LSP server to
	-- 		-- provide the inlay hints.
	-- 		inlay_hints = {
	-- 			enabled = false,
	-- 		},
	-- 		-- add any global capabilities here
	-- 		capabilities = {},
	-- 		-- options for vim.lsp.buf.format
	-- 		-- `bufnr` and `filter` is handled by the LazyVim formatter,
	-- 		-- but can be also overridden when specified
	-- 		format = {
	-- 			formatting_options = nil,
	-- 			timeout_ms = nil,
	-- 		},
	-- 		-- LSP Server Settings
	-- 		---@type lspconfig.options
	-- 		servers = {
	-- 			lua_ls = {
	-- 				-- mason = false, -- set to false if you don't want this server to be installed with mason
	-- 				-- Use this to add any additional keymaps
	-- 				-- for specific lsp servers
	-- 				---@type LazyKeysSpec[]
	-- 				-- keys = {},
	-- 				settings = {
	-- 					Lua = {
	-- 						workspace = {
	-- 							checkThirdParty = false,
	-- 						},
	-- 						completion = {
	-- 							callSnippet = "Replace",
	-- 						},
	-- 					},
	-- 				},
	-- 			},
	-- 		},
	-- 		-- you can do any additional lsp server setup here
	-- 		-- return true if you don't want this server to be setup with lspconfig
	-- 		---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
	-- 		setup = {
	-- 			-- example to setup with typescript.nvim
	-- 			-- tsserver = function(_, opts)
	-- 			--   require("typescript").setup({ server = opts })
	-- 			--   return true
	-- 			-- end,
	-- 			-- Specify * to use this function as a fallback for any server
	-- 			-- ["*"] = function(server, opts) end,
	-- 		},
	-- 	},
	-- 	config = function()
	-- 		local servers = {
	-- 			"bashls",
	-- 			"cmake",
	-- 			"cssls",
	-- 			"codeqlls",
	-- 			"dockerls",
	-- 			-- "eslint",
	-- 			"html",
	-- 			"jsonls",
	-- 			"typescript-language-server",
	-- 			"lua_ls",
	-- 			"pyright",
	-- 			"sqlls",
	-- 			"stylelint_lsp",
	-- 			"vimls",
	-- 			"yamlls",
	-- 		}

	-- 		-- from https://github.com/neovim/nvim-lspconfig
	-- 		-- See `:help vim.diagnostic.*` for documentation on any of the below functions
	-- 		local opts = { silent = true }
	-- 		vim.keymap.set("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	-- 		vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	-- 		vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	-- 		vim.keymap.set("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

	-- 		-- Use an on_attach function to only map the following keys
	-- 		-- after the language server attaches to the current buffer
	-- 		local on_attach = function(client, bufnr)
	-- 			-- Enable completion triggered by <c-x><c-o>
	-- 			vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- 			local buf_opts = { buffer = bufnr, unpack(opts) }

	-- 			-- Mappings.
	-- 			-- See `:help vim.lsp.*` for documentation on any of the below functions
	-- 			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, buf_opts)
	-- 			vim.keymap.set("n", "gd", vim.lsp.buf.definition, buf_opts)
	-- 			vim.keymap.set("n", "gr", vim.lsp.buf.references, buf_opts)
	-- 			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, buf_opts)
	-- 			vim.keymap.set("n", "K", vim.lsp.buf.hover, buf_opts)
	-- 			-- vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, buf_opts)
	-- 			vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, buf_opts)
	-- 			vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, buf_opts)
	-- 			vim.keymap.set("n", "<leader>wl", function()
	-- 				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	-- 			end, buf_opts)
	-- 			vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, buf_opts)
	-- 			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, buf_opts)
	-- 			vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, buf_opts)
	-- 			vim.keymap.set("n", "<leader>fmt", vim.lsp.buf.format, buf_opts)
	-- 		end

	-- 		local lspconfig = require("lspconfig")

	-- 		local lua_settings = {
	-- 			Lua = {
	-- 				runtime = {
	-- 					version = "LuaJIT", -- LuaJIT in the case of Neovim
	-- 					path = vim.split(package.path, ";"),
	-- 				},
	-- 				diagnostics = {
	-- 					-- Get the language server to recognize the `vim` global
	-- 					globals = { "vim" },
	-- 				},
	-- 				workspace = {
	-- 					-- Make the server aware of Neovim runtime files
	-- 					library = vim.api.nvim_get_runtime_file("", true),
	-- 				},
	-- 			},
	-- 		}

	-- 		-- map buffer local keybindings when the language server attaches
	-- 		for _, lsp in pairs(servers) do
	-- 			if lsp == "sumneko_lua" then
	-- 				lspconfig.sumneko_lua.setup({
	-- 					on_attach = on_attach,
	-- 					settings = lua_settings,
	-- 				})
	-- 			-- elseif lsp == "tsserver" then
	-- 			-- 	lspconfig.tsserver.setup({
	-- 			-- 		on_attach = function(client, bufnr)
	-- 			-- 			-- local ts_utils = require("nvim-lsp-ts-utils")
	-- 			-- 			-- ts_utils.setup({})
	-- 			-- 			-- ts_utils.setup_client(client)
	-- 			-- 			-- vim.keymap.set("n", "gs", ":TSLspOrganize<CR>", {buffer=bufnr})
	-- 			-- 			-- vim.keymap.set("n", "gi", ":TSLspRenameFile<CR>", {buffer=bufnr})
	-- 			-- 			-- vim.keymap.set("n", "go", ":TSLspImportAll<CR>", {buffer=bufnr})
	-- 			-- 			on_attach(client, bufnr)
	-- 			-- 		end,
	-- 			-- 	})
	-- 			else
	-- 				lspconfig[lsp].setup({
	-- 					on_attach = on_attach,
	-- 				})
	-- 			end
	-- 		end
	-- 	end,
	-- },

	-- -- {
	-- -- 	"pmizio/typescript-tools.nvim",
	-- -- 	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	-- -- 	config = function()
	-- -- 		require("typescript-tools").setup({
	-- -- 			settings = {
	-- -- 				tsserver_plugins = {
	-- -- 					"@styled/typescript-styled-plugin",
	-- -- 				},
	-- -- 			},
	-- -- 		})
	-- -- 	end,
	-- -- },
	-- -- }}}

	-- -- This tiny plugin adds vscode-like pictograms to neovim built-in LSP
}
