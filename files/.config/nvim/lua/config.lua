-- Increase the max oldfiles to 1000000.
--   The default was 100. lol.
vim.opt.shada = { "!", "'1000000", "<100", "s10", "h" }

-- https://codeberg.org/dnkl/foot/wiki#ctrl-key-breaks-input-in-vim
vim.cmd([[let &t_TI = "\<Esc>[>4;2m"]])
vim.cmd([[let &t_TE = "\<Esc>[>4m"]])

-- Shift+Space clears the current promp:
-- https://neovim.discourse.group/t/shift-space-escape-sequence-in-term-introduced-between-in-neovim-0-6-and-0-7/2816
vim.cmd([[tnoremap <S-Space> <Space>]])

-- Enable interactive shell (to have shell aliases / functions available from vim)
vim.cmd([[set shellcmdflag=-ic]])

vim.cmd([[set ttyfast]])

-- Change the leader key to a Comma. I find this superior to <Space>.
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Disable showmode on the bottom "--INSERT--"
vim.opt.showmode = false

-- Used for the	|CursorHold| autocommand event
vim.o.updatetime = 500
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Sets title to be enabled, which attempts to set the title in the shell,
-- which gets displayed on the terminal emulator.
vim.o.title = true

-- Wrapping should be enabled visually
vim.o.wrap = true

vim.o.ignorecase = true
vim.o.smartcase = true

-- Disable backups
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.updatecount = 0

-- Use LSP omnifunc (<C-x><C-o>) for completion
-- vim.api.nvim_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Increase the history length of :messages to 10k (max)
vim.o.messagesopt = "hit-enter,history:10000"

-- attempts to hide '%d buffer wiped out' messages
-- https://github.com/neovim/neovim/blob/v0.10.1/src/nvim/buffer.c#L1125
vim.o.report = 9000

-- Session settings (these are the enttities, buffers that gets saved into a session)
vim.o.sessionoptions =
  "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Yank to the system clipboard a bit easier:
-- Note that I have been doing single inline selections wrong.
-- I should have used the charwise mode "c"/"v" instead of blockwise-visual mode "b" or "<CTRL-V>"
-- That way a new line character won't be added to the clipboard.
vim.api.nvim_set_keymap("v", "<Leader>y", "", {
  desc = "Yank to clipboard",
  callback = function()
    vim.cmd('silent! normal! "+y')
    local copiedRegister = vim.fn.getreg("+")
    -- remove the last new line character from copies_test and
    copiedRegister = copiedRegister:gsub("\n$", "")
    vim.fn.setreg("+", copiedRegister)
  end,
})

-- Run the current command with C-o (as in OK)
-- https://youtu.be/TIItYdl1nXw?si=RkcYiy76nBxYPSly&t=40
--https://youtu.be/v5eAIYQWIpA?si=gFjudGyPyPSvMmQp&t=17
vim.api.nvim_set_keymap("c", "<C-o>", "<CR>", {
  noremap = true,
})

vim.api.nvim_set_keymap("t", "<Leader><Esc>", "<C-\\><C-n>", {
  desc = "Escape Terminal (<C-\\><C-n>)",
})

local start_term_in_cwd = function()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, buf)
  vim.cmd([[call jobstart(['zsh'], {'term':v:true})]])
  vim.cmd([[startinsert]])
end

vim.keymap.set("n", "<leader>cT", function() start_term_in_cwd() end, {
  desc = "Open Terminal in CWD",
})
vim.keymap.set("n", "<leader>T", function() start_term_in_cwd() end, {
  desc = "Open Terminal in CWD",
})

vim.api.nvim_set_keymap("n", "<Leader>z", "<C-w>_<C-w>|", {
  desc = "Maximizes the current window",
})

---------------------------------------------------------------------------------------------------
-- NAVIGATION / UI
---------------------------------------------------------------------------------------------------

-- Folding
-- Set the default fold method to indent as the tree-sitter implementation has
-- a bug in it: https://github.com/neovim/neovim/issues/14977
--
-- stash@{0}: On main: folding with nvim-treesitter
-- vim.opt.foldmethod = "indent"

