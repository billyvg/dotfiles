local prettier_config = {
  "prettierd",
  "prettier",
  stop_after_first = true,
  require_cwd = true,
}

local js_config = {
  "eslint_d",
  "prettierd",
  stop_after_first = false,
  require_cwd = true,
}

require("conform").setup({
  formatters = {},
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff" },
    json = prettier_config,
    javascript = js_config,
    ["javascript.jsx"] = js_config,
    javascriptreact = js_config,
    typescript = js_config,
    typescriptreact = js_config,
    ["typescript.tsx"] = js_config,
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
  format_on_save = { lsp_fallback = true, timeout_ms = 1500 },
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set("", "<leader>fm", function()
  require("conform").format({ async = true })
end, { desc = "Format buffer" })
