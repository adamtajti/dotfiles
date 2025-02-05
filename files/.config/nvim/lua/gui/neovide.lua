if vim.g.neovide then
  -- Setting the GUI font to 0xProto Nerd Font Mono
  vim.o.guifont = "0xProto Nerd Font Mono:h12"
  vim.opt.linespace = 4
  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<C-=>", function() change_scale_factor(1.25) end)
  vim.keymap.set("n", "<C-->", function() change_scale_factor(1 / 1.25) end)
  vim.g.neovide_scroll_animation_length = 0.07
  vim.g.neovide_hide_mouse_when_typing = false
  vim.g.neovide_confirm_quit = false
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_profiler = false
  vim.g.neovide_cursor_animation_length = 0.07
  vim.g.neovide_cursor_trail_size = 0.07
  vim.g.neovide_cursor_vfx_mode = "sonicboom"
  vim.keymap.set("n", "<C-s>", ":w<CR>") -- Save
  vim.keymap.set("v", "<C-c>", '"+y') -- Copy
  vim.keymap.set("n", "<C-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<C-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<C-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<C-v>", '<ESC>l"+Pli') -- Paste insert mode
  vim.api.nvim_set_keymap(
    "",
    "<C-v>",
    "+p<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "!",
    "<C-v>",
    "<C-R>+",
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "t",
    "<C-v>",
    "<C-R>+",
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    "v",
    "<C-v>",
    "<C-R>+",
    { noremap = true, silent = true }
  )
end
