return {
  "stevearc/quicker.nvim",
  event = "FileType qf",
  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = {
    opts = {
      buflisted = true,
      number = false,
      relativenumber = false,
      signcolumn = "auto",
      winfixheight = true,
      wrap = true,
    },
    use_default_opts = false,
    max_filename_width = function() return math.floor(4 * vim.o.columns / 5) end,
  },
}
