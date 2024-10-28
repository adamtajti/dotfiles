--- Buffer removing (unshow, delete, wipeout), which saves window layout
--- https://github.com/echasnovski/mini.bufremove
return {
  "echasnovski/mini.bufremove",
  event = "BufReadPre",
  keys = {
    {
      "<Leader>bd",
      function()
        local buffer_handle = vim.api.nvim_get_current_buf()
        require("mini.bufremove").delete(buffer_handle, true)
      end,
      noremap = true,
      desc = "Closes the current buffer",
    },
  },
}
