require("nvim_comment").setup()

vim.keymap.set("n", "<leader>/", "<cmd>CommentToggle<cr>", { silent = true })
vim.keymap.set("v", "<leader>/", ":'<,'>CommentToggle<CR>", { silent = true })
