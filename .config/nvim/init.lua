local api = vim.api
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options
local env = vim.env  -- environment variables

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- taken from https://github.com/norcalli/nvim_utils
function nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    api.nvim_command('augroup '..group_name)
    api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      -- if type(def) == 'table' and type(def[#def]) == 'function' then
      -- 	def[#def] = lua_callback(def[#def])
      -- end
      local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
      api.nvim_command(command)
    end
    api.nvim_command('augroup END')
  end
end

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  api.nvim_command('packadd packer.nvim')
end

require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- fzf
  use { 'junegunn/fzf', run = function() vim.fn['fzf#install']() end }
  use 'junegunn/fzf.vim'

  -- treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- Tree sitter Playground
  -- https://github.com/nvim-treesitter/playground
  -- use 'nvim-treesitter/playground'

  -- https://github.com/nvim-treesitter/nvim-treesitter-refactor
  -- use 'nvim-treesitter/nvim-treesitter-refactor'

  -- Custom text objects using treesitter
  -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  use 'nvim-treesitter/nvim-treesitter-textobjects'

  use {
    'scrooloose/nerdcommenter',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>/', ':call NERDComment(0, "toggle")<CR>', {noremap = true})
      vim.api.nvim_set_keymap('v', '<leader>/', ':call NERDComment(0, "toggle")<CR>', {noremap = true})
    end
  }

  use 'tpope/vim-surround'

  -- renames current file
  -- :Rename[!] {newname}
  use 'danro/rename.vim'

  -- tmux integrations
  use 'christoomey/vim-tmux-navigator' -- allows us to use vim hotkeys to move into tmux panes
  use 'tmux-plugins/vim-tmux-focus-events'
  use 'tmux-plugins/vim-tmux' -- for editing .tmux.conf

  -- vim test runner
  -- use 'janko-m/vim-test'

  -- linter
  use {
    'dense-analysis/ale',
    config = function()
      local g = vim.g
      local api = vim.api
      -- g.ale_javascript_prettier_use_local_config = 1
      -- g.ale_linter_aliases = {'jsx': ['css', 'javascript']}
      -- g.ale_linters = {
            -- \'jsx': ['stylelint', 'eslint'],
            -- \'javascript': ['eslint'],
            -- \'javascript.jsx': ['eslint'],
            -- \'typescript': ['eslint'],
            -- \'typescript.tsx': ['eslint'],
            -- \}
      -- g.ale_javascript_eslint_use_global = 0 -- this works more reliably
      -- g.ale_fixers = {}
      -- g.ale_fixers['json'] = ['prettier']
      -- g.ale_fixers['javascript'] = ['eslint']
      -- g.ale_fixers['javascript.jsx'] = ['eslint', 'stylelint']
      -- g.ale_fixers['typescript'] = ['eslint', 'prettier']
      -- g.ale_fixers['typescript.tsx'] = ['eslint']
      -- g.ale_fixers['less'] = ['prettier']
      -- g.ale_fixers['python'] = ['autopep8']
      g.ale_fix_on_save = 1
      g.ale_echo_msg_error_str = 'E'
      g.ale_echo_msg_warning_str = 'W'
      g.ale_echo_msg_format = '[%linter%] %s (%code%)'
      g.ale_lint_delay = 200
      g.ale_virtualtext_cursor = 1
      g.ale_linters_explicit = 1
      api.nvim_set_keymap('n', '<C-[>', '<Plug>(ale_previous_wrap)', {silent = true, noremap = true})
      api.nvim_set_keymap('n', '<C-]>', '<Plug>(ale_next_wrap)', {silent = true, noremap = true})
    end
  }

  -- git helpers {{{
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb' -- to support :Gbrowse for github
  use {
    'airblade/vim-gitgutter',
    config = function()
      vim.g.gitgutter_realtime = 250
      vim.g.gitgutter_eager = 100
    end
  }

  use 'rhysd/conflict-marker.vim'
  use 'k0kubun/vim-open-github' -- for opening in github
  -- }}}

  -- indent/whitespace {{{
  -- use 'Yggdroot/indentLine'
  use 'nathanaelkane/vim-indent-guides'
  use 'bronson/vim-trailing-whitespace'
  -- }}}

  -- shows colors for color hex codes
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end
  }

  -- theme {{{
  -- use 'crusoexia/vim-monokai'
  use {
    'patstockwell/vim-monokai-tasty',
    config = function()
      vim.g.vim_monokai_tasty_italic = 1
      vim.cmd('colorscheme vim-monokai-tasty')
    end
  }
  -- }}}

  -- snippets {{{
  -- use 'Shougo/neosnippet.vim'
  -- use 'Shougo/neosnippet-snippets'
  -- }}}

  -- auto close symbols {{{
  -- use 'jiangmiao/auto-pairs'
  -- use 'Raimondi/delimitMate'
  -- use 'Shougo/neopairs.vim'
  -- }}}

  -- Auto close html tags (and jsx) {{{
  -- use 'alvan/vim-closetag'
  -- }}}

  -- Directory viewers {{{
    use {
      'kyazdani42/nvim-tree.lua',
      requires = {'kyazdani42/nvim-web-devicons'},
      cmd = 'NvimTreeToggle',
      setup = function()
        vim.api.nvim_set_keymap('n', '<leader>n', ':NvimTreeToggle<CR>', {noremap = true})
      end
    }
  -- }}}

  -- Status line {{{
    use {
      'glepnir/galaxyline.nvim',
      branch = 'main',
      -- your statusline
      config = function() require('statusline') end,
      -- some optional icons
      requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }
  -- }}}

  -- rainbow brackets
  -- https://github.com/p00f/nvim-ts-rainbow
  -- use 'p00f/nvim-ts-rainbow'

  -- Language-related
  -- Python {{{
  -- use 'davidhalter/jedi-vim'
  -- use 'zchee/deoplete-jedi'
  -- }}}

  -- use 'neoclide/coc.nvim', {'branch': 'release'}

  use 'pangloss/vim-javascript'
  -- use 'mxw/vim-jsx'
  use 'maxmellon/vim-jsx-pretty'
  use 'jxnblk/vim-mdx-js'
  -- use 'Galooshi/vim-import-js', { 'do': 'npm install -g import-js' }

  -- use 'othree/javascript-libraries-syntax.vim'
  -- use 'moll/vim-node'
  -- use 'styled-components/vim-styled-components', { 'branch': 'main' }
  -- use 'wavded/vim-stylus'
  -- use 'leafgarland/typescript-vim'
  -- see https://github.com/leafgarland/typescript-vim/issues/184
  -- hi link typescriptReserved Keyword
  -- let g:typescript_indent_disable = 1
  -- -- use 'peitalin/vim-jsx-typescript'
  -- use 'elzr/vim-json'

  -- let g:vim_jsx_pretty_colorful_config = 1 -- default 0

  -- shows SyntaxAttrx highlighting attributes of char under cursor
  -- use 'vim-scripts/SyntaxAttr.vim'
end)


g.mapleader = ' '

opt.modelines = 1
opt.termguicolors = true                -- True color support
opt.background = "dark"                 -- Dark background
opt.undodir = '~/.config/nvim/undodir'  -- Persistent undo
opt.undofile = true                     --
opt.tabstop = 2                         -- Number of spaces tabs count for
opt.softtabstop = 2                     --
opt.shiftwidth = 2                      -- Size of an indent
opt.expandtab = true
opt.wrap = false
opt.colorcolumn = { 120 }
opt.mouse = "a"
opt.cursorline = true
opt.signcolumn = "yes"                  -- always show git gutter
opt.showmode = false                    -- hide modeline

cmd 'hi CursorLine ctermbg=186'
-- Needs to be set after plugin
-- g.monokai_term_italic = 1
-- g.monokai_gui_italic = 1
-- cmd 'colorscheme monokai'
-- g.airline_theme = 'monokai_tasty'
-- set t_Co=256 --256 colors

-- cmd 'syntax on'

-- For conceal markers.
if fn.has('conceal') then
  opt.conceallevel = 2
  opt.concealcursor = "niv"
end

if fn.exists('&inccommand') then
  opt.inccommand = "split"
end

-- Key Mappings --
-- <Tab> to navigate the completion menu
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})

