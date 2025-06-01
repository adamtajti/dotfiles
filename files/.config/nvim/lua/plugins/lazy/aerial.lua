---@type LazyPluginSpec
return {
  "stevearc/aerial.nvim",
  event = "VeryLazy",
  opts = {},
  -- Optional dependencies
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<leader>ba",
      function()
        require("aerial").toggle({
          focus = true,
          direction = "float",
        })
      end,
      desc = "Aerial",
      noremap = true,
    },
  },
}
