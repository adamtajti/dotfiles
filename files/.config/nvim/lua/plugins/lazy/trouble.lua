-- trouble provides a window with the workspace wide diagnostic errors
return {
  "folke/trouble.nvim",
  cmd = { "Trouble" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    -- A potential improvement could be installing this plugin and setting up a keymap to
    -- request/list all the diagnostics for the entire workspace. The plugin uses git
    -- to list files and send each of them to the LSP. It isn't the most elegant solution
    -- to the problem, but it may work out. I wasn't able to solve it with an LSP config
    -- change.
    --
    -- https://github.com/artemave/workspace-diagnostics.nvim
  },
  keys = {
    {
      "<Leader>ldt",
      function()
        ---@diagnostic disable-next-line: missing-fields all(?) fields are reported as required
        require("trouble").toggle({
          mode = "diagnostics",
        })
      end,
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
