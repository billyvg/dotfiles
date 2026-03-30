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
        "tree-sitter-cli",

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
        "basedpyright",
        "stylelint-lsp",
        "typescript-language-server",
        "vim-language-server",
        "yaml-language-server",
      },
    },
  },
}
