-- This plugin is required by all the others lsp-* plugins
return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  config = function(_, _)
    -- vim.lsp.set_log_level("debug")
    -- vim.lsp.set_log_level("trace")

    vim.keymap.set(
      "n",
      "<leader>ldf",
      "<cmd>lua vim.diagnostic.open_float({ border = 'rounded', max_width = 200 })<CR>",
      { desc = "Show Diagnostic Message Afloat", noremap = true, silent = true }
    )

    vim.keymap.set(
      "n",
      "<leader>ldp",
      "<cmd>lua vim.diagnostic.goto_prev()<CR>",
      { desc = "Next", noremap = true, silent = true }
    )

    vim.keymap.set(
      "n",
      "<leader>ldn",
      "<cmd>lua vim.diagnostic.goto_next()<CR>",
      { desc = "Previous", noremap = true, silent = true }
    )

    vim.keymap.set(
      "n",
      "<C-.>",
      "<cmd>lua vim.lsp.buf.code_action()<CR>",
      { desc = "Code Actions", noremap = true }
    )

    -- Navigational
    vim.keymap.set("n", "gD", "", {
      desc = "Go to Declaration",
      noremap = true,
      silent = true,
      callback = function() vim.lsp.buf.declaration() end,
    })

    vim.keymap.set("n", "gd", "", {
      desc = "Go to Definition",
      noremap = true,
      silent = true,
      callback = function() vim.lsp.buf.definition() end,
    })

    vim.keymap.set("n", "gt", "", {
      desc = "Go to Type Definition",
      noremap = true,
      silent = true,
      callback = function() vim.lsp.buf.type_definition() end,
    })

    vim.keymap.set("n", "gi", "", {
      desc = "Go to Implementation",
      noremap = true,
      silent = true,
      callback = function() vim.lsp.buf.implementation() end,
    })

    vim.keymap.set("n", "K", "", {
      desc = "Display Hover Information (documentation)",
      noremap = true,
      silent = true,
      callback = function() vim.lsp.buf.hover() end,
    })

    vim.keymap.set("n", "<C-k>", "", {
      desc = "Display Signature Help",
      noremap = true,
      silent = true,
      callback = function() vim.lsp.buf.signature_help() end,
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
  end,
}
