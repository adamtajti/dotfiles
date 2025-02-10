return {
  "michaelb/sniprun",
  build = "bash ./install.sh",
  dependencies = {
    -- bufferize is used in my own customization to run lua in neovim which can
    -- be useful when evaluating code that depends on the vim global.
    "AndrewRadev/bufferize.vim",

    -- nvim dap is required cause I made yet another customization so that selected code sections
    -- can be avaluated as an expression in the current debugging session (if any). That should take
    -- priority over anything else
    "mfussenegger/nvim-dap",
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
        local dap = require("dap")
        if dap.session() then
          -- dapui will evaluate the current selection if nvim is in visual mode
          require("dapui").eval()
          return
        end

        local current_file_path = vim.fn.expand("%:p")
        local found_nvim_in_path = string.find(current_file_path, "nvim")
        if found_nvim_in_path ~= nil then
          vim.cmd([[Bufferize '<,'>so]])
          return
        end

        require("sniprun").run("v")
      end,
      desc = "Evaluate Selected Lines",
      noremap = true,
      mode = { "x" },
    },
    {
      "<Leader><CR>",
      function()
        local dap = require("dap")
        if dap.session() then
          -- dapui will evaluate the current word if nvim is in normal mode
          require("dapui").eval()
          return
        end

        local current_file_path = vim.fn.expand("%:p")
        local found_nvim_in_path = string.find(current_file_path, "nvim")
        if found_nvim_in_path ~= nil then
          vim.cmd([[Bufferize source]])
        end

        require("sniprun").run()
      end,
      desc = "Evaluate Current File (Script)",
      noremap = true,
    },
  },
}
