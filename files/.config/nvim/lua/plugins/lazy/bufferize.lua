---@type LazyPluginSpec
return {
  "AndrewRadev/bufferize.vim",
  event = "VeryLazy",
  keys = {
    { "<leader>Bm", "<cmd>Bufferize messages<CR>", desc = "messages" },
    {
      "<leader>Bn",
      -- This is used to work with https://github.com/rcarriga/nvim-notify
      -- "<cmd>Bufferize Notifications<CR>",
      -- But I switched over to snacks
      function()
        local Snacks = require("snacks")
        Snacks.notifier.show_history({
          reverse = false,
        })
      end,
      desc = "Notifications",
    },
    {
      "<leader>Bl",
      "<cmd>Bufferize messages<CR><cmd>Bufferize Notifications<CR>",
      desc = "logs (messages, notifications)",
    },
  },
}
