-- {{{ Local aliases
local api = vim.api
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options
local env = vim.env  -- environment variables
-- }}}

-- {{{ Helper functions
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
--- }}}

-- {{{ Packer bootstrap
require('packer-bootstrap')
-- }}}

require('packer').startup({function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- {{{ Plugin: fzf
  use { 'junegunn/fzf', run = function() vim.fn['fzf#install']() end }
  use 'junegunn/fzf.vim'
  -- }}}

  -- {{{ Plugin: treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- Tree sitter Playground
  -- https://github.com/nvim-treesitter/playground
  use 'nvim-treesitter/playground'

  -- https://github.com/nvim-treesitter/nvim-treesitter-refactor
  -- use 'nvim-treesitter/nvim-treesitter-refactor'

  -- Custom text objects using treesitter
  -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  --- }}}

  -- {{{ Plugin: LSP
  use {
    'neovim/nvim-lspconfig',
  }

  -- Autocompletion
  use {
    'hrsh7th/nvim-compe',
    config = function()
      vim.o.completeopt = "menuone,noselect"
      require('compe').setup({
        enabled = true;
        autocomplete = true;
        debug = false;
        min_length = 1;
        preselect = 'enable';
        throttle_time = 80;
        source_timeout = 200;
        resolve_timeout = 800;
        incomplete_delay = 400;
        max_abbr_width = 100;
        max_kind_width = 100;
        max_menu_width = 100;
        documentation = {
          border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
          winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
          max_width = 120,
          min_width = 60,
          max_height = math.floor(vim.o.lines * 0.3),
          min_height = 1,
        };

        source = {
          path = true;
          buffer = true;
          calc = true;
          nvim_lsp = true;
          nvim_lua = true;
          vsnip = true;
          ultisnips = true;
          luasnip = true;
        };
      })
    end
  }

  -- Easier LSP installation
  use {
    'kabouzeid/nvim-lspinstall',
    config = function()
      -- {{{Plugin Configuration: LspInstall

      -- keymaps
      local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = { noremap=true, silent=true }
        -- buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        -- buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        -- buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        -- buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        -- buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        -- buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        -- buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

        -- Set some keybinds conditional on server capabilities
        -- if client.resolved_capabilities.document_formatting then
          -- buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        -- elseif client.resolved_capabilities.document_range_formatting then
          -- buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
        -- end

        -- Set autocommands conditional on server_capabilities
        if client.resolved_capabilities.document_highlight then
          vim.api.nvim_exec([[
          augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
          augroup END
          ]], false)
        end
      end

      -- Configure lua language server for neovim development
      local lua_settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT', -- LuaJIT in the case of Neovim
            path = vim.split(package.path, ';'),
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'},
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = {
              [vim.fn.expand('$VIMRUNTIME/lua')] = true,
              [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
              [vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim/lua'] = true,
            },
          },
        }
      }

      -- config that activates keymaps and enables snippet support
      local function make_config()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        return {
          -- enable snippet support
          capabilities = capabilities,
          -- map buffer local keybindings when the language server attaches
          on_attach = on_attach,
        }
      end

      local function setup_lsp_servers()
        require('lspinstall').setup()
        local my_servers = {
          "bash",  "cmake", "css", "dockerfile", "html", "json", "lua", "python", "typescript", "yaml"
        }

        local installed_servers = require('lspinstall').installed_servers()
        local installed_servers_lookup = {}

        -- Create a lookup table
        for _, server in pairs(installed_servers) do
          installed_servers_lookup[server] = true
        end


        for _, server in pairs(my_servers) do
          -- Install servers for myself if not already installed
          if not installed_servers_lookup[server] then
            print("Installing... " .. server)
            require('lspinstall').install_server(server)
          else
            local config = make_config()

            -- language specific config
            if server == "lua" then
              config.settings = lua_settings
            end
            require('lspconfig')[server].setup(config)
          end
        end
      end

      setup_lsp_servers()

      -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
      require('lspinstall').post_install_hook = function ()
        setup_lsp_servers() -- reload installed servers
        vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
      end
      -- }}}
    end
  }

  -- This tiny plugin adds vscode-like pictograms to neovim built-in LSP
  use {
    'onsails/lspkind-nvim',
    config = function()
      require('lspkind').init()
    end
  }

  -- This plugin makes the Neovim LSP client use FZF to display results and navigate the code.
  use {
    'ojroques/nvim-lspfuzzy',
    requires = {
      {'junegunn/fzf'},
      {'junegunn/fzf.vim'},  -- to enable preview (optional)
    },
    config = function()
      require('lspfuzzy').setup {}
    end
  }
  -- }}}

  -- {{{ Plugin: NERDCommenter
  use {
    'scrooloose/nerdcommenter',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>/', ':call NERDComment(0, "toggle")<CR>', {noremap = true})
      vim.api.nvim_set_keymap('v', '<leader>/', ':call NERDComment(0, "toggle")<CR>', {noremap = true})
    end
  }
  -- }}}

  use 'tpope/vim-surround'

  -- renames current file
  -- :Rename[!] {newname}
  use 'danro/rename.vim'

  -- {{{ Plugins: tmux integrations
  use 'christoomey/vim-tmux-navigator' -- allows us to use vim hotkeys to move into tmux panes
  use 'tmux-plugins/vim-tmux-focus-events'
  use 'tmux-plugins/vim-tmux' -- for editing .tmux.conf
  -- }}}


  -- {{{ Plugin: ALE
  use {
    'dense-analysis/ale',
    config = function()
      -- vim.g.ale_javascript_prettier_use_local_config = 1
      -- vim.g.ale_linter_aliases = {'jsx': ['css', 'javascript']}
      -- vim.g.ale_linters = {
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
      vim.g.ale_fix_on_save = 1
      vim.g.ale_echo_msg_error_str = 'E'
      vim.g.ale_echo_msg_warning_str = 'W'
      vim.g.ale_echo_msg_format = '[%linter%] %s (%code%)'
      vim.g.ale_lint_delay = 200
      vim.g.ale_virtualtext_cursor = 1
      vim.g.ale_linters_explicit = 1
      vim.api.nvim_set_keymap('n', '<C-[>', '<Plug>(ale_previous_wrap)', {silent = true, noremap = true})
      vim.api.nvim_set_keymap('n', '<C-]>', '<Plug>(ale_next_wrap)', {silent = true, noremap = true})
    end
  }
  --- }}}

  -- {{{ Plugins: git
  use {
    'tpope/vim-fugitive'
  }

  use {
    'tpope/vim-rhubarb', -- to support :GBrowse for github
    cmd = 'GBrowse'
  }

  use {
    'airblade/vim-gitgutter',
    config = function()
      vim.g.gitgutter_realtime = 250
      vim.g.gitgutter_eager = 100
    end
  }

  use 'rhysd/conflict-marker.vim'
  -- use 'tyru/open-browser-github.vim' -- for opening in github
  -- }}}

  -- {{{ Plugins: Formatting / whitespace
  use 'bronson/vim-trailing-whitespace'
  use "lukas-reineke/indent-blankline.nvim"
  -- }}}

  -- shows colors for color hex codes
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end
  }

  -- {{{ Plugin: Colorscheme
  use {
    'sainnhe/sonokai',
    config = function()
      vim.cmd('syntax on')
      -- vim.g.sonokai_style = 'andromeda'
      vim.g.sonokai_enable_italic = 1
      -- vim.g.sonokai_disable_italic_comment = 1
      vim.cmd('colorscheme sonokai')
    end
  }

  -- use 'crusoexia/vim-monokai'
  -- use {
    -- 'tanvirtin/monokai.nvim',
    -- config = function()
      -- vim.cmd('syntax on')
      -- vim.cmd('colorscheme monokai')
    -- end
  -- }
  -- use {
    -- 'patstockwell/vim-monokai-tasty',
    -- disable = true,
    -- config = function()
      -- vim.g.vim_monokai_tasty_italic = 1
      -- -- vim.cmd('colorscheme monokai')
    -- end
  -- }
  -- }}}

  -- {{{ Plugin: Snippets
  -- use 'Shougo/neosnippet.vim'
  -- use 'Shougo/neosnippet-snippets'
  -- }}}

  -- {{{ Plugin: Indent blanklines
  -- This plugin adds indentation guides to all lines (including empty lines).
  -- }}}

  -- {{{ Plugin: Autoclose
  -- use 'jiangmiao/auto-pairs'
  -- use 'Raimondi/delimitMate'
  -- use 'Shougo/neopairs.vim'
  -- use 'alvan/vim-closetag'
  -- }}}

  -- {{{ Plugin: Directory viewer
    use {
      'kyazdani42/nvim-tree.lua',
      requires = {'kyazdani42/nvim-web-devicons'},
      cmd = 'NvimTreeToggle',
      setup = function()
        vim.api.nvim_set_keymap('n', '<leader>n', ':NvimTreeToggle<CR>', {noremap = true})
      end
    }
  -- }}}

  -- {{{ Plugin: Statusline
    use {
      'glepnir/galaxyline.nvim',
      branch = 'main',
      -- your statusline
      config = function() require('statusline') end,
      -- some optional icons
      requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }
  -- }}}

  -- {{{ Plugin: SyntaxAttr
  -- shows SyntaxAttr highlighting attributes of char under cursor
  use {
    'vim-scripts/SyntaxAttr.vim',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>a', ':call SyntaxAttr()<CR>', {noremap = true})
    end
  }
  -- }}}

  -- Language-related
  -- {{{ Language: Javascript
    use 'jxnblk/vim-mdx-js'
  -- }}}


  -- {{{ Once upon a time plugins
  -- use 'neoclide/coc.nvim', {'branch': 'release'}
  --
  -- rainbow brackets
  -- https://github.com/p00f/nvim-ts-rainbow
  -- use 'p00f/nvim-ts-rainbow'

  -- vim test runner
  -- use 'janko-m/vim-test'
  --
  -- {{{ Language: Python
  -- use 'davidhalter/jedi-vim'
  -- use 'zchee/deoplete-jedi'
  -- }}}
  --
  -- use 'pangloss/vim-javascript'
  -- use 'mxw/vim-jsx'
  -- use {
    -- 'maxmellon/vim-jsx-pretty',
    -- config = function()
      -- vim.g.vim_jsx_pretty_colorful_config = 1
    -- end
  -- }
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
  -- }}}
end,
config = {
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'single' })
    end
  }
}})



