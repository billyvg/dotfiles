-- Treesitter parser installation and configuration
-- modified version of code from this config
-- https://github.com/fredrikaverpil/dotfiles/blob/main/nvim-fredrik/lua/fredrik/plugins/core/treesitter.lua

local ensure_installed = {
  "bash",
  "css",
  "diff",
  "go",
  "gomod",
  "gowork",
  "gosum",
  "graphql",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "lua",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
  "ruby",
}

-- Install parsers from ensure_installed
if #ensure_installed > 0 then
  require("nvim-treesitter").install(ensure_installed)
  -- Register and start parsers for filetypes
  for _, parser in ipairs(ensure_installed) do
    local filetypes = parser
    vim.treesitter.language.register(parser, filetypes)

    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = filetypes,
      callback = function(event)
        vim.treesitter.start(event.buf, parser)
      end,
    })
  end
end

-- Auto-install and start parsers for any buffer
vim.api.nvim_create_autocmd({ "BufRead" }, {
  callback = function(event)
    local bufnr = event.buf
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

    if filetype == "" then
      return
    end

    -- Check if this filetype is already handled by ensure_installed
    for _, filetypes in pairs(ensure_installed) do
      local ft_table = type(filetypes) == "table" and filetypes or { filetypes }
      if vim.tbl_contains(ft_table, filetype) then
        return
      end
    end

    local parser_name = vim.treesitter.language.get_lang(filetype)
    if not parser_name then
      return
    end

    local parser_configs = require("nvim-treesitter.parsers")
    if not parser_configs[parser_name] then
      return
    end

    local parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)

    if not parser_installed then
      require("nvim-treesitter").install({ parser_name }):wait(30000)
    end

    parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)

    if parser_installed then
      vim.treesitter.start(bufnr, parser_name)
    end
  end,
})

-- Treesitter context
require("treesitter-context").setup({
  multiwindow = true,
})
