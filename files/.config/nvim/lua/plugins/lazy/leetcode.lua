--- 🔥 Solve LeetCode problems within Neovim 🔥
--- https://github.com/kawre/leetcode.nvim

---@type LazyPluginSpec
return {
  "kawre/leetcode.nvim",
  --event = "VeryLazy",
  cmd = "Leet",
  build = ":TSUpdate html",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim", -- required by telescope
    "MunifTanjim/nui.nvim",

    -- optional
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    lang = "cpp", -- default language
    plugins = {
      non_standalone = true,
    },
  },
}