-- {{{ Editor Options
g.mapleader = ' '
opt.modelines = 1
if fn.has('termguicolors') then
  opt.termguicolors = true              -- True color support
end
opt.background = "dark"                 -- Dark background
opt.undodir = '.undodir'                -- Persistent undo
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
opt.foldmethod = "marker"

-- {{{ Conceal markers
if fn.has('conceal') then
  opt.conceallevel = 2
  opt.concealcursor = "niv"
end
-- }}}
--
if fn.exists('&inccommand') then
  opt.inccommand = "split"
end

-- }}}

cmd 'hi CursorLine ctermbg=186'
-- Needs to be set after plugin
-- g.monokai_term_italic = 1
-- g.monokai_gui_italic = 1
-- cmd 'colorscheme monokai'
-- set t_Co=256 --256 colors


-- {{{ Key Mappings
-- <Tab> to navigate the completion menu
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})

map('i', '<cr>', 'pumvisible() ? "\\<C-y>" : "\\<C-g>u\\<CR>"', {expr = true}) -- enter to confirm delete


map('n', '<C-p>', ':FZF<CR>')
map('n', '<leader>f', ':Rg<CR>')
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


-- {{{ Terminal keymapping
-- map('t', '<Esc>', '<C-\\><C-n>')
map('t', '<C-w>', '<C-\\><C-n><C-w>')
map('t', '<C-l>', '<C-\\><C-n><C-w><C-l>')
map('t', '<C-h>', '<C-\\><C-n><C-w><C-h>')
map('t', '<C-k>', '<C-\\><C-n><C-w><C-k>')
map('t', '<C-j>', '<C-\\><C-n><C-w><C-j>')
-- }}}

-- }}}

require('colorizer').setup()

-- {{{ Treesitter configuration
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'dockerfile',
    'html',
    'json',
    'python',
    'yaml',
    'comment',
    'jsdoc',
    'javascript',
    'graphql',
    'regex',
    'scss',
    'lua',
    'typescript',
    'tsx',
    'bash',
    'cmake',
    'css',
  },
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  }
})
-- }}}

-- {{{ NerdCommenter
-- Add spaces after comment delimiters by default
g.NERDSpaceDelims = 1
-- }}}

-- Some FZF Configuration
opt.grepprg = "rg --vimgrep"
vim.env['FZF_DEFAULT_COMMAND'] = 'rg --files --hidden --follow -g "!.git/*" -g "!south_migrations" -g "!src/sentry/south" -g "!CHANGES" -g "!vendor" -g "!tests/fixtures/integration-docs/*" -g "!static/dist" -g "!static/vendor" -g "!src/sentry/static/sentry"'
vim.env['FZF_DEFAULT_OPTS'] = '--layout=reverse'

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

-- {{{ Javascript plugin settings
g.javascript_plugin_flow = 0 -- disable flow for vim-javascript
g.jsx_ext_required = 0
-- }}}

nvim_create_augroups(augroups)


-- {{{ Old
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
-- }}}
