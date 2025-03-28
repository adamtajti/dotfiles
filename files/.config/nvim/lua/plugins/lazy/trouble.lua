-- trouble provides a window with the workspace wide diagnostic errors
return {
  "folke/trouble.nvim",
  cmd = { "TroubleToggle", "Trouble" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<Leader>ldt",
      function() require("trouble").toggle({ mode = "diagnostics" }) end,
      noremap = true,
      desc = "View Diagnostics Pane (aka: Trouble)",
    },
  },
  opts = {
    height = 15,
    padding = false,
    auto_close = false,
  },
}
