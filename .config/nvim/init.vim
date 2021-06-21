set modelines=1

if has('nvim')
  " let s:editor_root=expand("~/.nvim")
  " set notermguicolors
  set termguicolors
  " Plug 'billyvg/node-host', { 'do': 'npm install' }
  " tnoremap <Esc> <C-\><C-n>
  tnoremap <C-w> <C-\><C-n><C-w>
  tnoremap <C-l> <C-\><C-n><C-w><C-l>
  tnoremap <C-h> <C-\><C-n><C-w><C-h>
  tnoremap <C-k> <C-\><C-n><C-w><C-k>
  tnoremap <C-j> <C-\><C-n><C-w><C-j>

  " Always enter insert mode when entering into a terminal buffer
  autocmd BufWinEnter,WinEnter term://*zsh startinsert

  aug fzf_setup
    au!
    au TermOpen term://*FZF tnoremap <silent> <buffer><nowait> <esc> <c-c>
  aug END
else
    let s:editor_root=expand("~/.vim")
endif

if &compatible
  set nocompatible
endif

" Plugins {{{

" Automatically install and run if not found
if has('nvim')
  if empty(glob(expand('<sfile>:p:h') . '/autoload/plug.vim'))
    echo 'empty'
    exec '!curl -fLo ' . expand('<sfile>:p:h') . '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    augroup vimPlug
      autocmd!
      autocmd VimEnter * PlugInstall | source $MYVIMRC
    augroup END
  endif
endif

call plug#begin()
" fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Directory viewer
" Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
" Plug 'justinmk/vim-dirvish'

Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'bling/vim-airline'

" Tree sitter
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

" Tree sitter Playground
" https://github.com/nvim-treesitter/playground
" Plug 'nvim-treesitter/playground'

" https://github.com/nvim-treesitter/nvim-treesitter-refactor
" Plug 'nvim-treesitter/nvim-treesitter-refactor'

" Custom text objects using treesitter
" https://github.com/nvim-treesitter/nvim-treesitter-textobjects
" Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" rainbow brackets
" https://github.com/p00f/nvim-ts-rainbow
" Plug 'p00f/nvim-ts-rainbow'



" renames current file
" :rename[!] {newname}
Plug 'danro/rename.vim'

" tmux integrations
" allows us to use vim hotkeys to move into tmux panes
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux-focus-events'
" for editing .tmux.conf
Plug 'tmux-plugins/vim-tmux'

" linter
Plug 'dense-analysis/ale'

" vim test runner
" Plug 'janko-m/vim-test'

" git helpers {{{
Plug 'tpope/vim-fugitive'
" to support :Gbrowse for github
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/conflict-marker.vim'
" for opening in github
Plug 'k0kubun/vim-open-github'
" }}}

" indent/whitespace {{{
" Plug 'Yggdroot/indentLine'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'bronson/vim-trailing-whitespace'
" }}}

" snippets {{{
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
" }}}

" auto close symbols {{{
" Plug 'jiangmiao/auto-pairs'
" Plug 'Raimondi/delimitMate'
" Plug 'Shougo/neopairs.vim'
" }}}

" Auto close html tags (and jsx) {{{
" Plug 'alvan/vim-closetag'
" }}}

" Language-related
" Python
" Plug 'davidhalter/jedi-vim'
" " Plug 'zchee/deoplete-jedi'

" " Plug 'billyvg/tigris.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" " Plug 'autozimu/LanguageClient-neovim', {
    " " \ 'branch': 'next',
    " " \ 'do': 'bash install.sh',
    " \ }
 Plug 'pangloss/vim-javascript'
" " Plug 'mxw/vim-jsx'
 Plug 'maxmellon/vim-jsx-pretty'
Plug 'jxnblk/vim-mdx-js'
" " Plug 'flowtype/vim-flow'
" " Plug 'wokalski/autocomplete-flow'
" Plug 'Galooshi/vim-import-js', { 'do': 'npm install -g import-js' }


" " Plug 'othree/javascript-libraries-syntax.vim'
" " Plug 'moll/vim-node'
" Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
" " Plug 'wavded/vim-stylus'
" "Plug 'leafgarland/typescript-vim'
" " see https://github.com/leafgarland/typescript-vim/issues/184
" " hi link typescriptReserved Keyword
" let g:typescript_indent_disable = 1

" " Plug 'peitalin/vim-jsx-typescript'

let g:vim_jsx_pretty_colorful_config = 1 " default 0

