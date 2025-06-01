vim.lsp.config("lua_ls", {
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  settings = {
    -- options are documented over here:
    -- https://luals.github.io/wiki/settings/
    Lua = {
      -- deprecated: Telemetry has been removed since v3.6.5
      telemetry = {
        enable = false,
      },
      hover = {
        -- When a table is hovered, its fields will be displayed in the tooltip.
        -- This setting limits how many fields can be seen in the tooltip.
        -- Setting to 0 will disable this feature.
        -- default: 50
        previewFields = 100,

        -- When a value has multiple possible types, hovering it will display them.
        -- This setting limits how many will be displayed in the tooltip before they are truncated.
        -- default: 5
        enumsLimit = 100,
        -- The maximum number of characters that can be previewed by hovering a string before it is truncated.
        -- default: 1000
        viewStringMax = 2000,
      },
      format = {
        enable = false,
      },
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Add support for non-standard symbols.
        -- Make sure to double check that your runtime environment actually supports the symbols you are
        -- permitting as standard Lua does not.
        -- default: []
        -- note: This might be useful for custom lua scripts where additional keywords might be supported like
        -- `continue` or `+=`
        nonstandardSymbol = {},
      },
      codeLens = {
        enable = true,
      },
      diagnostics = {
        -- Define the delay between diagnoses of the workspace in milliseconds.
        --
        -- Every time a file is edited, created, deleted, etc. the workspace will be re-diagnosed in the background
        -- after this delay.
        --
        -- Setting to a negative number will disable automatic workspace diagnostics.
        -- default: 3000
        workspaceDelay = 100,
        -- Get the language server to recognize the `vim` global
        globals = {
          "vim",
          "ls",
          "s",
          "sn",
          "t",
          "i",
          "f",
          "c",
          "d",
          "r",
          "events",
          "ai",
          "extras",
          "l",
          "rep",
          "p",
          "m",
          "n",
          "dl",
          "fmt",
          "fmta",
          "conds",
          "postfix",
          "types",
          "parse",
          "ms",
          "k",
          "conds",
          "conds_expand",
          "table",
        },
        -- disable = {
        --   "missing-parameters",
        --   "missing-fields",
        --   "inject-field",
        -- },

        -- Set how files loaded with `workspace.library` are diagnosed.
        -- "Enable" - Always diagnose library files
        -- "Opened" - Only diagnose library files when they are open
        -- "Disable" - Never diagnose library files
        libraryFields = "Enable",
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        --   (this should include the Lazy.nvim plugins as well)
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false, -- don't ask for configuration again and again
      },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = "Disable",
        semicolon = "Disable",
        arrayIndex = "Disable",
      },
    },
  },
})
