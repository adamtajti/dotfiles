local tulip = require("work.tulip")

return {
  -- reuse_client = function() return true end,
  refactor_auto_rename = true,
  settings = {
    -- https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
    typescript = {
      tsserver = {
        -- Controls if TypeScript launches a dedicated server to more quickly handle syntax related operations, such as computing code folding.
        --
        -- 2025-05-08: This was set to "never", but I'm setting it back to "auto" since I have more RAM now
        useSyntaxServer = "auto", -- save ram: https://github.com/yioneko/vtsls/issues/136

        -- Enable/disable spawning a separate TypeScript server that can more quickly respond to syntax related operations, such as calculating folding or computing document symbols.
        --
        -- 2025-05-08: This was set to false, but I'm turning it on since I have more RAM now
        useSeparateSyntaxServer = true, -- save ram: https://github.com/yioneko/vtsls/issues/136

        -- The maximum amount of memory (in MB) to allocate to the TypeScript server process. To use a memory limit greater than 4 GB, use `#typescript.tsserver.nodePath#` to run TS Server with a custom Node installation.
        --
        -- 2025-05-08: This was reduced back to 4000 before, but since I'm expanding to 64GB RAM, I'm raising it
        --             back to 9G
        maxTsServerMemory = 9000, -- default: 3072
        experimental = {
          -- Enables project wide error reporting. (default: false)
          -- 2025-05-08: Setting this to true now that the previous issue should have been fixed
          --
          --
          --    https://github.com/yioneko/vtsls/issues/199 (randomly opens json files)
          --    https://github.com/yioneko/vtsls/commit/6553bab5701e4fdd46adb920dcd89f5c95e6b2e2
          enableProjectDiagnostics = false,
        },

        -- Configure which watching strategies should be used to keep track of files and directories.
        watchOptions = {
          -- 2025-05-08: Setting this back to "useFsEvents" from "useFsEventsOnParentDirectory"
          -- Read more about this at: https://devblogs.microsoft.com/typescript/announcing-typescript-3-8-rc/
          watchFile = "useFsEvents",
          watchDirectory = "useFsEvents",
          fallbackPolling = "dynamicPriorityPolling",

          -- Finally, two additional settings for reducing the amount of possible
          -- files to track  work from these directories
          excludeDirectories = { "**/node_modules", "_build" },
          excludeFiles = { "build/fileWhichChangesOften.ts" },
        },
      },
      -- inlayHints = {
      --   parameterNames = { enabled = "literals" },
      --   parameterTypes = { enabled = true },
      --   variableTypes = { enabled = true },
      --   propertyDeclarationTypes = { enabled = true },
      --   functionLikeReturnTypes = { enabled = true },
      --   enumMemberValues = { enabled = true },
      -- },
      referencesCodeLens = {
        enabled = false,
      },
      preferences = {
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
        importModuleSpecifier = "non-relative",

        -- Enable/disable searching `package.json` dependencies for available auto imports.
        includePackageJsonAutoImports = "on", -- default: "auto"
      },
      format = {
        enable = false,
      },
    },
    javascript = {
      validate = {
        enable = false,
      },
      preferences = {
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
        importModuleSpecifier = "non-relative",
      },
      format = {
        enable = false,
      },
    },
    vtsls = {
      -- Automatically use workspace version of TypeScript lib on startup. By default, the bundled version is used for intelliSense.
      -- This didn't work so I resorted to scripting it
      autoUseWorkspaceTsdk = false,
      typescript = {
        globalTsdk = tulip.getTSDKPath(),

        tsserver = {
          -- Read the configuration.schema.json if you want to configure
          -- this, this should be an array of objects.
          globalPlugins = {
            -- {
            --   name = "@vue/typescript-plugin",
            --   location = vim.fn.stdpath("data")
            --     .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
            --   languages = { "vue" },
            -- },
          },
        },
      },
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
          entriesLimit = 100,
        },
        maxInlayHintLength = 12,
      },
    },
  },
}
