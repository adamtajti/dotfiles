-- Plenary provides many utilities. Direct dependency seems to be necessary to run test files.
return {
  "nvim-lua/plenary.nvim",
  init = function()
    -- The keymap was much more simpler than this, but I wanted to use <Leader>p for :pwd
    vim.keymap.set(
      "n",
      "<leader>bPT",
      function()
        require("plenary.test_harness").test_directory(vim.fn.expand("%:p"))
      end,
      {
        desc = "Test Current Buffer",
        noremap = true,
      }
    )

    vim.keymap.set(
      "n",
      "<leader>bPo",
      function()
        require("plenary.reload").reload_module(
          "obsidian.completion.sources.blink.cmp_blink"
        )
      end,
      {
        desc = "Reload the Obsidian source for Blink",
        noremap = true,
      }
    )
  end,
}
