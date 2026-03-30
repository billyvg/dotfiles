-- vim-fugitive needs no setup

require("gitsigns").setup()

require("diffconflicts").setup({
  commands = {
    diff_conflicts = "DiffConflicts",
    show_history = "DiffConflictsShowHistory",
    with_history = "DiffConflictsWithHistory",
  },
})
