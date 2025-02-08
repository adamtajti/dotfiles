return {
  "michaelb/sniprun",
  build = "bash ./install.sh",
  dependencies = {
    -- bufferize is used in my own customization to run lua in neovim which can
    -- be useful when evaluating code that depends on the vim global.
    "AndrewRadev/bufferize.vim",
  },
  opts = {
    display = {
      -- Options:
      -- "Classic" -> display results in the command-line  area
      -- "VirtualText" -> display results as virtual text
      -- "TempFloatingWindow" -> display results in a floating window
      -- "LongTempFloatingWindow" -> same as above, but only long results. To use with VirtualText[Ok/Err]
      -- "Terminal" -> display results in a vertical split
      -- "TerminalWithCode" -> display results and code history in a vertical split
      -- "NvimNotify" -> display with the nvim-notify plugin
      -- "Api" -> return output to a programming interface
      -- "TempFloatingWindow",
      "TerminalWithCode",
    },
  },
  keys = {
    {
      "<Leader><CR>",
      function()
        local current_file_path = vim.fn.expand("%:p")
        local found_nvim_in_path = string.find(current_file_path, "nvim")
        if found_nvim_in_path ~= nil then
          vim.cmd([[Bufferize '<,'>so]])
        else
          require("sniprun").run("v")
        end
      end,
      desc = "Evaluate Selected Lines",
      noremap = true,
      mode = { "x" },
    },
    {
      "<Leader><CR>",
      function()
        local current_file_path = vim.fn.expand("%:p")
        local found_nvim_in_path = string.find(current_file_path, "nvim")
        if found_nvim_in_path ~= nil then
          vim.cmd([[Bufferize source]])
        else
          require("sniprun").run()
        end
      end,
      desc = "Evaluate Current File (Script)",
      noremap = true,
    },
  },
}
