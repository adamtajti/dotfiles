if vim.g.neovide then
  -- Use ~/.config/neovide/config.toml to specify the fonts
  -- vim.o.guifont = "PragmataPro_Mono:h16"
  vim.opt.linespace = -1
  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
    -- hack: attempt to set the new scale instantly. there is a bug that when +
    -- is used the next - gets interpreted as +
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor
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

  vim.api.nvim_set_keymap("v", "<sc-c>", '"+y', { noremap = true })
  vim.api.nvim_set_keymap("v", "<sc-v>", '"+P', { noremap = true })
  vim.api.nvim_set_keymap("c", "<sc-v>", "<C-r>+", { noremap = true })
  -- Errors out with Invalid expression: "^R+"
  vim.api.nvim_set_keymap(
    "i",
    "<C-S-V>",
    "<C-R>+",
    { noremap = true, desc = "neovide.lua settings" }
  )

  -- I had this enabled for weeks, but sometimes it didn't work in Telescope
  -- So I reverted to <Cr-r>+ for the time being... wild ride.
  -- vim.api.nvim_set_keymap(
  --   "i",
  --   "<C-S-V>",
  --   '<ESC>"+p',
  --   { noremap = true, desc = "neovide.lua settings" }
  -- )

  -- vim.api.nvim_set_keymap("i", "<sc-v>", '<ESC>l"+Pli', { noremap = true })
  vim.api.nvim_set_keymap("t", "<sc-v>", '<C-\\><C-n>"+Pi', { noremap = true })
  vim.api.nvim_set_keymap("n", "<sc-v>", '"+p', { noremap = true })
end
