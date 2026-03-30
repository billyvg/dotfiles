-- git
return {
  {
    "tpope/vim-fugitive",
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },

  {
    "mistweaverco/diffconflicts.nvim",
    opts = {
      -- Optional configuration
      commands = {
        -- Command to open the diff conflicts view, default is "DiffConflicts"
        -- set to nil to disable the command
        diff_conflicts = "DiffConflicts",
        -- Command to show the history of conflicts, default is "DiffConflictsShowHistory"
        -- set to nil to disable the command
        show_history = "DiffConflictsShowHistory",
        -- Command to resolve conflicts with history, default is "DiffConflictsWithHistory"
        -- set to nil to disable the command
        with_history = "DiffConflictsWithHistory",
      },
    },
  },
}