" " Plug 'gerw/vim-HiLinkTrace'
" " Plug 'Chiel92/vim-autoformat'

Plug 'norcalli/nvim-colorizer.lua'

" Plug 'elzr/vim-json'

" " theme
" " Plug 'crusoexia/vim-monokai'
Plug 'patstockwell/vim-monokai-tasty'

" " shows SyntaxAttrx highlighting attributes of char under cursor
" Plug 'vim-scripts/SyntaxAttr.vim'
call plug#end()
" }}}

" Colors/theme {{{
" Needs to be set after plugin
set background=dark
" let g:monokai_term_italic = 1
" let g:monokai_gui_italic = 1
" colorscheme monokai
let g:vim_monokai_tasty_italic = 1
let g:airline_theme='monokai_tasty'
hi CursorLine ctermbg=186
colorscheme vim-monokai-tasty
" highlight current line (monokai-tasty)

set t_Co=256 "256 colors
" }}}

" persistent undo
set undodir=~/.config/nvim/undodir
set undofile

let mapleader = "\<Space>"

set tabstop=2
set sts=2
set sw=2
set expandtab
set nowrap
set cc=120
set mouse=a
set cursorline

filetype plugin indent on
syntax on

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

if has('nvim')
  " dev
  noremap <leader>1 :source ~/.nvimdev.vim<CR>
  " dev
  noremap <leader>ur :UpdateRemotePlugins<CR>:qall!<CR>
  " noremap <leader>2 :NasteeToggle<CR>
  " source ~/.nvimdev.vim
endif

" Key mappings
" deoplete tab-complete
" inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" coc.nvim tab-complete
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" enter to confirm delete
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"


nnoremap <C-p> :FZF<CR>
nnoremap <leader>n :CHADopen<CR>
nnoremap <leader>/ :call NERDComment(0, "toggle")<CR>
vnoremap <leader>/ :call NERDComment(0, "toggle")<CR>
nnoremap <leader>es :execute ":split " . g:neosnippet#snippets_directory

nnoremap <leader>a :call SyntaxAttr()<CR>

nnoremap <leader>ev :split $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
" nnoremap <leader>l :Denite<CR>
" nnoremap <leader>ll :Denite location_list<CR>
nnoremap <leader>\ :vsplit<CR>
nnoremap <leader>- :split<CR>
nnoremap <leader>c :Gvdiff<CR>
nnoremap <leader>< :diffget //2<CR>:diffupdate<CR>]c<CR>
nnoremap <leader>> :diffget //3<CR>:diffupdate<CR>]c<CR>
" nnoremap <leader>i :ImportJSWord<CR>
nnoremap <silent> <D-s> :<C-u>Update<CR>
inoremap <D-s> <c-o>:Update<CR><CR>
inoremap <M-s> <c-o>:Update<CR><CR>
vnoremap <D-c>c "+y
" vnoremap <M-c>c "+y

" insert current dir path in command line
cnoremap <expr> <C-P> getcmdline()[getcmdpos()-2] ==# ' ' ? expand('%:p:h') : "\<C-P>"

" fzf
nnoremap <leader>f :Rg<CR>

" no EX mode accidents
nnoremap Q <nop>

" vnoremap <esc> <nop>
" inoremap <esc> <nop>
" vnoremap jk <esc>
" inoremap jk <esc>
noremap <leader>m :messages<CR>

" filetypes
autocmd BufNewFile,BufRead,BufEnter *.jsx,*.tsx,*.ts set filetype=typescript.tsx
autocmd BufRead,BufEnter .babelrc set filetype=json
autocmd BufRead,BufEnter .eslintrc set filetype=json


if exists('&inccommand')
  set inccommand=split
endif

" prettier
nnoremap gp :ALEFix<cr>

" disable netrw in favor of dirvish
let g:loaded_netrwPlugin = 1
command! -nargs=? -complete=dir Explore | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>

" airline config {{{
" Remove file encoding type
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 0

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_powerline_fonts = 1

let g:airline_section_y = ''
" Remove filetype
let g:airline_section_x = airline#section#create_right(['tagbar'])
" Remove git hunk info (only have branch)
let g:airline_section_b = airline#section#create(['branch'])
" }}}

" so deoplete can do completions
let g:jedi#completions_enabled = 0

