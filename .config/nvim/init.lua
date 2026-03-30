require("core.globals")
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  spec = {
    -- import your plugins
    { import = "plugins" },
  },

  -- I don't need luarocks
  rocks = { enabled = false },

  -- automatically check for plugin updates
  checker = { enabled = false },

  -- automatically check for config file changes and reload the ui
  change_detection = {
    enabled = true,
    notify = false, -- get a notification when changes are found
  },
  dev = {
    ---@type string | fun(plugin: LazyPlugin): string directory where you store your local plugin projects
    path = "~/code",
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = {}, -- For example {"folke"}
    fallback = false, -- Fallback to git when local plugin doesn't exist
  },
})

-- Native Neovim 0.11 LSP setup
vim.lsp.config("*", {
  root_markers = { ".git" },
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP keybindings",
  callback = function(event)
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
    end

    map("n", "K", vim.lsp.buf.hover, "LSP hover info")
    map("n", "gd", vim.lsp.buf.definition, "LSP go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "LSP go to declaration")
    map("n", "go", vim.lsp.buf.type_definition, "LSP go to type definition")
    map("n", "gi", vim.lsp.buf.implementation, "LSP go to implementation")
    map("n", "gr", vim.lsp.buf.references, "LSP list references")
    map("n", "gs", vim.lsp.buf.signature_help, "LSP signature help")
    map("n", "gn", vim.lsp.buf.rename, "LSP rename")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
    map("n", "[g", vim.diagnostic.goto_prev, "Go to previous diagnostic")
    map("n", "g]", vim.diagnostic.goto_next, "Go to next diagnostic")
    map({ "n", "x" }, "<F3>", function()
      vim.lsp.buf.format({ async = true })
    end, "LSP format")
  end,
})

vim.lsp.enable({
  "bashls",
  "biome",
  "cssls",
  "dockerls",
  "html",
  "jsonls",
  "lua_ls",
  "basedpyright",
  "sourcekit",
  "stylelint_lsp",
  "ts_ls",
  "vimls",
  "yamlls",
})
