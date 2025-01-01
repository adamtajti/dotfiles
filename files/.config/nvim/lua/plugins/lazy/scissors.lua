return {
  "chrisgrieser/nvim-scissors",
  dependencies = "nvim-telescope/telescope.nvim",
  opts = {
    snippetDir = vim.fn.expand("$HOME/.local/snippets"),
  },
}
