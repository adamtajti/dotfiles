--- Autoclose automatically inserts symbol pairs to get around faster.
--- https://github.com/m4xshen/autoclose.nvim
return {
  "m4xshen/autoclose.nvim",
  event = "BufReadPre",
  enabled = false,
  opts = {
    options = {
      disabled_filetypes = { "text", "markdown" },
    },
  },
}
