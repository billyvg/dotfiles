local opt = vim.opt

opt.modelines = 1
if vim.fn.has("termguicolors") then
	opt.termguicolors = true -- True color support
end
opt.background = "dark" -- Dark background
opt.undodir = vim.fn.stdpath("data") .. ".undodir" -- Persistent undo
opt.undofile = true --

-- Tabs/whitespace
opt.tabstop = 2 -- Number of spaces tabs count for
opt.softtabstop = 2 --
opt.shiftwidth = 2 -- Size of an indent
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
--

opt.colorcolumn = { 120 }
opt.mouse = "a"
opt.cursorline = true
opt.signcolumn = "yes" -- always show git gutter
opt.showmode = false -- hide modeline
-- opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
-- opt.diffopt = "internal,filler,closeoff,linematch:60"
opt.diffopt = "filler,internal,closeoff,algorithm:histogram,context:5,linematch:60"

-- Search
opt.incsearch = true
-- Case insensitive searching unless /C or capitilization is used in search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
--

if vim.fn.has("conceal") then
	vim.opt.conceallevel = 0
	vim.opt.concealcursor = "niv"
end

if vim.fn.exists("&inccommand") then
	vim.opt.inccommand = "split"
end

-- use ripgrep if it exists
if vim.fn.executable("rg") == 1 then
	vim.opt.grepprg = "rg --vimgrep"
end

-- whitespace chars
-- vim.opt.list = true
-- vim.opt.listchars:append("space:⋅")
-- vim.opt.listchars:append("eol:↴")
