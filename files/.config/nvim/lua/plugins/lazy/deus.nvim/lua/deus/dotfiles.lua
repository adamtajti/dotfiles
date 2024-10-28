local utils = require("deus.utils")

local M = {}

local HOME = os.getenv("HOME")
local DOTFILES_INSTALL = HOME .. "/GitHub/dotfiles/scripts/setup.sh"

function M.install()
  local overall_ui_width = utils.get_nvim_width()
  local popup_term_width = math.floor(overall_ui_width * 0.98)
  local overall_ui_height = utils.get_nvim_height()
  local popup_term_height = math.floor(overall_ui_height * 0.9)

  local buffer_handle = vim.api.nvim_create_buf(false, true)
  local term_chan = vim.api.nvim_open_term(buffer_handle, {})
  vim.fn.jobstart(DOTFILES_INSTALL, {
    cwd = HOME .. "/GitHub/dotfiles/",
    on_stdout = function(_, data)
      vim.api.nvim_chan_send(term_chan, table.concat(data, "\r\n"))
    end,
    on_stderr = function(_, data)
      vim.api.nvim_chan_send(term_chan, table.concat(data, "\r\n"))
    end,
    on_exit = function(_, exit_code)
      vim.fn.chanclose(term_chan)

      if exit_code == 0 then
        require("notify")("dotfiles: successful update!")
        vim.api.nvim_buf_delete(buffer_handle, { force = true, unload = false })
      else
        require("notify")("dotfiles: failed update!")

        -- open up a window to see the buffer output
        vim.api.nvim_open_win(buffer_handle, true, {
          relative = "editor",
          row = 2,
          col = 2,
          width = popup_term_width,
          height = popup_term_height,
          border = "rounded",
          style = "minimal",
        })
      end
    end,
  })
end

function M.setup()
  vim.api.nvim_set_keymap("n", "<Leader>Di", "", {
    desc = "Dotfiles: Install Links",
    noremap = true,
    silent = true,
    callback = function() M.install() end,
  })
end

return M
