return {
  {
    "ibhagwan/fzf-lua",
    enabled = true,
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      -- {
      --   "<c-p>",
      --   function()
      --     require("fzf-lua").files()
      --   end,
      --   desc = "Find Files",
      -- },
      {
        "<leader>ff",
        function()
          require("fzf-lua").grep_project({
            rg_glob = true,
            -- file_ignore_patterns = {
            --   ".*/src/sentry/.*",
            --   "%.py$",
            --   "CHANGES",
            --   -- ".*/api-docs/.*",
            --   ".*/sentry/data/samples.*",
            --   "%.svg$",
            --   "api%-docs.*",
            --   "fixtures/.*",
            --   "requirements.*%.txt",
            -- },
          })
        end,
        desc = "Grep in project (ignore backend)",
      },
      {
        "<leader>fa",
        function()
          require("fzf-lua").grep_project({
            rg_glob = true,
            -- file_ignore_patterns = { "%.[p|m]o$", "trace.json" },
          })
        end,
        desc = "Grep in project",
      },
      {
        "<leader>fg",
        function()
          require("fzf-lua").grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>fl",
        function()
          require("fzf-lua").live_grep_native()
        end,
        desc = "Live grep",
      },
      {
        "<leader>fw",
        function()
          require("fzf-lua").grep_cword()
        end,
        desc = "Find current word",
      },
      {
        "<leader>sdd",
        function()
          require("fzf-lua").diagnostics_document()
        end,
        desc = "Document diagnostics",
      },
      {
        "<leader>:",
        function()
          require("fzf-lua").command_history()
        end,
        desc = "Command history",
      },
      {
        "<leader>sC",
        function()
          require("fzf-lua").commands()
        end,
        desc = "Commands",
      },
    },
    opts = {
      -- grep = {
      -- file_ignore_patterns = {
      --   "%.[p|m]o$",
      --   "%.map$",
      --   "%.sourcemap.js$",
      --   "trace.json",
      --   ".*/fixtures/integration-docs/.*",
      --   ".*/integrations/msteams/test_helpers.py",
      --   "LICENSE",
      --   ".*/src/sentry/.*",
      --   "%.py$",
      --   "CHANGES",
      --   -- ".*/api-docs/.*",
      --   ".*/sentry/data/samples.*",
      --   "%.svg$",
      --   "api%-docs.*",
      --   "fixtures/.*",
      --   "requirements.*%.txt",
      -- },
      -- },
      grep = {
        rg_opts = "--sort-files --hidden --column --line-number --no-heading "
          .. "--color=always --smart-case -g '!{.git,node_modules,api-docs,}/*' -g '!*.{mo,po,svg}' -g '!CHANGES'",
      },
    },
  },
}
