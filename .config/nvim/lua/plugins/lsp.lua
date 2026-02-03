-- LSP
return {
  {
    "mason-org/mason.nvim",
    config = true,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- Formatters/linters
        "black",
        "isort",
        "prettierd",
        "stylua",
        "yamlfmt",
        -- LSP servers
        "bash-language-server",
        "biome",
        "css-lsp",
        "dockerfile-language-server",
        "html-lsp",
        "json-lsp",
        "lua-language-server",
        "pyright",
        "stylelint-lsp",
        "typescript-language-server",
        "vim-language-server",
        "yaml-language-server",
      },
    },
  },
  {
    -- LSP setup using native Neovim 0.11 API
    dir = vim.fn.stdpath("config"),
    name = "lsp-native",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim", "saghen/blink.cmp" },
    config = function()
      -- Global config for all servers
      vim.lsp.config("*", {
        root_markers = { ".git" },
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- LspAttach keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP keybindings",
        callback = function(event)
          local opts = { buffer = event.buf }
          -- vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          -- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          -- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          -- vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts) -- `go` conflicts
          -- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          -- vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
          -- vim.keymap.set("n", "gn", vim.lsp.buf.rename, opts)
          -- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set({ "n", "x" }, "<F3>", function()
            vim.lsp.buf.format({ async = true })
          end, opts)

          local wk = require("which-key")
          wk.register({
            K = { vim.lsp.buf.hover, "LSP hover info" },
            gd = { vim.lsp.buf.definition, "LSP go to definition" },
            gD = { vim.lsp.buf.declaration, "LSP go to declaration" },
            go = { vim.lsp.buf.type_definition, "LSP go to type definition" },
            gi = { vim.lsp.buf.implementation, "LSP go to implementation" },
            gr = { vim.lsp.buf.references, "LSP list references" },
            gs = { vim.lsp.signature_help, "LSP signature help" },
            gn = { vim.lsp.buf.rename, "LSP rename" },
            ["<leader>ca"] = { vim.lsp.buf.code_action, "LSP code action" },
            ["[g"] = { vim.diagnostic.goto_prev, "Go to previous diagnostic" },
            ["g]"] = { vim.diagnostic.goto_next, "Go to next diagnostic" },
          }, {
            mode = "n",
            silent = true,
          })
        end,
      })

      -- Enable all LSP servers
      vim.lsp.enable({
        "bashls",
        "biome",
        "cssls",
        "dockerls",
        "html",
        "jsonls",
        "lua_ls",
        "pyright",
        "sourcekit", -- installed with XCode
        "stylelint_lsp",
        "ts_ls",
        "vimls",
        "yamlls",
      })
    end,
  },
}
