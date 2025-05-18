-- Gaps the bridge between mason and lspconfig
---@type LazyPluginSpec
return {
  "mason-org/mason-lspconfig.nvim",
  lazy = false,
  config = function()
    require("mason")
    require("mason-lspconfig").setup({
      automatic_enable = {
        exclude = {
          "ts_ls",
          "vtsls",
        },
      },
    })
  end,
}
