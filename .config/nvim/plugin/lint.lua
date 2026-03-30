local js_linters = { "eslint_d" }

local linter_root_markers = {
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

local linters_by_ft = {
  typescript = js_linters,
  javascript = js_linters,
  typescriptreact = js_linters,
  javascriptreact = js_linters,
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    local lint = require("lint")

    if vim.opt_local.modifiable:get() then
      local names = linters_by_ft[vim.bo.filetype]

      if names ~= nil then
        for _, name in pairs(names) do
          local next = next

          if linter_root_markers[name] == nil or next(vim.fs.find(linter_root_markers[name], { upward = true })) then
            lint.try_lint(name)
          end
        end
      end
    end
  end,
})
