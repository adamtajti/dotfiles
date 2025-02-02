-- Utilized for the Callhierarchy module.
-- Eventually Glance might have this feature in the future.
return {
  "nvimdev/lspsaga.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- optional
    "nvim-tree/nvim-web-devicons", -- optional
  },
  opts = {},
  cmd = {
    "Lspsaga",
  },
}