map('i', '<cr>', 'pumvisible() ? "\\<C-y>" : "\\<C-g>u\\<CR>"', {expr = true}) -- enter to confirm delete


map('n', '<C-p>', ':FZF<CR>')
map('n', '<leader>f', ':RG<CR>')
map('n', 'gp', ':ALEFix<CR>')
-- map('n', '<leader>es', ':execute ":split " . g:neosnippet#snippets_directory')

map('c', '<C-P>', 'getcmdline()[getcmdpos()-2] ==# " " ? expand("%:p:h") : "\\<C-P>"', {expr = true}) -- insert current dir path in command line
map('n', '<leader>ev', ':split $MYVIMRC<CR>')
map('n', '<leader>sv', ':source $MYVIMRC<CR>')
map('n', '<leader>m', ':messages<CR>')
map('n', 'Q', '<nop>') -- no EX mode accidents

map('n', '<leader>\\', ':vsplit<CR>')
map('n', '<leader>-', ':split<CR>')

map('n', '<leader>c', ':Gvdiff<CR>')
map('n', '<leader><', ':diffget //2<CR>:diffupdate<CR>]c<CR>')
map('n', '<leader>>', ':diffget //3<CR>:diffupdate<CR>]c<CR>')
map('n', '<leader>fc', '<ESC>/\\v^[<=>]{7}( .*\\|$)<CR>', {silent = true})

