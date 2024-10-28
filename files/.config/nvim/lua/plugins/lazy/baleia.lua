return {
  "m00qek/baleia.nvim",
  -- I'll experiment with this later. I wasn't able to load color coded logs properly
  enabled = false,
  lazy = false,
  version = "*",
  config = function()
    vim.g.baleia = require("baleia").setup({})

    -- Command to colorize the current buffer
    vim.api.nvim_create_user_command(
      "BaleiaColorize",
      function() vim.g.baleia.once(vim.api.nvim_get_current_buf()) end,
      { bang = true }
    )

    -- Command to show logs
    vim.api.nvim_create_user_command(
      "BaleiaLogs",
      vim.g.baleia.logger.show,
      { bang = true }
    )
  end,
}
