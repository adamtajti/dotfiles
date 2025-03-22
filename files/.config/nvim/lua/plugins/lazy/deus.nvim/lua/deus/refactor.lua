local M = {}

function M.setup()
  -- buggy for now... launches in zsh, which is fucked up because of p10k...
  vim.api.nvim_set_keymap(
    "n",
    "<leader>lms",
    ":lua vim.fn.setreg('+', vim.fn.system([[node -e 'console.log(\""
      .. vim.fn.getreg("")
      .. '".toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-+|-+$/g, ""))\']]))<CR>'
      .. ':normal! "+p<CR>',
    { noremap = true, silent = true, desc = "Sanitize" }
  )
end

return M
