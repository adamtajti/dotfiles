-- Archived because Spectre doesn't suppoer multiline replaces
-- https://github.com/nvim-pack/nvim-spectre/issues/20
return {
  "nvim-pack/nvim-spectre",
  cmd = { "Spectre" },
  config = true,
  keys = {
    {
      "<Leader>s",
      function() require("spectre").open() end,
      desc = "Spectre (Search and Replace)",
      noremap = true,
    },
  },
}
