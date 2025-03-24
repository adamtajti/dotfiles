return {
  "danymat/neogen",
  event = "VeryLazy",
  config = true,
  opts = {
    snippet_engine = "nvim",
  },
  keys = {
    {
      "<Leader>lga",
      function() require("neogen").generate() end,
      desc = "Documentation: Auto",
      noremap = true,
    },
  },
}
