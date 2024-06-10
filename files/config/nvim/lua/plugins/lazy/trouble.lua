-- trouble provides a window with the workspace wide diagnostic errors
return {
  "folke/trouble.nvim",
  cmd = { "TroubleToggle", "Trouble" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<Leader>dt",
      function()
        require("trouble").toggle()
      end,
      noremap = true,
      desc = "View Diagnostics Pane (aka: Trouble)",
    }
  },
  opts = {
    height = 15,
    padding = false,
    auto_close = false,
  }
}
