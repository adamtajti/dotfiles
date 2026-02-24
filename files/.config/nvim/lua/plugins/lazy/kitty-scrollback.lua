return {
  "mikesmithgh/kitty-scrollback.nvim",
  enabled = false,
  cmd = {
    "KittyScrollbackGenerateKittens",
    "KittyScrollbackCheckHealth",
    "KittyScrollbackGenerateCommandLineEditing",
  },
  event = { "User KittyScrollbackLaunch" },
  -- version = '*', -- latest stable version, may have breaking changes if major version changed
  -- version = '^6.0.0', -- pin major version, include fixes and features that do not have breaking changes
  config = function()
    require("kitty-scrollback").setup({
      paste_window = {
        highlight_as_normal_win = true,
      },
    })
  end,
}
