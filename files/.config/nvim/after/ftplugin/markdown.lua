local opts = { buffer = true }

-- strike through
vim.keymap.set("v", "<C-s>", 'c~~<c-r>"~~', opts)
vim.keymap.set("n", "<C-s>", 'viwc~~<c-r>"~~<esc>', opts)

-- bold
vim.keymap.set("v", "<C-b>", 'c**<c-r>"**', opts)
vim.keymap.set("n", "<C-b>", 'viwc**<c-r>"**<esc>', opts)

-- italic
vim.keymap.set("v", "<C-i>", 'c_<c-r>"_', opts)
vim.keymap.set("n", "<C-i>", 'viwc_<c-r>"_<esc>', opts)

-- urls
vim.keymap.set("v", "<C-u>", 'c[](<c-r>")<c-o>F]', opts)
-- vim.keymap.set("n", "<C-u>", 'viwc[](<c-r>")<c-o>F]', opts)

-- title
vim.keymap.set("v", "<C-t>", 'c[<c-r>"]()<left>', opts)
vim.keymap.set("n", "<C-t>", 'viwc[<c-r>"]()<left>', opts)

-- backticks
vim.keymap.set("v", "<C-`>", 'c`<c-r>"`', opts)
vim.keymap.set("n", "<C-`>", 'viwc`<c-r>"`<esc>', opts)

-- close all folds and opens all folds under the cursors recursively
vim.keymap.set("n", "<C-z>", "zMzv", opts)

-- yank inside `
-- vim.keymap.set("n", ",y`", "vi`,y", {
--   buffer = true,
--   remap = true,
-- })

vim.keymap.set("n", ",y", function()
  -- Wait for one more character input
  local char = vim.fn.getcharstr()
  return "vi" .. char .. ",y"
end, {
  buffer = true,
  expr = true,
  remap = true,
})
