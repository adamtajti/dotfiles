local function detachedOpen(binary, args)
  local handle = vim.uv.spawn(binary, {
    args = args,
    cwd = vim.fn.getcwd(),
    detached = true,
    hide = true,
  })

  if handle ~= nil then
    vim.uv.unref(handle)
  end
end

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
  -- vim.api.nvim_set_keymap("i", "<sc-v>", "<C-r>+", { noremap = true })
  -- vim.api.nvim_set_keymap("i", "<sc-v>", '<ESC>l"+Pli', { noremap = true })
  vim.api.nvim_set_keymap("i", "<sc-v>", '<ESC>"+p', { noremap = true })
  vim.api.nvim_set_keymap("t", "<sc-v>", '<C-\\><C-n>"+Pi', { noremap = true })
  vim.api.nvim_set_keymap("n", "<sc-v>", '"+p', { noremap = true })
end

vim.keymap.set(
  "n",
  "<leader>1",
  function() detachedOpen("neovide", { vim.fn.expand("%:p") }) end,
  { desc = "External: Open file in NeoVide" }
)

vim.keymap.set(
  "n",
  "<leader>2",
  function() detachedOpen("footclient", {}) end,
  { desc = "External: Open CWD in foot" }
)
