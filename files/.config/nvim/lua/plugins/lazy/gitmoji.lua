return {
  "Dynge/gitmoji.nvim",
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  opts = {
    filetypes = { "NeogitCommitMessage" },
    completion = {
      append_space = false,
      complete_as = "emoji",
    },
  },
  ft = {
    "NeogitCommitMessage",
  },
}
