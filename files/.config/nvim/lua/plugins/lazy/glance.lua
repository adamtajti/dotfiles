return {
  "DNLHC/glance.nvim",
  lazy = false,
  config = function()
    require("glance").setup({
      border = {
        enable = true, -- Show window borders. Only horizontal borders allowed
        top_char = "―",
        bottom_char = "―",
      },
      -- your configuration
    })
    vim.keymap.set("n", "gD", "<CMD>Glance definitions<CR>")
    vim.keymap.set("n", "gR", "<CMD>Glance references<CR>")
    vim.keymap.set("n", "gY", "<CMD>Glance type_definitions<CR>")
    vim.keymap.set("n", "gM", "<CMD>Glance implementations<CR>")
  end,
}
