return {
  "chrisgrieser/nvim-scissors",
  enabled = false,
  dependencies = "nvim-telescope/telescope.nvim",
  event = "VeryLazy",
  opts = {
    snippetDir = vim.fn.expand("$HOME/.config/nvim/snippets/"),
  },
}
