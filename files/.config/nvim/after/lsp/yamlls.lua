return {
  -- I don't get why I added "ts" at the end. The rest was the default.
  -- filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "ts" },

  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#yamlls
  settings = {
    -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
    redhat = { telemetry = { enabled = false } },
    yaml = {
      hover = true,
      completion = true,
      validate = true,
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      -- schemas = {
      -- 	-- ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      -- 	-- ["../path/relative/to/file.yml"] = "/.github/workflows/*",
      -- 	-- ["/path/from/root/of/project"] = "/.github/workflows/*",
      -- },
    },
  },
}
