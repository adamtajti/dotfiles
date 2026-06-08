local avante_secure = require("avante-secure")

---@type LazyPluginSpec
return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  enabled = false,
  lazy = false,
  version = false,
  opts = {},
  config = function() avante_secure.setup() end,
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
