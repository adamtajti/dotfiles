-- Speed up log creation. Create various kinds of language-specific log statements, such as logs of variables, assertions, or time-measuring.
return {
  "chrisgrieser/nvim-chainsaw",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "<leader>llv",
      function() require("chainsaw").variableLog() end,
      silent = true,
      desc = "Log this variable",
    },
    {
      "<leader>llo",
      function() require("chainsaw").objectLog() end,
      silent = true,
      desc = "Log this object (json/whatever)",
    },
    {
      "<leader>llt",
      function() require("chainsaw").typeLog() end,
      silent = true,
      desc = "Log the type of this variable",
    },
    {
      "<leader>llb",
      function() require("chainsaw").beepLog() end,
      silent = true,
      desc = "BEEP, control-flow check",
    },
    {
      "<leader>llm",
      function() require("chainsaw").messageLog() end,
      silent = true,
      desc = "Log a message provided by me",
    },
    {
      "<leader>lld",
      function() require("chainsaw").timeLog() end,
      silent = true,
      desc = "Log a duration (start measure, log since)",
    },
    {
      "<leader>lls",
      function() require("chainsaw").stacktraceLog() end,
      silent = true,
      desc = "Log the stacktrace",
    },
  },
}
