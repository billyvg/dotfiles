-- {{ lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
-- }}

-- Set <space> as leader key
-- Must happen before plugins are required
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup("plugins", {
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = true,
		notify = false, -- get a notification when changes are found
	},
})

-- {{{ Editor Options
vim.g.mapleader = " "
vim.opt.modelines = 1
if vim.fn.has("termguicolors") then
	vim.opt.termguicolors = true -- True color support
end
vim.opt.background = "dark" -- Dark background
vim.opt.undodir = vim.fn.stdpath("data") .. ".undodir" -- Persistent undo
vim.opt.undofile = true --
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.softtabstop = 2 --
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.colorcolumn = { 120 }
vim.opt.mouse = "a"
vim.opt.cursorline = true
vim.opt.signcolumn = "yes" -- always show git gutter
vim.opt.showmode = false -- hide modeline
vim.opt.foldmethod = "marker"
-- vim.opt.diffopt = "internal,filler,closeoff,linematch:60"
vim.opt.diffopt = "filler,internal,closeoff,algorithm:histogram,context:5,linematch:60"

-- {{{ Conceal markers
if vim.fn.has("conceal") then
	vim.opt.conceallevel = 0
	vim.opt.concealcursor = "niv"
end
-- }}}
--
if vim.fn.exists("&inccommand") then
	vim.opt.inccommand = "split"
end

-- }}}

-- vim.cmd("hi CursorLine ctermbg=186") -- not sure why this is set

-- {{{ Key Mappings
-- <Tab> to navigate the completion menu
-- vim.keymap.set('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
-- vim.keymap.set('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})

-- vim.keymap.set('i', '<cr>', 'pumvisible() ? "\\<C-y>" : "\\<C-g>u\\<CR>"', {expr = true}) -- enter to confirm delete

vim.keymap.set("c", "<C-p>", 'getcmdline()[getcmdpos()-2] ==# " " ? expand("%:p:h") : "\\<C-p>"', { expr = true }) -- insert current dir path in command line
vim.keymap.set("n", "<leader>ev", ":split $MYVIMRC<CR>")
vim.keymap.set("n", "<leader>sv", ":source $MYVIMRC<CR>")
vim.keymap.set("n", "<leader>m", ":messages<CR>")
vim.keymap.set("n", "Q", "<nop>") -- no EX mode accidents

vim.keymap.set("n", "<leader>\\", ":vsplit<CR>")
vim.keymap.set("n", "<leader>-", ":split<CR>")

-- Toggle colorschemes
vim.keymap.set("n", "<leader>dm", function()
	vim.opt.background = vim.opt.background:get() == "light" and "dark" or "light"
end)

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

-- {{{ Terminal key mapping
vim.keymap.set("t", "<C-w>", "<C-\\><C-n><C-w>")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w><C-l>")
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w><C-h>")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w><C-k>")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w><C-j>")
-- }}}
-- }}}

vim.opt.grepprg = "rg --vimgrep"

local vimrc_group = vim.api.nvim_create_augroup("vimrc", { clear = true })
vim.api.nvim_create_autocmd(
	{ "BufWinEnter", "WinEnter" },
	{ pattern = "term://*zsh", command = "startinsert", group = vimrc_group }
)

-- {{{ Filetype autocommands
-- vim.api.nvim_create_autocmd("BufNewFile,BufRead,BufEnter", { pattern = "*.jsx,*.tsx,*.ts", command = "set filetype=typescript.tsx" group = vimrc_group })
vim.api.nvim_create_autocmd(
	{ "BufRead", "BufEnter" },
	{ pattern = ".babelrc", command = "set filetype=json", group = vimrc_group }
)
vim.api.nvim_create_autocmd(
	{ "BufRead", "BufEnter" },
	{ pattern = ".eslintrc", command = "set filetype=json", group = vimrc_group }
)
-- }}}

-- {{{ Whitespace characters
-- vim.opt.list = true
-- vim.opt.listchars:append("space:⋅")
-- vim.opt.listchars:append("eol:↴")
-- }}}