-- map('n', '<leader>1', ':source ~/.nvimdev.vim<CR>')
-- map('n', '<leader>ur', ':UpdateRemotePlugins<CR>:qall!<CR>')
-- map('n', '<D-s>', ':\\<C-u>Update<CR>', {silent = true})
-- map('i', '<D-s>', '<c-o>:Update<CR><CR>')
-- map('i', '<M-s>', '<c-o>:Update<CR><CR>')
-- map('v', '<M-c>', '"+y')
-- map('v', 'jk', '<esc>')


-- Terminal things
-- map('t', '<Esc>', '<C-\\><C-n>')
map('t', '<C-w>', '<C-\\><C-n><C-w>')
map('t', '<C-l>', '<C-\\><C-n><C-w><C-l>')
map('t', '<C-h>', '<C-\\><C-n><C-w><C-h>')
map('t', '<C-k>', '<C-\\><C-n><C-w><C-k>')
map('t', '<C-j>', '<C-\\><C-n><C-w><C-j>')

require('colorizer').setup()

local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

g.javascript_plugin_flow = 0 -- disable flow for vim-javascript
g.jsx_ext_required = 0
g.vim_jsx_pretty_colorful_config = 1

-- NERDCommenter {{{
-- Add spaces after comment delimiters by default
g.NERDSpaceDelims = 1
-- }}}

-- Some FZF Configuration
opt.grepprg = "rg --vimgrep"
vim.env['$FZF_DEFAULT_COMMAND'] = 'rg --files --hidden --follow -g "!.git/*" -g "!south_migrations" -g "!src/sentry/south" -g "!CHANGES" -g "!vendor" -g "!tests/fixtures/integration-docs/*" -g "!static/dist" -g "!static/vendor" -g "!src/sentry/static/sentry"'
vim.env['$FZF_DEFAULT_OPTS'] = '--layout=reverse'

local augroups = {
  fzf_setup = {
    {"TermOpen", "term://*FZF", "tnoremap <silent> <buffer><nowait> <esc> <c-c>"},
  },
  vimrc = {
    {"BufWinEnter,WinEnter term://*zsh startinsert"},
    {"BufNewFile,BufRead,BufEnter *.jsx,*.tsx,*.ts set filetype=typescript.tsx"},
    {"BufRead,BufEnter .babelrc set filetype=json"},
    {"BufRead,BufEnter .eslintrc set filetype=json"},
  },
}

nvim_create_augroups(augroups)

-- cmd([[command! -bang -nargs=* RG
 -- call fzf#vim#grep(
   -- 'rg --column --hidden --line-number --no-heading --follow --color never ' .
   -- '-g "!.git" '.
   -- '-g "!.git-blame-ignore-revs" '.
   -- '-g "!static/dist/**/*" '.
   -- '-g "!bin/yarn" '.
   -- '-g "!CHANGES" '.
   -- '-g "!stats.json" ' .
   -- '-g "!static/images/*" ' .
   -- '-g "!static/images/**/*" ' .
   -- '-g "!static/app/icons/*" ' .
   -- '-g "!static/less/debugger*" ' .
   -- '-g "!static/vendor/*" ' .
   -- '-g "!src/sentry/static/sentry/**/*" ' .
   -- '-g "!**/south_migrations/*" ' .
   -- '-g "!src/sentry/static/sentry/dist/**/*" ' .
   -- '-g "!src/sentry/static/sentry/images/*" ' .
   -- '-g "!src/sentry/static/sentry/images/**/*" ' .
   -- '-g "!src/sentry/static/sentry/app/icons/*" ' .
   -- '-g "!src/sentry/static/sentry/app/views/organizationIncidents/details/closedSymbol.jsx" ' .
   -- '-g "!src/sentry/static/sentry/app/views/organizationIncidents/details/detectedSymbol.jsx" ' .
   -- '-g "!src/sentry/static/sentry/less/debugger*" ' .
   -- '-g "!src/sentry/templates/sentry/js-sdk-loader.min.js.tmpl" ' .
   -- '-g "!src/sentry/templates/sentry/js-sdk-loader.min.js.tmpl" ' .
   -- '-g "!tests/js/**/*.snap" ' .
   -- '-g "!tests/fixtures/*" ' .
   -- '-g "!tests/fixtures/**/*" ' .
   -- '-g "!tests/*/fixtures/*" ' .
   -- '-g "!tests/**/fixtures/*" ' .
   -- '-g "!tests/**/snapshots/**/*" ' .
   -- '-g "!tests/sentry/lang/*/fixtures/*" ' .
   -- '-g "!tests/sentry/lang/**/*.map" ' .
   -- '-g "!tests/sentry/grouping/**/*" ' .
   -- '-g "!tests/sentry/db/*" ' .
   -- '-g "!tests/relay_integration/lang/javascript/example-project/*" ' .
   -- '-g "!src/sentry/locale/**/*" ' .
   -- '-g "!src/sentry/data/**/*" ' .
   -- '-g "!src/debug_toolbar/**/*" ' .
   -- shellescape(<q-args>), 1,
   -- <bang>1 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
           -- : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
   -- <bang>1)]], false)

