return {
  "danymat/neogen",
  event = "VeryLazy",
  config = true,
  opts = {
    snippet_engine = "luasnip",
  },
  keys = {
    {
      "<Leader>lga",
      function() require("neogen").generate() end,
      desc = "Annotation or Documentation",
      noremap = true,
    },
  },
}
