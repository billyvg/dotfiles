require("mason").setup()

require("mason-tool-installer").setup({
  ensure_installed = {
    "tree-sitter-cli",

    -- Formatters/linters
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
    "python-lsp-server",
    "ruff",
    "stylelint-lsp",
    "typescript-language-server",
    "vim-language-server",
    "yaml-language-server",
  },
})
