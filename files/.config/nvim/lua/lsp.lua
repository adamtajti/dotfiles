-- This is the suggested way of configuring the LSP for Neovim:
-- https://neovim.io/doc/user/lsp.html#vim.lsp.config()
--
-- Note that mason-lspconfig did little to ease the setup concerns,
-- thus that is going to be abandoned

-- These could be used to change the log levels
-- vim.lsp.set_log_level("debug")
-- vim.lsp.set_log_level("trace")

local capabilities = require("blink.cmp").get_lsp_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

vim.lsp.config("*", {
  capabilities = capabilities,
})

-- Enable the language servers, which means that they'll start automatically
-- once a file with the right filetypes is loaded
--
-- defaults @ nvim-lspconfig/lsp/<name>.lua
-- my defaults @ after/lsp/<name>.lua

vim.lsp.enable("asm_lsp")
vim.lsp.enable("bashls")
vim.lsp.enable("clangd")
vim.lsp.enable("cssls")
vim.lsp.enable("docker_compose_language_service")
vim.lsp.enable("dockerls")
vim.lsp.enable("gopls")
vim.lsp.enable("html")
vim.lsp.enable("jdtls")
vim.lsp.enable("jsonls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("omnisharp")
vim.lsp.enable("perlnavigator")
vim.lsp.enable("pyright")
vim.lsp.enable("rubocop")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("solargraph")
--vim.lsp.enable("ruby_lsp")
vim.lsp.enable("terraformls")
vim.lsp.enable("tflint")
vim.lsp.enable("vimls")
vim.lsp.enable("vue_ls")
vim.lsp.enable("vtsls")
vim.lsp.enable("yamlls")
vim.lsp.enable("nil_ls")
vim.lsp.enable("somesass_ls")
vim.lsp.enable("svelte")
vim.lsp.enable("systemd_ls")
vim.lsp.enable("ts_query_ls")
vim.lsp.enable("fsautocomplete")
vim.lsp.enable("gh_actions_ls")
vim.lsp.enable("helm_ls")
vim.lsp.enable("powershell_es")
vim.lsp.enable("postgres_lsp")

-- Keymap configurations
vim.keymap.set(
  "n",
  "<leader>ldf",
  function() vim.diagnostic.open_float({ border = "rounded", max_width = 300 }) end,
  { desc = "Show Diagnostic Message Afloat", noremap = true, silent = true }
)

-- Keymap configurations
vim.keymap.set(
  "n",
  "L",
  function() vim.diagnostic.open_float({ border = "rounded", max_width = 300 }) end,
  { desc = "Show Diagnostic Message Afloat", noremap = true, silent = true }
)

vim.keymap.set(
  "n",
  "<leader>ldp",
  function() vim.diagnostic.goto_prev() end,
  { desc = "Next", noremap = true }
)

vim.keymap.set(
  "n",
  "<leader>ldn",
  function() vim.diagnostic.goto_next() end,
  { desc = "Previous", noremap = true, silent = true }
)

vim.keymap.set(
  "n",
  "<C-.>",
  function() vim.lsp.buf.code_action() end,
  { desc = "Code Actions", noremap = true }
)

-- Navigational
vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, {
  desc = "Go to Declaration",
  noremap = true,
})

vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, {
  desc = "Go to Definition",
  noremap = true,
})

vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, {
  desc = "Go to Type Definition",
  noremap = true,
})

vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, {
  desc = "Go to Implementation",
  noremap = true,
})

vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, {
  desc = "Display Hover Information (documentation)",
  noremap = true,
})

vim.keymap.set("n", "<C-k>", function() vim.lsp.buf.signature_help() end, {
  desc = "Display Signature Help",
  noremap = true,
})

vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, {
  desc = "Lists all References",
})

vim.keymap.set("n", "<leader>lrr", function() vim.lsp.buf.rename() end, {
  desc = "Rename symbol",
})

vim.keymap.set(
  "n",
  "<Leader>f",
  function() vim.lsp.buf.format({ async = true, timeout_ms = 5000 }) end,
  {
    desc = "LSP: Format Current Document",
  }
)

vim.keymap.set(
  "v",
  "<Leader>f",
  function() vim.lsp.buf.format({ async = true, timeout_ms = 5000 }) end,
  {
    desc = "LSP: Format the selected range",
  }
)

vim.keymap.set(
  "n",
  "<leader>lh",
  function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
  {
    desc = "LSP: Toggle inlay hints",
  }
)

-- Disabled: TS io-ts has long and cryptic types
-- vim.lsp.inlay_hint.enable()
