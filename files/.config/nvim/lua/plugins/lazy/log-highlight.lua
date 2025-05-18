-- Adds .log filetype detection and syntax highlighting
---@type LazyPluginSpec
return {
  "fei6409/log-highlight.nvim",
  event = {
    "BufReadPre " .. "*{.,_}log",
    "BufNewFile " .. "*{.,_}log",
  },
  config = function() require("log-highlight").setup({}) end,
}
