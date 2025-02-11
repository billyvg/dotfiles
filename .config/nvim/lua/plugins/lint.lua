local js_linters = { "biomejs", "eslint_d" }
-- only run linters if a configuration file is found for the below linters
local linter_root_markers = {
  biomejs = { "biome.json", "biome.jsonc" },
  eslint_d = {
    "eslint.config.js",
    "eslint.config.mjs",
    "eslint.config.cjs",
    "eslint.config.ts",
    "eslint.config.mts",
    "eslint.config.cts",
    -- deprecated
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json",
  },
}

return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        typescript = js_linters,
        javascript = js_linters,
        typescriptreact = js_linters,
        javascriptreact = js_linters,
      },
    },
    config = function(_, opts)
      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          local lint = require("lint")

          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.opt_local.modifiable:get() then
            local names = opts.linters_by_ft[vim.bo.filetype]

            if names then
              for _, name in pairs(names) do
                local next = next

                -- use vim.fs.find to look for a config file in *any* parent directories
                if
                  linter_root_markers[name] == nil or next(vim.fs.find(linter_root_markers[name], { upward = true }))
                then
                  lint.try_lint(name)
                end
              end
            end
          end
        end,
      })
    end,
  },
}
