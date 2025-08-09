return {
  settings = {
    gopls = {
      experimentalPostfixCompletions = true,
      directoryFilters = {
        "-**/node_modules",
        "-**/vendor",
      },
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
      hints = {
        assignVariableTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
  init_options = {
    usePlaceholders = true,
  },
  flags = {
    allow_incremental_sync = false,
    debounce_text_changes = 500,
  },
}
