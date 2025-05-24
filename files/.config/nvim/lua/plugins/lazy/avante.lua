local tulip = require("work.tulip")

local vendors = {}

vendors = vim.tbl_extend("keep", vendors, {
  deepseek = {
    __inherited_from = "openai",
    api_key_name = "DEEPSEEK_API_KEY",
    endpoint = "https://api.deepseek.com",
    model = "deepseek-coder",
    max_tokens = 8192,
  },
})

vendors = vim.tbl_extend("keep", vendors, tulip.avante.providers.gemini)

---@type LazyPluginSpec
return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    -- The provider used in Aider mode or in the planning phase of Cursor Planning Mode
    -- This also seems to be the default provider+model to pick for all commands
    provider = "ollama",

    -- No longer needs to be specified as a vendor, it's a first-class provider
    ollama = {
      endpoint = "http://127.0.0.1:11434", -- Note that there is no /v1 at the end.
      model = "gemma3:12b",
    },

    -- See the full list of vendor names at
    -- /home/adamtajti/.local/share/nvim/lazy/avante.nvim/lua/avante/config.lua
    vendors = vendors,

    behaviour = {
      auto_suggestions = false, -- Experimental stage
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
      minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
      enable_token_counting = true, -- Whether to enable token counting. Default to true.
      enable_cursor_planning_mode = false, -- Whether to enable Cursor Planning Mode. Default to false.
      enable_claude_text_editor_tool_mode = false, -- Whether to enable Claude Text Editor Tool Mode.
    },

    rag_service = {
      enabled = false, -- Enables the RAG service
      host_mount = os.getenv("HOME"), -- Host mount path for the rag service
      provider = "ollama", -- The provider to use for RAG service (e.g. openai or ollama)
      -- llm_model = "gemma3:12b", -- The LLM model to use for RAG service
      -- embed_model = "nomic-embed-text", -- The embedding model to use for RAG service
      endpoint = "http://127.0.0.1:11434", -- The API endpoint for RAG service
    },

    file_selector = {
      provider = "telescope",
    },

    selector = {
      provider = "telescope",
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope

    -- {
    --   -- support for image pasting
    --   "HakonHarnes/img-clip.nvim",
    --   event = "VeryLazy",
    --   opts = {
    --     -- recommended settings
    --     default = {
    --       embed_image_as_base64 = false,
    --       prompt_for_file_name = false,
    --       drag_and_drop = {
    --         insert_mode = true,
    --       },
    --       -- required for Windows users
    --       use_absolute_path = true,
    --     },
    --   },
    -- },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
  keys = {
    {
      "<leader>aT",
      tulip.avante.keys.aT,
      desc = "Test",
      noremap = true,
    },
  },
}
