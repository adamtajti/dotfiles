--- Common Configurations
require("config")
require("plugins")
require("lsp")

--- GUI Frontend Configurations (loads conditionally)
--- placed after the common config so that it can override settings
require("gui.firenvim")
require("gui.vscode")
require("gui.neovide")
require("gui.fvim")

---------------------------------------------------------------------------------------------------
--- These should be moved into settings.lua eventually or something like that

-- <C-l> removes any search highlighting
vim.keymap.set("", "<C-l>", ":nohl<CR>", { noremap = true })

-- <S-Tab> decreases the identation
vim.keymap.set("i", "<S-Tab>", "<C-D>", { noremap = true })
vim.keymap.set("n", "<S-Tab>", "<<", { noremap = true })

-- Toggles QuickFix window (Bookmars, References frequently use this functionality)
vim.keymap.set("", "<F2>", function()
  if
    vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), "v:val.quickfix")) == 1
  then
    vim.cmd([[copen]])
  else
    vim.cmd([[cclose]])
  end
end, { noremap = true })

-- Switch between buffers quickly
vim.keymap.set("n", "<Leader><Tab>", "", {
  desc = "Next Buffer",
  noremap = true,
  callback = function() vim.cmd(":silent! bn") end,
})

vim.keymap.set("n", "<Leader><S-Tab>", "", {
  desc = "Previous Buffer",
  noremap = true,
  callback = function() vim.cmd(":silent! bp") end,
})

vim.keymap.set("n", "<Leader>L", "", {
  desc = "Lazy.nvim",
  noremap = true,
  callback = function() vim.cmd(":Lazy") end,
})

vim.keymap.set("n", "<Leader>Q", "", {
  desc = "Quit NVIM without saving anything",
  noremap = true,
  callback = function() vim.cmd(":qa!") end,
})

vim.keymap.set("n", ";;", "", {
  desc = ":w Save the current file",
  noremap = true,
  callback = function() vim.cmd(":w") end,
})

vim.keymap.set("n", "<Leader>W", "", {
  desc = "wq! save and exit",
  noremap = true,
  callback = function() vim.cmd(":wq!") end,
})

-- Floating Window Rounded Borders Styling
local border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}

-- Setting the hover handleer to be handled with the rounded borders.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = border,
})

-- Setting the hover handleer to be handled with the rounded borders.
vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = border,
  })

--- Diagnostics
vim.diagnostic.config({
  -- virtual_text is the text that is visible on the right side of the problematic line
  virtual_text = {
    prefix = "",
    format = function(diagnostic)
      if diagnostic.severity == vim.diagnostic.severity.ERROR then
        return string.format(" %s", diagnostic.message)
      elseif diagnostic.severity == vim.diagnostic.severity.WARN then
        return string.format(" %s", diagnostic.message)
      elseif diagnostic.severity == vim.diagnostic.severity.INFO then
        return string.format(" %s", diagnostic.message)
      elseif diagnostic.severity == vim.diagnostic.severity.HINT then
        return string.format(" %s", diagnostic.message)
      end

      return diagnostic.message
    end,
  },
})

vim.fn.sign_define(
  "DiagnosticSignError",
  { text = "", texthl = "DiagnosticSignError" }
)
vim.fn.sign_define(
  "DiagnosticSignWarn",
  { text = "", texthl = "DiagnosticSignWarn" }
)
vim.fn.sign_define(
  "DiagnosticSignInfo",
  { text = "", texthl = "DiagnosticSignInfo" }
)
vim.fn.sign_define(
  "DiagnosticSignHint",
  { text = "", texthl = "DiagnosticSignHint" }
)

--- Shortcuts to Copy Relative or Positive Paths or Filenames
vim.keymap.set("n", "<Leader>bpr", "", {
  desc = "Copy Relative Path",
  noremap = true,
  callback = function() vim.cmd(':let @+ = expand("%")') end,
})

vim.keymap.set("n", "<Leader>bpa", "", {
  desc = "Copy Absolute Path",
  noremap = true,
  callback = function() vim.cmd(':let @+ = expand("%:p")') end,
})

vim.keymap.set("n", "<Leader>bpn", "", {
  desc = "Copy Filename",
  noremap = true,
  callback = function() vim.cmd(':let @+ = expand("%:t")') end,
})

vim.keymap.set("n", "<Leader>bw", "", {
  desc = "Wipe Not Visible Buffers",
  noremap = true,
  callback = function()
    local bufinfos = vim.fn.getbufinfo({ buflisted = 1 })
    vim.tbl_map(function(bufinfo)
      if
        bufinfo.changed == 0 and (not bufinfo.windows or #bufinfo.windows == 0)
      then
        vim.api.nvim_buf_delete(
          bufinfo.bufnr,
          { force = false, unload = false }
        )
      end
    end, bufinfos)
  end,
})

--- Note taking specific shortcuts

-- Paste the current time in insert mode (used for journaling)
vim.keymap.set(
  "i",
  "<C-t>",
  "<C-r>=substitute(system('date +%H:%M'), '[\\r\\n]*$', '', '')<CR><ESC>",
  { noremap = true }
)
