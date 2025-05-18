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

---@type LazyPluginSpec
return {
  "mason-org/mason.nvim",
  -- `mason.nvim` is optimized to load as little as possible during setup.
  -- Lazy-loading the plugin, or somehow deferring the setup, is not recommended.
  -- https://github.com/mason-org/mason.nvim
  lazy = false,
  opts = {
    log_level = vim.log.levels.DEBUG, -- [..., TRACE]
    registries = {
      "github:mason-org/mason-registry",
    },
  },
  cmd = {
    "Mason",
    "MasonInstall",
    "MasonUninstall",
    "MasonUninstallAll",
    "MasonUpdate",
    "MasonLog",
  },
}
