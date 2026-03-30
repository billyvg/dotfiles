require("fzf-lua").setup({
  grep = {
    rg_opts = "--sort-files --hidden --column --line-number --no-heading "
      .. "--color=always --smart-case -g '!{.git,node_modules,api-docs,}/*' -g '!*.{mo,po,svg}' -g '!CHANGES'",
  },
})

vim.keymap.set("n", "<leader>ff", function()
  require("fzf-lua").grep_project({ rg_glob = true })
end, { desc = "Grep in project (ignore backend)" })

vim.keymap.set("n", "<leader>fa", function()
  require("fzf-lua").grep_project({ rg_glob = true })
end, { desc = "Grep in project" })

vim.keymap.set("n", "<leader>fg", function()
  require("fzf-lua").grep()
end, { desc = "Grep" })

vim.keymap.set("n", "<leader>fl", function()
  require("fzf-lua").live_grep_native()
end, { desc = "Live grep" })

vim.keymap.set("n", "<leader>fw", function()
  require("fzf-lua").grep_cword()
end, { desc = "Find current word" })

vim.keymap.set("n", "<leader>sdd", function()
  require("fzf-lua").diagnostics_document()
end, { desc = "Document diagnostics" })

vim.keymap.set("n", "<leader>:", function()
  require("fzf-lua").command_history()
end, { desc = "Command history" })

vim.keymap.set("n", "<leader>sC", function()
  require("fzf-lua").commands()
end, { desc = "Commands" })
