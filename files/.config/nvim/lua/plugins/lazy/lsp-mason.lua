-- mason.nvim is a Neovim plugin that allows you to easily manage external
-- editor tooling such as LSP servers, DAP servers, linters, and formatters
-- through a single interface. It runs everywhere Neovim runs (across Linux,
-- macOS, Windows, etc.), with only a small set of external requirements needed.
--
-- Although many packages are perfectly usable out of the box through Neovim
-- builtins, it is recommended to use other 3rd party plugins to further
-- integrate these. The following plugins are recommended:
--
--  LSP: lspconfig & mason-lspconfig.nvim
--  DAP: nvim-dap & nvim-dap-ui
--  Linters: null-ls.nvim or nvim-lint
--  Formatters: null-ls.nvim or formatter.nvim

return {
  "williamboman/mason.nvim",
  event = "VeryLazy",
  opts = {
    log_level = vim.log.levels.DEBUG, -- [..., TRACE]
    registries = {
      "github:mason-org/mason-registry",
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)

    require("mason-tool-installer")
  end,
}
