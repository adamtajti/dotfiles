---@type LazyPluginSpec
return {
  "m00qek/baleia.nvim",
  commit = "1b25eac3ac03659c3d3af75c7455e179e5f197f7",
  pin = true,
  submodules = false,
  cmd = {
    "BaleiaColorize",
    "BaleiaLogs",
  },
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
