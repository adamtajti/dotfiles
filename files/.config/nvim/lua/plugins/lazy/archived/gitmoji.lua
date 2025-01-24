-- Archived: This only works with hrsh7th/nvim-cmp at the minute.
-- It needs blink support
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
