local global_mason_tsdk_path =
  "/home/adamtajti/.local/share/nvim/mason/packages/vtsls/node_modules/@vtsls/language-server/node_modules/typescript/lib/"

-- helper util, I use this quite a lot in other places as well, I should
-- probably refactor this into a utils
local function trim(s) return (s:gsub("^%s*(.-)%s*$", "%1")) end

-- This is a tulip / yarn workspace specific modification. I should improve this
-- function later on by analyzing the internals of vtsls / autoUseWorkspaceTsdk
local function getTSDKPath()
  local open_pop = io.popen("git rev-parse --show-toplevel 2>/dev/null", "r")
  if open_pop == nil then
    return global_mason_tsdk_path
  end

  local repo_root = trim(open_pop:read("*all"))
  open_pop:close()

  if
    repo_root == nil
    or repo_root == ""
    or string.find(repo_root, "fatal:", 1, true)
  then
    return global_mason_tsdk_path
  end

  if
    not string.find(repo_root, "Projects", 1, true)
    or not string.find(repo_root, "tulip", 1, true)
  then
    return global_mason_tsdk_path
  end

  return repo_root .. "/environments/node_modules/typescript/lib"
end

return {
  "yioneko/nvim-vtsls",
  enabled = true,
  config = function(_, _)
    require("lspconfig.configs").vtsls = require("vtsls").lspconfig -- set default server config, optional but recommended

    -- If the lsp setup is taken over by other plugin, it is the same to call the counterpart setup function
    require("lspconfig").vtsls.setup({
      single_file_support = true,
      -- on_attach = on_attach,
      refactor_auto_rename = true,
      settings = {
        -- https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
        typescript = {
          tsserver = {
            -- Controls if TypeScript launches a dedicated server to more quickly handle syntax related operations, such as computing code folding.
            useSyntaxServer = "never", -- save ram: https://github.com/yioneko/vtsls/issues/136

            -- Enable/disable spawning a separate TypeScript server that can more quickly respond to syntax related operations, such as calculating folding or computing document symbols.
            useSeparateSyntaxServer = false, -- save ram: https://github.com/yioneko/vtsls/issues/136

            -- The maximum amount of memory (in MB) to allocate to the TypeScript server process. To use a memory limit greater than 4 GB, use `#typescript.tsserver.nodePath#` to run TS Server with a custom Node installation.
            maxTsServerMemory = 9000, -- default: 3072
            experimental = {
              -- Enables project wide error reporting. (default: false)
              enableProjectDiagnostics = false, -- randomly opens json files lol: https://github.com/yioneko/vtsls/issues/199
            },

            -- Configure which watching strategies should be used to keep track of files and directories.
            watchOptions = {
              watchFile = "useFsEventsOnParentDirectory",
              watchDirectory = "useFsEvents",
              fallbackPolling = "dynamicPriority",

              -- Finally, two additional settings for reducing the amount of possible
              -- files to track  work from these directories
              excludeDirectories = { "**/node_modules", "_build" },
              excludeFiles = { "build/fileWhichChangesOften.ts" },
            },
          },
          inlayHints = {
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            variableTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            enumMemberValues = { enabled = true },
          },
          referencesCodeLens = {
            enable = false,
          },
          preferences = {
            includeCompletionsForModuleExports = true,
            includeCompletionsForImportStatements = true,
            importModuleSpecifier = "non-relative",

            -- Enable/disable searching `package.json` dependencies for available auto imports.
            includePackageJsonAutoImports = "on", -- default: "auto", testing
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
            globalTsdk = getTSDKPath(),

            tsserver = {
              -- Read the configuration.schema.json if you want to configure
              -- this, this should be an array of objects.
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vim.fn.stdpath("data")
                    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                  languages = { "vue" },
                },
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
    })
  end,
}
