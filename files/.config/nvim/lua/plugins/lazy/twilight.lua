--- Folke's dimming plugin
--- https://github.com/folke/twilight.nvim
return {
  "folke/twilight.nvim",
  event = "VeryLazy",
  opts = {
    dimming = {
      alpha = 0.25,
    },
    expand = {
      "function",
      "method",
      "table",
      "if_statement",

      -- markdown
      -- "section", -- section covers the entire document
      "paragraph",
      "fenced_code_block",
      "list",
      "atx_heading",
      "atx_h3_marker",
    },
    exclude = { "oil" }, -- exclude these filetypes
  },
}
