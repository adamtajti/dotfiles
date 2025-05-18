-- This plugin is required by all the others lsp-* plugins
-- This runs before lua/lsp.lua
---@type LazyPluginSpec
return {
  "neovim/nvim-lspconfig",
  lazy = false,
}
