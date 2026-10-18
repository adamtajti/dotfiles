-- Provides the lsp/*.lua base configs (clangd, pylsp, ...) resolved by
-- vim.lsp.enable() from the after/lsp/ overrides. Was previously pulled in
-- as a dependency of the (removed) otter.nvim.
---@type LazyPluginSpec
return { "neovim/nvim-lspconfig", lazy = false }
