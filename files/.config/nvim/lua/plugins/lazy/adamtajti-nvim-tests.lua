-- This module is only used for tests and development.
-- Strive to keep the tests contained in command callbacks, so that they won't
-- disturb day to day business.
return {
  "adamtajti/adamtajti-nvim-tests",
  name = "adamtajti-nvim-tests",
  dependencies = {
    {
      "adamtajti/lit-coro-http-nvim.nvim",
      dev = true,
    },
  },
  enable = true,
  build = "rockspec",
  dev = true,
  opts = {},
  event = "VeryLazy",
  cmd = { "TestSecureSockets" },
}
