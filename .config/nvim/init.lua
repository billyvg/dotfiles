vim.loader.enable()

require("core.globals")
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Build hooks (must be BEFORE vim.pack.add)
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
    if name == "catppuccin" and (kind == "install" or kind == "update") then
      if not ev.data.active then
        vim.cmd.packadd("catppuccin")
      end
      vim.cmd("CatppuccinCompile")
    end
    if name == "blink.cmp" and (kind == "install" or kind == "update") then
      vim.notify("Building blink.cmp", vim.log.levels.INFO)
      local obj = vim.system({ "cargo", "build", "--release" }, { cwd = ev.data.path }):wait()
      if obj.code == 0 then
        vim.notify("Building blink.cmp done", vim.log.levels.INFO)
      else
        vim.notify("Building blink.cmp failed", vim.log.levels.ERROR)
      end
    end
  end,
})

-- Install and load ALL plugins (single call = robust bootstrapping)
vim.pack.add({
  -- Dependencies first
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/rafamadriz/friendly-snippets",

  -- Colorscheme
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },

  -- Completion
  "https://github.com/saghen/blink.cmp",

  -- Treesitter
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",

  -- LSP tooling
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",

  -- UI
  "https://github.com/folke/snacks.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/folke/trouble.nvim",

  -- Editing
  "https://github.com/terrortylor/nvim-comment",
  "https://github.com/kylechui/nvim-surround",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/folke/flash.nvim",
  "https://github.com/MagicDuck/grug-far.nvim",
  "https://github.com/danro/rename.vim",

  -- Formatting & Linting
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/mfussenegger/nvim-lint",

  -- Git
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/mistweaverco/diffconflicts.nvim",

  -- Fuzzy finding
  "https://github.com/ibhagwan/fzf-lua",

  -- Utilities
  { src = "https://github.com/catgoose/nvim-colorizer.lua", name = "nvim-colorizer.lua" },
  "https://github.com/folke/persistence.nvim",
  "https://github.com/folke/lazydev.nvim",

  -- Tmux
  "https://github.com/christoomey/vim-tmux-navigator",
  "https://github.com/tmux-plugins/vim-tmux",
})
