return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = "BufReadPost",
  config = function()
    require("nvim-treesitter-textobjects").setup({})

    local ts_select = require("nvim-treesitter-textobjects.select")

    vim.keymap.set(
      { "x", "o" },
      "af",
      function() ts_select.select_textobject("@function.outer", "textobjects") end
    )
    vim.keymap.set(
      { "x", "o" },
      "if",
      function() ts_select.select_textobject("@function.inner", "textobjects") end
    )
    vim.keymap.set(
      { "x", "o" },
      "ac",
      function() ts_select.select_textobject("@class.outer", "textobjects") end
    )
    vim.keymap.set(
      { "x", "o" },
      "ic",
      function() ts_select.select_textobject("@class.inner", "textobjects") end
    )
    -- You can also use captures from other query groups like `locals.scm`
    -- vim.keymap.set(
    --   { "x", "o" },
    --   "as",
    --   function() ts_select.select_textobject("@local.scope", "locals") end
    -- )
  end,
}
