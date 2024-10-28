return {
  "m4xshen/hardtime.nvim",
  dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  enabled = false, -- l key gets stuck after a while... wasn't able to remove it from restricted_keys
  event = "VeryLazy",
  opts = {
    disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil" },
    allow_different_key = true,
    restriction_mode = "hint",
    restricted_keys = {
      ["h"] = { "n", "x" },
      ["j"] = { "n", "x" },
      ["k"] = { "n", "x" },
      ["+"] = { "n", "x" },
      ["gj"] = { "n", "x" },
      ["gk"] = { "n", "x" },
      ["<CR>"] = { "n", "x" },
      ["<C-M>"] = { "n", "x" },
      ["<C-N>"] = { "n", "x" },
      ["<C-P>"] = { "n", "x" },
    },
    resetting_keys = {
      [">"] = {},
      ["<"] = {},
      ["l"] = {},
    },
  },
}
