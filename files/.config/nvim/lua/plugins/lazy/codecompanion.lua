---@type LazyPluginSpec
return {
  "olimorris/codecompanion.nvim",
  event = "VeryLazy",
  config = function()
    require("codecompanion").setup({
      opts = {
        -- Set debug logging
        log_level = "DEBUG",
      },
      -- sets up the default adapters to be a safe one, local ollama
      strategies = {
        chat = {
          adapter = "ollama/gemma3:12b",
        },
        inline = {
          adapter = "ollama/gemma3:12b",
        },
        cmd = {
          adapter = "ollama/gemma3:12b",
        },
      },
      adapters = {
        opts = {
          show_defaults = false,
        },
        ["ollama/gemma3:12b"] = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "ollama/gemma3:12b",
            schema = {
              model = {
                default = "gemma3:12b",
              },
              num_ctx = {
                default = 16384,
              },
              num_predict = {
                default = -1,
              },
            },
          })
        end,
        deepseek = function()
          return require("codecompanion.adapters").extend("deepseek", {
            name = "deepseek",
            schema = {
              model = {
                default = "deepseek-chat",
              },
            },
          })
        end,
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },
    })

    vim.keymap.set(
      { "n", "v" },
      "<C-a>",
      "<cmd>CodeCompanionActions<cr>",
      { noremap = true, silent = true }
    )
    vim.keymap.set(
      { "n", "v" },
      "<leader>a",
      "<cmd>CodeCompanionChat Toggle<cr>",
      { noremap = true, silent = true }
    )
    vim.keymap.set(
      "v",
      "ga",
      "<cmd>CodeCompanionChat Add<cr>",
      { noremap = true, silent = true }
    )
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/mcphub.nvim",
  },
}
