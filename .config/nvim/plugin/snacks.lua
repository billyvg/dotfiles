require("snacks").setup({
  image = { enabled = true },
  indent = { enabled = true },
  bigfile = { enabled = true },
  explorer = { enabled = true },
  gitbrowse = { enabled = true },
  input = { enabled = true },
  statuscolumn = { enabled = true },
  notifier = { enabled = true },

  picker = {
    enabled = true,
    win = {
      input = {
        keys = {
          ["<Esc>"] = { "close", mode = { "n", "i" } },
          ["<C-u>"] = "",
        },
      },
    },
  },

  -- Dashboard config
  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
      { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
      {
        pane = 2,
        icon = " ",
        title = "Git Status",
        section = "terminal",
        enabled = function()
          return Snacks.git.get_root() ~= nil
        end,
        cmd = "git status --short --branch --renames",
        height = 5,
        padding = 1,
        ttl = 5 * 60,
        indent = 3,
      },
      -- { section = "startup" },
    },
  },
})

-- Snacks keymaps
vim.keymap.set({ "n", "v" }, "<leader>gb", function()
  Snacks.gitbrowse.open()
end, { desc = "Open in GitHub" })

vim.keymap.set("n", "<leader>e", function()
  Snacks.explorer()
end, { desc = "File Explorer" })

-- Picker keymaps
vim.keymap.set("n", "<leader><space>", function()
  Snacks.picker.smart()
end, { desc = "Smart Find Files" })

vim.keymap.set("n", "<leader>,", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })

-- vim.keymap.set("n", "<leader>/", function()
--   Snacks.picker.grep()
-- end, { desc = "Grep" })

vim.keymap.set("n", "<leader>:", function()
  Snacks.picker.command_history()
end, { desc = "Command History" })

vim.keymap.set("n", "<leader>fb", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })

-- vim.keymap.set("n", "<leader>fc", function()
--   Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
-- end, { desc = "Find Config File" })

vim.keymap.set("n", "<C-P>", function()
  Snacks.picker.files({ hidden = true })
end, { desc = "Find Files" })

vim.keymap.set({ "n", "x" }, "<leader>sw", function()
  Snacks.picker.grep_word()
end, { desc = "Visual selection or word" })

vim.keymap.set("n", "<leader>sk", function()
  Snacks.picker.keymaps()
end, { desc = "Keymaps" })