" Deoplete (autocomplete menu) {{{
if has('nvim')
  " call deoplete#enable_logging('DEBUG', '/tmp/deoplete.log')

  let g:deoplete#enable_at_startup = 1
  " Autocomplete for including files should be relative to buffer path, not project path
  let g:deoplete#file#enable_buffer_path = 1

  " attempt to trigger deoplete immediately
  " let g:deoplete#complete_method = "omnifunc"
  let g:deoplete#auto_complete_delay = 0
  let g:deoplete#enable_profile = 1

  if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
  endif

  " Ignore buffer sources
  let g:deoplete#ignore_sources = get(g:,'deoplete#ignore_sources',{})
  " let g:deoplete#ignore_sources.javascript = ['buffer']
  " let g:deoplete#ignore_sources['javascript.jsx'] = ['buffer']

  " let g:deoplete#disable_auto_complete = 1
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
endif
" }}}

" Omnifuncs {{{
augroup omnifuncs
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup end
" }}}

" fzf - fuzzy file finder {{{
let $FZF_DEFAULT_COMMAND= 'rg --files --hidden --follow ' .
      \ '-g "!.git/*" '.
      \ '-g "!south_migrations" '.
      \ '-g "!src/sentry/south" '.
      \ '-g "!CHANGES" '.
      \ '-g "!vendor" '.
      \ '-g "!tests/fixtures/integration-docs/*" '.
      \ '-g "!static/dist" ' .
      \ '-g "!static/vendor" ' .
      \ '-g "!src/sentry/static/sentry" '

let $FZF_DEFAULT_OPTS='--layout=reverse'

" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
" \   '-g "src/sentry/**/*.py" ' .
set grepprg=rg\ --vimgrep
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --hidden --line-number --no-heading --follow --color never ' .
  \   '-g "!.git" '.
  \   '-g "!.git-blame-ignore-revs" '.
  \   '-g "!static/dist/**/*" '.
  \   '-g "!bin/yarn" '.
  \   '-g "!CHANGES" '.
  \   '-g "!stats.json" ' .
  \   '-g "!static/images/*" ' .
  \   '-g "!static/images/**/*" ' .
  \   '-g "!static/app/icons/*" ' .
  \   '-g "!static/less/debugger*" ' .
  \   '-g "!static/vendor/*" ' .
  \   '-g "!src/sentry/static/sentry/**/*" ' .
  \   '-g "!**/south_migrations/*" ' .
  \   '-g "!src/sentry/static/sentry/dist/**/*" ' .
  \   '-g "!src/sentry/static/sentry/images/*" ' .
  \   '-g "!src/sentry/static/sentry/images/**/*" ' .
  \   '-g "!src/sentry/static/sentry/app/icons/*" ' .
  \   '-g "!src/sentry/static/sentry/app/views/organizationIncidents/details/closedSymbol.jsx" ' .
  \   '-g "!src/sentry/static/sentry/app/views/organizationIncidents/details/detectedSymbol.jsx" ' .
  \   '-g "!src/sentry/static/sentry/less/debugger*" ' .
  \   '-g "!src/sentry/templates/sentry/js-sdk-loader.min.js.tmpl" ' .
  \   '-g "!src/sentry/templates/sentry/js-sdk-loader.min.js.tmpl" ' .
  \   '-g "!tests/js/**/*.snap" ' .
  \   '-g "!tests/fixtures/*" ' .
  \   '-g "!tests/fixtures/**/*" ' .
  \   '-g "!tests/*/fixtures/*" ' .
  \   '-g "!tests/**/fixtures/*" ' .
  \   '-g "!tests/**/snapshots/**/*" ' .
  \   '-g "!tests/sentry/lang/*/fixtures/*" ' .
  \   '-g "!tests/sentry/lang/**/*.map" ' .
  \   '-g "!tests/sentry/grouping/**/*" ' .
  \   '-g "!tests/sentry/db/*" ' .
  \   '-g "!tests/relay_integration/lang/javascript/example-project/*" ' .
  \   '-g "!src/sentry/locale/**/*" ' .
  \   '-g "!src/sentry/data/**/*" ' .
  \   '-g "!src/debug_toolbar/**/*" ' .
  \   shellescape(<q-args>), 1,
  \   <bang>1 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \   <bang>1)

" NERDCommenter {{{
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" }}}

" linter {{{
" let g:ale_linter_aliases = {'jsx': ['css', 'javascript']}
" let g:ale_linters = {
      " \'jsx': ['stylelint', 'eslint'],
      " \'javascript': ['eslint'],
      " \'javascript.jsx': ['eslint'],
      " \'typescript': ['eslint'],
      " \'typescript.tsx': ['eslint'],
      " \}
