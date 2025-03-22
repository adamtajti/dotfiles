return {
  "adamtajti/clickup.nvim",
  dependencies = {},
  build = {
    "rockspec",
    "build.lua",
  },
  enabled = true,
  dev = true,
  event = "VeryLazy",
  opts = {},
  cmd = { "ClickUp" },
  keys = {
    {
      "<leader>C",
      function() vim.cmd([[ClickUp]]) end,
      desc = "ClickUp UI",
      noremap = true,
    },
  },
}
