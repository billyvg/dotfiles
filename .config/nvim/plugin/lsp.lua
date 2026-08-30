vim.lsp.config("*", {
  root_markers = { ".git" },
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP keybindings",
  callback = function(event)
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
    end

    map("n", "K", vim.lsp.buf.hover, "LSP hover info")
    map("n", "gd", vim.lsp.buf.definition, "LSP go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "LSP go to declaration")
    map("n", "go", vim.lsp.buf.type_definition, "LSP go to type definition")
    map("n", "gi", vim.lsp.buf.implementation, "LSP go to implementation")
    map("n", "gr", vim.lsp.buf.references, "LSP list references")
    map("n", "gs", vim.lsp.buf.signature_help, "LSP signature help")
    map("n", "gn", vim.lsp.buf.rename, "LSP rename")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
    map("n", "[g", vim.diagnostic.goto_prev, "Go to previous diagnostic")
    map("n", "g]", vim.diagnostic.goto_next, "Go to next diagnostic")
    map({ "n", "x" }, "<F3>", function()
      vim.lsp.buf.format({ async = true })
    end, "LSP format")
  end,
})

vim.lsp.enable({
  "bashls",
  "biome",
  "cssls",
  "dockerls",
  "html",
  "jsonls",
  "lua_ls",
  "pylsp",
  "ruff_lsp",
  "sourcekit",
  "stylelint_lsp",
  "ts_ls",
  "vimls",
  "yamlls",
})