" let g:ale_javascript_eslint_use_global = 0 " this works more reliably
" let g:ale_fixers = {}
" let g:ale_fixers['json'] = ['prettier']
" let g:ale_fixers['javascript'] = ['eslint']
" let g:ale_fixers['javascript.jsx'] = ['eslint', 'stylelint']
" let g:ale_fixers['typescript'] = ['eslint', 'prettier']
" let g:ale_fixers['typescript.tsx'] = ['eslint']
" let g:ale_fixers['less'] = ['prettier']
" let g:ale_fixers['python'] = ['autopep8']
let g:ale_fix_on_save = 1
" let g:ale_javascript_prettier_use_local_config = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s (%code%)'
let g:ale_lint_delay = 200
let g:ale_virtualtext_cursor = 1
let g:ale_linters_explicit = 1

nmap <silent> <C-[> <Plug>(ale_previous_wrap)
nmap <silent> <C-]> <Plug>(ale_next_wrap)
" }}}

" vim test runner {{{
" let test#strategy = "neovim"
" let test#javascript#mocha#options = "tests/.setup.js --compilers js:babel-core/register"
" }}}


" git helpers {{{
" always show git gutter
set signcolumn="yes"
let g:gitgutter_realtime = 250
let g:gitgutter_eager = 100
" }}}

" Snippet configuration {{{
" key mappings
imap <C-j>     <Plug>(neosnippet_expand_or_jump)
smap <C-j>     <Plug>(neosnippet_expand_or_jump)
xmap <C-j>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#enable_completed_snippet = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.nvim/snippets/opstarts'
" }}}

" auto close symbols {{{
" let g:neopairs#enable = 1
" }}}

" Auto close html tags (and jsx) {{{
" let g:closetag_filenames = "*.html,*.jsx,*.js"
" }}}

" javascript {{{
let g:javascript_plugin_flow = 0 " for vim-javascript
let g:jsx_ext_required = 0
let g:vim_jsx_pretty_colorful_config = 1  " colorful jsx

" Automatically start language servers.
" let g:LanguageClient_autoStart = 0

" vim:foldmethod=marker:foldlevel=0
"
"
" set rtp+=~/Dev/ast.nvim
" set rtp+=~/Dev/tree-sitter-js.nvim

let g:python_host_prog = '/Users/billy/.pyenv/shims/python2'
let g:python3_host_prog = '/Users/billy/.pyenv/shims/python3'

" <leader>ld to go to definition
autocmd FileType javascript nnoremap <buffer>
  \ <leader>ld :call LanguageClient_textDocument_definition()<cr>
" <leader>lh for type info under cursor
autocmd FileType javascript nnoremap <buffer>
  \ <leader>lh :call LanguageClient_textDocument_hover()<cr>
" <leader>lr to rename variable under cursor
autocmd FileType javascript nnoremap <buffer>
  \ <leader>lr :call LanguageClient_textDocument_rename()<cr>
" <leader>lf to fuzzy find the symbols in the current document
autocmd FileType javascript nnoremap <buffer>
  \ <leader>lf :call LanguageClient_textDocument_documentSymbol()<cr>


""" coc.nvim recommended config
" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <leader>a  <Plug>(coc-codeaction-cursor)
" :command Fix :call CocAction('format')

if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" augroup mygroup
  " autocmd!
  " " Setup formatexpr specified filetype(s).
  " autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " " Update signature help on jump placeholder
  " autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end
"

if has('nvim')
  lua require'colorizer'.setup()

  " tree-sitter config
  " set foldmethod=expr
  " set foldexpr=nvim_treesitter#foldexpr()

  " TSHighlightCapturesUnderCursor
  " TSPlaygroundToggle

  " lua <<EOF
  " require'nvim-treesitter.configs'.setup {
    " ensure_installed = { "typescript", "javascript", "python", "html", "json", "jsdoc", "css", "bash", "yaml" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    " incremental_selection = {
      " enable = true,
      " keymaps = {
        " init_selection = "gnn",
        " node_incremental = "grn",
        " scope_incremental = "grc",
        " node_decremental = "grm",
      " },
    " },
    " indent = {
      " enable = true
    " },
    " highlight = {
      " enable = true,              -- false will disable the whole extension
    " },
    " playground = {
      " enable = true,
      " disable = {},
      " updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      " persist_queries = false -- Whether the query persists across vim sessions
    " }
  " }
" EOF

endif

nmap <Esc> <Esc>