-- cmd([[filetype plugin indent on]])
-- cmd([[syntax on]])

-- airline config {{{
-- Remove file encoding type
-- Enable the list of buffers
-- let g:airline#extensions#tabline#enabled = 0

-- " Show just the filename
-- let g:airline#extensions#tabline#fnamemod = ':t'
-- let g:airline_powerline_fonts = 1

-- let g:airline_section_y = ''
-- " Remove filetype
-- let g:airline_section_x = airline#section#create_right(['tagbar'])
-- " Remove git hunk info (only have branch)
-- let g:airline_section_b = airline#section#create(['branch'])
-- }}}

-- so deoplete can do completions
-- let g:jedi#completions_enabled = 0

-- Snippet configuration {{{
-- key mappings
-- imap <C-j>     <Plug>(neosnippet_expand_or_jump)
-- smap <C-j>     <Plug>(neosnippet_expand_or_jump)
-- xmap <C-j>     <Plug>(neosnippet_expand_target)

-- SuperTab like snippets behavior.
-- imap <expr><TAB>
 -- \ pumvisible() ? "\<C-n>" :
 -- \ neosnippet#expandable_or_jumpable() ?
 -- \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
-- smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
-- \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

-- -- Enable snipMate compatibility feature.
-- let g:neosnippet#enable_snipmate_compatibility = 1
-- let g:neosnippet#enable_completed_snippet = 1

-- -- Tell Neosnippet about the other snippets
-- let g:neosnippet#snippets_directory='~/.nvim/snippets/opstarts'
-- }}}

-- javascript {{{
-- Automatically start for language servers.
-- let g:LanguageClient_autoStart = 0

-- <leader>ld to go to definition
-- autocmd FileType javascript nnoremap <buffer>
  -- \ <leader>ld :call LanguageClient_textDocument_definition()<cr>
-- <leader>lh for type info under cursor
-- autocmd FileType javascript nnoremap <buffer>
  -- \ <leader>lh :call LanguageClient_textDocument_hover()<cr>
-- -- <leader>lr to rename variable under cursor
-- autocmd FileType javascript nnoremap <buffer>
  -- \ <leader>lr :call LanguageClient_textDocument_rename()<cr>
-- -- <leader>lf to fuzzy find the symbols in the current document
-- autocmd FileType javascript nnoremap <buffer>
  -- \ <leader>lf :call LanguageClient_textDocument_documentSymbol()<cr>


-- --"" coc.nvim recommended config
-- -- Better display for messages
-- set cmdheight=2

-- -- You will have bad experience for diagnostic messages when it's default 4000.
-- set updatetime=300

-- -- don't give |ins-completion-menu| messages.
-- set shortmess+=c

-- -- GoTo code navigation.
-- nmap <silent> gd <Plug>(coc-definition)
-- nmap <silent> gy <Plug>(coc-type-definition)
-- nmap <silent> gi <Plug>(coc-implementation)
-- nmap <silent> gr <Plug>(coc-references)

-- nmap <leader>a  <Plug>(coc-codeaction-cursor)
-- -- :command Fix :call CocAction('format')

-- if has('nvim')
  -- inoremap <silent><expr> <c-space> coc#refresh()
-- else
  -- inoremap <silent><expr> <c-@> coc#refresh()
-- endif
