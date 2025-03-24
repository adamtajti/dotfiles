local notebook_path = os.getenv("NOTEBOOK_PATH")

return {
  "adamtajti/deus.nvim",
  dev = true,
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "rcarriga/nvim-notify",
    "folke/which-key.nvim",
    "grapp-dev/nui-components.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function() require("deus").setup({}) end,
  keys = {
    {
      "<leader>nsf",
      function()
        require("telescope.builtin").find_files({
          cwd = notebook_path,
          hidden = true,
        })
      end,
      desc = "Find Files (Notebook)",
      noremap = true,
    },
    {
      "<Leader>nst",
      function()
        require("telescope").extensions.live_grep_args.live_grep_args({
          hidden = true,
          search_dirs = {
            notebook_path,
          },
        })
      end,
      desc = "Search Text (Notebook)",
      noremap = true,
    },
    {
      "<Leader>nso",
      function()
        require("telescope").extensions["recent-files"].recent_files({
          cwd = notebook_path,
        })
      end,
      desc = "Previously Opened Files",
      noremap = true,
    },
  },
}
