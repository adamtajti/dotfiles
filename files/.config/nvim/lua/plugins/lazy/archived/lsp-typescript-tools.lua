return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  event = "VeryLazy",
  ft = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  enabled = false,
  opts = {
    single_file_support = false,
    settings = {
      -- spawn additional tsserver instance to calculate diagnostics on it
      separate_diagnostic_server = true,

      -- "change"|"insert_leave" determine when the client asks the server about diagnostic
      publish_diagnostic_on = "insert_leave",

      -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
      -- "remove_unused_imports"|"organize_imports") -- or string "all"
      -- to include all supported code actions
      -- specify commands exposed as code_actions
      expose_as_code_action = "all",

      -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
      -- not exists then standard path resolution strategy is applied
      -- tsserver_path = "/home/adamtajti/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/bin/tsserver.js",

      -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
      -- (see 💅 `styled-components` support section)
      --
      -- MANUAL-INSTALLATION-STEP: `npm i -g @styled/typescript-styled-plugin typescript-styled-plugin`
      -- MANUAL-INSTALLATION-STEP: `npm i -g @monodon/typescript-nx-imports-plugin`
      -- Right now this step is not executed the plugin automatically, I assume it's because it "requires"
      -- a global installation and that requires root privileges.
      tsserver_plugins = {
        -- for TypeScript v4.9+
        "@styled/typescript-styled-plugin",
        -- or for older TypeScript versions
        -- "typescript-styled-plugin",

        "@monodon/typescript-nx-imports-plugin",
      },
      -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
      -- memory limit in megabytes or "auto"(basically no limit)
      -- tsserver_max_memory = "2048",
      -- described below
      tsserver_format_options = {},
      tsserver_file_preferences = {
        -- Inlay Hints
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
        -- Prefer "imports" (package.json) aliased imports
        -- ex.: `"#controllers/*": "./app/controllers/*.ts"`
        importModuleSpecifierPreference = "non-relative",
      },

      -- locale of all tsserver messages, supported locales you can find here:
      -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
      tsserver_locale = "en",

      -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
      complete_function_calls = true,

      include_completions_with_insert_text = true,

      -- CodeLens
      -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
      -- possible values: ("off"|"all"|"implementations_only"|"references_only")
      code_lens = "off",

      -- by default code lenses are displayed on all referencable values and for some of you it can
      -- be too much this option reduce count of them by removing member references from lenses
      disable_member_code_lens = true,
      -- JSXCloseTag
      -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-auto-tag,
      -- that maybe have a conflict if enable this feature. )
      jsx_close_tag = {
        enable = true,
        filetypes = { "javascriptreact", "typescriptreact" },
      },
    },
  },
  config = function(_, opts)
    require("typescript-tools").setup(opts)

    -- -- Do automatic file formatting, reformat over here
    -- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    --   buffer = bufnr,
    --   callback = function()
    --     -- Organize imports for TypeScript files. Unfortunate to have to do two
    --     -- separate actions, but unfortunately it's the way the language server is
    --     -- setup.
    --     if client.name == "typescript-tools" then
    --       local ts_tools_api = require("typescript-tools.api")
    --       -- add missing imports in sync
    --       ts_tools_api.add_missing_imports(true)
    --
    --       -- sorts and removes unused imports
    --       ts_tools_api.organize_imports(true)
    --     end
    --   end,
    -- })

    local ts_tools_api = require("typescript-tools.api")

    vim.keymap.set("n", "<Leader>lta", "", {
      desc = "LSP: TSTools: Add Missing Imports",
      noremap = true,
      silent = true,
      callback = function() ts_tools_api.add_missing_imports(true) end,
    })

    vim.keymap.set("n", "<Leader>lto", "", {
      desc = "LSP: TSTools: Organize Imports (sort and remove unused)",
      noremap = true,
      silent = true,
      callback = function() ts_tools_api.organize_imports(true) end,
    })

    vim.keymap.set("n", "<leader>lrf", "", {
      desc = "LSP: TSTools: Rename File",
      noremap = true,
      silent = true,
      callback = function() ts_tools_api.rename_file(true) end,
    })

    vim.keymap.set("n", "<leader>lrf", "", {
      desc = "LSP: TSTools: File References",
      noremap = true,
      silent = true,
      callback = function() ts_tools_api.file_references(true) end,
    })
  end,
}
