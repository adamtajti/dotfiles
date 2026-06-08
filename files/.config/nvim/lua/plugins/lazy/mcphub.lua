return {
  "ravitemer/mcphub.nvim",
  -- disabled: binds on * instead of just localhost, seemingly there is no way to control which address it binds to.
  -- https://github.com/ravitemer/mcp-hub/pull/138
  --
  -- 2026-04-22: mcp-hub is dead. The contributor ignored my PR pull request for two weeks, it should have took 5
  -- minutes to review and merge.
  enabled = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = "sudo npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
  config = function()
    -- https://ravitemer.github.io/mcphub.nvim/configuration.html#config
    require("mcphub").setup({

      config = vim.fn.expand("~/.config/mcphub/servers.json"), -- Absolute path to MCP Servers config file (will create if not exists)
      port = 37373, -- The port `mcp-hub` server listens to
      global_env = {
        -- https://github.com/modelcontextprotocol/servers-archived/tree/HEAD/src/sqlite
        "DB_PATH",
      },
    })
  end,
}
