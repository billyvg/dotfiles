return {
  -- Commenter
  {
    "terrortylor/nvim-comment",
    main = "nvim_comment",
    cmd = { "CommentToggle" },
    keys = {
      { "<leader>/", "<cmd>CommentToggle<cr>", mode = { "n" }, silent = true },
      { "<leader>/", ":'<,'>CommentToggle<CR>", mode = { "v" }, silent = true },
    },
    config = true,
  },

  -- surround
  -- use 'tpope/vim-surround'
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },

  -- Quick fix
  -- { "kevinhwang91/nvim-bqf", ft = "qf" },

  -- Trouble (diagnostics)
  -- https://github.com/folke/trouble.nvim
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons", opts = {} },
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
    },
  },

  -- rename current file
  -- :Rename[!] {newname}
  {
    "danro/rename.vim",
    cmd = { "Rename" },
  },

  -- shows colors for color hex codes
  {
    "norcalli/nvim-colorizer.lua",
    opts = {},
  },

  -- Autoclose
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string" }, -- it will not add a pair on that treesitter node
        javascript = { "template_string" },
      },

      -- Before        Input         After
      -- ------------------------------------
      -- (  |))         (            (  (|))
      enable_check_bracket_line = true,

      -- Before        Input         After
      -- ------------------------------------
      -- |foobar        (            (|foobar
      -- |.foobar       (            (|.foobar
      ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
    },
  },

  -- Directory viewer
  -- {
  -- 	"nvim-tree/nvim-tree.lua",
  -- 	dependencies = { "nvim-tree/nvim-web-devicons" },
  -- 	cmd = { "NvimTreeToggle" },
  -- 	keys = {
  -- 		{ "<leader>e", ":NvimTreeToggle<cr>", desc = "Directory tree toggle" },
  -- 	},
  -- 	opts = {},
  -- },

  -- WhichKey (https://github.com/folke/which-key.nvim)
  -- helps you remember your Neovim keymaps, by showing available keybindings in a popup as you type.
  -- {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },

  -- Flash enhances the built-in search functionality by showing labels
  -- at the end of each match, letting you quickly jump to a specific
  -- location.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- search/replace in multiple files
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },

  -- SyntaxAttr
  -- shows SyntaxAttr highlighting attributes of char under cursor
  -- {
  -- 	"vim-scripts/SyntaxAttr.vim",
  -- 	config = function()
  -- 		vim.keymap.set("n", "<leader>a", ":call SyntaxAttr()<CR>")
  -- 	end,
  -- },
}
