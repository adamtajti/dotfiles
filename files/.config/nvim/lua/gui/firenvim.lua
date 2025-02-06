--- firenvim is a browser extension that runs a neovim instance on inputs,
--- textfields.

if vim.g.started_by_firenvim == true then
  -- Disable the status line to save space on single line inputs.
  vim.o.laststatus = 0
  -- vim.cmd("autocmd WinResized * set laststatus=0")
  vim.g.firenvim_config.localSettings[".*"] = { takeover = "never" }

  -- keymap to set the editor to "fullscreen"
  -- :set lines=100
  -- :set columns=300
end
