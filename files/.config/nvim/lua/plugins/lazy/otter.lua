-- Otter.nvim provides lsp features and a code completion source for code embedded in other
-- documents
return {
  "jmbuhr/otter.nvim",
  event = "VeryLazy",
  -- bugged again
  enabled = false,
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local otter = require("otter")
    otter.setup({
      lsp = {
        hover = {
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        },
        -- `:h events` that cause the diagnostics to update. Set to:
        -- { "BufWritePost", "InsertLeave", "TextChanged" } for less performant
        -- but more instant diagnostic updates
        diagnostic_update_events = { "BufWritePost" },
      },
      buffers = {
        -- write <path>.otter.<embedded language extension> files
        -- to disk on save of main buffer.
        -- usefule for some linters that require actual files
        -- otter files are deleted on quit or main buffer close
        write_to_disk = false,
      },
      strip_wrapping_quote_characters = { "'", '"', "`" },
      -- Otter may not work the way you expect when entire code blocks are indented (eg. in Org files)
      -- When true, otter handles these cases fully. This is a (minor) performance hit
      handle_leading_whitespace = false,
    })

    vim.api.nvim_create_autocmd({ "BufRead" }, {
      pattern = { "*.norg", "*.md" },
      callback = function(_) otter.activate(nil, true, true, nil) end,
    })
  end,
}
