return {
  -- Unorganized snacks
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      image = { enabled = true },
      indent = { enabled = true }, -- indent guides
      bigfile = { enabled = true }, -- disable lsp/ts/etc for bigfiles
      explorer = { enabled = true },
      gitbrowse = { enabled = true },
      picker = { enabled = true },
      input = { enabled = true },
      statuscolumn = { enabled = true },
      notifier = { enabled = true },
    },
    keys = {
      {
        "<leader>gb",
        function()
          Snacks.gitbrowse.open()
        end,
        mode = { "n", "v" },
        desc = "Open in GitHub",
      },
      {
        "<leader>e",
        function()
          Snacks.explorer()
        end,
        desc = "File Explorer",
      },
    },
  },
}
