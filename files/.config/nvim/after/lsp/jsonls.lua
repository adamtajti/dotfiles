return {
  settings = {
    json = {
      format = {
        enable = false,
        keepLines = true,
      },
      schemas = {
        {
          fileMatch = { "tsconfig*.json" },
          url = "https://json.schemastore.org/tsconfig.json",
        },
      },
    },
  },
}
