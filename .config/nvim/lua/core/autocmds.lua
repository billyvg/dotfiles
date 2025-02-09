local vimrc_group = vim.api.nvim_create_augroup("vimrc", { clear = true })
vim.api.nvim_create_autocmd(
	{ "BufWinEnter", "WinEnter" },
	{ pattern = "term://*zsh", command = "startinsert", group = vimrc_group }
)

-- vim.api.nvim_create_autocmd("BufNewFile,BufRead,BufEnter", { pattern = "*.jsx,*.tsx,*.ts", command = "set filetype=typescript.tsx" group = vimrc_group })
vim.api.nvim_create_autocmd(
	{ "BufRead", "BufEnter" },
	{ pattern = ".babelrc", command = "set filetype=json", group = vimrc_group }
)
vim.api.nvim_create_autocmd(
	{ "BufRead", "BufEnter" },
	{ pattern = ".eslintrc", command = "set filetype=json", group = vimrc_group }
)
