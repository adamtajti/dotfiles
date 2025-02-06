local font_size = 24

local function inc_font_size()
  font_size = font_size + 1
  vim.o.guifont = "PragmataPro Mono:h" .. font_size
end
local function dec_font_size()
  font_size = font_size - 1
  vim.o.guifont = "PragmataPro Mono:h" .. font_size
end

if vim.g.fvim_loaded == 1 then
  -- vim.cmd([[set guifont=PragmataPro\ Mono:h18]])
  -- vim.cmd([[nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>]])
  -- vim.cmd([[nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>]])
  -- vim.cmd([[nnoremap <silent> <C-=> :set guifont=+<CR>]])
  -- vim.cmd([[nnoremap <silent> <C--> :set guifont=-<BS><CR>]])
  vim.o.guifont = "PragmataPro Mono:h24"

  -- CTRL+- and CTRL+= can't be mapped correctly in neovim
  -- As an alternative I'll use xremap to map them to scroll wheels inputs
  vim.keymap.set("n", "<C-ScrollWheelUp>", inc_font_size)
  vim.keymap.set("n", "<C-ScrollWheelDown>", dec_font_size)

  vim.cmd([[nnoremap <A-CR> :FVimToggleFullScreen<CR>]])
  vim.cmd([[FVimCursorSmoothMove v:false]])
  vim.cmd([[FVimCursorSmoothBlink v:false]])
end
