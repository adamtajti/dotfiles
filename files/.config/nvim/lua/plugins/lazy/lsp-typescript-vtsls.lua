return {
  "yioneko/nvim-vtsls",
  enabled = false,
  config = function(_, _)
    require("lspconfig.configs").vtsls = require("vtsls").lspconfig -- set default server config, optional but recommended

    -- If the lsp setup is taken over by other plugin, it is the same to call the counterpart setup function
    require("lspconfig").vtsls.setup({
      single_file_support = true,
      on_attach = on_attach,
      refactor_auto_rename = true,
      settings = {
        -- https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
        typescript = {
          tsserver = {
            useSyntaxServer = false, -- save ram: https://github.com/yioneko/vtsls/issues/136
            useSeparateSyntaxServer = false, -- save ram: https://github.com/yioneko/vtsls/issues/136
            maxTsServerMemory = 5120,
            experimental = {
              enableProjectDiagnostics = false, -- randomly opens json files lol: https://github.com/yioneko/vtsls/issues/199
            },
            watchOptions = {
              watchFile = "useFsEventsOnParentDirectory",
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
        },
        vtsls = {
          experimental = {
            completion = {
              enableServerSideFuzzyMatch = true,
              entriesLimit = 69,
            },
            maxInlayHintLength = 12,
          },
        },
      },
    })
  end,
}
