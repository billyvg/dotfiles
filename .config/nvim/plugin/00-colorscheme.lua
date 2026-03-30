require("catppuccin").setup({
  compile = {
    enabled = true,
    path = vim.fn.stdpath("cache") .. "/catppuccin",
  },
  integration = {
    nvimtree = {
      enabled = true,
      show_root = true,
      transparent_panel = false,
    },
    lsp_trouble = true,
    dashboard = true,
    bufferline = false,
    telekasten = false,
  },
})
vim.g.catppuccin_flavour = "macchiato"

vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = function()
    vim.cmd("Catppuccin " .. (vim.v.option_new == "light" and "latte" or "mocha"))
  end,
})

vim.cmd([[colorscheme catppuccin]])
