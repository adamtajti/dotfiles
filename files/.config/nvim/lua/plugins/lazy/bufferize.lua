return {
  "AndrewRadev/bufferize.vim",
  event = "VeryLazy",
  keys = {
    { "<leader>Bm", "<cmd>Bufferize messages<CR>", desc = "messages" },
    {
      "<leader>Bn",
      "<cmd>Bufferize Notifications<CR>",
      desc = "Notifications",
    },
    {
      "<leader>Bl",
      "<cmd>Bufferize messages<CR><cmd>Bufferize Notifications<CR>",
      desc = "logs (messages, notifications)",
    },
  },
}
