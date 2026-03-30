require("lazydev").setup({
  library = {
    { path = vim.fn.stdpath("data") .. "/site/pack/core/opt" },
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    { path = "snacks.nvim", words = { "Snacks" } },
    { path = "conform.nvim", words = { "Conform" } },
  },
})
