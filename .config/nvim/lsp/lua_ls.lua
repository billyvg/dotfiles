-- lazydev.nvim handles workspace library automatically
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
  settings = {
    Lua = {
      telemetry = { enable = false },
    },
  },
}
