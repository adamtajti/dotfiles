--- Extensible UI for Neovim notifications and LSP progress messages.
--- https://github.com/j-hui/fidget.nvim
return {
  "j-hui/fidget.nvim",
  enabled = true,
  event = "VeryLazy",
  opts = {
    progress = {
      suppress_on_insert = false,
      display = {
        render_limit = 1,
      },
    },
    notification = {
      poll_rate = 20,
      window = {
        winblend = 0,
        y_padding = 1,
      },
    },
  },
}
