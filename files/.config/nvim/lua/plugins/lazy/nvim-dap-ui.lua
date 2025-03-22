-- DAP UI
return {
  "rcarriga/nvim-dap-ui",
  -- event = "VeryLazy",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
  },
  enabled = true,
  opts = {
    floating = {
      border = "single",
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    -- Layouts are opened in the order defined {floating} `(dapui.Config.floating)` Floating window specific options
    layouts = {
      -- Toggle Clean
      {
        position = "left",
        size = 40,
        elements = {
          {
            id = "scopes",
            size = 0.5,
          },
          {
            id = "stacks",
            size = 0.5,
          },
        },
      },
      -- Toggle REPL
      {
        position = "bottom",
        size = 7,
        elements = {
          {
            id = "repl",
            size = 1,
          },
        },
      },
      -- Default Layout
      {
        elements = {
          {
            id = "scopes",
            size = 0.25,
          },
          {
            id = "breakpoints",
            size = 0.25,
          },
          {
            id = "stacks",
            size = 0.25,
          },
          {
            id = "watches",
            size = 0.25,
          },
        },
        position = "left",
        size = 40,
      },
      -- Toggle Full
      {
        elements = {
          {
            id = "repl",
            size = 0.5,
          },
          {
            id = "console",
            size = 0.5,
          },
        },
        position = "bottom",
        size = 10,
      },
    },
  },
  keys = {
    {
      "<leader>dutc",
      function()
        require("dapui").toggle({
          layout = 1,
        })
      end,
      desc = "Clean UI",
      noremap = true,
    },
    {
      "<leader>dutr",
      function()
        require("dapui").toggle({
          layout = 2,
        })
      end,
      desc = "REPL",
      noremap = true,
    },
    {
      "<leader>dutf",
      function()
        require("dapui").toggle({
          layout = 3,
        })
      end,
      desc = "Full (default layout)",
      noremap = true,
    },
  },
}
