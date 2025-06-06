-- Further configure the lua-language-server for better type and module resolutions.
-- In case I want to turn it off during a session: `:=vim.g.lazydev_enabled=false`

local lazy_plugin_config = require("plugins.config")

---@type LazyPluginSpec[]
return {
  {
    "folke/lazydev.nvim",
    -- every = "VeryLazy",

    -- Does this mean that this gets loaded every time?
    -- It seemed like that for each lua file
    -- ft = "lua", -- only load on lua files
    lazy = false,
    opts = {
      debug = false, -- turn it on if you have issues with lua completions
      library = {
        "lazy.nvim",
        "snacks.nvim",

        -- deus.nvim development
        vim.fn.resolve("~/GitHub/adamtajti/deus.nvim/"),

        -- clickup.nvim development
        vim.fn.resolve("~/GitHub/adamtajti/clickup.nvim/"),

        -- Useful while developing blink.cmp or nvim_cmp sources
        lazy_plugin_config.blink_instead_of_cmp and "saghen/blink.cmp"
          or "hrsh7th/nvim-cmp",
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
}
