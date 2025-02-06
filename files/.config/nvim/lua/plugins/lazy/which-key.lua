return {
  "folke/which-key.nvim",
  dependencies = {
    "echasnovski/mini.icons",
    "nvim-tree/nvim-web-devicons",
  },
  event = "VeryLazy",
  opts = function()
    local wk = require("which-key")
    wk.setup({
      preset = "helix",
      notify = false,
      -- disable = {
      -- 	ft = {
      -- 		"oil",
      -- 	},
      -- 	bt = {
      -- 		"oil",
      -- 	}
      -- },
      sort = { "local", "order", "group", "desc", "alphanum", "mod" },
      plugins = {
        marks = true,
        registers = true,
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          y = true,
          g = true,
        },
      },
      layout = {
        height = { min = 10, max = 75 },
      },
      icons = {
        group = "",
      },
    })

    wk.add({
      mode = { "n" }, -- normal mode

      -- DAP
      { "<leader>d", group = "Debug" },

      -- Snippet Management
      { "<leader>S", group = "Snippets" },

      -- Oil
      { "<leader>o", group = "Oil" },

      -- Telescope Commands
      { "<leader>t", group = "Telescope" },

      -- Home Scoped Commands
      { "<leader>h", group = "@Home" },

      -- CWD Scoped Commands
      { "<leader>c", group = "@CWD" },
      { "<leader>cs", group = "Search" },

      -- Git Scoped Commands
      { "<leader>g", group = "@Git" },
      { "<leader>gh", group = "Hunks" },
      { "<leader>gs", group = "Search" },

      -- Notebook Scoped Commands
      { "<leader>n", group = "@Notebook" },
      { "<leader>ns", group = "Search" },

      -- Buffer Scoped Commands
      { "<leader>b", group = "@Buffer" },
      { "<leader>bg", group = "Git" },
      { "<leader>bP", group = "Plenary (plugin development)" },
      { "<leader>b.", group = "Filetype specific" },
      { "<leader>bp", group = "+Path" },
      { "<leader>bb", group = "+Bufferize" },

      -- Personal Commands
      { "<leader>p", group = "@Personal" },
      { "<leader>pD", group = "Dotfiles" },

      -- Language related functionalities (LSP, Actions, Testing)
      { "<leader>l", group = "Language" },
      { "<leader>lr", group = "Refactor" },
      { "<leader>lg", group = "Generate" },
      { "<leader>ld", group = "Diagnostics" },
    })

    wk.add({
      mode = { "x" }, -- visual mode
      { "<leader>r", group = "Refactor" },
      { "<leader>S", group = "Snippets" },
      { "<leader>g", group = "Git Scope" },
    })
  end,
}
