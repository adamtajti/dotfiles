-- DAP Virtual Text
return {
  "theHamsta/nvim-dap-virtual-text",
  event = "VeryLazy",
  enabled = true,
  config = function()
    -- NvimDapVirtualTextChanged (links to DiagnosticVirtualTextWarn xxx guifg=#e3c78a guibg=#000000)
    -- NvimDapVirtualText xxx (links to Comment        xxx cterm=italic gui=italic guifg=#949494)

    vim.fn.sign_define("DapBreakpoint", {
      --text = "󰈻 ",
      --text = "󰹆 ",
      --text = "󰿋 ",
      --text = "󰯉 ",
      text = "󰮯 ",
      texthl = "MoonflyViolet",
      linehl = "",
      numhl = "",
    })
    vim.fn.sign_define("DapBreakpointCondition", {
      text = "󰯲 ",
      texthl = "MoonflyViolet",
      linehl = "",
      numhl = "",
    })

    vim.fn.sign_define("DapBreakpointRejected ", {
      text = "󰰟 ",
      texthl = "MoonflyViolet",
      linehl = "",
      numhl = "",
    })

    vim.fn.sign_define("DapLogPoint ", {
      --text = "󰰍 ",
      text = "󱂅 ",
      texthl = "MoonflyViolet",
      linehl = "",
      numhl = "",
    })

    vim.fn.sign_define("DapStopped", {
      --text = " ",
      text = "󰶻 ",
      texthl = "MoonflyViolet",
      linehl = "MoonflyCurrentLine",
      numhl = "",
    })

    require("nvim-dap-virtual-text").setup({
      enabled = true, -- enable this plugin (the default)
      enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
      highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
      highlight_new_as_changed = true, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
      show_stop_reason = true, -- show stop reason when stopped for exceptions
      commented = true, -- prefix virtual text with comment string
      only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
      all_references = false, -- show virtual text on all all references of the variable (not only definitions)
      filter_references_pattern = "<module", -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
      -- experimental features:
      virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
      all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
      virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
      virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
      -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
    })
  end,
}
