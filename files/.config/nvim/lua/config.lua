-- Filetype mappings
vim.filetype.add({
  pattern = {
    [".*/%.github/actions/.*%.ya?ml"] = "yaml.ghaction",
    [".*/%.github/workflows/.*%.ya?ml"] = "yaml.ghaction",
    ["Brewfile.*"] = "ruby",
    ["zinitrc"] = "zsh",
    [".*/playbooks/.*%.yml"] = "yaml.ansible",
    [".*/playbooks/.*%.yaml"] = "yaml.ansible",
    [".*/inventory/.*%.yml"] = "yaml.ansible",
    [".*/inventory/.*%.yaml"] = "yaml.ansible",
    [".*/host_vars/.*%.yml"] = "yaml.ansible",
    [".*/host_vars/.*%.yaml"] = "yaml.ansible",
    [".*/group_vars/.*%.yml"] = "yaml.ansible",
    [".*/group_vars/.*%.yaml"] = "yaml.ansible",
    [".*/roles/.*%.yml"] = "yaml.ansible",
    [".*/roles/.*%.yaml"] = "yaml.ansible",
    [".*/ansible/.*%.yml"] = "yaml.ansible",
    [".*/ansible/.*%.yaml"] = "yaml.ansible",
    [".*/roles/*/tasks/.*%.yml"] = "yaml.ansible",
    [".*/roles/*/tasks/.*%.yaml"] = "yaml.ansible",
    [".*%.ansible.yml"] = "yaml.ansible",
    [".*%.ansible.yaml"] = "yaml.ansible",
    [".*%.yml.draft"] = "yaml",
    [".*%.yaml.draft"] = "yaml",
    [".*/compose%.yaml"] = "yaml.docker-compose",
    [".*/compose%.yml"] = "yaml.docker-compose",
    [".*requirements%.in"] = "requirements",
    [".*requirements%.txt"] = "requirements",
    [".*/%.vscode/.*%.json"] = "json5", -- stevearc dotfiles -> these json files freq have comments
    [".*%.conf"] = "conf",
    [".*%.theme"] = "conf",
    [".*%.gradle"] = "groovy",
    ["^.env%..*"] = "bash",
    [".*aliases"] = "bash",
  },
})

-- Increase the max oldfiles to 1000000.
--   The default was 100. lol.
vim.opt.shada = { "!", "'5000", "<100", "s10", "h" }

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
vim.o.breakindent = true

vim.o.ignorecase = true
vim.o.smartcase = true

-- Disable backups
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.updatecount = 0

-- Disable wrapping search (looping to the first result from the last)
vim.o.wrapscan = false

-- Enables Select Mode for movement keys:
-- v,V,CTRL-V commands stays in Visual Mode
-- Movement commands (shift+left key) will select in Select mode
-- Mouse selection stays in Visual Mode
vim.o.selectmode = "key"
vim.o.keymodel = "startsel,stopsel"

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

-- Removed t which was hardwrapping on files without a filetype. I might want to make an auto command for those instead
-- in the future.
vim.o.formatoptions = "cqj"

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

-- vim.api.nvim_set_keymap("i", "<sc-v>", "<C-r>+", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<sc-v>", '"+p', { noremap = true })

local vertical_cursor = false
local toggle_insert_cursor_style = function()
  if vertical_cursor then
    vim.o.guicursor =
      "a:blinkwait150-blinkon200-blinkoff150,i-c:ver20-MoonflyEmeraldCursor,n:ver35-MoonflyLavenderCursor,v-V:block-MoonflyVioletCursor"
  else
    vim.o.guicursor =
      "a:blinkwait150-blinkon200-blinkoff150,i-c:ver20-MoonflyEmeraldCursor,n:block-MoonflyLavenderCursor,v-V:block-MoonflyVioletCursor"
  end
end
vim.api.nvim_set_keymap("n", ",,c", "", {
  desc = "Toggle insert cursor style",
  noremap = true,
  callback = function()
    vertical_cursor = not vertical_cursor
    toggle_insert_cursor_style()
  end,
})

toggle_insert_cursor_style()

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

vim.keymap.set(
  "n",
  "<leader>1",
  function()
    detachedOpen("footclient", { "zsh", "-c", "nvim " .. vim.fn.expand("%:p") })
  end,
  { desc = "External: Open file in another foot+nvim combo" }
)

vim.keymap.set(
  "n",
  "<leader>2",
  function() detachedOpen("footclient", {}) end,
  { desc = "External: Open CWD in foot" }
)

vim.keymap.set("n", "<leader>/f", function()
  vim.ui.input(
    { prompt = "delete lines that doesnt contain text: " },
    function(input)
      local cmd = "%g!/" .. input .. "/d"
      vim.cmd(cmd)
    end
  )
end, { desc = "Filter: delete lines that doesnt contain text: " })

vim.keymap.set("n", "<leader>/r", function()
  vim.ui.input({ prompt = "delete lines containing text: " }, function(input)
    local cmd = "%g/" .. input .. "/d"
    vim.cmd(cmd)
  end)
end, { desc = "Filter: delete lines containing text" })

-- This is useful when the editor is cluttered with many splits, which is my usual flow, but then I would like to focus
-- on one of the windows without breaking the layout too much.
vim.keymap.set(
  "n",
  "tn",
  function() vim.cmd([[tabnew %]]) end,
  { desc = "Open the current buffer in a new tab" }
)
