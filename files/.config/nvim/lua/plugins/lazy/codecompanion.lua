---@type LazyPluginSpec
return {
  "olimorris/codecompanion.nvim",
  commit = "42cf6d1",
  pin = true,
  event = "VeryLazy",
  config = function()
    require("codecompanion").setup({
      -- sets up the default adapters to be a safe one, local ollama
      -- (used to be called as strategies before https://github.com/olimorris/codecompanion.nvim/pull/2485)
      interactions = {
        chat = {
          adapter = "harbour-ollama",
        },
        inline = {
          adapter = "harbour-ollama",
        },
        cmd = {
          adapter = "harbour-ollama",
        },
        background = {
          adapter = "harbour-ollama",
        },
      },

      -- TODO: All settings below are unreviewed.
      -- REASON: I updated codecompanion and I'm reviewing my config on 2026-02-12

      opts = {
        -- Set debug logging
        log_level = "INFO", -- Options: ERROR, WARN, INFO, DEBUG, TRACE
      },

      adapters = {
        http = {
          ["harbour-ollama"] = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "harbour-ollama",
              opts = {
                stream = true,
                tools = true,
                vision = true,
              },
              schema = {
                model = {
                  default = "gpt-oss:20b",
                  choices = {
                    ["gpt-oss:20b"] = { opts = { can_reason = true } },
                  },
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
          ["tulip-gemini"] = function()
            return require("codecompanion.adapters").extend("gemini", {
              name = "tulip-gemini",
              env = {
                api_key = "TULIP_GEMINI_API_KEY",
              },
              schema = {
                model = {
                  default = "gemini-3-pro-preview",
                },
              },
            })
          end,
        },
      },
      extensions = {
        -- mcphub = {
        --   callback = "mcphub.extensions.codecompanion",
        --   opts = {
        --     make_vars = true,
        --     make_slash_commands = true,
        --     show_result_in_chat = true,
        --   },
        -- },
      },
    })

    -- vim.keymap.set(
    --   { "n", "v" },
    --   "<C-a>",
    --   "<cmd>CodeCompanionActions<cr>",
    --   { noremap = true, silent = true }
    -- )
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
    -- "ravitemer/mcphub.nvim",
  },
}
