return {
  "MisanthropicBit/winmove.nvim",
  config = function()
    require("winmove").configure({
      keymaps = {
        help = "?", -- Open floating window with help for the current mode
        help_close = "<esc>", -- Close the floating help window
        quit = "<esc>", -- Quit current mode
        toggle_mode = "<tab>", -- Toggle between modes when in a mode
      },
    })
  end,
  keys = {
    -- Winshift does this better
    -- {
    --   "<C-w>m",
    --   function() require("winmove").start_mode("move") end,
    --   desc = "Move",
    -- },
    {
      "<C-w>r",
      function() require("winmove").start_mode("resize") end,
      desc = "Resize",
    },
  },
}
