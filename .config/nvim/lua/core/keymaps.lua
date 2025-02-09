-- note: diagnostics are not exclusive to lsp servers
-- so these can be global keybindings
vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")

-- input current directory in command mode
vim.keymap.set("c", "<C-l>", 'getcmdline()[getcmdpos()-2] ==# " " ? expand("%:p:h") : "\\<C-p>"', { expr = true }) -- insert current dir path in command line
-- editing vim config
vim.keymap.set("n", "<leader>ev", ":split $MYVIMRC<CR>", { desc = "Edit nvim config" })
vim.keymap.set("n", "<leader>sv", ":source $MYVIMRC<CR>", { desc = "Source nvim config" })
-- splits
vim.keymap.set("n", "<leader>\\", ":vsplit<CR>")
vim.keymap.set("n", "<leader>-", ":split<CR>")

vim.keymap.set("n", "<leader>m", ":messages<CR>")
vim.keymap.set("n", "Q", "<nop>") -- no EX mode accidents

-- Toggle colorschemes
vim.keymap.set("n", "<leader>dm", function()
	vim.opt.background = vim.opt.background:get() == "light" and "dark" or "light"
end, { desc = "Toggle dark mode" })

vim.keymap.set("t", "<C-w>", "<C-\\><C-n><C-w>")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w><C-l>")
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w><C-h>")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w><C-k>")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w><C-j>")

-- vim.keymap.set("n", "<leader>c", ":Gvdiff<CR>")
-- vim.keymap.set("n", "<leader><", ":diffget //2<CR>:diffupdate<CR>]c<CR>")
-- vim.keymap.set("n", "<leader>>", ":diffget //3<CR>:diffupdate<CR>]c<CR>")
-- vim.keymap.set('n', '<leader>fc', '<ESC>/^[<=>]\{7\}\( .*\\|\$\)<CR>', { silent = true })

-- vim.keymap.set('n', '<leader>1', ':source ~/.nvimdev.vim<CR>')
-- vim.keymap.set('n', '<leader>ur', ':UpdateRemotePlugins<CR>:qall!<CR>')
-- vim.keymap.set('n', '<D-s>', ':\\<C-u>Update<CR>', {silent = true})
-- vim.keymap.set('i', '<D-s>', '<c-o>:Update<CR><CR>')
-- vim.keymap.set('i', '<M-s>', '<c-o>:Update<CR><CR>')
-- vim.keymap.set('v', '<M-c>', '"+y')
-- vim.keymap.set('v', 'jk', '<esc>')
