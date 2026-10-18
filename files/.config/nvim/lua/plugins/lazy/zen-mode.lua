--- Folke's zen-mode
--- https://github.com/folke/zen-mode.nvim

---@type LazyPluginSpec
return {
  "folke/zen-mode.nvim",
  event = "VeryLazy",
  opts = {
    window = {
      options = {
        signcolumn = "no", -- disable signcolumn
        number = false, -- disable number column
        relativenumber = false, -- disable relative numbers
        cursorline = false, -- disable cursorline
        cursorcolumn = false, -- disable cursor column
        foldcolumn = "0", -- disable fold column
        list = false, -- disable whitespace characters
      },
    },
  },
  keys = {
    { "<leader>z", "<cmd>ZenMode<cr>", desc = "ZenMode" },
  },
}