-- Line numbering: Mixed with relative, the current line will show the absolute position.
vim.o.number = true
vim.o.relativenumber = true

-- Enable GUI colors in the terminal.
vim.o.termguicolors = true

-- Enable mouse integration for resizing windows and clicking on links.
vim.o.mouse = "a"

-- Offset the screen in case of a jump / scroll to see more context
vim.o.so = 5

-- Removes the bottom bar
vim.g.laststatus = 3

-- Hide the command line while it's not in use
vim.o.cmdheight = 0

-- Disable netrw (I'm using Oil for file management)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--
vim.api.nvim_set_keymap("n", "<Leader>p", "", {
  desc = "pwd",
  callback = function() vim.cmd("pwd") end,
})

-- Resize
-- https://neovim.io/doc/user/options.html#'eadirection'
-- ver	vertically, width of windows is not affected
-- hor	horizontally, height of windows is not affected
-- both	width and height of windows is affected
-- vim.g.ead = "both"
vim.o.equalalways = false

---------------------------------------------------------------------------------------------------
-- FORMATTING
---------------------------------------------------------------------------------------------------

-- Set those tab widths to 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.wrap = true

-- Wrapping
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = { "*.jsx", "*.md", "*.txt", "COMMIT_EDITMSG" },
  command = "set wrap linebreak nolist",
})

---------------------------------------------------------------------------------------------------
-- Auto-create parent directories (except for URIs "://").
---------------------------------------------------------------------------------------------------

vim.cmd(
  [[au BufWritePre,FileWritePre * if @% !~# '\(://\)' | call mkdir(expand('<afile>:p:h'), 'p') | endif]]
)

---------------------------------------------------------------------------------------------------
-- Markdown
---------------------------------------------------------------------------------------------------
-- vim.g.markdown_folding = 1
-- vim.cmd("set foldlevel=99")
vim.g.markdown_fenced_languages = {
  "html",
  "python",
  "lua",
  "vim",
  "typescript",
  "javascript",
  "cpp",
  "c",
  "bash",
  "sh",
}

-- Conceal hides the backticks and whatnots. Sometimes that looks prettier.
-- Disable concealment for now:
-- - Conflicts with SnipRun in Markdown files
-- - And the rendering of actual links is highly buggy.
vim.o.conceallevel = 0
vim.o.concealcursor = "nc"

-- Override to expandtab (use spaces) on MD files
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  pattern = { "*.md" },
  command = "set expandtab tabstop=2 shiftwidth=2 softtabstop=2 colorcolumn=0",
})

-- Lua: Override to noexpandtab (use tabs) on LUA files
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  pattern = { "*.lua" },
  command = "set noexpandtab tabstop=2 shiftwidth=2 softtabstop=2",
})

-- JSON: fold by indent; TS & LSP struggles w large objs
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  pattern = { "*.json" },
  command = "set foldmethod=indent",
})

-- Tabs: tc keymap to close the current tab
vim.api.nvim_set_keymap("n", "tc", "", {
  desc = "Tab Close",
  noremap = true,
  callback = function() vim.cmd([[tabc]]) end,
})

-- terminal: Disable relative numbers in terminals
vim.cmd("autocmd TermOpen * setlocal nonumber norelativenumber")
vim.api.nvim_set_keymap("t", "<Leader><Esc>", "<C-\\><C-n>", {
  desc = "Escape Terminal (<C-\\><C-n>)",
})

-- Markdown: Copy the selection as HTML
vim.keymap.set("v", "<leader>Y", function()
  if vim.bo.filetype == "markdown" then
    return [[:<C-u>silent! '<,'>w ! pandoc -s | wl-copy -t text/html<CR>]]
  end
end, {
  desc = "Markdown: Copy as HTML",
  expr = true,
  silent = true,
})

-- Command Line: Force cmdheight to 0
-- Archived: Previously a plugin overwrote this setting.
-- vim.cmd("autocmd WinResized * set cmdheight=0")
